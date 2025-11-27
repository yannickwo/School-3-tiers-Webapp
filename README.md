# School-3-tiers-Webapp
This client wants to run their application with the whole infrastructure on AWS. Basically, we need to build:

a vpc,
couple subnets
an elb (elastic load balancer) to stay in front of the webserver instances.
an autoscalling group to scale up and scale (horizontal) down our instances accordingly. (cpu over usage, instance terminate)
couple databases (RDS with PostgreSQL)
cloudwatch for this app monitoring.
We need a type of notification when our system is running (new instances getting created, instances getting terminated). And for that we will need a notification system like: sns (simple notification service)
The school domain will be jkdhhjfhjfhf.com and to get or purchase this domain, we will need the route 53 service. -We can also create a dns record with this service.
Our instances will generate log messages that will need storage and for storage we can use the ebs and s3 bucket
Also our instances will be serving the same content so we need a share filesystem between those instances and for that we will use efs service.
We need to manage who can access these infrastructure thru the console and to do that we need to configure access using IAM service.
Our instance will need access to s3 bucket for backup and logs and to do that, we need to create IAM roles.
To make sure we can recreate all these without manual effort, we will use terraform to write the whole infrastructure as code.
