<%-- 
    Document   : HistorialCamiones
    Created on : 4 mar 2026, 6:30:33 p.m.
    Author     : Benja
--%>

<%@page import="DTO.HistorialCamionesDTO"%>
<%@page import="model.camiones"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="java.util.List"%>
<%@page import="model.Usuarios"%>

<%
    /* Validación de sesión y restricción de acceso para el rol Supervisor */
    HttpSession sessionActual = request.getSession(false);
    Usuarios usuarioLogeado = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;

    if (usuarioLogeado == null) {
        response.sendRedirect("login.jsp");
        return;
    } else if (!usuarioLogeado.getRol().equals("Supervisor")) {
        response.sendRedirect("AccDen.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historial de Camiones | Kronos Industrial</title>
    
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/HistorialCamiones.css">
    
    <script src="JS/menu-movil.js" defer></script>
    <script src="JS/buscadorCamiones.js" defer></script>
    <link rel="icon" href="images/KronosIndustrial.svg" type="image/png">

    <!-- Lucide Icons CDN -->
    <script src="JS/lucide.min.js"></script>
</head>
<body>

<div class="admin-container">
    <div class="overlay" id="sidebarOverlay"></div>

    <aside class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <img src="images/KronosIndustrial.svg" alt="Kronos Industrial Logo" class="sidebar-logo">
            <div class="brand-text">
                <h2 style="font-size: 18px;">Kronos Industrial</h2>
                <span class="panel-badge" style="background:#eafaf1; color:#27ae60;"><%= usuarioLogeado.getRol() %></span>
            </div>
        </div>
        <nav class="sidebar-nav">
            <a href="SupervisorPage" class="nav-item"><span>Dashboard Operativo</span></a>
            <a href="RegistrarCamionesSv" class="nav-item"><span>Registrar Camiones</span></a>
            <a href="HistorialCamiones" class="nav-item active"><span>Historial de Viajes</span></a>
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
                            <h2>Historial de Camiones</h2>
                            <p>Consulta todos los viajes de acarreo, materiales y fletes registrados.</p>
                        </div>
                        <div class="toolbar">
                            <input type="text" id="buscador" placeholder="Buscar viaje..." class="search-input">
                            <a href="RegistrarCamionesSv" class="btn-main">Registrar Viaje</a>
                        </div>
                    </div>

                    <div class="table-responsive">
                        <table class="vyg-table" id="tablaCamiones">
                            <thead>
                                <tr>
                                    <th>Viaje y Fecha</th>
                                    <th>Contexto Operativo</th>
                                    <th>Carga</th>
                                    <th>Ruta</th>
                                    <th>Horario</th>
                                    <th>Costo Flete</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    List<HistorialCamionesDTO> listaCamiones = (List<HistorialCamionesDTO>) request.getAttribute("ListaHC");
                                    if(listaCamiones != null && !listaCamiones.isEmpty()) {
                                        for(HistorialCamionesDTO camion : listaCamiones) {
                                %>
                                <tr class="fila-dato">
                                    <td data-label="Viaje y Fecha">
                                        <strong>#<%= camion.getId_ruta() %></strong><br>
                                        <small class="text-muted">Fecha: <%= camion.getFecha() %></small>
                                    </td>
                                    
                                    <td data-label="Contexto Operativo">
                                        <strong><%= camion.getNombre_proyecto() %></strong><br>
                                        <small class="text-muted">Equipo: <%= camion.getTipo_maquina() %></small>
                                    </td>
                                    
                                    <td data-label="Carga">
                                        <%= camion.getNombre_material() %><br>
                                        <small class="text-muted"><%= camion.getCantidad_cargada() %> m³</small>
                                    </td>
                                    
                                    <td data-label="Ruta">
                                        <%= camion.getOrigen() %><br>
                                        <small class="text-muted">Destino: <%= camion.getDestino() %></small>
                                    </td>
                                    
                                    <td data-label="Horario">
                                        <%= camion.getHora_salida() %><br>
                                        <small class="text-muted">Llegada: <%= camion.getHora_entrada() %></small>
                                    </td>
                                    
                                    <td data-label="Costo Flete" class="text-financial">
                                        C$ <%= String.format("%,.2f", camion.getCosto_flete()) %>
                                    </td>
                                    
                                    <td data-label="Acciones">
                                        <a href="HistorialCamiones?accion=verDetalle&id=<%= camion.getId_ruta() %>" class="btn-icon" title="Ver Detalle"><i data-lucide="settings" style="width: 20px; height: 20px"></i></a>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="7" class="empty-message">
                                        No hay viajes de camiones registrados en el historial.
                                    </td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>

                    <div class="table-footer">
                        <a href="SupervisorPage" class="btn-cancel">Volver al Panel</a>
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
