# Terraform AWS Infrastructure Project

This project provisions a scalable and secure AWS infrastructure using Terraform. It includes a custom VPC, public and private subnets, internet and NAT gateways, a bastion host, an autoscaling group of NGINX instances, and an Application Load Balancer (ALB).

---

## 📐 Architecture Overview

<img width="1478" height="792" alt="diagram-export-25-07-2025-15_02_25" src="https://github.com/user-attachments/assets/81c36677-61c7-4347-88cf-7cf2f6e4575e" />

The infrastructure consists of a custom VPC with two public subnets and two private subnets distributed across different Availability Zones for high availability. An Internet Gateway is attached to the VPC, allowing resources in public subnets to access the internet. 

The public subnets host an Application Load Balancer (ALB) and a Bastion Host. The ALB listens for HTTP requests and routes them to NGINX web servers deployed in private subnets via a Target Group. The Bastion Host allows secure SSH access to private EC2 instances and is the only instance directly accessible from the internet.

Private subnets do not have direct internet access; instead, they route outbound traffic through a NAT Gateway located in one of the public subnets. The NGINX instances in the private subnets are deployed using an Auto Scaling Group and are not publicly accessible, ensuring security and scalability.

---


## 🔧 Features

- 🏗️ **VPC** with CIDR block

- 🌐 **Public and Private Subnets** (2 each, across AZs)
- 🚪 **Internet Gateway** attached to public subnets
- 🔁 **NAT Gateway** in public subnet for private subnet egress
<img width="932" height="880" alt="Screenshot 2025-07-25 134029" src="https://github.com/user-attachments/assets/0321c3ab-98ec-465b-a404-629636fc2f0e" />
<img width="942" height="296" alt="Screenshot 2025-07-25 134123" src="https://github.com/user-attachments/assets/afeb6a4b-a3c9-46c4-9720-88c9b094f22e" />
<img width="1612" height="376" alt="Screenshot 2025-07-25 130210" src="https://github.com/user-attachments/assets/aa58764f-cbd6-4fda-998c-6e2f24074270" />
<img width="871" height="253" alt="Screenshot 2025-07-25 133954" src="https://github.com/user-attachments/assets/c111c2de-e5df-4804-b06f-e89175aac8e3" />

- 🧱 **Bastion Host** in public subnet for SSH access to private subnet instances
<img width="942" height="690" alt="Screenshot 2025-07-25 134211" src="https://github.com/user-attachments/assets/00434190-d4f7-41af-8813-b42fa32ead0e" />

- 📦 **Auto Scaling Group** with NGINX EC2 instances in private subnets
<img width="1637" height="817" alt="Screenshot 2025-07-25 130106" src="https://github.com/user-attachments/assets/380a7de7-5b63-4ca4-adb4-f3179e5f7b87" />

- ⚖️ **Application Load Balancer** to distribute incoming traffic to NGINX instances
<img width="1890" height="382" alt="Screenshot 2025-07-25 130007" src="https://github.com/user-attachments/assets/b625b2e8-52f7-4512-98b3-810956586d48" />
<img width="1628" height="387" alt="Screenshot 2025-07-25 130038" src="https://github.com/user-attachments/assets/e52403b7-c540-418c-ab6a-e4bc1d81abe2" />

---

🔐 Security Groups
Bastion Host SG: Allows SSH (port 22) from your IP

ALB SG: Allows HTTP (port 80) from anywhere

Private EC2 SG: Allows HTTP from ALB only, SSH from bastion

<img width="783" height="325" alt="Screenshot 2025-07-25 125939" src="https://github.com/user-attachments/assets/e4fe5406-5f1a-48db-95ca-bbb5402a95c9" />

📦 NGINX Auto Scaling
The Auto Scaling Group launches EC2 instances in the private subnets with a user-data script that installs and starts NGINX. These instances are automatically registered to the ALB target group. Load balancing and health checks are handled by the ALB to ensure high availability and failover.

📌 Prerequisites
Terraform CLI

AWS CLI configured (aws configure)

SSH key pair in AWS

IAM credentials with required permissions
