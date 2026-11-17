# Vulnerability alerts are on. Secret scanning, push protection and Dependabot security updates are
# off today and are left undeclared here, so this adopts what is live without changing it.
resource "github_repository_vulnerability_alerts" "tap" {
  repository = github_repository.tap.name
  enabled    = true
}
