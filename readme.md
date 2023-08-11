# Kubernetes with Github Actions and AWS CodePipeline CI/CD example

Kubernetes Manifests to provision deployment configurations for your microservice applications

## The AWS Pipeline

Github --> AWS CodeBuild (Validate Manifest) --> AWS CodeBuild (Deploy to Amazon EKS Cluster)

## Pull Request/Push Testing

Github --> Github Actions 