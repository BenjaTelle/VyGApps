<%-- 
    Document   : VerUsuarios
    Created on : 20 feb 2026, 5:11:42 p.m.
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
                <span class="panel-badge" style="background:#fceceb; color:#c0392b;"><%= usuarioLogeado.getRol() %></span>
            </div>
        </div>
        <nav class="sidebar-nav">
            <a href="AdminPage.jsp" class="nav-item">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="9"></rect><rect x="14" y="3" width="7" height="5"></rect><rect x="14" y="12" width="7" height="9"></rect><rect x="3" y="16" width="7" height="5"></rect></svg>
                <span>Dashboard Maestro</span>
            </a>
            <a href="VerUsuarios" class="nav-item active" style="background-color: #2c3e50;">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                <span>Gestión de Usuarios</span>
            </a>
            <a href="LogoutSv" class="nav-item logout-link" style="margin-top: 15px;">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" y1="12" x2="9" y2="12"></line></svg>
                <span>Cerrar Sesión</span>
            </a>
        </nav>
    </aside>

    <main class="main-content">
        <header class="topbar">
            <div class="header-left">
                <button id="menu-toggle" class="mobile-menu-btn">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="3" y1="12" x2="21" y2="12"></line><line x1="3" y1="6" x2="21" y2="6"></line><line x1="3" y1="18" x2="21" y2="18"></line></svg>
                </button>
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
                <a href="RegistrarUsu" class="btn-action">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-right: 5px; vertical-align: middle;"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                    Crear Usuario
                </a>
                <a href="ActualizarUsuario" class="btn-action btn-outline">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-right: 5px; vertical-align: middle;"><polygon points="16 3 21 8 8 21 3 21 3 16 16 3"></polygon></svg>
                    Editar Usuario
                </a>
                <a href="EliminarUsu" class="btn-action btn-danger">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-right: 5px; vertical-align: middle;"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path><line x1="10" y1="11" x2="10" y2="17"></line><line x1="14" y1="11" x2="14" y2="17"></line></svg>
                    Eliminar Usuario
                </a>
            </div>
        </section>
    </main>
</div>

</body>
</html>