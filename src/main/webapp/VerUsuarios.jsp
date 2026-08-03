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
    <title>Lista de Usuarios | V&G Ingenieros</title>
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/VerUsuarios.css">
    <script src="JS/menu-movil.js" defer></script>
    <link rel="icon" href="images/vygLogo.svg" type="image/png">

    <!-- Lucide Icons CDN -->
    <script src="JS/lucide.min.js"></script>
</head>
<body>

<div class="admin-container">
    <div class="overlay" id="sidebarOverlay"></div>

    <aside class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <img src="images/vygLogo.svg" alt="V&G Ingenieros Logo" class="sidebar-logo">
            <div class="brand-text">
                <h2 style="font-size: 18px;">V&G Ingenieros</h2>
                <span class="panel-badge"><%= usuarioLogeado.getRol() %></span>
            </div>
        </div>
        <nav class="sidebar-nav">
            <a href="AdminPage.jsp" class="nav-item">
                <i data-lucide="layout-dashboard" style="width: 20px; height: 20px"></i>
                <span>Dashboard Maestro</span>
            </a>
            <a href="VerUsuarios" class="nav-item active" style="background-color: #121216;">
                <i data-lucide="users" style="width: 20px; height: 20px"></i>
                <span>Gestión de Usuarios</span>
            </a>
            <a href="LogoutSv" class="nav-item logout-link" style="margin-top: 15px;">
                <i data-lucide="log-out" style="width: 20px; height: 20px"></i>
                <span>Cerrar Sesión</span>
            </a>
        </nav>
    </aside>

    <main class="main-content">
        <header class="topbar">
            <div class="header-left">
                <button id="menu-toggle" class="mobile-menu-btn">
                    <i data-lucide="menu" style="width: 24px; height: 24px"></i>
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
                    <i data-lucide="plus" style="margin-right: 5px; vertical-align: middle; width: 18px; height: 18px"></i>
                    Crear Usuario
                </a>
                <a href="ActualizarUsuario" class="btn-action btn-outline">
                    <i data-lucide="pencil" style="margin-right: 5px; vertical-align: middle; width: 18px; height: 18px"></i>
                    Editar Usuario
                </a>
                <a href="EliminarUsu" class="btn-action btn-danger">
                    <i data-lucide="trash-2" style="margin-right: 5px; vertical-align: middle; width: 18px; height: 18px"></i>
                    Eliminar Usuario
                </a>
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