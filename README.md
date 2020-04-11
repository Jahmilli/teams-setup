# Teams Setup

## Description

This is a repository used to manage the nginx as well as any configuration/templating required to deploy the teams application.
In our case, we likely won't need NGINX as we will do SSL termination from the ALB and just route requests directly to the ECS service. However, its useful to keep the NGINX config here for future use.

## Running Locally

To build nginx, from the nginx directory, run: `docker image build -t custom-nginx:latest .`

To run the docker compose, you can run: `docker-compose up`.

**Note:** This requires the teams-backend image to be stored in your images locally.

## Steps to deploy onto ECS

There are a number of steps required to deploy onto ECS. This includes creating an ECR, cluster, task definition, ALB and service definition. Following this, we can just push our image to ECR, and the service should pick up the latest changes **(Need to verify this)**.

Useful Links include:

- https://epsagon.com/blog/deploying-java-spring-boot-on-aws-fargate/

### Creating the infrastucture

#### Create an ECR repository:

```
aws ecr create-repository --repository-name teams-backend
```

#### Creating ALB and Target Group

TODO: Add here

#### Create Task Definition

```
aws ecs register-task-definition --family <Task_Name> --cli-input-json file://ecs/teams-backend.td.json --region ap-southeast-2
```

#### Create Service Definition

TODO: Add here

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
