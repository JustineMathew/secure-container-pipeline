provider "aws" {
  region = "ap-south-1"

  default_tags {
    tags = {
      Project   = "secure-container-pipeline"
      ManagedBy = "terraform"
    }
  }
}
