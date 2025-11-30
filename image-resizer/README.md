# 🖼️ Serverless Image Transform with Terraform

A fully serverless, scalable, and cost-efficient image transformation service using AWS CloudFront, Lambda, S3, and Terraform.

This service allows you to transform images on the fly (resize, change format, optimize quality, etc.) using query parameters.
Transformed images are cached in S3 and served globally through CloudFront for high performance.

## 📌 Architecture Overview

High-Level Flow

- User requests an image with transformation parameters /image.png?format=jpeg&height=200&width=200&quality=70
- CloudFront Function rewrites the URL → points to cached transformed image path
- If transformed version exists → CloudFront returns it instantly
- If not → request forwarded to Lambda
- Lambda fetches raw image from S3, transforms it, stores it in transformed bucket
- CloudFront caches and returns transformed image

## 🚀 Features

- Format conversion → PNG, JPEG, WebP
- Resize → width × height
- Quality optimization
- Automatic caching using S3 + CloudFront
- Pay-as-you-go serverless infrastructure
- Fully provisioned using Terraform
- CloudFront Function for URL rewrite
- Lambda for processing transformations

## 🔧 Tech Stack

- AWS CloudFront – CDN distribution + URL rewrite
- AWS Lambda – Serverless image processing
- AWS S3 – Raw and transformed image storage
- AWS IAM – Secure access control
- Terraform – Infrastructure as Code
- Sharp (NodeJS) – Image transformation library

### 🏗️ Terraform Setup

```bash
# Goto the directory and download the sharp module
cd module/lambda/sharp && \
npm install sharp --cpu=x64 --os=linux --libc=glibc

# Initialize Terraform
terraform init
# Validate configuration
terraform validate
# Validate configuration
terraform validate
# Validate configuration
terraform validate
# Preview changes
terraform plan
# Apply infrastructure
terraform apply -auto-approve
# View outputs
terraform output
```

### 🪣 S3 Buckets

Terraform creates two buckets:

Bucket Name Purpose

- raw-image-bucket Stores original / unmodified images
- transformed-image-bucket Stores processed/resized/optimized images

### λ Lambda Function

The Lambda function uses Sharp to process transformations from query parameters:

- Supported Parameters
- Parameter Description
- format jpeg, webp, png
- width change output width
- height change output height
- quality 1–100 output quality
- Example Transform Request
- https://<cloudfront-url>/image.png?format=jpeg&width=200&height=200&quality=70

### 🌐 CloudFront Behavior

CloudFront handles:

- URL rewrite using CloudFront Functions
- Checking transformed bucket before invoking Lambda
- Global caching for ultra-fast delivery

### 🧪 Testing the Service

- Original Image: https://<cloudfront-url>/image.png
- Resize + Convert to JPEG: https://<cloudfront-url>/image.png?format=jpeg&width=300&height=300
- Convert to WebP: https://<cloudfront-url>/image.png?format=webp&quality=90
- Cache Hit

You can verify transformed images saved under:

s3://transformed-image-bucket/<generated-key>

### 📈 Benefits

90–95% cost reduction vs EC2 image servers

Zero downtime

Edge caching improves load time globally

Highly scalable and event-driven

Perfect for e-commerce, dynamic assets, media platforms
