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

    <!-- Lucide Icons CDN -->
    <script src="JS/lucide.min.js"></script>
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
                <span class="icon"><i data-lucide="bar-chart-3" style="width: 20px; height: 20px"></i></span>
                <span>Dashboard</span>
            </a>
            <a href="ListarProyectos" class="nav-item">
                <span class="icon"><i data-lucide="briefcase" style="width: 20px; height: 20px"></i></span>
                <span>Proyectos Activos</span>
            </a>
            <a href="VerDetalleProyecto" class="nav-item active">
                <span class="icon"><i data-lucide="search" style="width: 20px; height: 20px"></i></span>
                <span>Consultar Proyecto</span>
            </a>
            <a href="LogoutSv" class="nav-item logout-link">
                <span class="icon"><i data-lucide="log-out" style="width: 20px; height: 20px"></i></span>
                <span>Cerrar Sesión</span>
            </a>
        </nav>
    </aside>

    <main class="main-content">

        <header class="topbar">
            <div class="header-left">
                <button id="menu-toggle" class="mobile-menu-btn"><i data-lucide="menu" style="width: 24px; height: 24px"></i></button>
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
                            <button type="submit" class="btn-search">Cargar Datos <i data-lucide="search" style="width: 20px; height: 20px"></i></button>
                        </div>
                    </div>
                </form>
            </div>

            <% if (proyectoSeleccionado != null) { %>
            <div class="result-card">
                <div class="result-header">
                    <h3><i data-lucide="clipboard" style="width: 20px; height: 20px"></i> Ficha Técnica del Proyecto</h3>
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


    <!-- Inicializacion de Lucide Icons -->
    <script>
        lucide.createIcons();
    </script>
</body>
</html>