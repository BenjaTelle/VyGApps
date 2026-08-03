<%-- 
    Document   : HistorialUso
    Created on : 4 mar 2026
    Author     : Benja
--%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="java.util.List"%>
<%@page import="DTO.HistorialUsoDTO"%>
<%@page import="model.Usuarios"%>

<%
    /* Validación de sesión y seguridad para el rol Supervisor */
    HttpSession sessionActual = request.getSession(false);
    Usuarios usuarioLogeado = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;

    if (usuarioLogeado == null) {
        response.sendRedirect("login.jsp");
        return;
    } 

    if (!usuarioLogeado.getRol().equals("Supervisor")) {
        response.sendRedirect("AccDen.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historial de Uso de Maquinaria | VyGApps</title>
    
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/HistorialUso.css">
    <script src="JS/menu-movil.js" defer></script>
    <script src="JS/buscadorUso.js" defer></script>
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
                <span class="panel-badge" style="background:#eafaf1; color:#27ae60;"><%= usuarioLogeado.getRol() %></span>
            </div>
        </div>
        <nav class="sidebar-nav">
            <a href="SupervisorPage" class="nav-item"><span>Dashboard Operativo</span></a>
            <a href="RegistrarUso" class="nav-item"><span>Registrar Maquinaria</span></a>
            <a href="HistorialUso" class="nav-item active"><span>Historial de Uso</span></a>
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
            <div class="table-wrapper">
                <div class="card table-card">
                    
                    <div class="table-header">
                        <div>
                            <h2><i data-lucide="briefcase" style="width: 20px; height: 20px"></i> Historial de Uso de Maquinaria</h2>
                            <p>Consulta todos los registros operativos y costos totales calculados.</p>
                        </div>
                        <div class="toolbar">
                            <input type="text" id="buscador" placeholder="Ej. CAT 320, Obra Central, Juan..." class="search-input">
                            <a href="RegistrarUso" class="btn-main"><i data-lucide="plus" style="display:inline-block; vertical-align:middle; margin-right:4px; width: 14px; height: 14px"></i>Registrar Nuevo Uso</a>
                        </div>
                    </div>

                    <div class="table-responsive">
                        <table class="vyg-table" id="tablaUso">
                            <thead>
                                <tr>
                                    <th>ID Registro</th>
                                    <th>Fecha</th>
                                    <th>Horario (Inicio - Fin)</th>
                                    <th>Proyecto</th>
                                    <th>Máquina</th>
                                    <th>Operador</th>
                                    <th>Costo/Hora (C$)</th>
                                    <th>Combustible (Gal)</th>
                                    <th>Costo Total (C$)</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<HistorialUsoDTO> listaUsos = (List<HistorialUsoDTO>) request.getAttribute("ListaHistorial");
                                    
                                    if (listaUsos != null && !listaUsos.isEmpty()) {
                                        for (HistorialUsoDTO uso : listaUsos) {
                                %>
                                <tr class="fila-dato">
                                    <td data-label="ID Registro"><strong>#<%= uso.getIdUso() %></strong></td>
                                    <td data-label="Fecha"><%= uso.getFecha() %></td>
                                    <td data-label="Horario (Inicio - Fin)"><%= uso.getHoraInicio() %> a <%= uso.getHoraFin() %></td>
                                    <td data-label="Proyecto"><%= uso.getNombreProyecto() %></td>
                                    <td data-label="Máquina"><%= uso.getNombreMaquina() %></td>
                                    <td data-label="Operador"><%= uso.getNombreTrabajador() %></td>
                                    <td data-label="Costo/Hora (C$)" style="color: #1B365D; font-weight: bold;">C$ <%= String.format("%,.2f", uso.getCostoPorHora()) %></td>
                                    <td data-label="Combustible (Gal)"><%= uso.getGalonesCombustible() %> Gal.</td>
                                    <td data-label="Costo Total (C$)" class="text-financial" style="color: #27ae60; font-weight: bold;">C$ <%= String.format("%,.2f", uso.getCostoTotal()) %></td>
                                    <td data-label="Acciones">
                                        <a href="DetalleUsoSv?id=<%= uso.getIdUso() %>" class="btn-icon" title="Ver Detalle"><i data-lucide="settings" style="width: 20px; height: 20px"></i></a>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="10" class="empty-message">
                                        No hay registros de uso de maquinaria en el historial.
                                    </td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>

                    <div class="table-footer">
                        <a href="SupervisorPage" class="btn-cancel"><i data-lucide="arrow-left" style="width: 20px; height: 20px"></i> Volver al Panel</a>
                    </div>

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
