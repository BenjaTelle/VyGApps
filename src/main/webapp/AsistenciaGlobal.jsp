<%-- 
    Document   : AsistenciaGlobal
    Created on : 31 mar 2026, 5:09:24 p.m.
    Author     : Benja
--%>
<%@page import="DTO.AsistenciaDTO"%>


<%@page import="java.sql.Time"%>
<%@page import="java.util.List"%>
<%-- DTO que incluye el nombre del trabajador --%>
<%@page import="DTO.AsistenciaDTO"%> 
<%@page import="model.Usuarios"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // --- LÓGICA DE SEGURIDAD (Solo Supervisores o Admins) ---
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
    <title>Control Global de Asistencia | VyGApps</title>
    <!-- Puedes crear este nuevo CSS o reutilizar el anterior -->
    <link rel="stylesheet" href="CSS/AsistenciaGlobal.css">
    <link rel="icon" href="images/vyg.svg" type="image/svg+xml">
</head>
<body>

    <div class="page-wrapper">
        <div class="card attendance-card">
            
            <div class="card-header">
                <h2>&#128101; Control Global de Asistencia</h2>
                <p>Historial general de entradas y salidas de todos los trabajadores activos.</p>
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
                            // Recibimos la lista completa desde el Servlet
                            List<AsistenciaDTO> listaAsistencia = (List<AsistenciaDTO>) request.getAttribute("ListaAsistenciaGlobal");

                            if (listaAsistencia != null && !listaAsistencia.isEmpty()) {
                                for (AsistenciaDTO a : listaAsistencia) {
                                    
                                    // --- LÓGICA DE LLEGADA TARDÍA (Después de las 08:00:00) ---
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
                            <!-- Nueva columna con el nombre -->
                            <td style="color: #2c3e50;"><strong><%= a.getNombreTrabajador() != null ? a.getNombreTrabajador() : "Desconocido" %></strong></td>
                            
                            <td><strong><%= a.getFecha() != null ? a.getFecha() : "Sin fecha" %></strong></td>
                            
                            <td class="time-in">
                                &#128308; <%= a.getHoraEntrada()!= null ? a.getHoraEntrada(): "--:--" %>
                            </td>
                            
                            <td class="time-out">
                                &#128308; <%= a.getHoraSalida()!= null ? a.getHoraSalida(): "<span style='color:#7f8c8d; font-size:12px;'>En turno</span>" %>
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
                            <td colspan="5" class="empty-message">No hay registros de asistencia en el sistema todavía.</td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>

            <div class="card-footer">
                <!-- Regresa al panel del Supervisor -->
                <a href="SupervisorPage" class="btn-back">&#11013; Volver al Panel de Control</a>
            </div>

        </div>
    </div>

</body>
</html>