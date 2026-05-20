<%-- 
    Document   : AdminFinanzas
    Created on : 2 abr 2026
    Author     : Benja
--%>
<%@page import="java.util.List"%>
<%@page import="DTO.DashboardAdminDTO"%>
<%@page import="model.Usuarios"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // 1. Lógica de seguridad ESTRICTA (Solo Administradores)
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
    
    if (user == null || !user.getRol().equalsIgnoreCase("Administrador")) {
        if(user != null && user.getRol().equalsIgnoreCase("Supervisor")){
            response.sendRedirect("BandejaAutorizacion.jsp");
        } else {
            response.sendRedirect("login.jsp");
        }
        return;
    }

    // 2. Recibimos los datos financieros desde el Servlet
    DashboardAdminDTO dashboard = (DashboardAdminDTO) request.getAttribute("DashboardData");
    
    // Prevención de nulos por si acceden directo al JSP sin pasar por el Servlet
    if(dashboard == null) {
        dashboard = new DashboardAdminDTO();
        dashboard.setTotalPagadoMes("C$ 0.00");
        dashboard.setTotalPendiente("C$ 0.00");
        dashboard.setPlanillasPendientes(0);
        dashboard.setPresupuestoGlobal("C$ 0.00");
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Control Financiero Maestro | VyGApps</title>
    
    <link rel="stylesheet" href="CSS/SupervisorPage.css"> 
    <link rel="stylesheet" href="CSS/AdminFinanzas.css"> 
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
            <a href="AdminFinanzas" class="nav-item active" style="background-color: #2c3e50;">
                <span class="icon">💰</span>
                <span>Control Financiero</span>
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
                    <h1>Finanzas y Nóminas</h1>
                    <span>Vista maestra de generación y presupuestos.</span>
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

            <div class="kpi-grid">
                <div class="kpi-card">
                    <span class="kpi-icon">💸</span>
                    <div class="kpi-data">
                        <p>Pagado este mes</p>
                        <h3 class="text-success"><%= dashboard.getTotalPagadoMes() %></h3>
                    </div>
                </div>
                
                <div class="kpi-card">
                    <span class="kpi-icon">⏳</span>
                    <div class="kpi-data">
                        <p>En espera de Autorización</p>
                        <h3 class="text-warning"><%= dashboard.getTotalPendiente() %></h3>
                    </div>
                </div>
                
                <div class="kpi-card">
                    <span class="kpi-icon">📉</span>
                    <div class="kpi-data">
                        <p>Planillas Pendientes</p>
                        <h3 class="text-dark"><%= dashboard.getPlanillasPendientes() %></h3>
                    </div>
                </div>
                
                <div class="kpi-card">
                    <span class="kpi-icon">🏗️</span>
                    <div class="kpi-data">
                        <p>Presupuesto Global Disp.</p>
                        <h3 class="text-dark"><%= dashboard.getPresupuestoGlobal() %></h3>
                    </div>
                </div>
            </div>

            <% 
                List<String> alertas = dashboard.getAlertas();
                if(alertas != null && !alertas.isEmpty()) { 
                    for(String alertaMensaje : alertas) {
            %>
            <div class="alert-box">
                <span class="alert-icon">⚠️</span>
                <div>
                    <strong>Atención requerida:</strong> <%= alertaMensaje %>
                </div>
            </div>
            <% 
                    }
                } 
            %>

            <h3 class="section-title">⚙️ Generación de Egresos</h3>
            <div class="action-grid">
                <a href="GenerarPlanilla" class="action-card">
                    <span class="action-icon">👥</span>
                    <h3>Nómina Quincenal</h3>
                    <p>Calcula días y genera pagos a trabajadores.</p>
                </a>
                
                <a href="GenerarPagoMaquinaria" class="action-card">
                    <span class="action-icon">🚜</span>
                    <h3>Liquidación Maquinaria</h3>
                    <p>Genera pagos por horas de alquiler y diésel.</p>
                </a>
                
                <a href="GestionPresupuestos" class="action-card">
                    <span class="action-icon">📊</span>
                    <h3>Gestión Presupuestos</h3>
                    <p>Asigna o modifica fondos por proyecto.</p>
                </a>
            </div>

            <h3 class="section-title">🕵️ Auditoría y Reportes</h3>
            <div class="action-grid auth-grid" style="grid-template-columns: repeat(3, 1fr);">
                
                <a href="MonitorAutorizaciones" class="action-card monitor-card">
                    <span class="action-icon">👀</span>
                    <h3>Monitor Autorizaciones</h3>
                    <p>Revisa el estatus de las planillas de cada supervisor.</p>
                </a>
                
                <a href="AutorizarGastosSv" class="action-card" style="border-top-color: #e67e22;">
                    <span class="action-icon">🧾</span>
                    <h3>Bandeja de Gastos</h3>
                    <p>Audita, aprueba o rechaza los gastos menores registrados por supervisores.</p>
                </a>

                <a href="AuditoriaPagosSv" class="action-card auditoria-card">
                    <span class="action-icon">🗂️</span>
                    <h3>Historial Maestro</h3>
                    <p>Búsqueda global de pagos y exportación a PDF.</p>
                </a>
                
            </div>

            <div class="card-footer-nav">
                <a href="AdminPage.jsp" class="btn-back">⬅️ Volver al Panel Principal</a>
            </div>

        </section>

    </main>
</div>

</body>
</html>