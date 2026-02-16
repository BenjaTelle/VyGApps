<%-- 
    Document   : AdminPage
    Created on : 2 feb 2026, 9:08:44 p.m.
    Author     : Benja
--%>

<%@page import="model.proyectos"%>
<%@page import="controlador.AdminPageSv"%>
<%@page import="Repository.UsuarioDAO"%>
<%@page import="java.util.List"%>
<%@page import="model.Usuarios"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

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
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Panel Administrador</title>
    <link rel="stylesheet" href="CSS/AdminPage.css">
</head>
<body>

<!-- TOP BAR -->
<header class="topbar">

    <!-- BRAND -->
    <div class="brand">
        <img src="images/vyg.svg" alt="VyG Logo">
        <span>Panel Administrativo</span>
    </div>

    <!-- USER PROFILE -->
    <div class="user-profile">
        <img src="images/usuario.png" alt="Perfil" class="user-avatar">
        <span class="user-info-text"><%= usuarioLogeado.getUser_name() %></span>
        <a href="LogoutSv" class="btn-logout">Salir</a>
    </div>

</header>

<!-- MAIN CONTENT -->
<main class="dashboard-container">

    <section class="dashboard-grid">

        <!-- USUARIOS -->
        <div class="dashboard-card">
            <h3>Gestión de Usuarios</h3>
            <p>Administración de accesos y perfiles</p>
            <div class="actions">
                <a href="CrearUsuario">Crear</a> <!-- cambiar por el serverlet cuando tengamos los metodos -->
                <a href="ActualizarUsuario">Actualizar</a>
                <a href="usuarios_eliminar.jsp" class="danger">Eliminar</a>
            </div>
        </div>

        <!-- TRABAJADORES -->
        <div class="dashboard-card">
            <h3>Gestión de Trabajadores</h3>
            <p>Control de personal y asignaciones</p>
            <div class="actions">
                <a href="RegistrarUsu">Registrar</a>
                <a href="AsignProyecto">Asignar proyecto</a>
                <a href="AsignSup">Supervisor</a>
                <a href="HistorialT.jsp">Historial</a> <!-- cambiar de jsp a serverlet cuando tengamos las funcionalidad-->
            </div>
        </div>

        <!-- PROYECTOS -->
        <div class="dashboard-card">
            <h3>Gestión de Proyectos</h3>
            <p>Creación y seguimiento de proyectos</p>
            <div class="actions">
                <a href="proyecto_crear.jsp">Crear</a>
                <a href="proyectos_listar.jsp">Listar</a>
                <a href="proyecto_asignar_supervisor.jsp">Supervisor</a>
                <a href="proyecto_trabajadores.jsp">Trabajadores</a>
            </div>
        </div>

        <!-- REPORTES -->
        <div class="dashboard-card">
            <h3>Reportes</h3>
            <p>Consultas y reportes generales</p>
            <div class="actions">
                <a href="reporte_proyectos.jsp">Proyectos</a>
                <a href="reporte_trabajadores.jsp">Trabajadores</a>
                <a href="reporte_asistencias.jsp">Asistencias</a>
                <a href="reporte_pagos.jsp">Pagos</a>
            </div>
        </div>

    </section>

</main>

</body>
</html>
