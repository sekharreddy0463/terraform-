
resource "aws_security_group" "eu_west_sg" {
  name        = "eu_west_sg"
  description = "port22_open_sg"
  vpc_id      = aws_vpc.eu_west_vpc.id
  ingress {
    description = "Security Group"
    from_port   = 0
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "eu_west_sg"
  }
}
resource "aws_instance" "ec2_testserver" {
    ami = var.ami
    subnet_id = aws_subnet.PublicSubnet.id
    instance_type = var.type
    security_groups = [ aws_security_group.eu_west_sg.id ]
    key_name = var.key
    associate_public_ip_address = true
    tags = {
    Name = "Devlopment_PHP"
  }
provisioner "remote-exec" {
    inline = [
        "sudo yum update -y",
        "sudo amazon-linux-extras install nginx1.12 -y",
        "sudo chkconfig nginx on",
        "sudo chkconfig php-fpm on",
        "sudo service nginx start",
        "sudo service php-fpm start",
        "sudo amazon-linux-extras enable php7.3",
        "sudo yum install php -y",
        "sudo yum install -y php-pear",
        "sudo yum install -y php-cgi",
        "sudo yum install -y php-common",
        "sudo yum install -y php-curl",
        "sudo yum install -y php-mbstring",
        "sudo yum install -y php-gd",
        "sudo yum install -y php-mysqlnd",
        "sudo yum install -y php-gettext",
        "sudo yum install -y php-bcmath",
        "sudo yum install -y php-json",
        "sudo yum install -y php-xml",
        "sudo yum install -y php-fpm",
        "sudo install -y php-intl",
        "sudo yum install -y php-zip"
    ]
# Connection 
connection {
    type = "ssh"
    user = "ec2-user"
    private_key = file("/home/ec2-user/csr/newkey.pem")
    host = self.public_ip
  }
  }  
}
