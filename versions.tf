terraform {
  required_version  = "~> 0.12"

  required_providers {
    random          = "= 2.2.1"
    google          = "= 3.27.0"
    google-beta     = "= 3.27.0"
    template        = "= 2.1.2"
    null            = "= 2.1.2"
  }
}
