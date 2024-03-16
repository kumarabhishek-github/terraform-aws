variable "region" {
  default =  "us-east-1"
}

variable "ami" {
  default = "your ami here "
}

variable "servers" {
 type = list(string)
 default =  ["app-server", "web-server"]
}

variable "instance_type" {
  default = "t2.micro"
  
}

variable "security_group" {
  default = "launch-wizard-1"
}

variable "key_name" {
  default = "ec2_keypair.pem"
}
variable "availability_zone" {
  default = "us-east-1b"
}