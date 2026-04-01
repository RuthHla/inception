*This project has been created as part of the 42 curriculum by alandel*
# Inception

## Description

The goal of this project is to build a small web infrastructure using Docker. It introduces the fundamentals of system administration and containerization by requiring the deployment of multiple services inside isolated containers. The challenge is to design a reproducible, portable, and maintainable environment that can run consistently across different machines.

The infrastructure is composed of:

* A **NGINX** container acting as a web server with TLS (Transport Layer Security)
* A **WordPress** container running PHP-FPM
* A **MariaDB** container used as the database

Each service runs in its own container and communicates through a Docker network.

This project answers a key question:

> How can we create a web infrastructure that is portable, reproducible, and independent of the host system?

## Instructions

### Prerequisites

* Docker
* Docker Compose
* Make

### Setup

Before running the project, you must:

* Fill the `.env` file with the required variables

### Installation & Run

```bash
git clone https://example.com inception
cd inception
make
```

### Access

Once the containers are running:

* Website: https://alandel.42.fr

## Project description

### Containers

#### NGINX

* Acts as a reverse proxy
* Handles HTTPS (TLSv1.2 / TLSv1.3)
* Forwards requests to WordPress (PHP-FPM)

#### WordPress

* Runs PHP-FPM
* Connects to MariaDB
* Serves dynamic content

#### MariaDB

* Stores WordPress data
* Initialized via script at container startup

## Docker Overview

### Why Docker?

Docker allows:

* Isolation of services
* Reproducibility of environments
* Easier deployment and scaling

This avoids the classic "it works on my machine" problem.

### Docker vs Virtual Machines

| | Docker | Virtual Machines |
|---|---|---|
| Lightweight | ✓ | ✗ |
| Fast startup | ✓ | ✗ |
| Share host kernel | ✓ | ✗ |
| Full OS per VM | ✗ | ✓ |
| Low resource usage | ✓ | ✗ |

➡️ Docker is more efficient for microservices architectures.

### Docker Compose

Docker Compose is used to:

* Define multi-container applications
* Manage services, networks, and volumes in one file

Key advantages:

* Simplifies orchestration
* Centralized configuration

## Data Management

### Volumes vs Bind Mounts

| | Volumes | Bind Mounts |
|---|---|---|
| Managed by Docker | ✓ | ✗ |
| Linked to host filesystem | ✗ | ✓ |
| Safer & portable | ✓ | ✗ |
| More flexible | ✗ | ✓ |
| Recommended for production | ✓ | ✗ |
| Useful for development | ✗ | ✓ |

➡️ This project uses Docker volumes to persist database and WordPress data.

### Environment Variables vs Secrets

| | Environment Variables | Docker Secrets |
|---|---|---|
| Easy to use | ✓ | ✗ |
| More secure | ✗ | ✓ |
| Stored in plain text | ✓ | ✗ |
| Encrypted | ✗ | ✓ |
| Good for non-sensitive data | ✓ | ✗ |
| Used for passwords | ✗ | ✓ |

➡️ This project uses Environment Variables for simplicity reasons.

## Networking

### Docker Network vs Host Network

| | Docker Network | Host Network |
|---|---|---|
| Isolated | ✓ | ✗ |
| Direct access to host | ✗ | ✓ |
| Secure | ✓ | ✗ |
| Less secure | ✗ | ✓ |
| Internal communication | ✓ | ✗ |
| No isolation | ✗ | ✓ |

➡️ This project uses a Docker network to allow containers to communicate securely.

## How It Works (Simplified Flow)

1. User sends HTTPS request to NGINX
2. NGINX handles SSL and forwards request
3. WordPress processes the request via PHP-FPM
4. WordPress queries MariaDB
5. Response is returned to the user

## Resources

### Documentation

* [Docker official documentation](https://docs.docker.com/)
* [Docker Compose documentation](https://docs.docker.com/compose/) (https://www.datacamp.com/fr/tutorial/docker-tutorial)
* [NGINX documentation](https://nginx.org/en/docs/) (https://openclassrooms.com/fr/courses/1733551-gerez-votre-serveur-linux-et-ses-services/5236081-mettez-en-place-un-reverse-proxy-avec-nginx)
* [MariaDB documentation](https://mariadb.com/docs/)
* [WordPress documentation](https://wordpress.org/documentation/)

### Tutorials

* Various YouTube tutorials on Docker basics

## Use of AI

AI was used in this project for:

* Understanding Docker concepts and best practices
* Clarifying theoretical concepts (Docker, NGINX, MariaDB)
