# Zomato Production EC2 Provisioning

This project uses **Terraform** to create an AWS EC2 web server and automatically configure it as a simple PHP web server.

## What This Project Does

* Creates an AWS EC2 instance
* Uses a `t3.micro` instance
* Connects to the instance using SSH
* Copies `setup.sh` to the EC2 instance
* Installs Apache (`httpd`) and PHP
* Creates a health check page
* Creates a PHP application page
* Starts and enables Apache and PHP-FPM services
* Re-runs provisioning when `setup.sh` changes

## Architecture

```text
Terraform
    |
    v
AWS EC2 Instance
    |
    +-- Apache (httpd)
    |
    +-- PHP
    |
    +-- setup.sh
    |
    +-- index.php
    |
    +-- health.html
```

## Files

```text
.
├── main.tf
└── setup.sh
```

### main.tf

Defines:

* AWS provider
* EC2 instance
* Terraform `null_resource`
* File provisioner
* Remote-exec provisioner
* SSH connection

### setup.sh

The script:

1. Installs Apache and PHP
2. Creates `health.html`
3. Creates `index.php`
4. Restarts Apache and PHP-FPM
5. Enables the services at boot

## Requirements

* AWS account
* Terraform installed
* AWS credentials configured
* Existing EC2 key pair
* SSH private key (`mykey-py.pem`)
* Existing security group allowing SSH and HTTP access

## Usage

Initialize Terraform:

```bash
terraform init
```

Validate the configuration:

```bash
terraform validate
```

Review the changes:

```bash
terraform plan
```

Create the EC2 instance:

```bash
terraform apply
```

To destroy the infrastructure:

```bash
terraform destroy
```

## Important

The private key file should **not** be uploaded to GitHub.

Add the following to `.gitignore`:

```text
*.pem
.terraform/
*.tfstate
*.tfstate.*
```

This project is created for learning and practicing **Terraform, AWS EC2, SSH provisioning, Bash scripting, Apache, and PHP**.
