terraform {
  backend "s3" {
    bucket = "dhoni-demo-terraform-bucket-123456"
    key    = "phase3/network/terraform.tfstate"
    region = "ap-south-1"
  }
}