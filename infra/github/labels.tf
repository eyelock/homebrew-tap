# Authoritative: a label created in the UI and not listed here is removed on apply. GitHub's defaults, plus both
# `merge:` labels, declared in every YN repository (decision ynw-nym0k): seats never create them by hand.
locals {
  labels = {
    "bug"                 = { color = "d73a4a", description = "Something isn't working" }
    "documentation"       = { color = "0075ca", description = "Improvements or additions to documentation" }
    "duplicate"           = { color = "cfd3d7", description = "This issue or pull request already exists" }
    "enhancement"         = { color = "a2eeef", description = "New feature or request" }
    "good first issue"    = { color = "7057ff", description = "Good for newcomers" }
    "help wanted"         = { color = "008672", description = "Extra attention is needed" }
    "invalid"             = { color = "e4e669", description = "This doesn't seem right" }
    "merge: merge commit" = { color = "0366d6", description = "Merge with a merge commit (stacked PR)" }
    "merge: squash"       = { color = "2ea44f", description = "Squash merge" }
    "question"            = { color = "d876e3", description = "Further information is requested" }
    "wontfix"             = { color = "ffffff", description = "This will not be worked on" }
  }
}

resource "github_issue_labels" "tap" {
  repository = github_repository.tap.name

  dynamic "label" {
    for_each = local.labels
    content {
      name        = label.key
      color       = label.value.color
      description = label.value.description
    }
  }
}
