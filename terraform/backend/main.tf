resource "aws_s3_bucket" "terraform_state" {
    bucket = "major-project-terraform-state-automated-sdlc"
    force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "block" {
    bucket = aws_s3_bucket.terraform_state.id

    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
}

resource "aws_s3_bucket_versioning" "tfstate_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}
