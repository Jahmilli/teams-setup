# Teams Setup

## Description

This is a repository used to manage the nginx as well as any configuration/templating required to deploy the teams application.

## Running Locally

To build nginx, from the nginx directory, run: `docker image build -t custom-nginx:latest .`

To run the docker compose, you can run: `docker-compose up`.

**Note:** This requires the teams-backend image to be stored in your images locally.
