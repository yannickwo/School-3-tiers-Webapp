# VPC Variables
variable "region" {
  default     = "us-east-1"
  description = "AWS Region"
  type        = string
}

variable "aws_profile" {
  default     = "cred"
  description = "AWS access_key - secret_key"
  type        = string
}
variable "vpc-cidr" {
  default     = "10.0.0.0/16"
  description = "VPC CIDR Block"
  type        = string
}


variable "public-subnet-1-cidr" {
  default     = "10.0.1.0/24"
  description = "Public Subnet 1 CIDR Block"
  type        = string
}

variable "public-subnet-2-cidr" {
  default     = "10.0.2.0/24"
  description = "Public Subnet 2 CIDR Block"
  type        = string
}

variable "private-subnet-1-cidr" {
  default     = "10.0.11.0/24"
  description = "Private Subnet 1 CIDR Block"
  type        = string
}

variable "private-subnet-2-cidr" {
  default     = "10.0.12.0/24"
  description = "Private Subnet 2 CIDR Block"
  type        = string
}

variable "private-subnet-3-cidr" {
  default     = "10.0.21.0/24"
  description = "Private Subnet 3 CIDR Block"
  type        = string
}

variable "private-subnet-4-cidr" {
  default     = "10.0.22.0/24"
  description = "Private Subnet 4 CIDR Block"
  type        = string
}

variable "ami" {
  default     = "ami-0747bdcabd34c712a"
  description = "Ubuntu 18 image "
  type        = string
}

variable "database-identifier-class" {
  default     = "db.t2.micro"
  description = "The Database Instance Type"
  type        = string
}

variable "ssh-location" {
  default     = "10.0.1.0/24"
  description = "IP address used by the Bastion host"
  type        = string
}

variable "instance-count" {
  default = "2"
}

variable "database-instance-identifier" {
  default     = "db-rbs"
  description = "The name of the RDS instance"
  type        = string
}
variable "multi-az-deployment" {
  default     = false
  description = "Create a Standby DB Instance"
  type        = bool
}
variable "username" {
  default = "admin"
  type    = string
}
variable "password" {
  default = "universZY123"
  type    = string
}
