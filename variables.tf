variable "region" {
  default = "us-east-1"
}

variable "cidr_block" {
  default = "172.31.0.0/16"
}

variable "az" {
  default = "us-east-1c"
}

variable "private_ip_s1" {
  type = list(string)
  default = ["172.31.1.50"]
}

variable "private_ip_s2" {
  type = list(string)
  default = ["172.31.1.51"]
}

variable "instance_type" {
  default = "t2.micro"
}

variable "subnet_block" {
  default = "172.31.1.0/24"
}

variable "vpc_id" {
  default = "vpc-f7083592"
  }

variable "security_group_id" {
  default = "sg-005bc7d8f29503320"
}

variable "subnet_id" {
  default = "subnet-6cb5f91b"
}
variable prefix {
  default = "noc_task"
}
