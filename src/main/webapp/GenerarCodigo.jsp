<%-- 
    Document   : GenerarCodigo
    Created on : 11 abr 2026, 8:09:31 p.m.
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
    <title>Generar Código | VyGApps</title>
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/GenerarCodigo.css"> <link rel="icon" href="images/vyg.svg" type="image/png">
</head>
<body>

<div class="container">

    <aside class="sidebar">
        <div class="sidebar-header">
            <div class="brand-title">
                <img src="images/vyg.svg" alt="VyG Logo" class="sidebar-logo">
                <h2>VyGApps</h2>
            </div>
            <p class="panel-label">Panel Supervisor</p>
        </div>
        <nav>
            <a href="SupervisorPanel" class="menu-item" style="color:rgb(152, 72, 7); text-decoration:none; padding:15px; display:block;">⬅ Volver al Panel</a>
        </nav>
    </aside>

    <main class="main-content">

        <header class="topbar">
            <div class="welcome">
                <h1>Generar Código de Asistencia</h1>
                <span>Crea claves temporales para el registro del personal de campo.</span>
            </div>

            <div class="profile">
                <img src="images/usuario.png" class="profile-img" alt="Perfil">
                <span><%= user.getUser_name() %></span>
                <a href="LogoutSv" class="btn-logout">Salir</a>
            </div>
        </header>

        <section class="dashboard">

            <%-- MOSTRAR CÓDIGO SI SE GENERÓ CON ÉXITO --%>
            <% 
                String codigoGenerado = (String) request.getAttribute("CodigoExito");
                if (codigoGenerado != null) { 
            %>
                <div class="codigo-result-card">
                    <h3>¡Código Generado Exitosamente! ✅</h3>
                    <p>Comparte este código con tu cuadrilla para que marquen su entrada:</p>
                    <div class="codigo-gigante"><%= codigoGenerado %></div>
                    <p class="codigo-info">⏳ Este código será válido por los próximos <strong><%= request.getAttribute("Minutos") %> minutos</strong>.</p>
                </div>
            <% } %>

            <%-- MOSTRAR ERROR SI ALGO SALIÓ MAL --%>
            <% if (request.getAttribute("ErrorGeneracion") != null) { %>
                <div style="background: #fdf2e9; color: #e74c3c; padding: 15px; text-align: center; border-radius: 8px; margin-bottom: 20px; font-weight: bold;">
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

                    <button type="submit" class="btn-generar">Generar Nuevo Código 🔑</button>
                </form>
            </div>

        </section>
    </main>
</div>

</body>
</html>