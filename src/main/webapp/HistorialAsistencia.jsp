<%-- 
    Document   : HistorialAsistencia
    Created on : 15 mar 2026
    Author     : Benja
--%>
<%@page import="java.sql.Time"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="DTO.AsistenciaDTO"%> 
<%@page import="model.Usuarios"%>

<%
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
    
    if (user == null || !user.getRol().equalsIgnoreCase("Trabajador")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Historial de Asistencia | Kronos Industrial</title>
    
    <link rel="stylesheet" href="CSS/Empleados.css">
    <link rel="stylesheet" href="CSS/HistorialAsistencia.css">
    <script src="JS/menu-movil.js" defer></script>
    <link rel="icon" href="images/KronosIndustrial.svg" type="image/svg+xml">
</head>
<body>

    <div class="admin-container">
        
        <div class="overlay" id="sidebarOverlay"></div>

        <aside class="sidebar" id="sidebar">
            <div class="sidebar-header">
                <img src="images/KronosIndustrial.svg" alt="Logo Kronos Industrial" class="logo-img">
                <h2 style="font-size: 18px;">Kronos Industrial</h2>
            </div>
            <nav>
                <a href="Home" class="menu-item"> 
                    <svg class="menu-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                    Mi Perfil
                </a>
                <a href="HistorialAsistenciaSv" class="menu-item active">
                    <svg class="menu-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                    Asistencia
                </a>
                <a href="MisPagosSv" class="menu-item">
                    <svg class="menu-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"></line><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path></svg>
                    Mis Pagos
                </a>
                <a href="ProyectosTrabajador" class="menu-item">
                    <svg class="menu-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path></svg>
                    Proyectos
                </a>
            </nav>
        </aside>

        <main class="main-content">
            
            <header class="header">
                <div class="header-left" style="display: flex; align-items: center; gap: 15px;">
                    <button id="menu-toggle" class="mobile-menu-btn">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="3" y1="12" x2="21" y2="12"></line><line x1="3" y1="6" x2="21" y2="6"></line><line x1="3" y1="18" x2="21" y2="18"></line></svg>
                    </button>
                    <div class="header-title">
                        <h1>Registro de Asistencia</h1>
                        <span>Historial de tus entradas y salidas en el sistema.</span>
                    </div>
                </div>
            </header>

            <div class="page-wrapper">
                <div class="card attendance-card" style="overflow-x: auto;">
                    
                    <div class="table-responsive">
                        <table class="vyg-table" style="min-width: 500px;">
                            <thead>
                                <tr>
                                    <th>Fecha</th>
                                    <th>Hora de Entrada</th>
                                    <th>Hora de Salida</th>
                                    <th>Observaciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    // Cambiamos el casteo a AsistenciaDTO para poder usar los datos avanzados
                                    List<AsistenciaDTO> listaAsistencia = (List<AsistenciaDTO>) request.getAttribute("ListaAsistencia");

                                    if (listaAsistencia != null && !listaAsistencia.isEmpty()) {
                                        for (AsistenciaDTO a : listaAsistencia) {
                                %>
                                <tr>
                                    <td><strong><%= a.getFecha() != null ? a.getFecha() : "Sin fecha" %></strong></td>
                                    
                                    <td class="time-in">
                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" style="vertical-align: middle; margin-right: 5px;"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                                        <%= a.getHoraEntrada() != null ? a.getHoraEntrada() : "--:--" %>
                                    </td>
                                    
                                    <td class="time-out">
                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" style="vertical-align: middle; margin-right: 5px;"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="16"></line><line x1="8" y1="12" x2="16" y2="12"></line></svg>
                                        <%= a.getHoraSalida() != null ? a.getHoraSalida() : "<span style='color:#7f8c8d; font-size:12px; font-weight:normal;'>En turno</span>" %>
                                    </td>
                                    
                                    <td class="observation-cell">
                                        <!-- 1. Etiqueta de Llegada -->
                                        <% if(a.getEstado_turno() != null && a.getEstado_turno().equals("Llegada Tardía")) { %>
                                            <span class="status-badge badge-warning">
                                                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                                                Llegada Tardía
                                            </span>
                                        <% } else { %>
                                            <span class="status-badge badge-success">
                                                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                                                A Tiempo
                                            </span>
                                        <% } %>

                                        <!-- 2. Etiqueta de Horas Extras -->
                                        <% if(a.getHorasExtras() > 0) { %>
                                            <span class="status-badge badge-info">
                                                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon></svg>
                                                <%= a.getHorasExtras() %> Hrs Extras
                                            </span>
                                        <% } %>

                                        <!-- 3. Etiqueta de Salida Temprana / Anómala -->
                                        <% if(a.getMarcaAnomala() == 1) { %>
                                            <span class="status-badge badge-danger">
                                                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path><line x1="12" y1="9" x2="12" y2="13"></line><line x1="12" y1="17" x2="12.01" y2="17"></line></svg>
                                                Salida Temprana
                                            </span>
                                        <% } %>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="4" class="empty-message">No tienes registros de asistencia todavía.</td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>

                </div>
            </div>
        </main>
    </div>

</body>
</html>