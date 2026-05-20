<%-- 
    Document   : ActualizarUsu
    Created on : 16 feb 2026, 5:22:05 p.m.
    Author     : Benja
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Usuarios"%>
<%@page import="model.trabajadores"%>
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
    <title>Actualizar Usuario | VyGApps</title>
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/ActualizarUsu.css">
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
            <a href="VerUsuarios" class="nav-item active" style="background-color: #2c3e50;"><span>Gestión de Usuarios</span></a>
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
                    <h2>Actualizar Usuario</h2>
                    <p class="subtitle">Seleccione el usuario y modifique la información</p>

                    <form action="ActualizarUsuario" method="POST">
                        <div class="form-group">
                            <label>Seleccionar Usuario</label>
                            <select name="id_usuario" required>
                                <option value="">Seleccione un usuario</option>
                                <%
                                    List<Usuarios> listaUsuarios = (List<Usuarios>) request.getAttribute("ListaUsuarios");
                                    if (listaUsuarios != null) {
                                        for (Usuarios u : listaUsuarios) {
                                %>
                                <option value="<%=u.getId_user()%>"><%=u.getUser_name() %></option>
                                <%      }
                                    } 
                                %>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Nombre de usuario</label>
                            <input type="text" name="user_name" required>
                        </div>

                        <div class="form-group">
                            <label>Nueva contraseña</label>
                            <input type="password" name="pass" required>
                        </div>

                        <div class="form-group">
                            <label>Rol del sistema</label>
                            <select name="rol" id="rolSelect" required>
                                <option value="">Seleccione un rol</option>
                                <option value="Administrador">Administrador</option>
                                <option value="Supervisor">Supervisor</option>
                                <option value="Trabajador">Trabajador</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Asignar a trabajador</label>
                            <select name="id_trabajador">
                                <option value="">Sin asignar</option>
                                <%
                                    List<trabajadores> listaTrab = (List<trabajadores>) request.getAttribute("ListaT");
                                    if (listaTrab != null) {
                                        for (trabajadores t : listaTrab) {
                                %>
                                <option value="<%= t.getId_trabajador()%>"><%= t.getFull_name()%></option>
                                <%      }
                                    } 
                                %>
                            </select>
                        </div>

                        <button type="submit" class="btn-submit">Actualizar Usuario</button>
                    </form>
                </div>
            </div>
        </section>
    </main>
</div>

<script>
    const rolSelect = document.getElementById("rolSelect");
    rolSelect.addEventListener("change", function () {
        this.classList.remove("admin-color", "supervisor-color", "trabajador-color");
        if (this.value === "Administrador") this.classList.add("admin-color");
        else if (this.value === "Supervisor") this.classList.add("supervisor-color");
        else if (this.value === "Trabajador") this.classList.add("trabajador-color");
    });
</script>
</body>
</html>