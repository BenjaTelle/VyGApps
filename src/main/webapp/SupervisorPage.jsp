  <%-- 
    Document   : SupervisorPage
    Created on : 3 feb 2026, 7:06:55 p.m.
    Author     : Benja
--%>


<%@page import="DTO.UsuarioDetalle"%>
<%@page import="model.Usuarios"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
    
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    if (!user.getRol().equalsIgnoreCase("Supervisor")) {
        response.sendRedirect("AccDen.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel Supervisor | VyGApps</title>
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <script src="JS/menu-movil.js" defer></script>
    <link rel="icon" href="images/vyg.svg" type="image/png">
</head>
<body>

<div class="admin-container">

    <div class="overlay" id="sidebarOverlay"></div>

    <aside class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <img src="images/vyg.svg" alt="VyG Logo" class="sidebar-logo">
            <div class="brand-text">
                <h2>VyGApps</h2>
                <span class="panel-badge">Supervisor</span>
            </div>
        </div>

        <nav class="sidebar-nav">
            <a href="SupervisorPage" class="nav-item active">
                <span class="icon">📊</span>
                <span>Dashboard</span>
            </a>
            <a href="RegistrarGastoSv" class="nav-item">
                <span class="icon">💸</span>
                <span>Control de Gastos</span>
            </a>
            <a href="#" class="nav-item">
                <span class="icon">⚙️</span>
                <span>Configuración</span>
            </a>
            <a href="LogoutSv" class="nav-item logout-link">
                <span class="icon">🚪</span>
                <span>Cerrar Sesión</span>
            </a>
        </nav>
    </aside>

    <main class="main-content">

        <header class="topbar">
            <div class="header-left">
                <button id="menu-toggle" class="mobile-menu-btn">☰</button>
                <div class="welcome">
                    <% UsuarioDetalle ud = (UsuarioDetalle) request.getAttribute("usuarioLogueadoDetalle");%>
                    <h1>Hola, <%= ud.getTrabajadorAsign() %> 👋</h1>
                    <span>Centro de Control y Supervisión</span>
                </div>
            </div>

            <div class="profile-menu">
                <div class="profile-info">
                    <span class="profile-name"><%= user.getUser_name() %></span>
                    <span class="profile-role">Supervisor</span>
                </div>
                <img src="images/usuario.png" class="profile-img" alt="Perfil">
            </div>
        </header>

        <div class="highlight-card">
            <div class="highlight-info">
                <h3>🔑 Control de Accesos</h3>
                <p>Genera claves seguras para la asistencia diaria del personal en la obra.</p>
            </div>
            <a href="GenerarCodigoSv" class="btn-primary">Generar Código Ahora</a>
        </div>

        <section class="dashboard-grid">

            <div class="module-card">
                <div class="card-icon">🏗️</div>
                <h3>Proyectos</h3>
                <p>Gestión y seguimiento de obras.</p>
                <div class="actions">
                    <a href="ListarProyectos" class="btn-outline">Ver proyectos</a>
                    <a href="VerDetalleProyecto" class="btn-outline">Detalle proyecto</a>
                </div>
            </div>

            <div class="module-card">
                <div class="card-icon">💸</div>
                <h3>Gastos de Obra</h3>
                <p>Registro de viáticos, compras y caja chica.</p>
                <div class="actions">
                    <a href="RegistrarGastoSv" class="btn-outline">Registrar gasto</a>
                    <a href="#" class="btn-outline">Ver historial</a>
                </div>
            </div>

            <div class="module-card">
                <div class="card-icon">💰</div>
                <h3>Planilla y Pagos</h3>
                <p>Revisión y autorización de nóminas.</p>
                <div class="actions">
                    <a href="CentroPagos" class="btn-outline">Autorizar pagos</a>
                    <a href="HistorialPagosSupSv" class="btn-outline">Historial de pagos</a>
                </div>
            </div>

            <div class="module-card">
                <div class="card-icon">📅</div>
                <h3>Asistencias</h3>
                <p>Monitoreo y control del equipo.</p>
                <div class="actions">
                    <a href="AsistenciaGlobal" class="btn-outline">Ver asistencias</a>
                    <a href="BuscarDetalleAsis" class="btn-outline">Detalle por empleado</a>
                </div>
            </div>

            <div class="module-card">
                <div class="card-icon">🚜</div>
                <h3>Maquinaria</h3>
                <p>Registro y control de uso en obra.</p>
                <div class="actions">
                    <a href="RegistrarUso" class="btn-outline">Registrar uso</a>
                    <a href="HistorialUso" class="btn-outline">Ver Historial</a>
                </div>
            </div>

            <div class="module-card">
                <div class="card-icon">🚛</div>
                <h3>Control de Camiones</h3>
                <p>Ingreso y salida de material.</p>
                <div class="actions">
                    <a href="RegistrarCamionesSv" class="btn-outline">Registrar viaje</a>
                    <a href="HistorialCamiones" class="btn-outline">Ver Historial</a>
                </div>
            </div>

        </section>

    </main>
</div>

</body>
</html>
