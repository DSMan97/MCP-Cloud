# GCP MCP Server

This project implements a Model Context Protocol (MCP) server for Google Cloud Platform (GCP). It allows AI models to interact with GCP resources like Cloud Run, Cloud Storage, and Cloud Build using a standardized protocol.

## Project Structure

The project is organized as follows:

```text
gcp-mcp-server/
├── docs/               # Project documentation and images
├── src/                # Python source code for the MCP server
│   ├── Dockerfile      # Container definition for deployment
│   ├── requirements.txt # Python dependencies
│   └── server.py       # Main server implementation using FastMCP
└── terraform/          # Infrastructure as Code
    ├── main.tf         # Main Terraform entry point
    ├── variables.tf    # Infrastructure variable definitions
    ├── providers.tf    # Terraform providers configuration
    ├── outputs.tf      # Infrastructure output definitions
    └── modules/        # Reusable Terraform modules (IAM, Cloud Run)
```

### Key Components

- **`src/server.py`**: The core logic of the MCP server. It uses the `FastMCP` library to define tools that wrap GCP client libraries.
- **`terraform/`**: Contains the code to deploy the server to GCP as a Cloud Run service, including the necessary IAM permissions.

## Terraform Deployment

To deploy this server to your GCP project, follow these steps:

### 1. Configuration

Copy the example variables file and fill in your details:

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your `project_id`, `region`, and the `image_url` of your container.

### 2. Initialization

Initialize Terraform to download providers and initialize modules:

```bash
terraform init
```

### 3. Plan

Review the changes that Terraform will perform:

```bash
terraform plan
```

**Example output:**
```text
Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.iam.google_service_account.mcp_sa will be created
  + resource "google_service_account" "mcp_sa" {
      + account_id   = "gcp-mcp-server-sa"
      + display_name = "MCP Server Service Account"
      ...
    }

  # module.cloud_run.google_cloud_run_v2_service.mcp_service will be created
  + resource "google_cloud_run_v2_service" "mcp_service" {
      + name     = "gcp-mcp-server"
      + location = "us-central1"
      ...
    }

Plan: 5 to add, 0 to change, 0 to destroy.
```

### 4. Apply

Deploy the infrastructure:

```bash
terraform apply
```

Confirm the operation by typing `yes` when prompted.

## Available MCP Tools

Once deployed, the server provides several tools to interact with GCP:

- `fetch_cloud_run_logs`: Retrieves the latest logs from a specific Cloud Run service.
- `list_bucket_files`: Lists files within a Cloud Storage bucket.
- `list_buckets`: Lists all Cloud Storage buckets in the project.
- `list_cloud_run_services`: Lists Cloud Run services in a specific region.
- `list_cloud_run_jobs`: Lists Cloud Run jobs in a specific region.
- `list_worker_pools`: Lists Cloud Build worker pools.

## Development

To run the server locally for testing:

1. Install dependencies:
   ```bash
   pip install -r src/requirements.txt
   ```
2. Set environment variables:
   ```bash
   export GOOGLE_CLOUD_PROJECT="your-project-id"
   ```
3. Run the server:
   ```bash
   python src/server.py
   ```

## IDE Integration

For detailed instructions on how to integrate this MCP server with your favorite IDE, please refer to our documentation:

- **JetBrains (PyCharm, IntelliJ, etc.):** [English](docs/JETBRAINS-SETUP-EN.md) | [Spanish](docs/JETBRAINS-SETUP-ES.md)
- **VS Code:** [English](docs/VSCODE-SETUP-EN.md) | [Spanish](docs/VSCODE-SETUP-ES.md)

See the full documentation in the [docs/ directory](docs/README.md).
