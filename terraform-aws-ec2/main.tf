resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  user_data = file("web.sh")
  security_groups = [ var.security_group ]
  availability_zone = var.availability_zone
  tags = {
    Name = "web-server"
  }
  depends_on = [ aws_key_pair.ec2_aws_key_pair ]
}
resource "aws_instance" "app" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  user_data = file("app.sh")
  security_groups = [ var.security_group ]
  availability_zone = var.availability_zone
  tags = {
    Name = "app-server"
  }
  # Make sure the  Key Pair is available before creating this server
  depends_on = [ aws_key_pair.ec2_aws_key_pair ] 
}
resource "aws_key_pair" "ec2_aws_key_pair" {
  key_name = var.key_name
  public_key = tls_private_key.rsa.public_key_openssh
}
resource "tls_private_key" "rsa" {
algorithm = "RSA"
rsa_bits  = 4096
}
#save the  private key in a local file named after the key
resource "local_file" "server_key" {
content  = tls_private_key.rsa.private_key_pem
filename = var.key_name
}

