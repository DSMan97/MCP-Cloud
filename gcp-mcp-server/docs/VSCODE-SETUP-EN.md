# VS Code MCP Configuration

This guide details how to integrate the GCP MCP server into Visual Studio Code.

## Prerequisites

Before starting, ensure you meet the following requirements:

1.  **MCP-compatible Extension**: You must have an extension that supports the Model Context Protocol installed. Recommended extensions include:
    - **Cline** (formerly Claude Dev)
    - **Roo Code**
2.  **Cloud Auth Proxy (Localhost)**: The MCP server must be accessible through a local proxy that handles authentication with Google Cloud.

### Cloud Auth Proxy Setup

For VS Code to communicate with the MCP server deployed on Cloud Run, using a local proxy is recommended. The development team should run the authentication proxy so that the server is available at:
`http://localhost:8080` (or the configured port).

## Integration Steps (Cline / Roo Code)

1.  **Open Extension Settings**:
    - Click on the extension icon in the sidebar.
    - Go to the settings or configuration section of the extension.

2.  **Configure the MCP Server**:
    - Look for the **MCP Servers** or **Model Context Protocol** configuration.
    - You will likely need to edit a JSON configuration file.

3.  **Server Configuration**:
    Add the following entry to your MCP configuration:

    ```json
    {
      "mcpServers": {
        "gcp-mcp-server": {
          "command": "curl",
          "args": ["-s", "http://localhost:8080/sse"],
          "disabled": false,
          "autoApprove": []
        }
      }
    }
    ```

    *Note: Since the server uses SSE (Server-Sent Events) over HTTP, some VS Code extensions might require a command-line wrapper like `curl` or a specific SSE client if they don't support SSE URLs directly in their configuration.*

4.  **Verification**:
    - Restart the extension or reload VS Code.
    - Check the extension's logs to ensure the connection to `GCP-MCP-Server` is established.
    - You should see the list of available tools (e.g., `fetch_cloud_run_logs`, `list_buckets`).

## Usage

Once configured, you can interact with the GCP tools directly from the chat. For example:

> "List the Cloud Run services in the us-central1 region."
> "Show me the logs for the service 'my-app'."
