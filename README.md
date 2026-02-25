Deploy Strapi on AWS ECS (Fargate) with Blue/Green Deployment & Terraform

This guide explains how to deploy a Strapi application on AWS ECS Fargate using Blue/Green deployments via CodeDeploy, fully automated with Terraform and GitHub Actions CI/CD.

1. Create a New Strapi Application
npx create-strapi-app@latest my-strapi
cd my-strapi
npm run develop

Test locally to verify the app runs.

2. Containerize the Strapi Application

Inside my-strapi/, create a Dockerfile.
Then build and tag your image:

docker build -t strapi .
3. Set Up an ECR Repository

Create an ECR repository using Terraform.

Example ECR URI:

811738710312.dkr.ecr.us-east-1.amazonaws.com/strapi-bluegreen-ecr

Tag and push the Docker image:

docker tag strapi:latest 811738710312.dkr.ecr.us-east-1.amazonaws.com/ecs-bluegreen-ecr:latest
docker push 811738710312.dkr.ecr.us-east-1.amazonaws.com/ecs-bluegreen-ecr:latest
4. Infrastructure Setup Using Terraform

Terraform will create and manage all AWS resources.

Core AWS Resources

VPC with public/private subnets

Internet Gateway & NAT Gateway

Security groups

IAM roles for ECS and CodeDeploy

ECS & Load Balancer

ECS Cluster (Fargate)

ECS Task Definition (updated through CI/CD)

ECS Service using CodeDeploy deployment controller

Application Load Balancer

Two Target Groups:

Blue → Production

Green → New Deployment

ALB Listeners (HTTP 80 and optional 443)

CodeDeploy

Application & Deployment Group

Deployment configuration (e.g., Canary 10% → 5 minutes)

Auto rollback

Old task set termination

Deploy with:

terraform init
terraform apply
5. Configure GitHub Actions (CI/CD)

Add workflow files inside:

.github/workflows/
CI Workflow (ci.yaml)

Build Docker image

Tag image

Push to ECR

CD Workflow (cd.yaml)

Run Terraform

Update ECS Task Definition

Trigger Blue/Green deployment

Required GitHub Secrets
Secret Name	Description
AWS_ACCESS_KEY_ID	AWS user key
AWS_SECRET_ACCESS_KEY	AWS secret key
AWS_REGION	e.g., us-east-1
6. Initial Deployment

First deployment happens automatically when you push code:

CI builds and pushes image to ECR

CD runs Terraform

Task Definition updates

CodeDeploy deploys

Traffic shifts Blue → Green

ECS begins serving Strapi through the ALB

7. Updating Strapi (Subsequent Deployments)

Anytime you:

Modify Strapi code

Add plugins

Update configurations

Just commit & push.

CI Workflow:

Builds new Docker image

Tags it

Pushes to ECR

CD Workflow:

Runs Terraform

Creates new Task Definition revision

Triggers Blue/Green deployment

Shifts traffic to Green

Terminates old Blue tasks

Zero downtime every time.

8. Access the Strapi Application

Terraform outputs:

alb_dns_name = ecs-strapi-123456.elb.amazonaws.com

Access Strapi:

http://<ALB-DNS>

Strapi listens internally on port 1337, but ALB listens on 80.

Optional Custom Port (9000)

Add an ALB listener for port 9000 → point it to Blue target group.

Access:

http://<ALB-DNS>:9000
9. Verify Blue/Green Switching

During deployment, CodeDeploy:

Launches new (Green) tasks

Runs health checks via ALB

Shifts traffic from Blue → Green

Terminates old tasks

Check deployment status:

ECS Console → Cluster → Service → Deployments
CodeDeploy → Application → Deployments

You can visually see Blue/Green switching.