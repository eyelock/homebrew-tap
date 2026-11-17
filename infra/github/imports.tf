# Adopt the live repository into a fresh local state. Once imported these are no-ops.
import {
  to = github_repository.tap
  id = "homebrew-tap"
}

import {
  to = github_branch_default.main
  id = "homebrew-tap"
}

import {
  to = github_issue_labels.tap
  id = "homebrew-tap"
}

import {
  to = github_actions_repository_permissions.tap
  id = "homebrew-tap"
}

import {
  to = github_workflow_repository_permissions.tap
  id = "homebrew-tap"
}

import {
  to = github_repository_vulnerability_alerts.tap
  id = "homebrew-tap"
}
