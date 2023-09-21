resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${random_pet.name.id}-s3-bucket"
  #  acl    = "private"

  tags = {
    Name = "${random_pet.name.id}-s3-bucket"
  }
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [aws_s3_bucket_ownership_controls.example]

  bucket = aws_s3_bucket.s3_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      #    kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "some_bucket_access" {
  bucket              = aws_s3_bucket.s3_bucket.id
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
}

resource "aws_s3_object" "objects" {
  for_each = fileset("${path.module}/web_content/", "**")
  bucket   = aws_s3_bucket.s3_bucket.id
  key      = each.value
  source   = "${path.module}/web_content/${each.value}"
  etag     = filemd5("${path.module}/web_content/${each.value}")
}