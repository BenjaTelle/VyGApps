<%@page import="model.Usuarios"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
    
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String returnLink = "Home";
    if (user.getRol().equalsIgnoreCase("Supervisor")) {
        returnLink = "SupervisorPage";
    } else if (user.getRol().equalsIgnoreCase("Administrador")) {
        returnLink = "AdminPage.jsp";
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Configuración de Perfil | V&G Ingenieros</title>
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="icon" href="images/vygLogo.svg" type="image/svg+xml">
    <style>
        body {
            background-color: #f4f6f8;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .config-container {
            background: #fff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.08);
            width: 100%;
            max-width: 500px;
        }
        .config-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .config-header h2 {
            margin: 0;
            color: #121216;
            font-size: 24px;
        }
        .config-header p {
            color: #7f8c8d;
            margin-top: 5px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #1E1E24;
            font-weight: 600;
        }
        .form-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid #bdc3c7;
            border-radius: 6px;
            font-size: 15px;
            box-sizing: border-box;
            transition: border-color 0.3s;
        }
        .form-group input:focus {
            border-color: #3498db;
            outline: none;
        }
        .alert-success {
            background: #eafaf1;
            color: #27ae60;
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
            border-left: 4px solid #27ae60;
        }
        .alert-error {
            background: #fdedec;
            color: #c0392b;
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
            border-left: 4px solid #c0392b;
        }
        .actions {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }
        .btn-primary {
            flex: 1;
            background: #3498db;
            color: #fff;
            padding: 12px;
            border: none;
            border-radius: 6px;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.3s;
            text-align: center;
            text-decoration: none;
        }
        .btn-primary:hover {
            background: #2980b9;
        }
        .btn-cancel {
            flex: 1;
            background: #ecf0f1;
            color: #7f8c8d;
            padding: 12px;
            border: none;
            border-radius: 6px;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.3s;
            text-align: center;
            text-decoration: none;
        }
        .btn-cancel:hover {
            background: #bdc3c7;
            color: #121216;
        }
        .password-container {
            position: relative;
            display: flex;
            align-items: center;
        }
        .password-container input {
            width: 100%;
            padding-right: 40px;
        }
        .toggle-password {
            position: absolute;
            right: 10px;
            cursor: pointer;
            color: #7f8c8d;
        }
        .toggle-password:hover {
            color: #1E1E24;
        }
    </style>

    <!-- Lucide Icons CDN -->
    <script src="JS/lucide.min.js"></script>
</head>
<body>

    <div class="config-container">
        <div class="config-header">
            <i data-lucide="settings" style="margin-bottom: 10px; width: 40px; height: 40px"></i>
            <h2>Configuración de Cuenta</h2>
            <p>Actualiza tus credenciales de acceso</p>
        </div>

        <% 
            String success = request.getParameter("success");
            String error = request.getParameter("error");
            if (success != null) {
        %>
            <div class="alert-success">Tus datos han sido actualizados correctamente.</div>
        <% } %>
        <% if (error != null) { %>
            <div class="alert-error">Las contraseñas no coinciden. Intenta de nuevo.</div>
        <% } %>

        <form action="ConfiguracionSv" method="POST">
            <div class="form-group">
                <label for="nuevo_nombre">Nombre de Usuario (Login)</label>
                <input type="text" id="nuevo_nombre" name="nuevo_nombre" value="<%= user.getUser_name() %>" required pattern=".{6,}" title="Debe tener al menos 6 caracteres">
            </div>
            
            <div class="form-group">
                <label for="nueva_pass">Nueva Contraseña</label>
                <div class="password-container">
                    <input type="password" id="nueva_pass" name="nueva_pass" placeholder="Dejar en blanco para no cambiar" pattern="(?=.*\d)(?=.*[A-Z]).{6,}" title="Debe tener al menos 6 caracteres, incluir una mayúscula y un número">
                    <span class="toggle-password" title="Mostrar/Ocultar contraseña">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path><line x1="1" y1="1" x2="23" y2="23"></line></svg>
                    </span>
                </div>
            </div>

            <div class="form-group">
                <label for="confirmar_pass">Confirmar Nueva Contraseña</label>
                <div class="password-container">
                    <input type="password" id="confirmar_pass" name="confirmar_pass" placeholder="Repetir contraseña" pattern="(?=.*\d)(?=.*[A-Z]).{6,}" title="Debe tener al menos 6 caracteres, incluir una mayúscula y un número">
                    <span class="toggle-password" title="Mostrar/Ocultar contraseña">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path><line x1="1" y1="1" x2="23" y2="23"></line></svg>
                    </span>
                </div>
            </div>

            <div class="actions">
                <a href="<%= returnLink %>" class="btn-cancel">Volver</a>
                <button type="submit" class="btn-primary">Guardar Cambios</button>
            </div>
        </form>
    </div>
<script>
    document.querySelectorAll('.toggle-password').forEach(button => {
        button.addEventListener('click', function() {
            const input = this.previousElementSibling;
            if (input.type === 'password') {
                input.type = 'text';
                this.innerHTML = '<i data-lucide="settings" style="width: 20px; height: 20px"></i>';
            } else {
                input.type = 'password';
                this.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path><line x1="1" y1="1" x2="23" y2="23"></line></svg>';
            }
        });
    });
</script>

    <!-- Inicializacion de Lucide Icons -->
    <script>
        lucide.createIcons();
    </script>
</body>
</html>
