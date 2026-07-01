<%-- 
    Document   : ProyectosTrabajador
    Created on : 20 mar 2026
    Author     : Benja
--%>
<%@page import="java.util.List"%>
<%@page import="DTO.ProyectosTrabajadorDTO"%> 
<%@page import="model.Usuarios"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
    
    if (user == null || !user.getRol().equalsIgnoreCase("Trabajador")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Proyectos | Panel de Usuario</title>
    
    <link rel="stylesheet" href="CSS/Empleados.css">
    <link rel="stylesheet" href="CSS/ProyectosTrabajador.css">
    <script src="JS/menu-movil.js" defer></script>
    <link rel="icon" href="images/vyg.svg" type="image/png">
</head>
<body>

    <div class="admin-container">
        
        <div class="overlay" id="sidebarOverlay"></div>

        <aside class="sidebar" id="sidebar">
                        <div class="sidebar-header">
                <img src="images/vyg.svg" alt="Logotipo VyG" class="logo-img">
                <div class="brand-text">
                    <h2>VyGApps</h2>
                    <span class="panel-badge" style="<%= (user.getRol().equalsIgnoreCase("Administrador") ? "background:#fceceb; color:#c0392b;" : user.getRol().equalsIgnoreCase("Supervisor") ? "background:#eafaf1; color:#27ae60;" : "background:#e8f0fe; color:#1a73e8;") %>"><%= user.getRol() %></span>
                </div>
            </div>
            <nav>
                <a href="Home" class="menu-item"> 
                    <span class="menu-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg></span> Mi Perfil
                </a>
                <a href="HistorialAsistenciaSv" class="menu-item">
                    <span class="menu-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg></span> Asistencia
                </a>
                <a href="MisPagosSv" class="menu-item">
                    <span class="menu-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"></line><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path></svg></span> Mis Pagos
                </a>
                <a href="ProyectosTrabajador" class="menu-item active">
                    <span class="menu-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path></svg></span> Proyectos
                </a>
            </nav>
        </aside>

        <main class="main-content">
            
            <header class="header">
                <div class="header-left" style="display: flex; align-items: center; gap: 15px;">
                    <button id="menu-toggle" class="mobile-menu-btn">☰</button>
                    <div class="header-title">
                        <h1>Mis Proyectos Asignados</h1>
                        <span>Listado de las obras en las que estás registrado actualmente.</span>
                    </div>
                </div>
            </header>

            <div class="page-wrapper">
                <div class="card attendance-card">
                    
                    <div class="table-responsive">
                        <table class="vyg-table">
                            <thead>
                                <tr>
                                    <th>Nombre del Trabajador</th>
                                    <th>Puesto Asignado</th>
                                    <th>Proyecto / Obra</th>
                                    <th>Estado de la Obra</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    ProyectosTrabajadorDTO misProyectos = (ProyectosTrabajadorDTO) request.getAttribute("TraerProyecto");

                                    if (misProyectos != null && !misProyectos.getNombre_proyecto().isEmpty()) {
                                        
                                        String estadoClass = "status-paused"; 
                                        if (misProyectos.getEstado().equalsIgnoreCase("activo")) {
                                            estadoClass = "status-active";
                                        } else if (misProyectos.getEstado().equalsIgnoreCase("finalizado") || misProyectos.getEstado().equalsIgnoreCase("inactivo")) {
                                            estadoClass = "status-finished";
                                        }
                                %>
                                <tr>
                                    <td data-label="Nombre del Trabajador"><strong><%= misProyectos.getNombre()%></strong></td>
                                    <td data-label="Puesto Asignado" class="text-puesto"><%= misProyectos.getPuesto() %></td>
                                    <td data-label="Proyecto / Obra">
                                        <span class="project-icon">&#127975;</span> 
                                        <strong><%= misProyectos.getNombre_proyecto()%></strong>
                                    </td>
                                    <td data-label="Estado de la Obra">
                                        <span class="status-badge <%= estadoClass %>">
                                            <%= misProyectos.getEstado().toUpperCase() %>
                                        </span>
                                    </td>
                                </tr>
                                <%
                                    } else {
                                %>
                                <tr>
                                    <td colspan="4" class="empty-cell">
                                        <div class="empty-state-container" style="text-align: center; padding: 40px; color: #7f8c8d;">
                                            <span class="empty-icon" style="font-size: 40px; display: block; margin-bottom: 10px;">&#128679;</span>
                                            <h3>Sin asignaciones activas</h3>
                                            <p style="margin-top: 10px;">
                                                Actualmente no tienes ningún proyecto u obra asignada en el sistema. <br>
                                                Consulta con tu Ingeniero Residente o Supervisor.
                                            </p>
                                        </div>
                                    </td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>

                </div>
            </div>

        </main>
    </div>

</body>
</html>