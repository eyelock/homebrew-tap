# GitHub settings for eyelock/homebrew-tap

The repository's live settings as Terraform, adopted without changing them. Modelled on ynh's
`infra/github/`, with two differences: state is local (no S3 backend), and this directory is
plan-only. Never run `terraform apply` here.

Covers the repository, its default branch, labels, Actions permissions and vulnerability alerts.
There is no `merge_queue` (GitHub refuses one on a personal account, HTTP 422), and no rulesets,
Pages, secrets or environments, because the repository has none.

To check for drift:

```sh
export GITHUB_TOKEN="$(gh auth token)"   # never write it to a file
cd infra/github
terraform init
# On a fresh clone, adopt the live settings into local state (no apply):
for p in github_repository.tap github_branch_default.main github_issue_labels.tap \
  github_actions_repository_permissions.tap github_workflow_repository_permissions.tap \
  github_repository_vulnerability_alerts.tap; do terraform import "$p" homebrew-tap; done
terraform plan   # expected: No changes.
```

Until this change is applied by a human, the plan is not clean. Under the decision that every YN repository
declares both `merge:` labels (ynw-nym0k), `labels.tf` adds `merge: merge commit` (not yet live) and aligns the
live `merge: squash` (colour 5319e7, no description) to the shared shape (2ea44f, "Squash merge"). The expected
plan is therefore one change, to `github_issue_labels.tap`, and nothing else.

`terraform.tfstate*`, `.terraform/` and `*.tfvars` are gitignored.
