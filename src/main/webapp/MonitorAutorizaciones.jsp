<%-- 
    Document   : MonitorAutorizaciones
    Created on : 2 abr 2026, 7:11:50 p.m.
    Author     : Benja
--%>

<%@page import="java.util.List"%>
<%@page import="DTO.MonitorPendientesDTO"%> 
<%@page import="model.Usuarios"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Seguridad: Solo Administradores
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
    
    if (user == null || !user.getRol().equalsIgnoreCase("Administrador")) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Lista de pendientes enviada por el Servlet
    List<MonitorPendientesDTO> listaPendientes = (List<MonitorPendientesDTO>) request.getAttribute("ListaMonitor");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Monitor de Autorizaciones | VyGApps</title>
    <link rel="stylesheet" href="CSS/HistorialAsistencia.css">
    <link rel="stylesheet" href="CSS/AdminFinanzas.css"> 
    <link rel="stylesheet" href="CSS/MonitorAutorizaciones.css">
    <link rel="icon" href="images/vyg.svg" type="image/svg+xml">
</head>
<body>

    <div class="page-wrapper" style="max-width: 1100px;">
        
        <div class="worker-profile-header admin-header" style="background: linear-gradient(135deg, #2c3e50, #2980b9);">
            <div class="profile-info">
                <h2>👀 Monitor de Autorizaciones Pendientes</h2>
                <p>Seguimiento en tiempo real de planillas generadas que esperan aprobación de supervisores.</p>
            </div>
        </div>

        <div class="card monitor-card">
            <div class="card-header">
                <h3>🚦 Gestión de Pagos</h3>
                <p>Los registros en rojo indican retrasos superiores a 48 horas.</p>
            </div>
            
            <div class="table-responsive">
                <table class="vyg-table">
                    <thead>
                        <tr>
                            <th>Proyecto</th>
                            <th>Supervisor Responsable</th>
                            <th>Fecha Generación</th>
                            <th>Monto Total</th>
                            <th>Días de Retraso</th>
                            <th>Estado</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            if(listaPendientes != null && !listaPendientes.isEmpty()) {
                                for(MonitorPendientesDTO m : listaPendientes) { 
                                    String claseRetraso = (m.getDiasRetraso() >= 3) ? "retraso-critico" : (m.getDiasRetraso() >= 2 ? "retraso-medio" : "al-dia");
                        %>
                        <tr class="<%= claseRetraso %>">
                            <td><strong><%= m.getNombreProyecto() %></strong></td>
                            <td><%= m.getNombreSupervisor() %></td>
                            <td><%= m.getFechaGeneracion() %></td>
                            <td class="monto">C$ <%= String.format("%,.2f", m.getMontoTotal()) %></td>
                            <td style="text-align: center;">
                                <span class="dias-badge"><%= m.getDiasRetraso() %> días</span>
                            </td>
                            <td>
                                <span class="status-indicator">Pendiente</span>
                            </td>
                        </tr>
                        <% 
                                }
                            } else { 
                        %>
                        <tr>
                            <td colspan="6" class="empty-message">🎉 ¡Excelente! No hay autorizaciones pendientes de larga duración.</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <div style="margin-top: 25px;">
            <a href="AdminFinanzas" class="btn-back">⬅️ Volver al Panel Financiero</a>
        </div>

    </div>

</body>
</html>