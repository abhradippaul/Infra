# Terraform AWS Project — CloudFront, EC2, and S3

This Terraform project creates an AWS setup with CloudFront, EC2, and S3 using separate modules.

## Project Overview

<img width="1592" height="846" alt="diagram-export-10-29-2025-2_38_28-PM" src="https://github.com/user-attachments/assets/891f8cbe-a559-402e-8857-754981f34f0d" />

- This setup demonstrates how to combine multiple AWS services using Terraform modules for better organization and reusability.

- The S3 bucket hosts static assets such as HTML, CSS, and JS.

- The EC2 instance runs a backend server or dynamic web application.

- The CloudFront distribution acts as a CDN that connects both S3 and EC2 as origins to serve content securely and efficiently

### Components:-

- S3 → Stores static website files.

- EC2 → Hosts a web application or backend.

- CloudFront → CDN to distribute content from S3 and EC2 globally.

### How It Works

- S3 Bucket stores static files.

- EC2 Instance runs the server.

- CloudFront connects to both S3 and EC2 as origins to serve content.
