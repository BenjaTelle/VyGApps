    
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="DTO.UsuarioDetalle"%>
<%@page import="model.Usuarios"%>
<%
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
    
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Validar Rol (Aseg�rate que coincida con tu BD)
    if (!user.getRol().equalsIgnoreCase("Supervisor")) {
        response.sendRedirect("AccDen.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Panel Supervisor | VyGApps</title>
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="icon" href="images/vyg.svg" type="image/png">
</head>
<body>

<div class="container">

    <aside class="sidebar">
        <div class="sidebar-header">
            <div class="brand-title">
                <img src="images/vyg.svg" alt="VyG Logo" class="sidebar-logo">
                <h2>VyGApps</h2>
            </div>
            <p class="panel-label">Panel Supervisor</p>
        </div>
    </aside>

    <main class="main-content">

        <header class="topbar">
            <div class="welcome">
                <% UsuarioDetalle ud = (UsuarioDetalle) request.getAttribute("usuarioLogueadoDetalle");%>
                <h1>Bienvenido, <%= ud.getTrabajadorAsign() %></h1>
                <span>Gesti�n general de supervisi�n</span>
            </div>

            <div class="profile">
                <img src="images/usuario.png" class="profile-img" alt="Perfil">
                <span><%= user.getUser_name() %></span>
                <a href="LogoutSv" class="btn-logout">Salir</a>
            </div>
        </header>

        <section class="dashboard">

            <div class="card" style="border-left: 5px solid #27ae60;">
                <h3 style="color: #27ae60;">Control de Accesos</h3>
                <p>Genera claves seguras para la asistencia diaria del personal.</p>
                <div class="actions">
                    <a href="GenerarCodigoSv" style="background-color: #27ae60; color: white; border: none; font-weight: bold;">Generar C�digo</a>
                </div>
            </div>

            <div class="card">
                <h3>Proyectos</h3>
                <p>Gesti�n y seguimiento de obras asignadas.</p>
                <div class="actions">
                    <a href="ListarProyectos">Ver proyectos</a>
                    <a href="VerDetalleProyecto">Detalle proyecto</a>
                </div>
            </div>

            <div class="card">
                <h3>Pagos</h3>
                <p>Revisi�n y autorizaci�n de pagos del personal.</p>
                <div class="actions">
                    <a href="CentroPagos">Autorizar pagos</a>
                    <a href="HistorialPagosSupSv">Historial de pagos</a>
                </div>
            </div>

            <div class="card">
                <h3>Asistencias</h3>
                <p>Monitoreo y control de asistencia del equipo.</p>
                <div class="actions">
                    <a href="AsistenciaGlobal">Ver asistencias</a>
                    <a href="BuscarDetalleAsis">Detalle por trabajador</a>
                </div>
            </div>

            <div class="card">
                <h3>Uso de Maquinaria</h3>
                <p>Registro y control de maquinaria en obra.</p>
                <div class="actions">
                    <a href="RegistrarUso">Registrar uso</a>
                    <a href="HistorialUso">Historial</a>
                </div>
            </div>

            <div class="card">
                <h3>Registro de Camiones</h3>
                <p>Control de ingreso y salida de camiones.</p>
                <div class="actions">
                    <a href="RegistrarCamionesSv">Registrar</a>
                    <a href="HistorialCamiones">Historial</a>
                </div>
            </div>

        </section>

    </main>

</div>

</body>
</html>
