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
                <span class="icon">&#128202;</span>
                <span>Dashboard</span>
            </a>
            <a href="AsistenciaGlobal" class="nav-item active">
                <span class="icon">&#128197;</span>
                <span>Asistencias</span>
            </a>
            <a href="LogoutSv" class="nav-item logout-link">
                <span class="icon">&#128682;</span>
                <span>Cerrar Sesión</span>
            </a>
        </nav>
    </aside>

    <main class="main-content">

        <header class="topbar">
            <div class="header-left">
                <button id="menu-toggle" class="mobile-menu-btn">&#9776;</button>
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
                    <span class="search-icon">&#128269;</span>
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
                                        &#128065; Ver Detalle
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