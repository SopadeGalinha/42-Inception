# Evaluation Guide

## How Docker and Docker Compose Work

**Docker** is a platform that allows you to create, deploy, and run applications inside lightweight, portable containers. Think of a container as a small, efficient, and self-sufficient virtual machine that can run any application along with all its dependencies.

- **Containers:** Containers are isolated environments that bundle an application with all its dependencies. They share the host system's OS kernel, making them much lighter and faster than traditional virtual machines (VMs).
- **Images:** Containers are created from images, which are snapshots of a container's file system, including the application and its dependencies. An image is essentially a blueprint for a container.
- **Dockerfile:** A Dockerfile is a script containing a series of commands that Docker uses to build an image. It specifies the base image, application code, dependencies, and configuration steps.

**Docker Compose** is a tool used to define and manage multi-container Docker applications. It uses a YAML file (`docker-compose.yml`) to configure the services, networks, and volumes needed for the application. With a single command, Docker Compose can start all the services defined in the configuration file, making it easy to manage complex applications with multiple interconnected containers.

## Difference Between a Docker Image Used with Docker Compose and Without Docker Compose

When you use a **Docker image** without Docker Compose, you manually manage the creation and execution of individual containers using Docker commands. This approach is suitable for simple applications or when dealing with a single container. However, managing multiple containers with complex dependencies becomes cumbersome.

With **Docker Compose**, you define and manage multiple containers as a single service. The `docker-compose.yml` file allows you to specify how containers should interact, share networks, and persist data across containers. This approach simplifies orchestration, especially for multi-container applications, by allowing you to start, stop, and configure all containers together.

## Benefit of Docker Compared to Virtual Machines (VMs)

**Docker** provides several advantages over traditional **Virtual Machines (VMs)**:

- **Lightweight**: Docker containers share the host OS kernel, reducing overhead and allowing containers to be much lighter and faster to start than VMs, which include a full OS.
- **Portability**: Containers can run consistently across different environments (development, testing, production), eliminating the "it works on my machine" problem.
- **Efficiency**: Containers use fewer resources than VMs because they don't require a separate OS for each instance, enabling higher density of applications on the same hardware.
- **Speed**: Docker images can be built and deployed quickly, making them ideal for CI/CD pipelines and rapid iteration.

## Pertinence of the Directory Structure Required for This Project

The directory structure for this project is designed to organize resources efficiently and align with best practices for Docker and Docker Compose projects. The structure typically includes:

- **Application Code**: Organized into separate directories to isolate different components (e.g., `wordpress`, `mysql`).
- **Configuration Files**: `Dockerfile`, `.env`, and `docker-compose.yml` files are placed in the root directory for easy access and management.
- **Data Volumes**: Directories for persistent data (e.g., `data/wordpress`, `data/mysql`) are defined to ensure that container data is preserved across restarts and updates.

This structure enhances maintainability, scalability, and clarity, making it easier to manage, collaborate on, and deploy the project.

Sure! Here’s a simple explanation about Docker networks, using the example you provided:

---

### Docker Networks

Docker networks allow containers to communicate with each other and with the outside world in an isolated environment. They provide a way to manage how containers connect and exchange data.

#### Example: Defining a Docker Network

```yaml
networks:
  inception:
    name: inception
    driver: bridge
```

In this example:

- **`networks:`**: This section defines the networks used by the Docker containers.
- **`inception:`**: This is the name of the custom network.
- **`name: inception`**: This specifies the actual name of the network that Docker will use.
- **`driver: bridge`**: This specifies the type of network driver to use. The `bridge` driver creates a private internal network on your host machine, allowing containers connected to this network to communicate with each other.

#### Key Points

- **Bridge Network**: This is the default network driver. It creates a private network on your host machine and is used for communication between containers. Containers connected to the same bridge network can communicate with each other using their container names.

- **Custom Networks**: By defining custom networks, you can control which containers can interact with each other and manage network configurations more flexibly.

Docker networks are essential for defining how containers interact within your applications, ensuring they can connect as needed while maintaining isolation from other networks and services.

---

### How TLS/SSL Work
 Establishing a Secure Connection:
      Handshake: The client and server perform a "handshake" to establish a secure connection. During this process, they negotiate the type of encryption to use and exchange encryption keys.
      Certificates: The server presents a digital certificate to the client. This certificate serves as proof of identity and includes a public key used to establish a secure connection.

  Encryption:
      Symmetric and Asymmetric Encryption: After the handshake, the client and server use symmetric encryption to protect the data transmitted. Asymmetric encryption is initially used to exchange the symmetric encryption keys.

  Data Integrity:
      MAC (Message Authentication Code): TLS/SSL uses authentication codes to ensure that data has not been tampered with during transmission.

#### Importance of TLS/SSL

  Data Security: Protects sensitive data, such as personal and financial information, ensuring that it cannot be intercepted or altered.
  Authentication: Ensures that you are connecting to the correct server, helping to prevent phishing and man-in-the-middle attacks.
  Privacy: Ensures that the communication between the client and server is private and secure.

Example of Use

When you access a website using https://, you are using TLS/SSL to secure the communication between your browser and the web server. The "s" in https stands for "secure," indicating that the connection is encrypted.

## Environment Configuration (`.env` file)

Ensure that your `.env` file is correctly set up with the following configurations:

```ini
DOMAIN_NAME=jhogonca.42.fr

# SSL Certificates
CERTS_KEY=/etc/ssl/private/nginx-selfsigned.key
CERTS_CRT=/etc/ssl/certs/nginx-selfsigned.crt

# MySQL Configuration
MYSQL_DATABASE=WordpressDB
MYSQL_ROOT_PASSWORD=1234root4321
MYSQL_USER=jhogonca
MYSQL_PASSWORD=1234mysql4321

# WordPress Setup
FTP_USER=jhogonca
FTP_PASSWORD=1234ftp4321
```

## Pre-Launch Checklist

### 1. Ensure No Conflicting Services Are Running

Run the following command to check the status of Docker components (networks, volumes, containers, and images):

```bash
make status
```

This command will output:

- **Networks**: List of Docker networks.
- **Volumes**: List of Docker volumes.
- **Containers**: Details of all containers, including their IDs, names, images, statuses, and ports.
- **Images**: List of Docker images.

### 2. Launch the Project

Start the project with:

```bash
make
```

### 3. Verify Setup Completion

After running the project, ensure that all Docker components (networks, volumes, images, and containers) are set up correctly by executing:

```bash
make status
```

### 4. Inspect a Specific Volume

To inspect a specific Docker volume, use:

```bash
docker volume inspect <volume_name>
```

Replace `<volume_name>` with the actual name of the volume you wish to inspect.

## WordPress Configuration Verification

### 1. Verify the `wp-config.php` File

You can inspect the WordPress configuration locally since the WordPress volume points to an external directory:

```bash
cat ~/data/wordpress/wp-config.php
```

This command will display the full configuration of the WordPress website.

### 2. Access the WordPress Site

To ensure the website is functioning correctly, open a browser and navigate to your domain:

```
https://jhogonca.42.fr
```

The website should be up and running. Two user accounts are available for testing:

- **Admin User:** `oxymoron`
- **Regular User:** `Harrison Forged`

Log in with both accounts to verify the site's functionality.

## Adminer Access

Adminer is a database management tool available at:

- **URL:** [https://jhogonca.42.fr/adminer.php](https://jhogonca.42.fr/adminer.php)
- **Server:** `mariadb`
- **Database:** `WordpressDB`
- **Username:** `jhogonca`
- **Password:** `1234mysql4321`
