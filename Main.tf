# Configure the AWS Provider
provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "cred"
}

# Create vpc
resource "aws_vpc" "vpc" {
  cidr_block              = "${var.vpc-cidr}"
  instance_tenancy        = "default"
  enable_dns_hostnames    = true

  tags      = {
    Name    = "ZY VPC"
  }
}

# Create Internet Gateway and Attach it to VPC
resource "aws_internet_gateway" "internet-gateway" {
  vpc_id    = aws_vpc.vpc.id

  tags      = {
    Name    = "ZY IGW"
  }
}

# Create Public Subnet 1
resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "${var.public-subnet-1-cidr}"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags      = {
    Name    = "Public Subnet 1"
  }
}

# Create Public Subnet 2
resource "aws_subnet" "public-subnet-2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "${var.public-subnet-2-cidr}"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags      = {
    Name    = "Public Subnet 2"
  }
}

# Create Route Table and Add Public Route
resource "aws_route_table" "public-route-table" {
  vpc_id       = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }

  tags       = {
    Name     = "Public Route Table"
  }
}

# Associate Public Subnet 1 to "Public Route Table"
resource "aws_route_table_association" "public-subnet-1-route-table-association" {
  subnet_id           = aws_subnet.public-subnet-1.id
  route_table_id      = aws_route_table.public-route-table.id
}

# Associate Public Subnet 2 to "Public Route Table"
resource "aws_route_table_association" "public-subnet-2-route-table-association" {
  subnet_id           = aws_subnet.public-subnet-2.id
  route_table_id      = aws_route_table.public-route-table.id
}

# Create Private Subnet 1
resource "aws_subnet" "private-subnet-1" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = "${var.private-subnet-1-cidr}"
  availability_zone        = "us-east-1a"
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "Private Subnet 1 | App Tier"
  }
}

# Create Private Subnet 2
resource "aws_subnet" "private-subnet-2" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = "${var.private-subnet-2-cidr}"
  availability_zone        = "us-east-1b"
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "Private Subnet 2 | App Tier"
  }
}

# Create Private Subnet 3
resource "aws_subnet" "private-subnet-3" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = "${var.private-subnet-3-cidr}"
  availability_zone        = "us-east-1a"
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "Private Subnet 3 | Database Tier"
  }
}

# Create Private Subnet 4
resource "aws_subnet" "private-subnet-4" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = "${var.private-subnet-4-cidr}"
  availability_zone        = "us-east-1b"
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "Private Subnet 4 | Database Tier"
  }
}
            # NAT GATEWAY
# Allocate Elastic IP Address (EIP 1)
resource "aws_eip" "eip-for-nat-gateway-1" {
  vpc    = true

  tags   = {
    Name = "EIP 1"
  }
}

# Allocate Elastic IP Address (EIP 2)
resource "aws_eip" "eip-for-nat-gateway-2" {
  vpc    = true

  tags   = {
    Name = "EIP 2"
  }
}

# Create Nat Gateway 1 in Public Subnet 1
resource "aws_nat_gateway" "nat-gateway-1" {
  allocation_id = aws_eip.eip-for-nat-gateway-1.id
  subnet_id     = aws_subnet.public-subnet-1.id

  tags   = {
    Name = "Nat Gateway Public Subnet 1"
  }
}

# Create Nat Gateway 2 in Public Subnet 2
resource "aws_nat_gateway" "nat-gateway-2" {
  allocation_id = aws_eip.eip-for-nat-gateway-2.id
  subnet_id     = aws_subnet.public-subnet-2.id

  tags   = {
    Name = "Nat Gateway Public Subnet 2"
  }
}

# Create Private Route Table 1 and Add Route Through Nat Gateway 1
resource "aws_route_table" "private-route-table-1" {
  vpc_id            = aws_vpc.vpc.id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat-gateway-1.id
  }

  tags   = {
    Name = "Private Route Table 1"
  }
}

# Associate Private Subnet 1 with "Private Route Table 1"
resource "aws_route_table_association" "private-subnet-1-route-table-association" {
  subnet_id         = aws_subnet.private-subnet-1.id
  route_table_id    = aws_route_table.private-route-table-1.id
}

# Associate Private Subnet 3 with "Private Route Table 1"
resource "aws_route_table_association" "private-subnet-3-route-table-association" {
  subnet_id         = aws_subnet.private-subnet-3.id
  route_table_id    = aws_route_table.private-route-table-1.id
}

# Create Private Route Table 2 and Add Route Through Nat Gateway 2
resource "aws_route_table" "private-route-table-2" {
  vpc_id            = aws_vpc.vpc.id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat-gateway-2.id
  }

  tags   = {
    Name = "Private Route Table 2"
  }
}

# Associate Private Subnet 2 with "Private Route Table 2"
resource "aws_route_table_association" "private-subnet-2-route-table-association" {
  subnet_id         = aws_subnet.private-subnet-2.id
  route_table_id    = aws_route_table.private-route-table-2.id
}

