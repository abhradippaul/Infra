# Serverless Dynamic Website on AWS with Terraform

A fully serverless, scalable, and low-cost architecture for hosting a dynamic website using AWS services such as S3, CloudFront, Cognito, API Gateway, Lambda, and DynamoDB.

<img width="1475" height="667" alt="diagram-export-28-11-2025-8_09_50-am" src="https://github.com/user-attachments/assets/529ea766-630a-4b48-b115-d5182d36a946" />

## Overview

This project implements a complete serverless web application where:

- Static website (HTML, CSS, JS) is hosted on S3.
- CloudFront CDN distributes content globally with caching and HTTPS.
- Cognito User Pool + Hosted UI provides secure authentication.
- API Gateway exposes REST API endpoints for CRUD operations.
- Lambda functions perform backend logic for Create, Read, Update, Delete actions.
- DynamoDB stores application data in a fully managed, scalable NoSQL database.
- The architecture ensures high availability, automatic scaling, IAM-based security, and zero server management.

## Components

### Amazon S3 – Static Website Hosting

- Stores all frontend assets (index.html, JS, CSS, images).
- Public access is blocked; CloudFront origin access control (OAC) is used.
- High durability and availability.

### Amazon CloudFront – CDN

- Speeds up content delivery globally.
- Handles HTTPS using ACM SSL certificate.
- Integrates with S3 using OAC for secure access.

### Amazon Cognito – Authentication

- Manages user registration, login, JWT token generation.
- Protects API Gateway endpoints using Cognito Authorizer.
- Supports MFA, password policies, and email verification.

### Amazon API Gateway – REST API Layer

- Exposes secure REST endpoints for the frontend.
- Integrates with Lambda via proxy integration.
- Uses Cognito Authorizer to validate tokens.

### AWS Lambda – Serverless Backend

Functions implement CRUD operations:

- Create Task
- Get Task(s)
- Update Task
- Delete Task

Zero servers to manage; auto-scaling based on traffic.

### Amazon DynamoDB – NoSQL Database

- Stores user data and task items.
- Fast, scalable, pay-per-use billing.
- Uses partition & sort keys for efficient queries.

## Features

- Fully serverless (no EC2, no servers).
- Highly scalable and low-cost.
- Secure user authentication.
- Real-time CRUD operations.
- Modular Terraform infrastructure.
