resource "aws_s3_bucket" "build" {
  bucket = "ansible-build-bucket"  # Replace with your bucket name
}

resource "aws_s3_object" "build" {
  bucket = aws_s3_bucket.build.bucket
  key    = "project_inventory/inventory.py"  # Replace with the desired S3 key (path) for the file
  source = "${path.module}/project_inventory/inventory.py"  # Replace with the local path to the file
  acl    = "private"
  depends_on = [aws_s3_bucket.build]
  }

resource "aws_s3_bucket_acl" "build" {
  bucket = aws_s3_bucket.build.id
  acl    = "private"
  depends_on = [aws_s3_bucket_ownership_controls.build]
}

resource "aws_s3_bucket_versioning" "versioning_build" {
  bucket = aws_s3_bucket.build.id
  versioning_configuration {
    status = "Enabled"
   }
}

resource "aws_s3_bucket_ownership_controls" "build" {
  bucket = aws_s3_bucket.build.id

  rule {
    object_ownership = "ObjectWriter"
  }
}