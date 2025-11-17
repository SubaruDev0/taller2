<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Taller 2 - Inicio</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            padding: 40px;
            max-width: 600px;
            width: 100%;
            text-align: center;
        }

        h1 {
            color: #333;
            font-size: 2.5em;
            margin-bottom: 20px;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
        }

        .mensaje {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            font-size: 1.3em;
            margin: 20px 0;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .status-box {
            margin: 20px 0;
            padding: 15px;
            border-radius: 10px;
            border-left: 5px solid;
        }

        .status-connected {
            background: #d4edda;
            border-color: #28a745;
            color: #155724;
        }

        .status-disconnected {
            background: #f8d7da;
            border-color: #dc3545;
            color: #721c24;
        }

        .status-icon {
            font-size: 1.5em;
            margin-right: 10px;
        }

        .info {
            margin-top: 30px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 10px;
            text-align: left;
        }

        .info h3 {
            color: #667eea;
            margin-bottom: 15px;
        }

        .info ul {
            list-style: none;
            padding-left: 0;
        }

        .info li {
            padding: 8px 0;
            border-bottom: 1px solid #dee2e6;
        }

        .info li:last-child {
            border-bottom: none;
        }

        .info strong {
            color: #495057;
        }

        footer {
            margin-top: 30px;
            color: #6c757d;
            font-size: 0.9em;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Taller 2</h1>

        <div class="mensaje">
            ${mensaje}
        </div>

        <div class="status-box ${dbConnected ? 'status-connected' : 'status-disconnected'}">
            <span class="status-icon">${dbConnected ? '✓' : '✗'}</span>
            <strong>Estado Base de Datos:</strong> ${dbStatus}
        </div>

        <div class="info">
            <h3>📋 Información del Sistema</h3>
            <ul>
                <li><strong>Servidor:</strong> GlassFish</li>
                <li><strong>Puerto:</strong> 9000</li>
                <li><strong>Base de Datos:</strong> PostgreSQL (taller2_bd)</li>
                <li><strong>Patrón:</strong> MVC + DAO</li>
                <li><strong>Conexión:</strong> Singleton</li>
            </ul>
        </div>

        <footer>
            <p>© 2025 - Proyecto Taller 2</p>
        </footer>
    </div>
</body>
</html>
