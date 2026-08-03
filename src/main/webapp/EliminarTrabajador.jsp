<%-- 
    Document   : EliminarTrabajador
    Created on : 18 feb 2026, 6:47:06 p.m.
    Author     : Benja
--%>
<%@page import="model.trabajadores"%>
<%@page import="java.util.List"%>
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
    <title>Eliminar Trabajador | VyGApps</title>
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/EliminarTrabajadores.css">
    <script src="JS/menu-movil.js" defer></script>
    <link rel="icon" href="images/vyg.svg" type="image/png">

    <!-- Lucide Icons CDN -->
    <script src="JS/lucide.min.js"></script>
</head>
<body>

<div class="admin-container">
    <div class="overlay" id="sidebarOverlay"></div>

    <aside class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <img src="images/vyg.svg" alt="VyG Logo" class="sidebar-logo">
            <div class="brand-text">
                <h2 style="font-size: 18px;">VyGApps</h2>
                <span class="panel-badge" style="background: #FDE8E8; color: #991B1B;"><%= usuarioLogeado.getRol() %></span>
            </div>
        </div>
        <nav class="sidebar-nav">
            <a href="AdminPage.jsp" class="nav-item"><span>Dashboard Maestro</span></a>
            <a href="ReporteTrabajadoresSv" class="nav-item active" style="background-color: #121216;"><span>Reporte Trabajadores</span></a>
            <a href="LogoutSv" class="nav-item logout-link"><span>Cerrar Sesión</span></a>
        </nav>
    </aside>

    <main class="main-content">
        <header class="topbar">
            <div class="header-left">
                <button id="menu-toggle" class="mobile-menu-btn"><i data-lucide="menu" style="width: 24px; height: 24px"></i></button>
            </div>
            <div class="profile-menu">
                <div class="profile-info">
                    <span class="profile-name"><%= usuarioLogeado.getUser_name() %></span>
                    <span class="profile-role"><%= usuarioLogeado.getRol() %></span>
                </div>
                <img src="images/usuario.png" class="profile-img" alt="Perfil">
            </div>
        </header>

        <section class="dashboard">
            <div class="form-container">
                <div class="delete-container">
                    <h2>Eliminar Trabajador</h2>
                    <p class="warning-text">Esta acción es permanente y no se puede deshacer.</p>

                    <%
                        String mensaje = (String) request.getAttribute("mensaje");
                        String tipo = (String) request.getAttribute("tipo");
                        if (mensaje != null) {
                    %>
                    <div class="alert <%= tipo%>">
                        <%= mensaje%>
                    </div>
                    <% } %>

                    <form action="EliminarTrabajadores" method="post">
                        <label for="trabajador">Seleccionar Trabajador</label>
                        <select name="id_trabajador" id="trabajador" required>
                            <option value="">-- Seleccione un trabajador --</option>
                            <%
                                List<trabajadores> listaTrabajadores = (List<trabajadores>) request.getAttribute("ListaT");
                                if(listaTrabajadores != null) {
                                    for (trabajadores t : listaTrabajadores) {
                            %>
                            <option value="<%=t.getId_trabajador()%>"><%=t.getFull_name()%></option>
                            <%      }
                                } 
                            %>
                        </select>

                        <button type="submit" class="btn-delete" onclick="return confirm('¿Confirma la eliminación definitiva de este trabajador?');">
                            Eliminar Trabajador
                        </button>
                    </form>
                </div>
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
