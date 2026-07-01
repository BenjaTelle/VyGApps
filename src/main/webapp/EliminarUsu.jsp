<%-- 
    Document   : EliminarUsu
    Created on : 16 feb 2026, 9:16:04 p.m.
    Author     : Benja
--%>
<%@page import="java.util.List"%>
<%@page import="Repository.UsuarioDAO"%>
<%@page import="model.Usuarios"%>
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
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Eliminar Usuario | VyGApps</title>
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/EliminarUsu.css">
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
                <span class="panel-badge" style="background:#fceceb; color:#c0392b;"><%= usuarioLogeado.getRol() %></span>
            </div>
        </div>
        <nav class="sidebar-nav">
            <a href="AdminPage.jsp" class="nav-item"><span>Dashboard Maestro</span></a>
            <a href="VerUsuarios" class="nav-item active" style="background-color: #2c3e50;"><span>Gestión de Usuarios</span></a>
            <a href="LogoutSv" class="nav-item logout-link"><span>Cerrar Sesión</span></a>
        </nav>
    </aside>

    <main class="main-content">
        <header class="topbar">
            <div class="header-left">
                <button id="menu-toggle" class="mobile-menu-btn"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="3" y1="12" x2="21" y2="12"></line><line x1="3" y1="6" x2="21" y2="6"></line><line x1="3" y1="18" x2="21" y2="18"></line></svg></button>
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
                    <h2>Eliminar Usuario</h2>
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

                    <form action="EliminarUsu" method="post">
                        <label for="usuario">Seleccionar Usuario</label>
                        <select name="id_user" id="usuario" required>
                            <option value="">-- Seleccione un usuario --</option>
                            <%
                                List<Usuarios> ListaU = (List<Usuarios>) request.getAttribute("ListaUsuarios");
                                if(ListaU != null) {
                                    for (Usuarios u : ListaU) {
                            %>
                            <option value="<%=u.getId_user()%>"><%=u.getUser_name()%></option>
                            <%      }
                                } 
                            %>
                        </select>

                        <button type="submit" class="btn-delete" onclick="return confirm('¿Confirma la eliminación definitiva?');">
                            Eliminar Usuario
                        </button>
                    </form>
                </div>
            </div>
        </section>
    </main>
</div>

</body>
</html>
