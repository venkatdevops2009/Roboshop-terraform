terraform {
  backend "s3" {
    bucket       = "backend-9465"
    key          = "roboshop-tf-state"
    region       = "ap-south-1"
    use_lockfile = true
  }
}