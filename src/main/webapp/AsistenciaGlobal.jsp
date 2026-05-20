<%-- 
    Document   : AsistenciaGlobal
    Created on : 31 mar 2026
    Author     : Benja
--%>
<%@page import="DTO.AsistenciaDTO"%>
<%@page import="java.sql.Time"%>
<%@page import="java.util.List"%>
<%@page import="model.Usuarios"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // --- LÓGICA DE SEGURIDAD ---
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
    <title>Control Global de Asistencia | VyGApps</title>
    
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/AsistenciaGlobal.css">
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
                <span class="icon">📊</span>
                <span>Dashboard</span>
            </a>
            <a href="AsistenciaGlobal" class="nav-item active">
                <span class="icon">📅</span>
                <span>Asistencias</span>
            </a>
            <a href="LogoutSv" class="nav-item logout-link">
                <span class="icon">🚪</span>
                <span>Cerrar Sesión</span>
            </a>
        </nav>
    </aside>

    <main class="main-content">

        <header class="topbar">
            <div class="header-left">
                <button id="menu-toggle" class="mobile-menu-btn">☰</button>
                <div class="welcome">
                    <h1>Control Global de Asistencia</h1>
                    <span>Historial de entradas y salidas del personal activo.</span>
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

            <div class="attendance-card">
                
                <div class="card-header">
                    <h2>📋 Registro de Asistencias</h2>
                </div>

                <div class="table-responsive">
                    <table class="vyg-table">
                        <thead>
                            <tr>
                                <th>Trabajador</th>
                                <th>Fecha</th>
                                <th>Hora de Entrada</th>
                                <th>Hora de Salida</th>
                                <th>Estado del Turno</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<AsistenciaDTO> listaAsistencia = (List<AsistenciaDTO>) request.getAttribute("ListaAsistenciaGlobal");

                                if (listaAsistencia != null && !listaAsistencia.isEmpty()) {
                                    for (AsistenciaDTO a : listaAsistencia) {
                                        
                                        // --- LÓGICA DE LLEGADA TARDÍA ---
                                        boolean llegadaTardia = false;
                                        Time horaEntrada = a.getHoraEntrada();
                                        
                                        if (horaEntrada != null) {
                                            String horaString = horaEntrada.toString();
                                            if (horaString.compareTo("08:00:00") > 0) {
                                                llegadaTardia = true;
                                            }
                                        }
                            %>
                            <tr>
                                <td data-label="Trabajador" class="worker-name">
                                    <strong><%= a.getNombreTrabajador() != null ? a.getNombreTrabajador() : "Desconocido" %></strong>
                                </td>
                                
                                <td data-label="Fecha">
                                    <%= a.getFecha() != null ? a.getFecha() : "Sin fecha" %>
                                </td>
                                
                                <td data-label="Entrada" class="time-in">
                                    🟢 <%= a.getHoraEntrada()!= null ? a.getHoraEntrada(): "--:--" %>
                                </td>
                                
                                <td data-label="Salida" class="time-out">
                                    🔴 <%= a.getHoraSalida()!= null ? a.getHoraSalida(): "<span style='color:var(--text-muted); font-size:13px; font-weight:normal;'>En turno</span>" %>
                                </td>
                                
                                <td data-label="Estado">
                                    <% if(llegadaTardia) { %>
                                        <span class="badge-warning">⚠️ Llegada Tardía</span>
                                    <% } else { %>
                                        <span class="badge-ok">✔️ A tiempo</span>
                                    <% } %>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="5" class="empty-cell">No hay registros de asistencia en el sistema todavía.</td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>

                <div class="card-footer">
                    <a href="SupervisorPage" class="btn-back">⬅️ Volver al Panel</a>
                </div>

            </div>

        </section>

    </main>
</div>

</body>
</html>