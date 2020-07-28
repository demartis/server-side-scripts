Debian 10 + Docker only
=======================

This is all I need to run Debian 10 server with
Docker, Docker Compose and a minimum set of tools for my production servers

----
Use this script to configure *Docker + Docker Compose* in a newly installed Debian 10.
It works also with Debian 9.

   
## Usage
1. Install a fresh Debian 10 or Debian 9
2. Ensure wget is pre-installed:
    ```bash
    apt install wget 
    ```
3. Run:
    ```bash
    bash <(wget -q0- https://github.com/demartis/server-side-scripts/tree/master/fresh-install/debian-docker/start-here.sh)
    ```

## What this script do:
This script will:
- update all apt packages
- install latest release of Docker
- install latest release of Docker Compose
- run and start on boot Docker engine


## Thoughts about Docker
I encourage you to follow these recommendations for Docker:
- Prefer minimalist official base images
- Use official, purpose-built images (Also, See [Security Best Practices for Docker Images](https://www.wintellect.com/security-best-practices-for-docker-images/?ref=hackernoon.com))
- Use tags to reference specific image versions
- Use multi-stage builds
- Persist data outside of a container, better with [Volumes](https://docs.docker.com/storage/volumes/)
- Try to not use a root user whenever possible
- Leverage Docker enterprise features for additional protection
- Use Docker compose to use as Infrastructure As Code and keep track using tags
