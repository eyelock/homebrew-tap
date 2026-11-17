terraform {
  required_version = ">= 1.10"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.13"
    }
  }

  # No backend: state is local (terraform.tfstate here), gitignored, and never committed. This
  # directory is plan-only; the settings are adopted from what is live and are not applied from here.
}

# The token comes from GITHUB_TOKEN (`export GITHUB_TOKEN="$(gh auth token)"`), never from a file.
provider "github" {
  owner = var.owner
}
