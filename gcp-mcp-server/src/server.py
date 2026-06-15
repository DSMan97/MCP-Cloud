import os
from fastmcp import FastMCP
from google.cloud import logging as cloud_logging
from google.cloud import storage
from google.cloud import run_v2
from google.cloud.devtools import cloudbuild_v1

# Read the port injected by Cloud Run, or 8080 by default
PORT = int(os.environ.get("PORT", 8080))

# Initialize FastMCP server with specific configuration for Cloud Run
mcp = FastMCP(
    "GCP_DevOps_MCP",
    host="0.0.0.0",
    port=PORT,
    stateless_http=True,
    # To enable Human-in-the-loop (HITL) for all tools, uncomment the line below:
    # warn_on_dangerous_tools=True, 
)

# Example of how to add HITL to a specific tool using annotations:
# from mcp.types import ToolAnnotations
# @mcp.tool(annotations=ToolAnnotations(readOnlyHint=False, destructiveHint=True))
# def some_dangerous_tool():
#     ...

@mcp.tool()
def fetch_cloud_run_logs(service_name: str, limit: int = 20) -> str:
    """Gets the latest logs from a Cloud Run service."""
    client = cloud_logging.Client()
    filter_str = f'resource.type="cloud_run_revision" AND resource.labels.service_name="{service_name}"'

    entries = client.list_entries(filter_=filter_str, order_by=cloud_logging.DESCENDING, max_results=limit)
    logs = [f"[{entry.timestamp}] {entry.severity}: {entry.payload}" for entry in entries]

    return "\n".join(logs) if logs else f"No logs found for {service_name}."

@mcp.tool()
def list_bucket_files(bucket_name: str) -> str:
    """Lists files within a Cloud Storage bucket."""
    client = storage.Client()
    bucket = client.bucket(bucket_name)
    blobs = bucket.list_blobs(max_results=50)

    files = [blob.name for blob in blobs]
    return "\n".join(files) if files else "The bucket is empty or does not exist."

@mcp.tool()
def list_buckets() -> str:
    """Lists all Cloud Storage buckets in the project."""
    client = storage.Client()
    buckets = list(client.list_buckets())

    bucket_names = [bucket.name for bucket in buckets]
    return "\n".join(bucket_names) if bucket_names else "No buckets found in the project."

@mcp.tool()
def list_cloud_run_services(region: str = "us-central1") -> str:
    """Lists Cloud Run services in a specific region."""
    client = run_v2.ServicesClient()
    project_id = os.environ.get("GOOGLE_CLOUD_PROJECT")
    if not project_id:
        return "Error: The GOOGLE_CLOUD_PROJECT environment variable is not configured."

    parent = f"projects/{project_id}/locations/{region}"
    services = client.list_services(parent=parent)

    service_list = [service.name.split("/")[-1] for service in services]
    return "\n".join(service_list) if service_list else f"No services found in region {region}."

@mcp.tool()
def list_cloud_run_jobs(region: str = "us-central1") -> str:
    """Lists Cloud Run jobs in a specific region."""
    client = run_v2.JobsClient()
    project_id = os.environ.get("GOOGLE_CLOUD_PROJECT")
    if not project_id:
        return "Error: The GOOGLE_CLOUD_PROJECT environment variable is not configured."

    parent = f"projects/{project_id}/locations/{region}"
    jobs = client.list_jobs(parent=parent)

    job_list = [job.name.split("/")[-1] for job in jobs]
    return "\n".join(job_list) if job_list else f"No jobs found in region {region}."

@mcp.tool()
def list_worker_pools(region: str = "us-central1") -> str:
    """Lists Cloud Build worker pools (private pools) in a specific region."""
    client = devtools_v1.CloudBuildClient()
    project_id = os.environ.get("GOOGLE_CLOUD_PROJECT")
    if not project_id:
        return "Error: The GOOGLE_CLOUD_PROJECT environment variable is not configured."

    parent = f"projects/{project_id}/locations/{region}"
    worker_pools = client.list_worker_pools(parent=parent)

    pool_list = [pool.name.split("/")[-1] for pool in worker_pools]
    return "\n".join(pool_list) if pool_list else f"No worker pools found in region {region}."

# Instead of mcp.run(), we export the SSE-compatible ASGI app
# Cloud Run will use Uvicorn to serve this 'app' object
app = mcp.http_app()
