<%-- 
    Document   : HistorialAsistencia
    Created on : 15 mar 2026
    Author     : Benja
--%>
<%@page import="java.sql.Time"%>
<%@page import="model.asistencia"%>
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
    <title>Mi Historial de Asistencia | VyGApps</title>
    
    <link rel="stylesheet" href="CSS/Empleados.css">
    <link rel="stylesheet" href="CSS/HistorialAsistencia.css">
    <script src="JS/menu-movil.js" defer></script>
    <link rel="icon" href="images/vyg.svg" type="image/png">
</head>
<body>

    <div class="admin-container">
        
        <div class="overlay" id="sidebarOverlay"></div>

        <aside class="sidebar" id="sidebar">
            <div class="sidebar-header">
                <img src="images/vyg.svg" alt="Logo VyG" class="logo-img">
                <h2>VyGApps</h2>
            </div>
            <nav>
                <a href="Home" class="menu-item"> 
                    <span class="menu-icon">👤</span> Mi Perfil
                </a>
                <a href="HistorialAsistenciaSv" class="menu-item active">
                    <span class="menu-icon">📅</span> Asistencia
                </a>
                <a href="MisPagosSv" class="menu-item">
                    <span class="menu-icon">💰</span> Mis Pagos
                </a>
                <a href="ProyectosTrabajador" class="menu-item">
                    <span class="menu-icon">📂</span> Proyectos
                </a>
            </nav>
        </aside>

        <main class="main-content">
            
            <header class="header">
                <div class="header-left" style="display: flex; align-items: center; gap: 15px;">
                    <button id="menu-toggle" class="mobile-menu-btn">☰</button>
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
                                    List<asistencia> listaAsistencia = (List<asistencia>) request.getAttribute("ListaAsistencia");

                                    if (listaAsistencia != null && !listaAsistencia.isEmpty()) {
                                        for (asistencia a : listaAsistencia) {
                                            
                                            boolean llegadaTardia = false;
                                            Time horaEntrada=  a.getHora_entrada(); 
                                            if (horaEntrada != null && horaEntrada.toString().compareTo("08:00:00") > 0) {
                                                llegadaTardia = true;
                                            }
                                %>
                                <tr>
                                    <td><strong><%= a.getFecha() != null ? a.getFecha() : "Sin fecha" %></strong></td>
                                    <td class="time-in">
                                        &#128308; <%= a.getHora_entrada() != null ? a.getHora_entrada() : "--:--" %>
                                    </td>
                                    <td class="time-out">
                                        &#128308; <%= a.getHora_salida() != null ? a.getHora_salida() : "<span style='color:#7f8c8d; font-size:12px;'>En turno</span>" %>
                                    </td>
                                    <td>
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