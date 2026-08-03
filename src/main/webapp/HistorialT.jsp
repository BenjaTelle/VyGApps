<%-- 
    Document   : RegistroT
    Created on : 11 feb 2026, 5:51:17 p.m.
    Author     : Benja
--%>

<%@page import="model.Usuarios"%>
<%
    //  Recuperar la sesión (false significa: no crees una nueva si no existe)
    HttpSession sessionActual = request.getSession(false);

    //  Recuperar el usuario
    Usuarios usuarioLogeado = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;

    //  VALIDACIÓN DE SEGURIDAD
    if (usuarioLogeado == null) {
        //  No se ha logueado, vuelve al login 
        response.sendRedirect("login.jsp");
        return; // Importante para detener la ejecución del resto de la página
    } else if (!usuarioLogeado.getRol().equals("Administrador")) {
        //  Sí está logueado, pero es empleado intentando entrar a zona admin
        response.sendRedirect("AccDen.jsp");
        return;
    }
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestión de Trabajadores</title>
    <link rel="stylesheet" href="CSS/HistorialT.css">
     <link rel="icon" href="images/vyg.svg" type="image/png">

    <!-- Lucide Icons CDN -->
    <script src="JS/lucide.min.js"></script>
</head>
<body>

    <div class="dev-container">

        <div class="dev-card">

            <div class="dev-icon">
                <i data-lucide="settings" style="width: 20px; height: 20px"></i>
            </div>

            <h2>Gestión de Trabajadores</h2>

            <p class="subtitle">
                Estamos trabajando en nuevas funcionalidades para mejorar la administración del personal.
            </p>

            <div class="feature-preview">

                <div class="feature-item">
                    <i data-lucide="clipboard" style="width: 20px; height: 20px"></i> Historial laboral detallado
                </div>

                <div class="feature-item">
                    <i data-lucide="bar-chart-3" style="width: 20px; height: 20px"></i> Reportes de rendimiento
                </div>

                <div class="feature-item">
                    <i data-lucide="briefcase" style="width: 20px; height: 20px"></i> Asignación múltiple de supervisores
                </div>

                <div class="feature-item">
                    <i data-lucide="dollar-sign" style="width: 20px; height: 20px"></i> Control de pagos automatizado
                </div>

            </div>

            <div class="progress-section">

                <div class="progress-text">
                    Desarrollo en progreso
                </div>

                <div class="progress-bar">
                    <div class="progress-fill"></div>
                </div>

            </div>

            <a href="AdminPage.jsp" class="btn-back">
                Volver al Panel
            </a>

        </div>

    </div>


    <!-- Inicializacion de Lucide Icons -->
    <script>
        lucide.createIcons();
    </script>
</body>
</html>