# Associate Private Subnet 4 with "Private Route Table 2"
resource "aws_route_table_association" "private-subnet-4-route-table-association" {
  subnet_id         = aws_subnet.private-subnet-4.id
  route_table_id    = aws_route_table.private-route-table-2.id

}
                  # SECURITY GROUP
# Create Security Group for the Application Load Balancer
resource "aws_security_group" "alb-security-group" {
  name        = "ALB Security Group"
  description = "Enable HTTP/HTTPS access on Port 80/443"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "HTTP Access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTPS Access"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "ALB Security Group"
  }
}

# Create Security Group for the Bastion Host
resource "aws_security_group" "ssh-security-group" {
  name        = "SSH Security Group"
  description = "Enable SSH access on Port 22"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "SSH Access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["${var.ssh-location}"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "SSH Security Group"
  }
}

# Create Security Group for the Web Server
resource "aws_security_group" "webserver-security-group" {
  name        = "Web Server Security Group"
  description = "Enable HTTP/HTTPS access on Port 80/443 via ALB and SSH access on Port 22 via SSH SG"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "HTTP Access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = ["${aws_security_group.alb-security-group.id}"]
  }

  ingress {
    description      = "HTTPS Access"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    security_groups  = ["${aws_security_group.alb-security-group.id}"]
  }

  ingress {
    description      = "SSH Access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups  = ["${aws_security_group.ssh-security-group.id}"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "Web Server Security Group"
  }
}

# Create Security Group for the Database
resource "aws_security_group" "database-security-group" {
  name        = "Database Security Group"
  description = "Enable MYSQL/Aurora access on Port 3306"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "MYSQL/Aurora Access"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups  = ["${aws_security_group.webserver-security-group.id}"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "Database Security Group"
  }
}
# Create instance - Bastion Host in Public subnet 1
resource "aws_instance" "Bastion-host1" {
    ami                         = "${var.ami}"
    associate_public_ip_address = true
    instance_type               = "t2.micro"
    availability_zone           = "us-east-1a"
    key_name                    = "Main-key"
    subnet_id                   = aws_subnet.public-subnet-1.id
    vpc_security_group_ids      = [aws_security_group.ssh-security-group.id]

    tags     = {
        Name = "Bastion-host1"
    }
}
# Create instance - Bastion Host in Public subnet 2
resource "aws_instance" "Bastion-host2" {
    ami                         = "${var.ami}"
    associate_public_ip_address = true
    instance_type               = "t2.micro"
    availability_zone           = "us-east-1b"
    key_name                    = "Main-key"
    subnet_id                   = aws_subnet.public-subnet-2.id
    vpc_security_group_ids      = [aws_security_group.ssh-security-group.id]

    tags     = {
        Name = "Bastion-host2"
    }
}

# Create instance - App webserver in Private subnet 1
resource "aws_instance" "webserver1" {
    ami                         = "${var.ami}"
    associate_public_ip_address = false
    instance_type               = "t2.micro"
    availability_zone           = "us-east-1a"
    key_name                    = "Main-key"
    subnet_id                   = aws_subnet.private-subnet-1.id
    vpc_security_group_ids      = [aws_security_group.webserver-security-group.id]
    count                       = "${var.instance-count}"

    user_data = <<-EOF
               #!/bin/bash
               sudo apt install httpd -y
               sudo systemctl start httpd
               sudo systemctl enable httpd
               echo "<h1>Welcome to ZY University<h1>" | sudo tee /var/www/html/index.html
    EOF

     tags = {
    "Name" = "webserver-sub1-${count.index}"
  }
}

# Configure EBS volume and connect it to webserver in AZ1
resource "aws_ebs_volume" "data-vol1" {
 availability_zone = "us-east-1a"
 count       = "${var.instance-count}"
 size = 100

 tags = {
Name = "data-volume1"
}

}
resource "aws_volume_attachment" "webserver-vol1" {
 device_name = "/dev/sdf"
 count       = "${var.instance-count}"
 volume_id   = "${element(aws_ebs_volume.data-vol1.*.id, count.index)}"
 instance_id = "${element(aws_instance.webserver1.*.id, count.index)}"

}

# Create instance - App webserver in Private subnet 2
resource "aws_instance" "webserver2" {
    ami                         = "${var.ami}"
    associate_public_ip_address = false
    instance_type               = "t2.micro"
    availability_zone           = "us-east-1b"
    key_name                    = "Main-key"
    subnet_id                   = aws_subnet.private-subnet-2.id
    vpc_security_group_ids      = [aws_security_group.webserver-security-group.id]
   count                        = "${var.instance-count}"

    user_data = <<-EOF
               #!/bin/bash
               sudo apt install httpd -y
               sudo systemctl start httpd
               sudo systemctl enable httpd
               echo "<h1>Welcome to ZY University<h1>" | sudo tee /var/www/html/index.html
    EOF

     tags = {
    Name = "webserver-sub2-${count.index}"
  }
}

