<%-- 
    Document   : ReporteProyectos
    Created on : 20 feb 2026, 7:53:54 p.m.
    Author     : Benja
--%>
<%@page import="java.util.List"%>
<%@page import="DTO.ProyectoReporteDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Reporte de Proyectos</title>
        <link rel="stylesheet" href="CSS/ReporteProyectos.css">
    </head>
    <body>

        <div class="container">

            <h2>Reporte General de Proyectos</h2>
            <p class="subtitle">Vista global del estado y rendimiento de los proyectos</p>

            <!-- resumen de los proyectos  -->
            <div class="summary-cards">

                <div class="card-summary">
                    <h4>Total Proyectos</h4>
                    <span>
                        <%= request.getAttribute("TotalProyectos") != null ? request.getAttribute("TotalProyectos") : "0"%>
                    </span>
                </div>

                <div class="card-summary">
                    <h4>Activos</h4>
                    <span>
                        <%= request.getAttribute("ProyectosActivos") != null ? request.getAttribute("ProyectosActivos") : "0"%>
                    </span>
                </div>



            </div>

            <!-- tabla de proyectos -->
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>Proyecto</th>
                            <th>Supervisor</th>
                            <th>Trabajadores</th>
                            <th>Total Pagado</th>
                            <th>Estado</th>
                        </tr>
                    </thead>
                    <tbody>

                        <%
                            List<ProyectoReporteDTO> lista
                                    = (List<ProyectoReporteDTO>) request.getAttribute("ListaReporte");

                            if (lista != null && !lista.isEmpty()) {
                                for (ProyectoReporteDTO p : lista) {

                                    String claseEstado = "activo".equalsIgnoreCase(p.getEstado())
                                            ? "estado-activo"
                                            : "estado-finalizado";
                                    System.out.println("estado: " + p.getEstado());

                                    String textoSupervisor = (p.getSupervisor() == null)
                                            ? "No hay supervisor asignado"
                                            : p.getSupervisor();
                        %>

                        <tr>
                            <td><%=  p.getNombreProyecto()%></td>

                            <td><%= textoSupervisor%></td>
                            <td><%= p.getCantidadTrabajadores()%></td>
                               <td>C$ <%= p.getTotalPagado() %></td>
                            <td>
                                <span class="estado-badge <%= claseEstado%>">
                                    <%= p.getEstado()%>
                                </span>
                            </td>
                        </tr>

                        <%
                            }
                        } else {
                        %>
                        <tr>
                            <td colspan="5" class="empty">
                                No hay proyectos registrados.
                            </td>
                        </tr>
                        <%
                            }
                        %>

                    </tbody>
                </table>
            </div>

        </div>

    </body>
</html>
