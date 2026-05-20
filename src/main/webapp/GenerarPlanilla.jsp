<%-- 
    Document   : GenerarPlanilla
    Author     : Benja
--%>
<%@page import="model.Usuarios"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Lógica de seguridad ESTRICTA (Solo Administradores)
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
    
    if (user == null || !user.getRol().equalsIgnoreCase("Administrador")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Generar Nómina | VyGApps</title>
    
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/FormulariosGeneracion.css">
    <script src="JS/menu-movil.js" defer></script>
    <link rel="icon" href="images/vyg.svg" type="image/svg+xml">
</head>
<body>

<div class="admin-container">

    <div class="overlay" id="sidebarOverlay"></div>

    <aside class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <img src="images/vyg.svg" alt="VyG Logo" class="sidebar-logo">
            <div class="brand-text">
                <h2>VyGApps</h2>
                <span class="panel-badge" style="background:#fceceb; color:#c0392b;">Administrador</span>
            </div>
        </div>

        <nav class="sidebar-nav">
            <a href="AdminPage.jsp" class="nav-item">
                <span class="icon">📊</span>
                <span>Dashboard Maestro</span>
            </a>
            <a href="AdminFinanzas" class="nav-item"">
                <span class="icon">💰</span>
                <span>Control Financiero</span>
            </a>
            <a href="GenerarPlanilla.jsp" class="nav-item active" style="background-color: #2c3e50;">
                <span class="icon">📌</span>
                <span>Generar Planilla</span>
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
                    <h1>Asistente de Nómina</h1>
                    <span>Configura el periodo quincenal para procesar los pagos.</span>
                </div>
            </div>

            <div class="profile-menu">
                <div class="profile-info">
                    <span class="profile-name"><%= user.getUser_name() %></span>
                    <span class="profile-role">Administrador</span>
                </div>
                <img src="images/usuario.png" class="profile-img" alt="Perfil">
            </div>
        </header>

        <section class="dashboard">

            <div class="generator-wrapper">
                
                <div class="generator-header bg-nomina">
                    <div class="header-content">
                        <h2>👥 Cálculo de Nómina Quincenal</h2>
                        <p>Genera las planillas de los trabajadores basadas en sus asistencias marcadas.</p>
                    </div>
                </div>

                <div class="form-card">
                    <div class="form-header">
                        <h3>Parámetros de la Quincena</h3>
                        <p>Selecciona las fechas de inicio y fin. El sistema evaluará la asistencia en este rango.</p>
                    </div>

                    <form action="GenerarPlanilla" method="POST" class="vyg-form">
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="fecha_inicio">Fecha de Inicio del Periodo:</label>
                                <input type="date" id="fecha_inicio" name="fecha_inicio" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="fecha_fin">Fecha de Fin del Periodo:</label>
                                <input type="date" id="fecha_fin" name="fecha_fin" required>
                            </div>
                        </div>

                        <div class="info-box info-blue">
                            <span class="info-icon">ℹ️</span>
                            <div class="info-text">
                                <strong>¿Cómo funciona el cálculo?</strong><br>
                                El sistema tomará el salario quincenal, lo dividirá entre 15 días y lo multiplicará por los días que el trabajador tenga registros de entrada en el rango. Los días sin marcar serán descontados automáticamente.
                            </div>
                        </div>

                        <div class="form-actions">
                            <a href="AdminFinanzas" class="btn-cancelar">Cancelar</a>
                            <button type="submit" class="btn-generar btn-nomina">
                                🚀 Procesar Planillas
                            </button>
                        </div>
                    </form>
                </div>

            </div>

        </section>

    </main>
</div>

</body>
</html>