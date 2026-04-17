<%-- 
    Document   : BandejaAutorizacion
    Created on : 2 abr 2026, 7:35:58 p.m.
    Author     : Benja
--%>

<%@page import="java.util.List"%>
<%@page import="DTO.PlanillaPendienteDTO"%> 
<%@page import="model.Usuarios"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Seguridad: Supervisores y Administradores
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
    
    if (user == null || (!user.getRol().equalsIgnoreCase("Supervisor") && !user.getRol().equalsIgnoreCase("Administrador"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<PlanillaPendienteDTO> listaPlanillas = (List<PlanillaPendienteDTO>) request.getAttribute("ListaPlanillas");
    String mensaje = request.getParameter("msg");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Bandeja de Autorización | VyGApps</title>
    <link rel="stylesheet" href="CSS/HistorialAsistencia.css">
    <link rel="stylesheet" href="CSS/BandejaAutorizacion.css">
    <link rel="icon" href="images/vyg.svg" type="image/svg+xml">
</head>
<body>

    <div class="page-wrapper" style="max-width: 1000px;">
        
        <div class="worker-profile-header supervisor-header">
            <div class="profile-info">
                <h2>✅ Bandeja de Autorización de Pagos</h2>
                <p>Revisa y aprueba las planillas generadas para tu equipo. Asegúrate de tener fondos suficientes.</p>
            </div>
        </div>

        <% if ("exito".equals(mensaje)) { %>
            <div class="alert-box alert-success">
                <span>✔️</span> Planilla autorizada. Fondos descontados del proyecto.
            </div>
        <% } else if ("sin_fondos".equals(mensaje)) { %>
            <div class="alert-box alert-danger">
                <span>❌</span> <strong>Error:</strong> El proyecto no tiene fondos suficientes para cubrir esta planilla.
            </div>
        <% } else if ("error".equals(mensaje)) { %>
            <div class="alert-box alert-danger">
                <span>⚠️</span> Ocurrió un error al intentar autorizar la planilla.
            </div>
        <% } %>

        <div class="card table-card">
            <div class="card-header">
                <h3>📋 Planillas Pendientes de Aprobación</h3>
            </div>
            
            <div class="table-responsive">
                <table class="vyg-table">
                    <thead>
                        <tr>
                            <th>Trabajador</th>
                            <th>Proyecto</th>
                            <th>Periodo</th>
                            <th>Días Trab.</th>
                            <th>Monto a Pagar</th>
                            <th style="text-align: center;">Acción</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            if(listaPlanillas != null && !listaPlanillas.isEmpty()) {
                                for(PlanillaPendienteDTO p : listaPlanillas) { 
                        %>
                        <tr>
                            <td><strong><%= p.getNombreTrabajador() %></strong></td>
                            <td><%= p.getNombreProyecto() %></td>
                            <td><span class="badge-periodo"><%= p.getPeriodo() %></span></td>
                            <td style="text-align: center;"><%= p.getDiasTrabajados() %></td>
                            <td class="monto-destacado">C$ <%= String.format("%,.2f", p.getMontoPagado()) %></td>
                            <td style="text-align: center;">
                                <a href="AutorizarPagoSv?id_pago=<%= p.getIdPago() %>&id_proyecto=<%= p.getIdProyecto() %>&monto=<%= p.getMontoPagado() %>" 
                                   class="btn-autorizar" 
                                   onclick="return confirm('¿Confirma autorizar el pago por C$ <%= String.format("%,.2f", p.getMontoPagado()) %>? Se descontará del presupuesto.');">
                                   Aprobar Pago
                                </a>
                            </td>
                        </tr>
                        <% 
                                }
                            } else { 
                        %>
                        <tr>
                            <td colspan="6" class="empty-message">No tienes planillas pendientes de autorización en este momento.</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <div style="margin-top: 25px;">
            <% if (user.getRol().equalsIgnoreCase("Administrador")) { %>
                <a href="AdminFinanzas" class="btn-back">⬅️ Volver al Panel Financiero</a>
            <% } else { %>
                <a href="SupervisorPage" class="btn-back">⬅️ Volver a mi Panel</a>
            <% } %>
        </div>

    </div>

</body>
</html>