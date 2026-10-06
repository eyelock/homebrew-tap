# typed: false
# frozen_string_literal: true

require "download_strategy"
require "utils/github/api"

# Downloads a release asset from a private GitHub repository.
#
# GitHub answers 404 for a private repository's github.com/<owner>/<repo>/releases/download/...
# links even with a token; only the API's asset link serves the file. This looks the asset up
# through the API, then downloads it from there, with the token Homebrew already uses for
# GitHub: $HOMEBREW_GITHUB_API_TOKEN, else the GitHub CLI's login, else the keychain. The
# formula keeps the ordinary release URL, so it works unchanged once the repository is public.
class GitHubPrivateReleaseDownloadStrategy < CurlDownloadStrategy
  URL_PATTERN = %r{\Ahttps://github\.com/([^/]+)/([^/]+)/releases/download/([^/]+)/([^/?#]+)\z}

  def initialize(url, name, version, **meta)
    super
    match = URL_PATTERN.match(@url)
    raise CurlDownloadStrategyError.new(@url, "not a GitHub release download URL") unless match

    @owner, @repo, @tag, @filename = match.captures
  end

  private

  # The asset's API URL, without asking github.com about the release URL first: for a private
  # repository it would only answer 404.
  def resolve_url_basename_time_file_size(_url, timeout: nil)
    [asset_url, @filename, nil, nil, nil, false]
  end

  def _fetch(url:, resolved_url:, timeout:)
    ohai "Downloading #{@filename} from #{@owner}/#{@repo} #{@tag} through the GitHub API"
    curl_download resolved_url,
                  "--header", "Accept: application/octet-stream",
                  "--header", "Authorization: Bearer #{token}",
                  to: temporary_path, timeout: timeout
  end

  def asset_url
    @asset_url ||= begin
      release = GitHub::API.open_rest("https://api.github.com/repos/#{@owner}/#{@repo}/releases/tags/#{@tag}")
      asset = Array(release["assets"]).find { |a| a["name"] == @filename }
      raise CurlDownloadStrategyError.new(@url, "#{@owner}/#{@repo} #{@tag} has no asset #{@filename}") unless asset

      asset["url"]
    end
  end

  def token
    credentials = GitHub::API.credentials
    if credentials.blank?
      raise CurlDownloadStrategyError.new(@url, <<~EOS)
        #{@owner}/#{@repo} is private. Set HOMEBREW_GITHUB_API_TOKEN to a token that can read it,
        or log in with the GitHub CLI (gh auth login).
      EOS
    end

    credentials
  end
end
