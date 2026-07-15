<%-- 
    Document   : VerDetalleProyecto
    Created on : 6 mar 2026
    Author     : Benja
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.proyectos"%>
<%@page import="java.util.List"%>
<%@page import="model.Usuarios"%>

<%
    // Validación de seguridad de sesión
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;

    if (user == null || (!user.getRol().equalsIgnoreCase("Supervisor") && !user.getRol().equalsIgnoreCase("Administrador"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<proyectos> listaProyectos = (List<proyectos>) request.getAttribute("ListaProyectos");
    proyectos proyectoSeleccionado = (proyectos) request.getAttribute("proyectoSeleccionado");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalles del Proyecto | Kronos Industrial</title>
    
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/VerDetalleProyecto.css">
    <script src="JS/menu-movil.js" defer></script>
    <link rel="icon" href="images/KronosIndustrial.svg" type="image/png">
</head>
<body>

<div class="admin-container">

    <div class="overlay" id="sidebarOverlay"></div>

    <aside class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <img src="images/KronosIndustrial.svg" alt="Kronos Industrial Logo" class="sidebar-logo">
            <div class="brand-text">
                <h2 style="font-size: 18px;">Kronos Industrial</h2>
                <span class="panel-badge"><%= user.getRol() %></span>
            </div>
        </div>

        <nav class="sidebar-nav">
            <a href="SupervisorPage" class="nav-item">
                <span class="icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="20" x2="12" y2="10"></line><line x1="18" y1="20" x2="18" y2="4"></line><line x1="6" y1="20" x2="6" y2="16"></line></svg></span>
                <span>Dashboard</span>
            </a>
            <a href="ListarProyectos" class="nav-item">
                <span class="icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="7" width="20" height="14" rx="2" ry="2"></rect><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"></path></svg></span>
                <span>Proyectos Activos</span>
            </a>
            <a href="VerDetalleProyecto" class="nav-item active">
                <span class="icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg></span>
                <span>Consultar Proyecto</span>
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
                <button id="menu-toggle" class="mobile-menu-btn"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="3" y1="12" x2="21" y2="12"></line><line x1="3" y1="6" x2="21" y2="6"></line><line x1="3" y1="18" x2="21" y2="18"></line></svg></button>
                <div class="welcome">
                    <h1>Consultar Proyecto</h1>
                    <span>Seleccione una obra para ver su estado y presupuesto.</span>
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

        <section class="dashboard">

            <div class="form-container">
                <form action="VerDetalleProyecto" method="GET" class="search-form">
                    <input type="hidden" name="accion" value="verDetalle">
                    
                    <div class="form-group">
                        <label for="id_proyecto">Seleccione el Proyecto a consultar:</label>
                        <div class="input-group">
                            <select name="id_proyecto" id="id_proyecto" required>
                                <option value="" disabled selected>-- Lista de proyectos activos --</option>
                                <%
                                    if(listaProyectos != null) {
                                        for(proyectos p : listaProyectos) {
                                            String isSelected = (proyectoSeleccionado != null && proyectoSeleccionado.getProyecto_id() == p.getProyecto_id()) ? "selected" : "";
                                %>
                                <option value="<%= p.getProyecto_id() %>" <%= isSelected %>>
                                    <%= p.getNombre_proyecto()%>
                                </option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                            <button type="submit" class="btn-search">Cargar Datos <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg></button>
                        </div>
                    </div>
                </form>
            </div>

            <% if (proyectoSeleccionado != null) { %>
            <div class="result-card">
                <div class="result-header">
                    <h3><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"></path><rect x="8" y="2" width="8" height="4" rx="1" ry="1"></rect></svg> Ficha Técnica del Proyecto</h3>
                    <span class="status-badge <%= proyectoSeleccionado.getEstado().equalsIgnoreCase("activo") ? "status-active" : "status-inactive" %>">
                        <%= proyectoSeleccionado.getEstado().toUpperCase() %>
                    </span>
                </div>

                <div class="result-body">
                    <div class="info-group full-width">
                        <span class="info-label">Nombre Oficial de la Obra</span>
                        <span class="info-value title-value"><%= proyectoSeleccionado.getNombre_proyecto()%></span>
                    </div>

                    <div class="info-group">
                        <span class="info-label">Código Interno</span>
                        <span class="info-value">PRY-<%= String.format("%03d", proyectoSeleccionado.getProyecto_id()) %></span>
                    </div>

                    <div class="info-group highlight-financial">
                        <span class="info-label">Presupuesto Total Asignado</span>
                        <span class="info-value text-green">C$ <%= String.format("%,.2f", proyectoSeleccionado.getPresupuesto_total()) %></span>
                    </div>
                </div>
            </div>
            <% } %>

        </section>

    </main>
</div>

</body>
</html>