<%-- 
    Document   : CrearProyecto
    Created on : 17 feb 2026, 6:34:50 p.m.
    Author     : Benja
--%>
<%@page import="java.util.List"%>
<%@page import="model.trabajadores"%>
<%@page import="model.Usuarios"%>
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
    <title>Crear Proyecto | VyGApps</title>
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/CrearProyecto.css">
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
                <span class="panel-badge" style="background:#fceceb; color:#c0392b;">Administrador</span>
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
                    <h2>Crear Nuevo Proyecto</h2>
                    <p class="subtitle">Complete la información general de la obra</p>

                    <form action="CrearProyecto" method="post">
                        <div class="form-group">
                            <label for="nombre">Nombre del Proyecto</label>
                            <input type="text" id="nombre" name="nombre_proyecto" placeholder="Ej. Residencial Las Colinas" required>
                        </div>

                        <div class="form-group">
                            <label for="presupuesto">Presupuesto Total (C$)</label>
                            <input type="number" step="0.01" id="presupuesto" name="presupuesto_total" placeholder="Ej. 150000.50" required>
                        </div>

                        <div class="form-group">
                            <label for="supervisor">Asignar Supervisor Principal</label>
                            <select name="id_supervisor" id="supervisor" required>
                                <option value="">-- Seleccione un supervisor --</option>
                                <%
                                    List<trabajadores> lista = (List<trabajadores>) request.getAttribute("ListaSupervisores");
                                    if (lista != null) {
                                        for (trabajadores t : lista) {
                                %>
                                <option value="<%= t.getId_trabajador()%>"><%= t.getFull_name()%></option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>

                        <button type="submit" class="btn-submit">Registrar Proyecto</button>
                    </form>
                </div>
            </div>
        </section>
    </main>
</div>

</body>
</html>