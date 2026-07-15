<%-- 
    Document   : login.jsp
    Created on : 2 feb 2026
    Author     : Benja
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sistema de Gestión Industrial | Kronos Industrial</title>
    
    <link rel="stylesheet" href="CSS/login.css">
    <link rel="icon" href="images/KronosIndustrial.svg" type="image/png">
    <script src="JS/login.js" defer></script>

    <!-- Lucide Icons CDN -->
    <script src="https://unpkg.com/lucide@latest"></script>
</head>
<body>

<div class="login-container">

    <div class="logo">
        <img src="images/KronosIndustrial.svg" alt="Logo Kronos Industrial">
    </div>

    <h2>Control Operativo y Gestión de Proyectos</h2>

    <%-- NUEVA ALERTA PERSONALIZADA --%>
    <% 
        String error = (String) request.getAttribute("error");
        if (error != null && !error.isEmpty()) {
    %>
        <div class="custom-alert">
            <i data-lucide="alert-circle" style="width: 20px; height: 20px"></i>
            <span><%= error %></span>
        </div>
    <%
        }
    %>

    <form method="POST" action="loginSv">

        <input type="text"
               name="user_name"
               placeholder="Nombre de Usuario"
               required>

        <div class="password-container">
            <input type="password"
                   id="inputContrasena"
                   name="pass"
                   placeholder="Contraseña"
                   required>
            
            <span id="btnMostrarPass" title="Mostrar/Ocultar contraseña">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
                    <line x1="1" y1="1" x2="23" y2="23"></line>
                </svg>
            </span>
        </div>

        <button type="submit">INICIAR SESIÓN</button>
    </form>

</div>


    <!-- Inicializacion de Lucide Icons -->
    <script>
        lucide.createIcons();
    </script>
</body>
</html>