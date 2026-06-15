# Configuración de MCP en VS Code

Esta guía detalla cómo integrar el servidor MCP de GCP en Visual Studio Code.

## Prerrequisitos

Antes de comenzar, asegúrate de cumplir con los siguientes requisitos:

1.  **Extensión compatible con MCP**: Debes tener instalada una extensión que soporte el Model Context Protocol. Las extensiones recomendadas incluyen:
    - **Cline** (anteriormente Claude Dev)
    - **Roo Code**
2.  **Cloud Auth Proxy (Localhost)**: El servidor MCP debe estar accesible a través de un proxy local que maneje la autenticación con Google Cloud.

### Configuración del Cloud Auth Proxy

Para que VS Code pueda comunicarse con el servidor MCP desplegado en Cloud Run, se recomienda usar un proxy local. El equipo de desarrollo debe ejecutar el proxy de autenticación para que el servidor esté disponible en:
`http://localhost:8080` (o el puerto configurado).

## Pasos para la integración (Cline / Roo Code)

1.  **Abrir los Ajustes de la Extensión**:
    - Haz clic en el icono de la extensión en la barra lateral.
    - Ve a la sección de ajustes o configuración de la extensión.

2.  **Configurar el Servidor MCP**:
    - Busca la configuración de **MCP Servers** o **Model Context Protocol**.
    - Probablemente necesites editar un archivo de configuración JSON.

3.  **Configuración del Servidor**:
    Añade la siguiente entrada a tu configuración de MCP:

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

    *Nota: Dado que el servidor utiliza SSE (Server-Sent Events) sobre HTTP, algunas extensiones de VS Code pueden requerir un envoltorio de línea de comandos como `curl` o un cliente SSE específico si no soportan URLs SSE directamente en su configuración.*

4.  **Verificación**:
    - Reinicia la extensión o recarga VS Code.
    - Comprueba los logs de la extensión para asegurar que la conexión con `GCP-MCP-Server` se ha establecido.
    - Deberías ver la lista de herramientas disponibles (ej. `fetch_cloud_run_logs`, `list_buckets`).

## Uso

Una vez configurado, puedes interactuar con las herramientas de GCP directamente desde el chat. Por ejemplo:

> "Lista los servicios de Cloud Run en la región us-central1."
> "Muéstrame los logs del servicio 'my-app'."
