# Teams Setup

## TODO:

- Figure sending HTTPS requests from client to ALB and do SSL termination from ALB.
- Set up CI (we want the following:
  - lint checks
  - Tests (unit tests)
  - Application build (output to JAR)
  - Docker build
  - Docker tag (make sure git commit is included as well)
  - Docker push to ECR
  - Trigger new task deployment in ECS

## Description

This is a repository used to manage the nginx as well as any configuration/templating required to deploy the teams application.
In our case, we likely won't need NGINX as we will do SSL termination from the ALB and just route requests directly to the ECS service. However, its useful to keep the NGINX config here for future use.

## Running Locally with Docker Compose (Not required anymore)

To build nginx, from the nginx directory, run: `docker image build -t custom-nginx:latest .`

To run the docker compose, you can run: `docker-compose up`.

**Note:** This requires the teams-backend image to be stored in your images locally.

## Steps to deploy onto ECS

There are a number of steps required to deploy onto ECS. This includes creating an ECR, cluster, task definition, ALB and service definition. Following this, we can just push our image to ECR, and the service should pick up the latest changes **(Need to verify this)**.

Useful Links include:

- https://epsagon.com/blog/deploying-java-spring-boot-on-aws-fargate/
- https://medium.com/@bradford_hamilton/deploying-containers-on-amazons-ecs-using-fargate-and-terraform-part-2-2e6f6a3a957f
- https://blog.oxalide.io/post/aws-fargate/

### Creating the infrastucture

Infrastructure is provisioned using Terraform. I was originally going to just try and use JSON files in combination with the AWS CLI but it seemed like manual work would be needed or a bit of extra scripting.

#### Setup Terraform State Bucket

Terraform state is managed in S3 in `sebs-terraform-state`.

#### Create an ECR repository:

Don't want to manage this with Terraform as if we want to delete everything we may not necessarily want to remove all the images...

```
aws ecr create-repository --repository-name teams-backend
```

#### Create IAM Group and Service Account in AWS

This was done manually from the console and sort of lazily. The following were created:

- User:
  - name: cicd-service-account
  - group: cicd-service-account
  - tags: none
- IAM Group:
  - name: cicd-service-account
  - permissions:
    - AmazonECS_FullAccess
    - AmazonEC2ContainerRegistryPowerUser

Once the service account is created, we need to add the access key and secret access key as Github Secrets.

#### Creating Everything Else

- Make sure you have Terraform, to check if you do, run: `terraform --version`

- Make sure you have correct access to AWS

- To setup the infrastructure, run: `ENVIRONMENT=nonprod TERRAFORM_RUN="apply" ./scripts/build.sh`

#### Removing Infrastructure created with Terraform

- Run: `ENVIRONMENT=nonprod TERRAFORM_RUN="destroy" ./scripts/build.sh`

**Note:** There is an existing issue with Terraform where it cannot delete the ECS cluster whilst tasks are active. You will need to stop all Tasks before running destroy to ensure destroy does not hang when deleting the cluster.

### Building/Pushing and Deploying

#### Login to ECR:

```
aws ecr get-login-password --region ap-southeast-2 | docker login --username AWS --password-stdin 699129468547.dkr.ecr.ap-southeast-2.amazonaws.com
```

#### Tagging the Image

```
docker tag teams-backend:latest 699129468547.dkr.ecr.ap-southeast-2.amazonaws.com/teams-backend:latest
```

#### Pushing the Image

```
docker push 699129468547.dkr.ecr.ap-southeast-2.amazonaws.com/teams-backend:latest
```

### Useful things

To remove dangling images run:

```
docker images | grep -i none | tr -s ' ' | cut -d ' ' -f 3 | while read line; do docker rmi $line; done
```
