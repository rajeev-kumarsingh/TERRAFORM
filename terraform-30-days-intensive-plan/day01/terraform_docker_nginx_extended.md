# 🐳 Extended Terraform Docker NGINX Example – Volumes, Env Vars, and Health Checks

This extended Terraform configuration adds:
- A volume for persistent/static content
- Environment variables (optional example)
- A health check to monitor container status

---

## 📁 Extended Terraform Code

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

# Pull nginx image
resource "docker_image" "nginx" {
  name         = "nginx"
  keep_locally = false
}

# Create a Docker volume
resource "docker_volume" "nginx_data" {
  name = "nginx_html"
}

# Run nginx container
resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "tutorial"

  # Port mapping
  ports {
    internal = 80
    external = 8000
  }

  # Mount volume to serve static content
  mounts {
    target = "/usr/share/nginx/html"
    source = docker_volume.nginx_data.name
    type   = "volume"
  }

  # Example environment variables (not used by nginx by default)
  env = [
    "APP_ENV=production",
    "APP_VERSION=1.0"
  ]

  # Health check for nginx
  healthcheck {
    test     = ["CMD", "curl", "-f", "http://localhost"]
    interval = "30s"
    timeout  = "10s"
    retries  = 3
  }
}
```

---

## 🧱 Step-by-Step Explanation

### ✅ Volume

```hcl
resource "docker_volume" "nginx_data" {
  name = "nginx_html"
}
```

- Creates a Docker-managed volume.
- Used to persist or override default `/usr/share/nginx/html` content.

### ✅ Mount Volume

```hcl
mounts {
  target = "/usr/share/nginx/html"
  source = docker_volume.nginx_data.name
  type   = "volume"
}
```

- Attaches the volume to the container.
- You can manually copy your custom `index.html` to this volume.

### ✅ Environment Variables

```hcl
env = [
  "APP_ENV=production",
  "APP_VERSION=1.0"
]
```

- Demonstrates how to pass environment variables.
- NGINX doesn't use these by default, but this pattern is useful for dynamic apps.

### ✅ Health Check

```hcl
healthcheck {
  test     = ["CMD", "curl", "-f", "http://localhost"]
  interval = "30s"
  timeout  = "10s"
  retries  = 3
}
```

- Uses `curl` to check if NGINX is serving content.
- Retries 3 times if failed, checks every 30 seconds.

---

## 🧪 Run and Test

### 1. Initialize Terraform

```bash
terraform init
```

### 2. Apply Configuration

```bash
terraform apply
```

### 3. Access Your App

Open your browser: [http://localhost:8000](http://localhost:8000)

### 4. Inspect Volume (optional)

To copy files to the volume:

```bash
docker cp ./index.html tutorial:/usr/share/nginx/html/index.html
```

Or use bind mounts if you want to directly reference local files.

---

## 🧼 Clean Up

```bash
terraform destroy
```

This will delete the container, volume, and image (since `keep_locally = false`).

---

## ✅ Summary

| Feature          | Description                                      |
|------------------|--------------------------------------------------|
| Docker Volume    | `/usr/share/nginx/html` for custom web content   |
| Env Vars         | Example values (`APP_ENV`, `APP_VERSION`)        |
| Health Check     | Uses curl to check if NGINX is serving           |
| Port Mapping     | Host 8000 ➝ Container 80                         |