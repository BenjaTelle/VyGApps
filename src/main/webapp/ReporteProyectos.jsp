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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reporte de Proyectos | VyGApps</title>
    <link rel="stylesheet" href="CSS/ReporteProyectos.css">
    <link rel="icon" href="images/vyg.svg" type="image/png">
     <script src="JS/ReporteProyectos.js"></script>
</head>
<body>

    <div class="main-container">
        
        <header class="report-header">
            <div class="header-content">
                <h2>📊 Reporte General de Proyectos</h2>
                <p class="subtitle">Vista global del estado y rendimiento financiero de las obras</p>
            </div>
            <div class="search-box">
                <span class="search-icon">🔍</span>
                <input type="text" id="inputBusqueda" placeholder="Buscar proyecto o supervisor...">
            </div>
        </header>

        <section class="summary-grid">
            <div class="kpi-card">
                <div class="kpi-icon total-icon">📂</div>
                <div class="kpi-data">
                    <h4>Total Proyectos</h4>
                    <span class="kpi-value">
                        <%= request.getAttribute("TotalProyectos") != null ? request.getAttribute("TotalProyectos") : "0"%>
                    </span>
                </div>
            </div>

            <div class="kpi-card">
                <div class="kpi-icon active-icon">⚙️</div>
                <div class="kpi-data">
                    <h4>Proyectos Activos</h4>
                    <span class="kpi-value" style="color: #2e7d32;">
                        <%= request.getAttribute("ProyectosActivos") != null ? request.getAttribute("ProyectosActivos") : "0"%>
                    </span>
                </div>
            </div>
        </section>

        <section class="table-card">
            <div class="table-responsive">
                <table id="tablaProyectos">
                    <thead>
                        <tr>
                            <th>Proyecto</th>
                            <th>Supervisor</th>
                            <th class="text-center">Trabajadores</th>
                            <th>Total Pagado</th>
                            <th class="text-center">Estado</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<ProyectoReporteDTO> lista = (List<ProyectoReporteDTO>) request.getAttribute("ListaReporte");

                            if (lista != null && !lista.isEmpty()) {
                                for (ProyectoReporteDTO p : lista) {
                                    String claseEstado = "activo".equalsIgnoreCase(p.getEstado()) ? "badge-activo" : "badge-finalizado";
                                    String textoSupervisor = (p.getSupervisor() == null || p.getSupervisor().trim().isEmpty()) 
                                        ? "Sin supervisor asignado" : p.getSupervisor();
                        %>
                        <tr class="proyecto-fila">
                            <td class="col-proyecto"><strong><%= p.getNombreProyecto()%></strong></td>
                            <td class="col-supervisor"><%= textoSupervisor%></td>
                            <td class="text-center"><span class="number-badge"><%= p.getCantidadTrabajadores()%></span></td>
                            <td class="col-monto">C$ <%= String.format("%,.2f", p.getTotalPagado()) %></td>
                            <td class="text-center">
                                <span class="estado-badge <%= claseEstado%>">
                                    <%= p.getEstado().toUpperCase()%>
                                </span>
                            </td>
                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr id="filaVacia">
                            <td colspan="5" class="empty-row">
                                <div class="empty-content">
                                    <span>📭</span>
                                    <p>No se encontraron proyectos registrados.</p>
                                </div>
                            </td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </section>

    </div>

   
</body>
</html>