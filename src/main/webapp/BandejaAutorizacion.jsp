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
    // --- LÓGICA DE SEGURIDAD ---
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;

    if (user == null || (!user.getRol().equalsIgnoreCase("Supervisor") && !user.getRol().equalsIgnoreCase("Administrador"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    // --- RECEPCIÓN DE DATOS ---
    List<PlanillaPendienteDTO> listaPlanillas = (List<PlanillaPendienteDTO>) request.getAttribute("ListaPlanillas");
    List<PlanillaPendienteDTO> listaMaquinarias = (List<PlanillaPendienteDTO>) request.getAttribute("ListaMaquinarias");

    String mensaje = request.getParameter("msg");
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Bandeja de Autorización | VyGApps</title>
        <link rel="stylesheet" href="CSS/BandejaAutorizacion.css">
        <link rel="icon" href="images/vyg.svg" type="image/svg+xml">
        <script src="JS/BandejaAutorizacion.js"></script>
    </head>
    <body>

        <div class="main-wrapper">

            <header class="page-header">
                <div class="header-overlay">
                    <div class="header-content">
                        <h2><span class="emoji-title">💼</span> Bandeja de Autorización</h2>
                        <p>Revisa, valida y aprueba los pagos generados. Verifica la disponibilidad del presupuesto de la obra antes de proceder.</p>
                    </div>
                </div>
            </header>

            <% if ("exito".equals(mensaje)) { %>
            <div class="alert-box alert-success" id="alertBox">
                <span class="alert-icon">✔️</span>
                <p><strong>Operación exitosa:</strong> El pago ha sido autorizado y los fondos fueron descontados del presupuesto.</p>
                <button type="button" class="close-alert" onclick="dismissAlert()">✕</button>
            </div>
            <% } else if ("sin_fondos".equals(mensaje)) { %>
            <div class="alert-box alert-danger" id="alertBox">
                <span class="alert-icon">❌</span>
                <p><strong>Fondos Insuficientes:</strong> El proyecto no cuenta con fondos disponibles para cubrir esta planilla.</p>
                <button type="button" class="close-alert" onclick="dismissAlert()">✕</button>
            </div>
            <% } else if ("error".equals(mensaje)) { %>
            <div class="alert-box alert-warning" id="alertBox">
                <span class="alert-icon">⚠️</span>
                <p><strong>Error técnico:</strong> Ocurrió un problema al procesar la solicitud. Intenta de nuevo.</p>
                <button type="button" class="close-alert" onclick="dismissAlert()">✕</button>
            </div>
            <% } %>

            <section class="table-card card-payroll">
                <div class="card-header">
                    <h3><span class="header-icon icon-payroll">👥</span> Nóminas de Personal Pendientes</h3>
                </div>

                <div class="table-responsive">
                    <table class="vyg-table">
                        <thead>
                            <tr>
                                <th>Trabajador</th>
                                <th>Proyecto</th>
                                <th>Periodo</th>
                                <th class="text-center">Días</th>
                                <th>Monto a Pagar</th>
                                <th class="text-center">Acción</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (listaPlanillas != null && !listaPlanillas.isEmpty()) {
                                    for (PlanillaPendienteDTO p : listaPlanillas) {
                            %>
                            <tr>
                                <td class="col-main"><strong><%= p.getNombreTrabajador()%></strong></td>
                                <td><%= p.getNombreProyecto()%></td>
                                <td><span class="badge-periodo"><%= p.getPeriodo()%></span></td>
                                <td class="text-center"><span class="number-badge"><%= p.getDiasTrabajados()%></span></td>
                                <td class="col-monto text-payroll">C$ <%= String.format("%,.2f", p.getMontoPagado())%></td>
                                <td class="text-center">
                                    <a href="AutorizarPagoSv?id_pago=<%= p.getIdPago()%>&id_proyecto=<%= p.getIdProyecto()%>&monto=<%= p.getMontoPagado()%>&tipo=nomina" 
                                       class="btn-action btn-payroll" 
                                       onclick="return confirmApproval('nomina', '<%= p.getNombreTrabajador()%>', '<%= String.format("%,.2f", p.getMontoPagado())%>');">
                                        Aprobar
                                    </a>
                                </td>
                            </tr>
                            <%
                                }
                            } else {
                            %>
                            <tr>
                                <td colspan="6" class="empty-row">
                                    <div class="empty-container">
                                        <span>📭</span>
                                        <p>No hay nóminas de personal esperando aprobación.</p>
                                    </div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div> <script src="JS/BandejaAutorizacion.js"></script>
            </section>

            <section class="table-card card-machinery">
                <div class="card-header">
                    <h3><span class="header-icon icon-machinery">🚜</span> Pagos de Maquinaria y Fletes Pendientes</h3>
                </div>

                <div class="table-responsive">
                    <table class="vyg-table">
                        <thead>
                            <tr>
                                <th>Máquina / Concepto</th>
                                <th>Proyecto</th>
                                <th>Fecha</th>
                                <th>Total Liquidado</th>
                                <th class="text-center">Acción</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (listaMaquinarias != null && !listaMaquinarias.isEmpty()) {
                                    for (PlanillaPendienteDTO m : listaMaquinarias) {
                            %>
                            <tr>
                                <td class="col-main"><strong><%= m.getNombreTrabajador()%></strong></td>
                                <td><%= m.getNombreProyecto()%></td>
                                <td><span class="badge-periodo"><%= m.getPeriodo()%></span></td>
                                <td class="col-monto text-machinery">C$ <%= String.format("%,.2f", m.getMontoPagado())%></td>
                                <td class="text-center">
                                    <a href="AutorizarPagoSv?id_pago=<%= m.getIdPago()%>&id_proyecto=<%= m.getIdProyecto()%>&monto=<%= m.getMontoPagado()%>&tipo=maquinaria" 
                                       class="btn-action btn-machinery" 
                                       onclick="return confirmApproval('maquinaria', '<%= m.getNombreTrabajador()%>', '<%= String.format("%,.2f", m.getMontoPagado())%>');">
                                        Aprobar
                                    </a>
                                </td>
                            </tr>
                            <%
                                }
                            } else {
                            %>
                            <tr>
                                <td colspan="5" class="empty-row">
                                    <div class="empty-container">
                                        <span>🚜</span>
                                        <p>No hay órdenes de maquinaria o fletes pendientes.</p>
                                    </div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </section>

            <footer class="footer-navigation">
                <% if (user.getRol().equalsIgnoreCase("Administrador")) { %>
                <a href="AdminFinanzas" class="btn-return">⬅️ Volver al Panel Financiero</a>
                <% } else { %>
                <a href="SupervisorPage" class="btn-return">⬅️ Volver a mi Panel de Control</a>
                <% }%>
            </footer>

        </div>


    </body>
</html>