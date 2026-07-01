<%-- 
    Document   : GenerarCodigo
    Created on : 11 abr 2026
    Author     : Benja
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.proyectos"%>
<%@page import="java.util.List"%>
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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Generar Código | VyGApps</title>
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/GenerarCodigo.css">
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
                <span class="panel-badge"><%= user.getRol() %></span>
            </div>
        </div>

        <nav class="sidebar-nav">
            <a href="SupervisorPage" class="nav-item">
                <span class="icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="20" x2="12" y2="10"></line><line x1="18" y1="20" x2="18" y2="4"></line><line x1="6" y1="20" x2="6" y2="16"></line></svg></span>
                <span>Dashboard</span>
            </a>
            <a href="GenerarCodigoSv" class="nav-item active">
                <span class="icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 2l-2 2m-7.61 7.61a5.5 5.5 0 1 1-7.778 7.778 5.5 5.5 0 0 1 7.777-7.777zm0 0L15.5 7.5m0 0l3 3L22 7l-3-3m-3.5 3.5L19 4"></path></svg></span>
                <span>Generar Código</span>
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
                    <h1>Generar Código de Asistencia</h1>
                    <span>Crea claves temporales para el registro del personal.</span>
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

            <%-- MOSTRAR CÓDIGO SI SE GENERÓ CON ÉXITO --%>
            <% 
                String codigoGenerado = (String) request.getAttribute("CodigoExito");
                if (codigoGenerado != null) { 
            %>
                <div class="codigo-result-card">
                    <h3>¡Código Generado Exitosamente! <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg></h3>
                    <p>Comparte este código con tu cuadrilla para que marquen su entrada:</p>
                    <div class="codigo-gigante"><%= codigoGenerado %></div>
                    <p class="codigo-info"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" style="display:inline-block; vertical-align:middle; margin-right:4px;"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg> Este código será válido por los próximos <strong><%= request.getAttribute("Minutos") %> minutos</strong>.</p>
                </div>
            <% } %>

            <%-- MOSTRAR ERROR SI ALGO SALIÓ MAL --%>
            <% if (request.getAttribute("ErrorGeneracion") != null) { %>
                <div class="error-msg">
                    <%= request.getAttribute("ErrorGeneracion") %>
                </div>
            <% } %>

            <%-- FORMULARIO DE GENERACIÓN --%>
            <div class="form-container">
                <form action="GenerarCodigoSv" method="POST">
                    
                    <div class="form-group">
                        <label>Seleccionar Proyecto / Obra:</label>
                        <select name="id_proyecto" required>
                            <option value="">-- Seleccione un proyecto --</option>
                            <% 
                                List<proyectos> listaProyectos = (List<proyectos>) request.getAttribute("ListaProyectos");
                                if (listaProyectos != null) {
                                    for (proyectos p : listaProyectos) {
                            %>
                                <option value="<%= p.getProyecto_id() %>"><%= p.getNombre_proyecto() %></option>
                            <% 
                                    }
                                } 
                            %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Tiempo de Validez:</label>
                        <select name="tiempo_validez" required>
                            <option value="15">15 Minutos (Recomendado)</option>
                            <option value="30">30 Minutos</option>
                            <option value="60">1 Hora</option>
                            <option value="720">Todo el día (12 Horas)</option>
                        </select>
                    </div>

                    <button type="submit" class="btn-generar">Generar Nuevo Código <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 2l-2 2m-7.61 7.61a5.5 5.5 0 1 1-7.778 7.778 5.5 5.5 0 0 1 7.777-7.777zm0 0L15.5 7.5m0 0l3 3L22 7l-3-3m-3.5 3.5L19 4"></path></svg></button>
                </form>
            </div>

        </section>
    </main>
</div>

</body>
</html>
