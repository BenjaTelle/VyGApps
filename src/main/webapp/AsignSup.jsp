<%-- 
    Document   : AsignSup
    Created on : 10 feb 2026, 7:19:44?p.m.
    Author     : Benja
--%>
<%@page import="model.Usuarios"%>
<%@page import="Repository.TrabajadoresDAO"%>
<%@page import="model.trabajadores"%>
<%@page import="java.util.List"%>
<%@page import="Repository.ProyectoDAO"%>
<%@page import="model.proyectos"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    HttpSession sessionActual = request.getSession(false);
    Usuarios usuarioLogeado = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;

    if (usuarioLogeado == null) {
        response.sendRedirect("login.jsp");
        return;
    } else if (!usuarioLogeado.getRol().equals("Administrador")) {
        response.sendRedirect("AccDen.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Asignar Supervisor | VyGApps</title>
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/AsignSupervisor.css">
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
                <span class="panel-badge" style="<%= (usuarioLogeado.getRol().equalsIgnoreCase("Administrador") ? "background:#fceceb; color:#c0392b;" : usuarioLogeado.getRol().equalsIgnoreCase("Supervisor") ? "background:#eafaf1; color:#27ae60;" : "background:#e8f0fe; color:#1a73e8;") %>"><%= usuarioLogeado.getRol() %></span>
            </div>
        </div>
        <nav class="sidebar-nav">
            <a href="AdminPage.jsp" class="nav-item"><span>Dashboard Maestro</span></a>
            <a href="ListarProyectosSv" class="nav-item active" style="background-color: #2c3e50;"><span>Gestión de Proyectos</span></a>
            <a href="LogoutSv" class="nav-item logout-link"><span>Cerrar Sesión</span></a>
        </nav>
    </aside>

    <main class="main-content">
        <header class="topbar">
            <div class="header-left">
                <button id="menu-toggle" class="mobile-menu-btn">☰</button>
            </div>
            <div class="profile-menu">
                <div class="profile-info">
                    <span class="profile-name"><%= usuarioLogeado.getUser_name() %></span>
                    <span class="profile-role">Administrador</span>
                </div>
                <img src="images/usuario.png" class="profile-img" alt="Perfil">
            </div>
        </header>

        <section class="dashboard">
            <div class="form-container">
                <div class="form-card">
                    <h2>Asignar Supervisor</h2>
                    <p class="subtitle">Promueva a un trabajador como responsable de obra</p>

                    <form action="AsignSup" method="POST">
                        <div class="form-group">
                            <label>Seleccionar Trabajador</label>
                            <select name="id_trabajador" required>
                                <option value="">-- Elija un trabajador --</option>
                                <% 
                                    TrabajadoresDAO tDAO = new TrabajadoresDAO();
                                    List<trabajadores> ListaT = tDAO.ListarTrabajadoresSinSuperv();
                                    for (trabajadores t : ListaT) { 
                                %>
                                <option value="<%=t.getId_trabajador()%>"><%=t.getFull_name()%></option>
                                <% } %>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Proyecto / Obra Destino</label>
                            <select name="id_proyecto" required>
                                <option value="">-- Elija un proyecto --</option>
                                <%
                                    ProyectoDAO proyect = new ProyectoDAO();
                                    List<proyectos> Listap = proyect.ListarProyectos();
                                    for (proyectos p : Listap) {
                                %>
                                <option value="<%=p.getProyecto_id()%>"><%=p.getNombre_proyecto()%></option>
                                <% } %>
                            </select>
                        </div>

                        <div class="info-box">
                            El perfil seleccionado adquirirá los permisos para gestionar cuadrillas en este proyecto.
                        </div>

                        <button type="submit" class="btn-submit">Confirmar Asignación</button>
                    </form>
                </div>
            </div>
        </section>
    </main>
</div>

</body>
</html>