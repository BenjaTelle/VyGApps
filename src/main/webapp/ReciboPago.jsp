<%-- 
    Document   : ReciboPago
    Created on : 22 abr 2026
    Author     : Benja
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="DTO.PagoDTO"%>
<%@page import="model.Usuarios"%>

<%
    // Seguridad: Solo usuarios logueados pueden ver su recibo
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
    
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Recuperamos el objeto PagoDTO enviado por el Servlet
    PagoDTO pago = (PagoDTO) request.getAttribute("DetallePago");
    if (pago == null) {
        out.println("Error: No se encontró la información del pago.");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Recibo de Pago #<%= String.format("%04d", pago.getIdPago()) %> | VyGApps</title>
    <link rel="stylesheet" href="CSS/ReciboPago.css">
    <link rel="icon" href="images/vyg.svg" type="image/png">
</head>
<body>

    <div class="receipt-container">
        <header class="receipt-header">
            <div class="company-brand">
                <img src="images/vyg.svg" alt="Logo VyG" class="receipt-logo">
                <div class="company-info">
                    <h1>VyG Construcciones S.A.</h1>
                    <p>Gestión de Proyectos e Infraestructura</p>
                    <p>Managua, Nicaragua</p>
                </div>
            </div>
            <div class="receipt-meta">
                <div class="receipt-number">
                    <span>RECIBO DE PAGO</span>
                    <h2>#<%= String.format("%04d", pago.getIdPago()) %></h2>
                </div>
                <p class="receipt-date">Generado el: 22/04/2026</p>
            </div>
        </header>

        <hr class="divider">

        <section class="receipt-section">
            <h3 class="section-title">Información del Colaborador</h3>
            <div class="info-grid">
                <div class="info-item">
                    <label>Nombre Completo:</label>
                    <p><%= pago.getNombreTrabajador() %></p> </div>
                <div class="info-item">
                    <label>Cargo:</label>
                    <p><%= user.getRol() %></p>
                </div>
                <div class="info-item">
                    <label>Periodo de Pago:</label>
                    <p>Del <%= pago.getPeriodoInicio() %> al <%= pago.getPeriodoFin() %></p>
                </div>
                <div class="info-item">
                    <label>Estado del Pago:</label>
                    <p class="status-text"><%= pago.getEstado() %></p>
                </div>
            </div>
        </section>

        <section class="receipt-section">
            <h3 class="section-title">Detalle de Liquidación</h3>
            <table class="receipt-table">
                <thead>
                    <tr>
                        <th>Descripción del Concepto</th>
                        <th class="text-right">Monto</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Pago Quincenal Ordinario - Asistencia Registrada</td>
                        <td class="text-right">C$ <%= String.format("%,.2f", pago.getMonto()) %></td>
                    </tr>
                    </tbody>
                <tfoot>
                    <tr class="total-row">
                        <td>TOTAL NETO A RECIBIR</td>
                        <td class="text-right">C$ <%= String.format("%,.2f", pago.getMonto()) %></td>
                    </tr>
                </tfoot>
            </table>
        </section>

        <footer class="receipt-footer">
            <div class="signature-box">
                <div class="signature-line"></div>
                <p>Firma del Colaborador</p>
            </div>
            <div class="signature-box">
                <div class="signature-line"></div>
                <p>Sello y Firma Autorizada</p>
            </div>
            <div class="legal-notice">
                <p>Este documento es un comprobante oficial generado por el sistema VyGApps. 
                   La falsificación de este recibo es un delito penado por la ley.</p>
            </div>
        </footer>
    </div>

    <div class="action-bar">
        <button onclick="window.print()" class="btn-print"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 6 2 18 2 18 9"></polyline><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"></path><rect x="6" y="14" width="12" height="8"></rect></svg> Imprimir Recibo</button>
        <button onclick="window.close()" class="btn-close">Cerrar Vista</button>
    </div>

</body>
</html>