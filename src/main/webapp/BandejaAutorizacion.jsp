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
        <title>Bandeja de Autorización | Kronos Industrial</title>
        <link rel="stylesheet" href="CSS/BandejaAutorizacion.css">
        <link rel="icon" href="images/KronosIndustrial.svg" type="image/svg+xml">
        <script src="JS/BandejaAutorizacion.js"></script>
    
    <!-- Lucide Icons CDN -->
    <script src="https://unpkg.com/lucide@latest"></script>
</head>
    <body>

        <div class="main-wrapper">

            <header class="page-header">
                <div class="header-overlay">
                    <div class="header-content">
                        <h2><span class="emoji-title"><i data-lucide="briefcase" style="width: 20px; height: 20px"></i></span> Bandeja de Autorización</h2>
                        <p>Revisa, valida y aprueba los pagos generados. Verifica la disponibilidad del presupuesto de la obra antes de proceder.</p>
                    </div>
                </div>
            </header>

            <% if ("exito".equals(mensaje)) { %>
            <div class="alert-box alert-success" id="alertBox">
                <span class="alert-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg></span>
                <p><strong>Operación exitosa:</strong> El pago ha sido autorizado y los fondos fueron descontados del presupuesto.</p>
                <button type="button" class="close-alert" onclick="dismissAlert()">✕</button>
            </div>
            <% } else if ("sin_fondos".equals(mensaje)) { %>
            <div class="alert-box alert-danger" id="alertBox">
                <span class="alert-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="15" y1="9" x2="9" y2="15"></line><line x1="9" y1="9" x2="15" y2="15"></line></svg></span>
                <p><strong>Fondos Insuficientes:</strong> El proyecto no cuenta con fondos disponibles para cubrir esta planilla.</p>
                <button type="button" class="close-alert" onclick="dismissAlert()">✕</button>
            </div>
            <% } else if ("error".equals(mensaje)) { %>
            <div class="alert-box alert-warning" id="alertBox">
                <span class="alert-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path><line x1="12" y1="9" x2="12" y2="13"></line><line x1="12" y1="17" x2="12.01" y2="17"></line></svg></span>
                <p><strong>Error técnico:</strong> Ocurrió un problema al procesar la solicitud. Intenta de nuevo.</p>
                <button type="button" class="close-alert" onclick="dismissAlert()">✕</button>
            </div>
            <% } %>

            <section class="table-card card-payroll">
                <div class="card-header">
                    <h3><span class="header-icon icon-payroll"><i data-lucide="users" style="width: 20px; height: 20px"></i></span> Nóminas de Personal Pendientes</h3>
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
                                        <span><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="22 12 16 12 14 15 10 15 8 12 2 12"></polyline><path d="M5.45 5.11L2 12v6a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-6l-3.45-6.89A2 2 0 0 0 16.76 4H7.24a2 2 0 0 0-1.79 1.11z"></path></svg></span>
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
                    <h3><span class="header-icon icon-machinery"><i data-lucide="briefcase" style="width: 20px; height: 20px"></i></span> Pagos de Maquinaria y Fletes Pendientes</h3>
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
                                        <span><i data-lucide="briefcase" style="width: 20px; height: 20px"></i></span>
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
                <a href="AdminFinanzas" class="btn-return"><i data-lucide="arrow-left" style="width: 20px; height: 20px"></i> Volver al Panel Financiero</a>
                <% } else { %>
                <a href="SupervisorPage" class="btn-return"><i data-lucide="arrow-left" style="width: 20px; height: 20px"></i> Volver a mi Panel de Control</a>
                <% }%>
            </footer>

        </div>


    
    <!-- Inicializacion de Lucide Icons -->
    <script>
        lucide.createIcons();
    </script>
</body>
</html>