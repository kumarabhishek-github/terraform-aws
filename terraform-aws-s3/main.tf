#creating S3  bucket for storing the data
resource "aws_s3_bucket" "smiplestoregbucket" {
  bucket = var.s3_bucket_name
  tags = {
    Name        = "newBucket"
    Environment = "Dev"
  }
  
}
#enable versioning
resource "aws_s3_bucket_versioning" "file_versioning" {
  bucket = aws_s3_bucket.smiplestoregbucket.id
  versioning_configuration {
    status = "Enabled"
  }

}
#S3 bucket policy that allows read-only access to a specific IAM user.
resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.smiplestoregbucket.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}
data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["554593751194"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.smiplestoregbucket.arn,
      "${aws_s3_bucket.smiplestoregbucket.arn}/*",
    ]
  }
}
#uploading file in bucket
resource "aws_s3_object" "htmlfile" {
  bucket = aws_s3_bucket.smiplestoregbucket.id
  key    = "app/index.html"
  source = "./index.html" #path of the file 
}
