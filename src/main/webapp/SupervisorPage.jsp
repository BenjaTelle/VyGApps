<%-- 
    Document   : SupervisorPage
    Created on : 3 feb 2026
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
    <title>Panel Supervisor | V&G Ingenieros</title>
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <script src="JS/menu-movil.js" defer></script>
    <link rel="icon" href="images/vygLogo.svg" type="image/svg+xml">

    <!-- Lucide Icons CDN -->
    <script src="JS/lucide.min.js"></script>
</head>
<body>

<div class="admin-container">

    <div class="overlay" id="sidebarOverlay"></div>

    <aside class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <img src="images/vygLogo.svg" alt="V&G Ingenieros Logo" class="sidebar-logo">
            <div class="brand-text">
                <h2 style="font-size: 18px;">V&G Ingenieros</h2>
                <span class="panel-badge"><%= user.getRol() %></span>
            </div>
        </div>

        <nav class="sidebar-nav">
            <a href="SupervisorPage" class="nav-item active">
                <i data-lucide="layout-dashboard" style="width: 20px; height: 20px"></i>
                <span>Dashboard</span>
            </a>
            <a href="RegistrarGastoSv" class="nav-item">
                <i data-lucide="dollar-sign" style="width: 20px; height: 20px"></i>
                <span>Control de Gastos</span>
            </a>
            <a href="GestionJustificaciones" class="nav-item">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                <span>Justificaciones</span>
            </a>
            <a href="Deducciones" class="nav-item">
                <i data-lucide="minus-circle" style="width: 20px; height: 20px"></i>
                <span>Deducciones</span>
            </a>
            <a href="Configuracion.jsp" class="nav-item">
                <i data-lucide="settings" style="width: 20px; height: 20px"></i>
                <span>Configuración</span>
            </a>
            <a href="LogoutSv" class="nav-item logout-link">
                <i data-lucide="log-out" style="width: 20px; height: 20px"></i>
                <span>Cerrar Sesión</span>
            </a>
        </nav>
    </aside>

    <main class="main-content">

        <header class="topbar">
            <div class="header-left">
                <button id="menu-toggle" class="mobile-menu-btn">
                    <i data-lucide="menu" style="width: 24px; height: 24px"></i>
                </button>
                <div class="welcome">
                    <% 
                        UsuarioDetalle ud = (UsuarioDetalle) request.getAttribute("usuarioLogueadoDetalle");
                        String nombreMostrar = (ud != null && ud.getTrabajadorAsign() != null && !ud.getTrabajadorAsign().isEmpty()) ? ud.getTrabajadorAsign() : user.getUser_name();
                    %>
                    <h1>Hola, <%= nombreMostrar %></h1>
                    <span>Centro de Control y Supervisión</span>
                </div>
            </div>

            <div class="profile-menu">
                <div class="profile-info">
                    <span class="profile-name"><%= user.getUser_name() %></span>
                    <span class="profile-role"><%= user.getRol() %></span>
                </div>
                <img src="images/usuario.png" class="profile-img" alt="Perfil">
            </div>
        </header>

        <div class="highlight-card">
            <div class="highlight-info">
                <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 8px;">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 2l-2 2m-7.61 7.61a5.5 5.5 0 1 1-7.778 7.778 5.5 5.5 0 0 1 7.777-7.777zm0 0L15.5 7.5m0 0l3 3L22 7l-3-3m-3.5 3.5L19 4"></path></svg>
                    <h3 style="margin: 0;">Control de Accesos</h3>
                </div>
                <p style="margin: 0;">Genera claves seguras para la asistencia diaria del personal en la obra.</p>
            </div>
            <a href="GenerarCodigoSv" class="btn-primary">Generar Código Ahora</a>
        </div>

        <section class="dashboard-grid">

            <div class="module-card">
                <div class="card-icon icon-orange">
                    <i data-lucide="home" style="width: 28px; height: 28px"></i>
                </div>
                <h3>Proyectos</h3>
                <p>Gestión y seguimiento de obras.</p>
                <div class="actions">
                    <a href="ListarProyectos" class="btn-outline">Ver proyectos</a>
                    <a href="VerDetalleProyecto" class="btn-outline">Detalle proyecto</a>
                </div>
            </div>

            <div class="module-card">
                <div class="card-icon icon-blue">
                    <i data-lucide="dollar-sign" style="width: 28px; height: 28px"></i>
                </div>
                <h3>Gastos de Obra</h3>
                <p>Registro de viáticos, compras y caja chica.</p>
                <div class="actions">
                    <a href="RegistrarGastoSv" class="btn-outline">Registrar gasto</a>
                    <a href="#" class="btn-outline">Ver historial</a>
                </div>
            </div>

            <div class="module-card">
                <div class="card-icon icon-purple">
                    <i data-lucide="briefcase" style="width: 28px; height: 28px"></i>
                </div>
                <h3>Planilla y Pagos</h3>
                <p>Revisión y autorización de nóminas.</p>
                <div class="actions">
                    <a href="CentroPagos" class="btn-outline">Autorizar pagos</a>
                    <a href="HistorialPagosSupSv" class="btn-outline">Historial de pagos</a>
                </div>
            </div>

            <div class="module-card">
                <div class="card-icon icon-green">
                    <i data-lucide="calendar" style="width: 28px; height: 28px"></i>
                </div>
                <h3>Asistencias</h3>
                <p>Monitoreo y control del equipo.</p>
                <div class="actions">
                    <a href="AsistenciaGlobal" class="btn-outline">Ver asistencias</a>
                    <a href="GestionJustificaciones" class="btn-outline">Justificaciones</a>
                    <a href="BuscarDetalleAsis" class="btn-outline">Detalle empleado</a>
                </div>
            </div>

            <div class="module-card">
                <div class="card-icon icon-dark">
                    <i data-lucide="wrench" style="width: 28px; height: 28px"></i>
                </div>
                <h3>Maquinaria</h3>
                <p>Registro y control de uso en obra.</p>
                <div class="actions">
                    <a href="RegistrarUso" class="btn-outline">Registrar uso</a>
                    <a href="HistorialUso" class="btn-outline">Ver Historial</a>
                </div>
            </div>

            <div class="module-card">
                <div class="card-icon icon-teal">
                    <i data-lucide="truck" style="width: 28px; height: 28px"></i>
                </div>
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


    <!-- Inicializacion de Lucide Icons -->
    <script>
        lucide.createIcons();
    </script>
</body>
</html>
