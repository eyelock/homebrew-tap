resource "github_repository" "tap" {
  name         = var.repository
  description  = "Homebrew tap for eyelock - distribution of helpful binaries"
  homepage_url = "https://github.com/eyelock"
  visibility   = "public"
  topics       = ["homebrew", "homebrew-tap", "ynh"]

  has_issues      = true
  has_discussions = false
  has_projects    = false
  has_wiki        = false
  is_template     = false

  # What is live: squash and rebase merges on, merge commits off.
  allow_squash_merge          = true
  allow_merge_commit          = false
  allow_rebase_merge          = true
  allow_auto_merge            = false
  allow_update_branch         = false
  delete_branch_on_merge      = true
  squash_merge_commit_title   = "COMMIT_OR_PR_TITLE"
  squash_merge_commit_message = "COMMIT_MESSAGES"
  merge_commit_title          = "MERGE_MESSAGE"
  merge_commit_message        = "PR_TITLE"
  web_commit_signoff_required = false

  # Never destroyed from here. (archive_on_destroy is left unset: it is a provider-only setting,
  # not a GitHub one, and setting it only adds a state-only change to every plan.)
  lifecycle {
    prevent_destroy = true
  }
}

# No merge_queue: GitHub refuses one on a personal account (HTTP 422). No rulesets, Pages, secrets
# or environments exist on this repository, so none are declared.
resource "github_branch_default" "main" {
  repository = github_repository.tap.name
  branch     = "main"
}
