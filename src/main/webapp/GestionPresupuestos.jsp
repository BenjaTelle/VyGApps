<%-- 
    Document   : GestionPresupuestos
    Created on : 2 abr 2026
    Author     : Benja
--%>
<%@page import="model.proyectos"%>
<%@page import="java.util.List"%>
<%@page import="Repository.ProyectoDAO"%> 
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

    // Recibimos la lista de proyectos desde el Servlet
    List<proyectos> listaProyectos = (List<proyectos>) request.getAttribute("ListaProyectos");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Presupuestos | VyGApps</title>
    
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/GestionPresupuestos.css">
    
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
                <span class="icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="20" x2="12" y2="10"></line><line x1="18" y1="20" x2="18" y2="4"></line><line x1="6" y1="20" x2="6" y2="16"></line></svg></span>
                <span>Dashboard Maestro</span>
            </a>
            <a href="AdminFinanzas" class="nav-item" ">
                <span class="icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"></line><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path></svg></span>
                <span>Control Financiero</span>
            </a>
            <a href="GestionPresupuestos" class="nav-item active" style="background-color: #2c3e50;">
                <span class="icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"></path><polyline points="7.5 4.21 12 6.81 16.5 4.21"></polyline><polyline points="7.5 19.79 7.5 14.6 3 12"></polyline><polyline points="21 12 16.5 14.6 16.5 19.79"></polyline><polyline points="3.27 6.96 12 12.01 20.73 6.96"></polyline><line x1="12" y1="22.08" x2="12" y2="12"></line></svg></span>
                <span>Gestionar Presupuestos</span>
            </a>
            <a href="LogoutSv" class="nav-item logout-link">
                <span class="icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" y1="12" x2="9" y2="12"></line></svg></span>
                <span>Cerrar Sesión</span>
            </a>
        </nav>
    </aside>

    <main class="main-content">

        <header class="topbar">
            <div class="header-left">
                <button id="menu-toggle" class="mobile-menu-btn">☰</button>
                <div class="welcome">
                    <h1>Inyección de Presupuestos</h1>
                    <span>Asigna fondos a los proyectos para cubrir nóminas y gastos.</span>
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

            <div class="budget-container">
                
                <div class="budget-form-card">
                    <div class="card-header">
                        <h3>➕ Inyectar Capital</h3>
                        <p>Suma fondos al presupuesto actual de un proyecto.</p>
                    </div>
                    
                    <form action="GestionPresupuestos" method="POST" class="vyg-form">
                        <div class="form-group">
                            <label for="id_proyecto">Seleccionar Proyecto:</label>
                            <select id="id_proyecto" name="id_proyecto" required>
                                <option value="">-- Elija un proyecto --</option>
                                <% 
                                    if(listaProyectos != null) {
                                        for(proyectos p : listaProyectos) { 
                                %>
                                    <option value="<%= p.getProyecto_id()%>"><%= p.getNombre_proyecto() %></option>
                                <% 
                                        }
                                    } 
                                %>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="monto_adicional">Monto a Inyectar (C$):</label>
                            <input type="number" id="monto_adicional" name="monto_adicional" step="0.01" min="1" placeholder="Ej. 50000.00" required>
                        </div>

                        <button type="submit" class="btn-submit-budget"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="8 17 12 21 16 17"></polyline><line x1="12" y1="12" x2="12" y2="21"></line><path d="M20.88 18.09A5 5 0 0 0 18 9h-1.26A8 8 0 1 0 3 16.29"></path></svg> Asignar Fondos</button>
                    </form>
                </div>

                <div class="budget-table-card">
                    <div class="card-header">
                        <h3><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"></line><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path></svg> Estado de Proyectos</h3>
                    </div>
                    
                    <div class="table-responsive">
                        <table class="vyg-table">
                            <thead>
                                <tr>
                                    <th>Proyecto</th>
                                    <th style="text-align: right;">Presupuesto Disponible</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    if(listaProyectos != null && !listaProyectos.isEmpty()) {
                                        for(proyectos p : listaProyectos) { 
                                %>
                                <tr>
                                    <td data-label="Proyecto"><strong><%= p.getNombre_proyecto() %></strong></td>
                                    <td data-label="Disponible" class="money-cell">
                                        C$ <%= String.format("%,.2f", p.getPresupuesto_total()) %>
                                    </td>
                                </tr>
                                <% 
                                        }
                                    } else { 
                                %>
                                <tr>
                                    <td colspan="2" class="empty-cell">No hay proyectos activos en este momento.</td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div> 

            <div class="card-footer-nav">   
                <a href="AdminFinanzas" class="btn-back"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg> Volver al Panel Financiero</a>
            </div>

        </section>

    </main>
</div>

</body>
</html>