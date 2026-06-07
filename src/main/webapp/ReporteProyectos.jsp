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
                <h2><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="20" x2="12" y2="10"></line><line x1="18" y1="20" x2="18" y2="4"></line><line x1="6" y1="20" x2="6" y2="16"></line></svg> Reporte General de Proyectos</h2>
                <p class="subtitle">Vista global del estado y rendimiento financiero de las obras</p>
            </div>
            <div class="search-box">
                <span class="search-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg></span>
                <input type="text" id="inputBusqueda" placeholder="Buscar proyecto o supervisor...">
            </div>
        </header>

        <section class="summary-grid">
            <div class="kpi-card">
                <div class="kpi-icon total-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path></svg></div>
                <div class="kpi-data">
                    <h4>Total Proyectos</h4>
                    <span class="kpi-value">
                        <%= request.getAttribute("TotalProyectos") != null ? request.getAttribute("TotalProyectos") : "0"%>
                    </span>
                </div>
            </div>

            <div class="kpi-card">
                <div class="kpi-icon active-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="3"></circle><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path></svg></div>
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
                                    <span><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="22 12 16 12 14 15 10 15 8 12 2 12"></polyline><path d="M5.45 5.11L2 12v6a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-6l-3.45-6.89A2 2 0 0 0 16.76 4H7.24a2 2 0 0 0-1.79 1.11z"></path></svg></span>
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