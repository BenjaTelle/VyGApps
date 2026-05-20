<%-- 
    Document   : VerUsuarios
    Created on : 20 feb 2026, 5:11:42 p.m.
    Author     : Benja
--%>
<%@page import="DTO.UsuarioDetalle"%>
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
    <title>Lista de Usuarios | VyGApps</title>
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/VerUsuarios.css">
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
            <div class="admin-header-banner">
                <div class="admin-header-info">
                    <h2>Usuarios del Sistema</h2>
                    <p>Listado general y control de cuentas registradas.</p>
                </div>
            </div>

            <div class="card result-card">
                <div class="card-header">
                    <h3>Cuentas de Acceso</h3>
                </div>
                
                <div class="table-responsive">
                    <table class="vyg-table">
                        <thead>
                            <tr>
                                <th>Usuario</th>
                                <th>Trabajador Asignado</th>
                                <th>Rol del Sistema</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<UsuarioDetalle> lista = (List<UsuarioDetalle>) request.getAttribute("ListaUsuariosDetalle");
                                if (lista != null && !lista.isEmpty()) {
                                    for (UsuarioDetalle ud : lista) {
                                        String claseRol = "";
                                        if (ud.getRol().equals("Trabajador")) claseRol = "rol-trabajador";
                                        else if (ud.getRol().equals("Supervisor")) claseRol = "rol-supervisor";
                                        else if (ud.getRol().equals("Administrador")) claseRol = "rol-admin";
                            %>
                            <tr>
                                <td data-label="Usuario"><strong><%= ud.getUsern_name()%></strong></td>
                                <td data-label="Trabajador"><%= ud.getTrabajadorAsign() %></td>
                                <td data-label="Rol">
                                    <span class="rol-badge <%= claseRol %>"><%= ud.getRol()%></span>
                                </td>
                            </tr>
                            <%      }
                                } else { 
                            %>
                            <tr>
                                <td colspan="3" class="empty-message">No hay usuarios registrados en la base de datos.</td>
                            </tr>
                            <%  } %>
                        </tbody>
                    </table>
                </div>
            </div>
            
            <div class="actions-footer">
                <a href="RegistrarUsu.jsp" class="btn-action">Crear Usuario</a>
                <a href="ActualizarUsu.jsp" class="btn-action btn-outline">Editar Usuario</a>
                <a href="EliminarUsu" class="btn-action btn-danger">Eliminar Usuario</a>
            </div>
        </section>
    </main>
</div>

</body>
</html>