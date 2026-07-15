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
    <title>Generar Código | Kronos Industrial</title>
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/GenerarCodigo.css">
    <script src="JS/menu-movil.js" defer></script>
    <link rel="icon" href="images/KronosIndustrial.svg" type="image/png">

    <!-- Lucide Icons CDN -->
    <script src="https://unpkg.com/lucide@latest"></script>
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
            <a href="GenerarCodigoSv" class="nav-item active">
                <span class="icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 2l-2 2m-7.61 7.61a5.5 5.5 0 1 1-7.778 7.778 5.5 5.5 0 0 1 7.777-7.777zm0 0L15.5 7.5m0 0l3 3L22 7l-3-3m-3.5 3.5L19 4"></path></svg></span>
                <span>Generar Código</span>
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
                    <p class="codigo-info"><i data-lucide="clock" style="display:inline-block; vertical-align:middle; margin-right:4px; width: 14px; height: 14px"></i> Este código será válido por los próximos <strong><%= request.getAttribute("Minutos") %> minutos</strong>.</p>
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


    <!-- Inicializacion de Lucide Icons -->
    <script>
        lucide.createIcons();
    </script>
</body>
</html>
