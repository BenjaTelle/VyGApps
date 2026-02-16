<%-- 
    Document   : login.jsp
    Created on : 2 feb 2026, 6:36:29 p.m.
    Author     : Benja
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Sistema de Gestión Industrial</title>
    
    <link rel="stylesheet" href="CSS/login.css">
</head>
<body>

<div class="login-container">

    <div class="logo">
        <img src="images/vyg_logo.jpg" alt="Logo">
    </div>

    <h2>SISTEMA DE GESTIÓN INDUSTRIAL</h2>

    <form method="POST" action="loginSv">

        <input type="text"
               name="user_name"
               placeholder="Usuario"
               required>

        <input type="password"
               name="pass"
               placeholder="Contraseña"
               required>

        <button type="submit">INICIAR SESIÓN</button>
    </form>


    <%-- Aquí va la alerta de error --%>
    <% 
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
        <script>
            alert("<%= error %>");
        </script>
    <%
        }
    %>
</div>

</body>
</html>
