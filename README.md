# Flask Microservices Application Overview

## Core Services

- **Frontend Service**: Interfaces with users, handling actions like login and data entry, all through Flask.

- **User Service**: Manages user accounts, authentication, and securely stores data using SQLite.

- **Data Service**: Responsible for storing and retrieving user data, also leveraging SQLite.

## System Design

- **Modular Architecture**: Each service focuses on specific functionalities for better scalability and maintenance.
- **Inter-service Communication**: Achieved via HTTP requests, promoting a decoupled yet cohesive structure.

# Running the Application Locally

## Prerequisites

Before you begin, ensure you have the following installed:
- Docker
- Docker Compose

## Steps to Run

1. **Clone the Repository**:
   Execute the following command to clone the project repository to your local machine:
   ```bash
   git clone https://github.com/GeorgiYovchev/f-project.git


2. **Navigate to the Project Directory**:
   Change into the project directory:
   ```bash
   cd f-project


3. **Run Docker Compose**:
   Start the application by running Docker Compose. This will build and start all the services defined in the `docker-compose.yml` file:
   ```bash
   docker-compose up

## Stopping the Application
1. **To stop the application, use the following Docker Compose command:**
   ```bash
   docker-compose down 

# CI/CD

In this section, we discuss the main CI/CD Pipeline for the Frontend service.

![CI/CD Pipeline](.github/workflows/diagram.jpg)

## Overview

## CI Key Components

The CI pipeline for the Frontend Service is defined in GitHub Actions. 
It is triggered on every push to specific paths in the repository, ensuring that the codebase is continuously integrated and tested.

- **Editorconfig Check**: Ensures the existence of `.editorconfig` to maintain code style consistency across the project.
- **Linter**: Incorporates `black` for Python linting, upholding code quality and standard formatting.
- **Unit Tests**: Executes unit tests to validate the correctness of code changes, ensuring reliability.
- **Security Scan (Gitleaks)**: Performs a scan for secrets and sensitive credentials within the codebase, enhancing security.
- **Code Smells Detection (SonarCloud)**: Analyzes the code for potential bugs and smells, aiding in maintaining clean, efficient code.
- **Build and Push**: Automates the building of the Docker image and pushes it to DockerHub, streamlining deployment.
- **Docker Image Security Scan (Trivy)**: Scans the Docker image for vulnerabilities, ensuring deployment security.

# Continuous Deployment (CD) Components

## Overview

After the Continuous Integration (CI) process completes, including security testing and Docker image upload to Docker Hub, the workflow continues with Continuous Deployment (CD) pipeline. This pipeline consists of three primary stages: Building Infrastructure, Configuring the VM, and Deploying the Application.

## Stage 1: Building Infrastructure

The first stage of the CD process is crucial as it involves setting up the necessary infrastructure for the application. This process is automated using Terraform within the GitHub Actions workflow.

### GitHub Actions Workflow for Infrastructure

In this stage, the workflow performs several key actions:
- **Code Checkout**: Retrieves the latest codebase from the repository.
- **Terraform Setup**: Initializes Terraform with the specified version.
- **Infrastructure Creation**: Executes Terraform scripts to provision required infrastructure, such as cloud server.
- **Output Generation**: Outputs crucial information like the server IP address, which is used in subsequent stages.

### Terraform Configuration

The Terraform configuration in this stage is designed to set up and manage the cloud infrastructure. Key aspects include:
- **Version and Provider Specification**: Defines the required version of Terraform and configures cloud providers (like AWS and Hetzner Cloud).
- **State Management**: Configures backend for state management, ensuring consistent tracking of infrastructure changes.
- **Resource Definition and Allocation**: Creates cloud resource, such as virtual server as per the project requirements.
- **Output Information**: Provides essential details like server IP addresses for use in later stages of the pipeline.

This stage sets a solid foundation for the next steps, ensuring that the application has a robust and well-configured infrastructure to run on.
