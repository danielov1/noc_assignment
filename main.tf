provider "aws" {
  region = var.region
  access_key = var.accessKey
  secret_key = var.secretKey
  token = var.sessionToken
}


resource "aws_network_interface" "noc_task_network_interface1" {
  subnet_id = data.aws_subnet.selected.id
  private_ips = var.private_ip_s1
  security_groups = [data.aws_security_group.selected.id]
}
resource "aws_network_interface" "noc_task_network_interface2" {
  subnet_id = data.aws_subnet.selected.id
  private_ips = var.private_ip_s2
  security_groups = [data.aws_security_group.selected.id]
}

resource "aws_eip" "noc_task_eip1" {
  depends_on =  [aws_instance.noc_task_instance1]
  vpc = true
  network_interface = aws_network_interface.noc_task_network_interface1.id
  associate_with_private_ip = var.private_ip_s1[0]
}

resource "aws_eip" "noc_task_eip2" {
  depends_on = [aws_instance.noc_task_instance2]
  vpc = true
  network_interface = aws_network_interface.noc_task_network_interface2.id
  associate_with_private_ip = var.private_ip_s2[0]
}

resource "aws_key_pair" "deployer" {
  key_name   = "chlng-${var.prefix}"
  public_key = var.publicKey
}

resource "aws_instance" "noc_task_instance1" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  availability_zone = var.az
  key_name = "chlng-${var.prefix}"
  user_data =  <<-EOF
              #!/bin/bash
              sudo -i
              sudo useradd -p saw8BISi1.vIw noc -s /bin/bash
              sudo adduser noc sudo
              sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
              sudo service ssh restart
              EOF 

  network_interface {
    device_index = 0 
    network_interface_id = aws_network_interface.noc_task_network_interface1.id
  }

  tags = {
    Name = "server1-${var.prefix}"
    Owner = "-${var.prefix}"
    terminate	= "false"
  }
}

resource "aws_instance" "noc_task_instance2" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  availability_zone = var.az
  key_name = "chlng-${var.prefix}"
    user_data =  <<-EOF
              #!/bin/bash
              sudo -i
              sudo useradd -p saw8BISi1.vIw noc -s /bin/bash
              sudo adduser noc sudo
              sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
              sudo service ssh restart
              EOF 

  network_interface {
    device_index = 0 
    network_interface_id = aws_network_interface.noc_task_network_interface2.id
  }

  tags = {
    Name = "server2-${var.prefix}"
    Owner = "-${var.prefix}"
    terminate	= "false"
  }
}
