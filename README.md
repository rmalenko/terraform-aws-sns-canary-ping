# Terraform AWS SNS Canary Ping Project

This GitHub project provides a Terraform code to set up an AWS CloudWatch Synthetics Canary that monitors a website's availability and sends alerts using Amazon SNS. It offers a lightweight and automated solution to monitor URL uptime by periodically pinging the target site and triggering email notifications if a failure occurs.

Features:
- Deploys a Canary for regular website pings.
- Automates email alerts via SNS on error responses.
- Fully configurable using Terraform for infrastructure as code.
- Simple alternative to third-party monitoring tools like Pingdom.
