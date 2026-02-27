<%@page import="DTO.UsuarioDetalle"%>
<%@page import="model.Usuarios"%>
<%
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;

    if (user == null || !user.getRol().equalsIgnoreCase("Supervisor")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Panel Supervisor</title>
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
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
                <span>Gestión general de supervisión</span>
            </div>

            <div class="profile">
                <img src="images/usuario.png" class="profile-img" alt="Perfil">
                <span><%= user.getUser_name() %></span>
                <a href="LogoutSv" class="btn-logout">Salir</a>
            </div>
        </header>

        <section class="dashboard">

            <div class="card">
                <h3>Proyectos</h3>
                <p>Gestión y seguimiento de obras asignadas.</p>
                <div class="actions">
                    <a href="VerProyectos">Ver proyectos</a>
                    <a href="DetalleProyecto">Detalle proyecto</a>
                </div>
            </div>

            <div class="card">
                <h3>Pagos</h3>
                <p>Revisión y autorización de pagos del personal.</p>
                <div class="actions">
                    <a href="AutorizarPagos">Autorizar pagos</a>
                    <a href="HistorialPagos">Historial de pagos</a>
                </div>
            </div>

            <div class="card">
                <h3>Asistencias</h3>
                <p>Monitoreo y control de asistencia del equipo.</p>
                <div class="actions">
                    <a href="MonitorearAsistencia">Ver asistencias</a>
                    <a href="DetalleAsistencia">Detalle por trabajador</a>
                </div>
            </div>

            <div class="card">
                <h3>Uso de Maquinaria</h3>
                <p>Registro y control de maquinaria en obra.</p>
                <div class="actions">
                    <a href="RegistrarUsoMaquinaria">Registrar uso</a>
                    <a href="HistorialMaquinaria">Historial</a>
                </div>
            </div>

            <div class="card">
                <h3>Registro de Camiones</h3>
                <p>Control de ingreso y salida de camiones.</p>
                <div class="actions">
                    <a href="RegistrarCamion">Registrar</a>
                    <a href="HistorialCamiones">Historial</a>
                </div>
            </div>

        </section>

    </main>

</div>

</body>
</html>