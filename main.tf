data "aws_ami" "amazon-linux-2" {
 owners = ["amazon"]
  most_recent = true

 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
}


resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = var.ssh_key_pub
}

# security group ssh
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "ssh from local"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_with_cider]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

# security group http
resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow http inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "http from web"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

data "template_file" "userdata" {
  template = file("${abspath(path.module)}/userdata.yaml")
}

resource "aws_instance" "app_server" {
  ami                    = "${data.aws_ami.amazon-linux-2.id}"
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.allow_http.id, aws_security_group.allow_ssh.id]
  key_name               = aws_key_pair.deployer.key_name
  user_data              = data.template_file.userdata.rendered
  tags = {
    Name = var.instance_name
  }
}

