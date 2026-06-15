# Configuración de MCP en JetBrains

Esta guía detalla cómo integrar el servidor MCP de GCP en tu IDE de JetBrains (IntelliJ IDEA, PyCharm, WebStorm, etc.) paso a paso.

## Prerrequisitos

Antes de comenzar, asegúrate de cumplir con los siguientes requisitos:

1.  **Plugin de AI Assistant**: Debes tener instalado y configurado el plugin **AI Assistant** de JetBrains en tu IDE.
2.  **Cloud Auth Proxy (Localhost)**: El servidor MCP debe estar accesible a través de un proxy local que maneje la autenticación con Google Cloud. Esto permite que el equipo de desarrollo apunte a `localhost` sin preocuparse por la inyección manual de tokens de identidad.

### Configuración del Cloud Auth Proxy

Para que el IDE pueda comunicarse con el servidor MCP desplegado en Cloud Run, se recomienda usar un proxy local. El equipo de desarrollo debe ejecutar el proxy de autenticación para que el servidor esté disponible en:
`http://localhost:8080` (o el puerto configurado).

## Pasos para la integración

Sigue estos pasos para añadir el servidor MCP a tu AI Assistant:

1.  **Abrir los Ajustes de AI Assistant**:
    - Ve a `Settings` (en macOS `PyCharm/IntelliJ IDEA -> Settings`, en Windows/Linux `File -> Settings`).
    - Navega hasta `Tools -> AI Assistant`.

2.  **Configurar el Servidor MCP**:
    - Busca la sección de **Model Context Protocol (MCP)**.
    - Haz clic en el botón **+** (Add) para añadir un nuevo servidor.

3.  **Detalles del Servidor**:
    - **Name**: `GCP-MCP-Server` (o el nombre que prefieras).
    - **Type**: Selecciona `SSE` (Server-Sent Events) ya que el servidor está desplegado en Cloud Run y utiliza comunicación HTTP.
    - **URL**: Introduce la dirección de tu proxy local:
      `http://localhost:8080/sse`

    - **Copia rápida JSON (para configuración manual si es necesario)**:
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

4.  **Verificación**:
    - El IDE intentará conectar con el servidor. Si la conexión es exitosa, verás una lista de las herramientas disponibles (ej. `fetch_cloud_run_logs`, `list_buckets`, etc.).
    - Haz clic en **Apply** y **OK**.

## Uso en el Chat de AI Assistant

Una vez configurado, puedes pedirle al AI Assistant que utilice las herramientas de GCP. Por ejemplo:

> "¿Puedes listar los buckets de Cloud Storage en mi proyecto actual?"
> "¿Cuál es el estado de los servicios de Cloud Run en la región us-central1?"

El asistente detectará automáticamente que tiene herramientas disponibles para responder a estas preguntas y las ejecutará a través del servidor MCP configurado.
