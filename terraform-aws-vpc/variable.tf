variable "region" {
  type = string
  default = "us-east-1"
}

variable "ami" {
  type = string
  default = "ami-080e1f13689e07408"
}
variable "instance_type" {
  type = string
  default = "t2.micro" 
}
variable "availability_zone" {
  type = string
  default = "us-east-1b"
}
variable "availability_zoneb" {
  type = string
  default = "us-east-1a"
}