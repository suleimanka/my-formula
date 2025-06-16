# Terraform formula

This formula installs the [Terraform](https://www.terraform.io/) binary without using the system package manager. It supports installing multiple versions on Debian/Ubuntu and RedHat/Rocky based systems.

## Pillar Configuration
```yaml
terraform:
  url: 'https://releases.hashicorp.com/terraform'
  versions:
    - '1.8.5'
  default: '1.8.5'
  arch: 'amd64'
```

* `url` - base download URL for Terraform archives.
* `versions` - list of versions to install.
* `default` - version used for the global `terraform` symlink.
* `arch` - CPU architecture used in archive name.

## Usage
Include the main state in your top file:
```yaml
include:
  - terraform
```
