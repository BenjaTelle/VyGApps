<%-- 
    Document   : HistorialPagosSup
    Created on : 3 abr 2026, 5:42:05 p.m.
    Author     : Benja
--%>

<%@page import="java.util.List"%>
<%@page import="DTO.AuditoriaPagoDTO"%> 
<%@page import="model.Usuarios"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Seguridad: Solo Supervisores (o Admin)
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
    
    if (user == null || (!user.getRol().equalsIgnoreCase("Supervisor") && !user.getRol().equalsIgnoreCase("Administrador"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<AuditoriaPagoDTO> listaHistorial = (List<AuditoriaPagoDTO>) request.getAttribute("HistorialSupervisor");
    
    // Calcular el total gastado rápido para el KPI
    double totalGastado = 0;
    if(listaHistorial != null) {
        for(AuditoriaPagoDTO p : listaHistorial) {
            totalGastado += p.getMontoPagado();
        }
    }
    
    String filtroMes = request.getParameter("mes");
    if(filtroMes == null) filtroMes = ""; // Vacío trae todo por defecto en el Servlet
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mi Historial de Pagos | VyGApps</title>
    <link rel="stylesheet" href="CSS/HistorialAsistencia.css">
    <link rel="stylesheet" href="CSS/HistorialPagosSup.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    <link rel="icon" href="images/vyg.svg" type="image/svg+xml">
</head>
<body>

    <div class="page-wrapper" style="max-width: 1000px;">
        
        <div class="worker-profile-header supervisor-header">
            <div class="profile-info">
                <h2>📊 Historial de Pagos Autorizados</h2>
                <p>Registro de nóminas y uso de maquinaria aprobados para tu proyecto.</p>
            </div>
        </div>

        <div class="kpi-container">
            <div class="kpi-card">
                <span class="kpi-icon">💰</span>
                <div class="kpi-data">
                    <p>Total Autorizado (Filtrado)</p>
                    <h3>C$ <%= String.format("%,.2f", totalGastado) %></h3>
                </div>
            </div>
            
            <div class="kpi-card search-card">
                <form action="HistorialPagosSupSv" method="GET" style="display: flex; gap: 10px; width: 100%;">
                    <input type="month" name="mes" value="<%= filtroMes %>" class="input-mes">
                    <button type="submit" class="btn-filtrar">Filtrar Mes</button>
                </form>
            </div>
        </div>

        <div class="card result-card" id="area-impresion">
            <div class="card-header" style="display: flex; justify-content: space-between; align-items: center;">
                <div>
                    <h3>Mis Autorizaciones</h3>
                </div>
                <% if(listaHistorial != null && !listaHistorial.isEmpty()) { %>
                    <button onclick="descargarPDF()" class="btn-pdf">📄 Generar Reporte</button>
                <% } %>
            </div>
            
            <div class="table-responsive">
                <table class="vyg-table">
                    <thead>
                        <tr>
                            <th>Recibo #</th>
                            <th>Tipo</th>
                            <th>Beneficiario / Concepto</th>
                            <th>Fecha Aprobación</th>
                            <th style="text-align: right;">Monto</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            if(listaHistorial != null && !listaHistorial.isEmpty()) {
                                for(AuditoriaPagoDTO p : listaHistorial) { 
                        %>
                        <tr>
                            <td><span class="badge-recibo"><%= p.getCodigoRecibo() %></span></td>
                            <td><span class="badge-tipo"><%= p.getTipoPago() %></span></td>
                            <td><strong><%= p.getConcepto() %></strong></td>
                            <td><%= p.getFechaPago() %></td>
                            <td class="monto">C$ <%= String.format("%,.2f", p.getMontoPagado()) %></td>
                        </tr>
                        <% 
                                }
                            } else { 
                        %>
                        <tr>
                            <td colspan="5" class="empty-message">No tienes pagos registrados en este periodo.</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <div style="margin-top: 25px; text-align: left;">
            <a href="SupervisorPage" class="btn-back">⬅️ Volver a mi Panel</a>
        </div>

    </div>

    <script>
        function descargarPDF() {
            var elemento = document.getElementById('area-impresion');
            var botones = document.querySelector('.btn-pdf');
            botones.style.display = 'none';

            var opciones = {
                margin:       10,
                filename:     'Reporte_Gastos_Proyecto.pdf',
                image:        { type: 'jpeg', quality: 0.98 },
                html2canvas:  { scale: 2 },
                jsPDF:        { unit: 'mm', format: 'a4', orientation: 'portrait' } 
            };

            html2pdf().set(opciones).from(elemento).save().then(function(){
                botones.style.display = 'block';
            });
        }
    </script>
</body>
</html>