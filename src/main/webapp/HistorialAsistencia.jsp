<%-- 
    Document   : HistorialAsistencia
    Created on : 15 mar 2026, 5:55:30 p.m.
    Author     : Benja
--%>

<%@page import="java.sql.Time"%>
<%@page import="model.asistencia"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<%@page import="java.util.List"%>
<%-- Asumiendo que crearás un DTO para esto --%>
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
    <title>Mi Historial de Asistencia</title>
    <link rel="stylesheet" href="CSS/HistorialAsistencia.css">
    <link rel="icon" href="images/vyg.svg" type="image/png">
</head>
<body>

    <div class="page-wrapper">
        <div class="card attendance-card">
            
            <div class="card-header">
                <h2>📅 Mi Registro de Asistencia</h2>
                <p>Historial de tus entradas y salidas registradas en el sistema.</p>
            </div>

            <div class="table-responsive">
                <table class="vyg-table">
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
                                    
                                    // Lógica para detectar llegada tardía (después de las 08:00:00)
                                    boolean llegadaTardia = false;
                                   Time horaEntrada=  a.getHora_entrada(); 
                                   String HoraString =horaEntrada.toString();
                                    if (a.getHora_entrada() != null && HoraString.compareTo("08:00:00") > 0) {
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

            <div class="card-footer">
                <a href="Home.jsp" class="btn-back">&#11013; Volver a mi Panel</a>
            </div>

        </div>
    </div>

</body>
</html>