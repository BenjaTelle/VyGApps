<%-- 
    Document   : DetalleAsistenciaTrabajador
    Created on : [Fecha Actual]
    Author     : Benja
--%>
<%@page import="java.util.List"%>
<%@page import="DTO.AsistenciaDTO"%> 
<%@page import="DTO.ResumenAsistenciaDTO"%> 
<%@page import="model.Usuarios"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Lógica de seguridad
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
    
    if (user == null || (!user.getRol().equalsIgnoreCase("Supervisor") && !user.getRol().equalsIgnoreCase("Administrador"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    ResumenAsistenciaDTO resumen = (ResumenAsistenciaDTO) request.getAttribute("DetalleAsistencia");
    List<AsistenciaDTO> historial = (List<AsistenciaDTO>) request.getAttribute("HistorialAsistencia");
    
    if(resumen == null) {
        response.sendRedirect("AsistenciaGlobal.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalle de Asistencia | <%= resumen.getNombreCompleto() %></title>
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/DetalleAsistencia.css">
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
                <span class="panel-badge">Supervisor</span>
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
                    <h1>Detalle de Asistencia</h1>
                    <span>Reporte individual del trabajador.</span>
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

        <div class="worker-profile-header">
            <div class="profile-info-text">
                <h2>👤 <%= resumen.getNombreCompleto() %></h2>
                <p><strong>Cédula:</strong> <%= resumen.getCedula() %> | <strong>Puesto:</strong> <%= resumen.getPuesto() %></p>
                <p><strong>Proyecto Actual:</strong> 🏗️ <%= resumen.getNombreProyecto() %></p>
            </div>
            <button onclick="window.print()" class="btn-print">🖨️ Imprimir Reporte</button>
        </div>

        <div class="kpi-grid">
            <div class="kpi-card">
                <span class="kpi-icon">📅</span>
                <div class="kpi-data">
                    <h3><%= resumen.getTotalDiasTrabajados() %></h3>
                    <p>Días Trabajados</p>
                </div>
            </div>
            <div class="kpi-card">
                <span class="kpi-icon">⚠️</span>
                <div class="kpi-data">
                    <h3 style="color: #d35400;"><%= resumen.getTotalLlegadasTardias() %></h3>
                    <p>Llegadas Tardías</p>
                </div>
            </div>
            <div class="kpi-card">
                <span class="kpi-icon">⭐</span>
                <div class="kpi-data">
                    <h3 style="color: #27ae60;"><%= resumen.getPorcentajePuntualidad() %>%</h3>
                    <p>Nivel de Puntualidad</p>
                </div>
            </div>
            <div class="kpi-card">
                <span class="kpi-icon">⏱️</span>
                <div class="kpi-data">
                    <h3><%= resumen.getHorasPromedioPorDia() != null ? resumen.getHorasPromedioPorDia() : "0h" %></h3>
                    <p>Promedio Diario</p>
                </div>
            </div>
        </div>

        <div class="card attendance-card">
            <div class="card-header" style="padding: 20px 30px; border-bottom: 1px solid #eee;">
                <h2 style="font-size: 18px; color: var(--primary-color);">📑 Historial Detallado</h2>
            </div>

            <div class="table-responsive">
                <table class="vyg-table">
                    <thead>
                        <tr>
                            <th>Fecha</th>
                            <th>Hora de Entrada</th>
                            <th>Hora de Salida</th>
                            <th>Estado del Turno</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (historial != null && !historial.isEmpty()) {
                                for (AsistenciaDTO a : historial) {
                        %>
                        <tr>
                            <td data-label="Fecha"><strong><%= a.getFecha() %></strong></td>
                            <td data-label="Hora de Entrada" class="time-in">🟢 <%= a.getHoraEntrada()%></td>
                            <td data-label="Hora de Salida" class="time-out">🔴 <%= a.getHoraSalida()!= null ? a.getHoraSalida(): "En turno" %></td>
                            <td data-label="Estado del Turno">
                                <% if(a.getEstado_turno()!= null && a.getEstado_turno().equals("Llegada Tardía")) { %>
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
                            <td colspan="4" class="empty-cell" style="text-align: center; padding: 30px; color: #7f8c8d;">
                                No hay registros para este trabajador.
                            </td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
            
            <div class="card-footer">
                <a href="BuscarDetalleAsis" class="btn-back">⬅️ Volver al listado </a>
            </div>
        </div>

    </main>
</div>

</body>
</html>