# Configure EBS volume and connect it to EC2 instance in AZ2
resource "aws_ebs_volume" "data-vol2" {
 availability_zone = "us-east-1b"
 count             = "${var.instance-count}"
 size              = 100

 tags = {
 Name = "data-volume2"
}

}
resource "aws_volume_attachment" "webserver-vol2" {
 device_name = "/dev/sdf"
 count       = "${var.instance-count}"
 volume_id   = "${element(aws_ebs_volume.data-vol2.*.id, count.index)}"
 instance_id = "${element(aws_instance.webserver2.*.id, count.index)}"
 

}

# Application load balancer
resource "aws_lb" "zyuniversitylb" {
  name               = "alb-zyuniversity"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-security-group.id]
  subnets            = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]

  enable_deletion_protection = true


  tags          = {
    Environment = "production"
  }
}

# Create Database Subnet Group
resource "aws_db_subnet_group" "database-subnet-group" {
  name         = "database subnets"
  subnet_ids   = [aws_subnet.private-subnet-3.id, aws_subnet.private-subnet-4.id]
  description  = "Subnets for Database Instance"

  tags   = {
    Name = "Database Subnets"
  }
}

# Create Database Instance
resource "aws_db_instance" "database-instance" {
  allocated_storage       = 20
  instance_class          = "${var.database-identifier-class}"
  skip_final_snapshot     = true
  availability_zone       = "us-east-1a"
  engine                  = "mysql"
  engine_version          = "8.0.20"
  name                    = "DB1"
  username                = "${var.username}"
  password                = "${var.password}" 
  identifier              = "${var.database-instance-identifier}"
  db_subnet_group_name    = aws_db_subnet_group.database-subnet-group.name
  multi_az                = "${var.multi-az-deployment}"
  vpc_security_group_ids  = [aws_security_group.database-security-group.id]
}

# Create EFS  
resource "aws_efs_file_system" "ZY-EFS" {
  creation_token = "ZY-EFS"

  tags   = {
    Name = "Vol-Shared"
  }
}

resource "aws_efs_mount_target" "efs-mt" {
   file_system_id  = aws_efs_file_system.ZY-EFS.id
   subnet_id            = aws_subnet.efs.id
   security_groups = ["${aws_security_group.efs-security-group.id}"]
 }

resource "aws_subnet" "efs" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.0.0/24"
}

# Create Security Group for the EFS
resource "aws_security_group" "efs-security-group" {
  name        = "EFS Security Group"
  description = "Enable NFS access on Port 2049"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "NFS Access"
    from_port        = 2049
    to_port          = 2049
    protocol         = "tcp"
    security_groups  = ["${aws_security_group.webserver-security-group.id}"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "EFS Security Group"
  }
}

# Create a Route53
resource "aws_route53_zone" "zyuniversity" {
  name = "www.zyuniversity.edu"
}

# Create S3 bucket
resource "aws_s3_bucket" "zyuniversity-edu" {
  bucket = "zyunivers1stbuck"
  acl    = "public-read"

  tags = {
    Name        = "zyunivers1stbuck"
    Environment = "Prod"
  }
}
             # Autoscalling group
# Create a Launch configuration template 
resource "aws_launch_configuration" "webserver" {
  name_prefix = "webserver-"

  image_id = "ami-0747bdcabd34c712a" 
  instance_type = "t2.micro"
  key_name = "Main-key"

  security_groups = [aws_security_group.webserver-security-group.id]
  associate_public_ip_address = false

  user_data = <<-EOF
               #!/bin/bash
               sudo apt install httpd -y
               sudo systemctl start httpd
               sudo systemctl enable httpd
               echo "<h1>Welcome to ZY University<h1>" | sudo tee /var/www/html/index.html
    EOF

  lifecycle {
    create_before_destroy = true
  }
}

# Autoscalling creation
resource "aws_autoscaling_group" "webserver" {
  name                      = "${aws_launch_configuration.webserver.name}-asg"
  min_size                  = 1
  desired_capacity          = 2
  max_size                  = 4
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  launch_configuration      = aws_launch_configuration.webserver.name

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"
  vpc_zone_identifier  = [ aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id ]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "webserver"
    propagate_at_launch = true
  }

}

resource "aws_autoscaling_policy" "web_policy_up" {
  name = "web_policy_up"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.webserver.name
}

# CloudWatch Alarms to monitor the CPU
resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_up" {
  alarm_name = "web_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "60"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webserver.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ aws_autoscaling_policy.web_policy_up.arn ]
}

resource "aws_autoscaling_policy" "web_policy_down" {
  name = "web_policy_down"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.webserver.name
}

resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_down" {
  alarm_name = "web_cpu_alarm_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "10"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webserver.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ aws_autoscaling_policy.web_policy_down.arn ]
}

# SNS (simple notification service)
resource "aws_sns_topic" "system_updates" {
  name = "system-info"
delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF

}


