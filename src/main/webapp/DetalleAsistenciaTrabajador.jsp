<%-- 
    Document   : DetalleAsistenciaTrabajador
    Created on : 31 mar 2026, 6:19:21 p.m.
    Author     : Benja
--%>
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
    // Lógica de seguridad (Solo Supervisores o Admins)
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
    
    if (user == null || (!user.getRol().equalsIgnoreCase("Supervisor") && !user.getRol().equalsIgnoreCase("Administrador"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Recibimos los dos paquetes de datos desde el Servlet
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
    <title>Detalle de Asistencia | <%= resumen.getNombreCompleto() %></title>
    <link rel="stylesheet" href="CSS/HistorialAsistencia.css">
    <link rel="stylesheet" href="CSS/DetalleAsistencia.css"> <!-- CSS extra para los KPIs -->
    <link rel="icon" href="images/vyg.svg" type="image/svg+xml">
</head>
<body>

    <div class="page-wrapper">
        
        <!-- HEADER DEL TRABAJADOR -->
        <div class="worker-profile-header">
            <div class="profile-info">
                <h2>👤 <%= resumen.getNombreCompleto() %></h2>
                <p><strong>Cédula:</strong> <%= resumen.getCedula() %> | <strong>Puesto:</strong> <%= resumen.getPuesto() %></p>
                <p><strong>Proyecto Actual:</strong> 🏗️ <%= resumen.getNombreProyecto() %></p>
            </div>
            <button onclick="window.print()" class="btn-print">🖨️ Imprimir Reporte</button>
        </div>

        <!-- TARJETAS DE KPIs (Dashboard) -->
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

        <!-- TABLA DE HISTORIAL (Reutilizada de tu diseño) -->
        <div class="card attendance-card">
            <div class="card-header">
                <h2>📑 Historial Detallado</h2>
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
                            <td><strong><%= a.getFecha() %></strong></td>
                            <td class="time-in">🟢 <%= a.getHoraEntrada()%></td>
                            <td class="time-out">🔴 <%= a.getHoraSalida()!= null ? a.getHoraSalida(): "En turno" %></td>
                            <td>
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
                            <td colspan="4" class="empty-message">No hay registros para este trabajador.</td>
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
    </div>

</body>
</html>