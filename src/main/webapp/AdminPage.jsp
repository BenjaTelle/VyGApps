<%-- 
    Document   : AdminPage
    Created on : 2 feb 2026, 9:08:44 p.m.
    Author     : Benja
--%>
<%@page import="model.Usuarios"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // 1. Recuperar la sesión actual (sin crear una nueva si no existe)
    HttpSession sessionActual = request.getSession(false);

    // 2. Obtener el usuario logueado
    Usuarios usuarioLogeado = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;

    // 3. VALIDACIÓN DE SEGURIDAD
    if (usuarioLogeado == null) {
        // No está logueado, redirigir al login
        response.sendRedirect("login.jsp");
        return; 
    } else if (!usuarioLogeado.getRol().equalsIgnoreCase("Administrador")) {
        // Está logueado pero no tiene permisos de administrador
        response.sendRedirect("AccDen.jsp");
        return; 
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel Administrativo | VyGApps</title>
    <link rel="stylesheet" href="CSS/AdminPage.css">
    <link rel="icon" href="images/vyg.svg" type="image/png">
</head>
<body>

<header class="topbar">
    <div class="brand">
        <img src="images/vyg.svg" alt="VyG Logo">
        <div class="brand-text">
            <h1>VyG Apps</h1>
            <span>Panel Administrativo</span>
        </div>
    </div>

    <div class="user-profile">
        <div class="user-info">
            <img src="images/usuario.png" alt="Perfil" class="user-avatar">
            <span class="user-info-text"><%= usuarioLogeado.getUser_name() %></span>
        </div>
        <a href="LogoutSv" class="btn-logout">
            <span class="logout-icon">🚪</span> Salir
        </a>
    </div>
</header>

<main class="dashboard-container">

    <section class="welcome-banner">
        <h2>¡Bienvenido al Panel de Control, <%= usuarioLogeado.getUser_name() %>!</h2>
        <p>Gestiona los accesos, proyectos, personal y reportes desde un solo lugar.</p>
    </section>

    <section class="dashboard-grid">

        <div class="dashboard-card">
            <div class="card-header">
                <span class="card-icon">👥</span>
                <div class="card-title">
                    <h3>Gestión de Usuarios</h3>
                    <p>Accesos y perfiles del sistema</p>
                </div>
            </div>
            <div class="actions-grid">
                <a href="CrearUsuario" class="btn-action">Crear</a>
                <a href="ActualizarUsuario" class="btn-action">Actualizar</a>
                <a href="VerUsuarios" class="btn-action">Ver Usuarios</a>
                <a href="EliminarUsu" class="btn-action danger">Eliminar</a>
            </div>
        </div>

        <div class="dashboard-card">
            <div class="card-header">
                <span class="card-icon">👷</span>
                <div class="card-title">
                    <h3>Gestión de Personal</h3>
                    <p>Control de personal y asignaciones</p>
                </div>
            </div>
            <div class="actions-grid">
                <a href="RegistrarUsu" class="btn-action">Registrar</a>
                <a href="ActualizarTrabajadores" class="btn-action">Actualizar</a>
                <a href="EliminarTrabajadores" class="btn-action">Eliminar</a>
                <a href="HistorialT.jsp" class="btn-action">Historial</a>
            </div>
        </div>

        <div class="dashboard-card">
            <div class="card-header">
                <span class="card-icon">🏗️</span>
                <div class="card-title">
                    <h3>Gestión de Proyectos</h3>
                    <p>Creación y seguimiento de obras</p>
                </div>
            </div>
            <div class="actions-grid">
                <a href="CrearProyecto" class="btn-action">Crear</a>
                <a href="ListarProyectos" class="btn-action">Listar</a>
                <a href="AsignSup" class="btn-action">Asignar Sup.</a>
                <a href="AsignProyecto" class="btn-action">Asignar Proy.</a>
            </div>
        </div>

        <div class="dashboard-card">
            <div class="card-header">
                <span class="card-icon">📈</span>
                <div class="card-title">
                    <h3>Reportes y Finanzas</h3>
                    <p>Consultas y reportes generales</p>
                </div>
            </div>
            <div class="actions-grid">
                <a href="ReporteProyecto" class="btn-action">Proyectos</a>
                <a href="ReporteTrabajadoresSv" class="btn-action">Trabajadores</a>
                <a href="ReporteAsistenciaSv" class="btn-action">Asistencias</a>
                <a href="AdminFinanzas" class="btn-action highlight">Pagos</a>
            </div>
        </div>

    </section>

</main>

<script src="JS/AdminPage.js"></script>
</body>
</html>