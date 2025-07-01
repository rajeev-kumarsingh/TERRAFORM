# 🐳 Terraform Docker NGINX Example – Step-by-Step Explanation

This Terraform configuration pulls the official NGINX image and runs it inside a Docker container on port 8000.

---

## 📁 Full Terraform Code

```hcl
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

resource "docker_image" "nginx" {
  name         = "nginx"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "tutorial"

  ports {
    internal = 80
    external = 8000
  }
}
```

---

## 🧱 Step-by-Step Explanation

### 🔹 Step 1: Specify Required Provider

```hcl
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}
```

- Uses the `kreuzwerker/docker` provider.
- Version constraint `~> 3.0.1` allows compatible minor updates.

### 🔹 Step 2: Configure the Docker Provider

```hcl
provider "docker" {}
```

- Uses the local Docker daemon.
- Defaults to `/var/run/docker.sock`.

### 🔹 Step 3: Pull NGINX Image

```hcl
resource "docker_image" "nginx" {
  name         = "nginx"
  keep_locally = false
}
```

- Pulls the official `nginx` image from Docker Hub.
- `keep_locally = false`: Image will be removed when the container is destroyed.

### 🔹 Step 4: Create Docker Container

```hcl
resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "tutorial"

  ports {
    internal = 80
    external = 8000
  }
}
```

- Runs an NGINX container named `tutorial`.
- Maps container port `80` to host port `8000`.
- Access it via: `http://localhost:8000`

---

## 🛠 How to Use

### ✅ Prerequisites

- Docker installed and running.
- Terraform installed.

### 🧪 Commands

```bash
terraform init
terraform apply
```

Then open your browser and visit: `http://localhost:8000`

---

## 🧼 Clean Up

```bash
terraform destroy
```

- Destroys the container and removes the NGINX image.

---

## 📌 Summary

| Component        | Description                            |
|------------------|----------------------------------------|
| Docker Provider  | Manages Docker images and containers   |
| nginx Image      | Pulled from Docker Hub                 |
| Container Name   | `tutorial`                             |
| Port Mapping     | Host 8000 ➝ Container 80               |