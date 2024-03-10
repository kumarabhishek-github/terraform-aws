//author: Abhishek Kumar 
//date: 10-03-2024
//Identity and access management in AWS with Terraform
//=============================================================
#create IAM group - developers
resource "aws_iam_group" "developers" {
  name = var.dev
}
#define IAM group policy
resource "aws_iam_group_policy" "policy" {
  name  = "developer_policy"
  group = aws_iam_group.developers.name
  policy = file("policy.json")
}
# create IAM users
resource "aws_iam_user" "users" {
    name = each.value
    for_each = toset(var.dev-users)
}
#add users to developers group
resource "aws_iam_user_group_membership" "add_user_to_group" {
  for_each = aws_iam_user.users
  user = each.key
  groups = [
    aws_iam_group.developers.name,
  ]
}