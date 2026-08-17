terraform {
  backend "s3" {
    bucket = "dhoni-demo-terraform-bucket-123456"
    key    = "hub/phase1/terraform.tfstate"
    region = "ap-south-1"
  }
}   