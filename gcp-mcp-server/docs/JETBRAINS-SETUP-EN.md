# JetBrains MCP Configuration

This guide details how to integrate the GCP MCP server into your JetBrains IDE (IntelliJ IDEA, PyCharm, WebStorm, etc.) step-by-step.

## Prerequisites

Before starting, ensure you meet the following requirements:

1.  **AI Assistant Plugin**: You must have the JetBrains **AI Assistant** plugin installed and configured in your IDE.
2.  **Cloud Auth Proxy (Localhost)**: The MCP server must be accessible through a local proxy that handles authentication with Google Cloud. This allows the development team to point to `localhost` without worrying about manual identity token injection.

### Cloud Auth Proxy Setup

For the IDE to communicate with the MCP server deployed on Cloud Run, using a local proxy is recommended. The development team should run the authentication proxy so that the server is available at:
`http://localhost:8080` (or the configured port).

## Integration Steps

Follow these steps to add the MCP server to your AI Assistant:

1.  **Open AI Assistant Settings**:
    - Go to `Settings` (on macOS `PyCharm/IntelliJ IDEA -> Settings`, on Windows/Linux `File -> Settings`).
    - Navigate to `Tools -> AI Assistant`.

2.  **Configure the MCP Server**:
    - Look for the **Model Context Protocol (MCP)** section.
    - Click the **+** (Add) button to add a new server.

3.  **Server Details**:
    - **Name**: `GCP-MCP-Server` (or your preferred name).
    - **Type**: Select `SSE` (Server-Sent Events) since the server is deployed on Cloud Run and uses HTTP communication.
    - **URL**: Enter your local proxy address:
      `http://localhost:8080/sse`

    - **Quick Copy JSON (for manual config if needed)**:
      ```json
      {
        "mcpServers": {
          "GCP-MCP-Server": {
            "type": "sse",
            "url": "http://localhost:8080/sse"
          }
        }
      }
      ```

4.  **Verification**:
    - The IDE will attempt to connect to the server. If the connection is successful, you will see a list of available tools (e.g., `fetch_cloud_run_logs`, `list_buckets`, etc.).
    - Click **Apply** and **OK**.

## Usage in AI Assistant Chat

Once configured, you can ask the AI Assistant to use the GCP tools. For example:

> "Can you list the Cloud Storage buckets in my current project?"
> "What is the status of the Cloud Run services in the us-central1 region?"

The assistant will automatically detect that it has tools available to answer these questions and will execute them through the configured MCP server.
