terraform {
  backend "s3" {
    bucket       = "harish-gaddam-bucket123"
    key          = "networking/spoke/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
    encrypt      = true
  }
}