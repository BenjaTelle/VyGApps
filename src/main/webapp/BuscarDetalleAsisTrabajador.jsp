<%-- 
    Document   : BuscarDetalleAsisTrabajador
    Created on : 31 mar 2026
    Author     : Benja
--%>
<%@page import="model.trabajadores"%>
<%@page import="java.util.List"%>
<%@page import="model.Usuarios"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;

    if (user == null || (!user.getRol().equalsIgnoreCase("Supervisor") && !user.getRol().equalsIgnoreCase("Administrador"))) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Directorio de Trabajadores | VyGApps</title>

    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/BuscarDetalleAsisTrabajador.css"> 
    <script src="JS/menu-movil.js" defer></script>
    <link rel="icon" href="images/vyg.svg" type="image/svg+xml">
</head>
<body>

<div class="admin-container">

    <div class="overlay" id="sidebarOverlay"></div>

    <aside class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <img src="images/vyg.svg" alt="VyG Logo" class="sidebar-logo">
            <div class="brand-text">
                <h2>VyGApps</h2>
                <span class="panel-badge"><%= user.getRol() %></span>
            </div>
        </div>

        <nav class="sidebar-nav">
            <a href="SupervisorPage" class="nav-item">
                <span class="icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="20" x2="18" y2="10"></line><line x1="12" y1="20" x2="12" y2="4"></line><line x1="6" y1="20" x2="6" y2="14"></line></svg></span>
                <span>Dashboard</span>
            </a>
            <a href="AsistenciaGlobal" class="nav-item active">
                <span class="icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg></span>
                <span>Asistencias</span>
            </a>
            <a href="LogoutSv" class="nav-item logout-link">
                <span class="icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" y1="12" x2="9" y2="12"></line></svg></span>
                <span>Cerrar Sesión</span>
            </a>
        </nav>
    </aside>

    <main class="main-content">

        <header class="topbar">
            <div class="header-left">
                <button id="menu-toggle" class="mobile-menu-btn"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="3" y1="12" x2="21" y2="12"></line><line x1="3" y1="6" x2="21" y2="6"></line><line x1="3" y1="18" x2="21" y2="18"></line></svg></button>
                <div class="welcome">
                    <h1>Directorio del Personal</h1>
                    <span>Busca y selecciona un trabajador para ver su historial.</span>
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

            <div class="directory-card">
                
                <div class="search-container">
                    <span class="search-icon"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg></span>
                    <input type="text" id="buscador" placeholder="Buscar por nombre o puesto...">
                </div>

                <div class="table-responsive">
                    <table class="vyg-table" id="tablaTrabajadores">
                        <thead>
                            <tr>
                                <th>Nombre Completo</th>
                                <th>Puesto Asignado</th>
                                <th style="text-align: center;">Acción</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%                            
                                List<trabajadores> listaTrabajadores = (List<trabajadores>) request.getAttribute("ListaTrabajadores");
                                if (listaTrabajadores != null && !listaTrabajadores.isEmpty()) {
                                    for (trabajadores t : listaTrabajadores) {
                            %>
                            <tr>
                                <td data-label="Nombre"><strong><%= t.getFull_name()%></strong></td>
                                <td data-label="Puesto" class="puesto-text"><%= t.getPuesto()%></td>
                                <td data-label="Acción" style="text-align: center;">
                                    <a href="DetalleAsistenciaTrabajador?id_trabajador=<%= t.getId_trabajador()%>" class="btn-view" title="Ver Detalle de Asistencia">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="display:inline-block; vertical-align:middle; margin-right:4px;"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>Ver Detalle
                                    </a>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="3" class="empty-cell">No hay trabajadores registrados en el sistema.</td>
                            </tr>
                            <%                            
                                }
                            %>
                        </tbody>
                    </table>
                </div>

                <div class="card-footer">
                    <a href="SupervisorPage" class="btn-back">&#11013; Volver al Panel</a>
                </div>

            </div>

        </section>

    </main>
</div>

<script>
    document.getElementById("buscador").addEventListener("keyup", function () {
        let texto = this.value.toLowerCase();
        let filas = document.querySelectorAll("#tablaTrabajadores tbody tr");

        filas.forEach(function (fila) {
            let contenido = fila.textContent.toLowerCase();
            if (contenido.includes(texto)) {
                fila.style.display = "";
            } else {
                fila.style.display = "none";
            }
        });
    });
</script>

</body>
</html>