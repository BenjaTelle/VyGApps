<%-- 
    Document   : ReporteAuditoria
    Created on : 19 may 2026, 9:25:34 p.m.
    Author     : Benja
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="DTO.AuditoriaPagoDTO"%> 
<%@page import="model.Usuarios"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.time.format.DateTimeFormatter"%>


<%
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
    
    if (user == null || !user.getRol().equalsIgnoreCase("Administrador")) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<AuditoriaPagoDTO> lista = (List<AuditoriaPagoDTO>) request.getAttribute("ResultadosReporte");
    String criterio = (String) request.getAttribute("CriterioFiltro");
    
    double sumaTotal = 0;
    if (lista != null) {
        for (AuditoriaPagoDTO p : lista) {
            sumaTotal += p.getMontoPagado();
        }
    }
    
    String fechaImpresion = LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss"));
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Informe Oficial de Auditoría | V&G Ingenieros</title>
    
    <link rel="stylesheet" href="CSS/ReporteAuditoria.css">
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    <script src="JS/reporte-auditoria.js" defer></script>

    <!-- Lucide Icons CDN -->
    <script src="JS/lucide.min.js"></script>
</head>
<body>

    <div class="action-bar" id="actionBar">
        <div class="action-left">
            <span>Vista Previa del Documento</span>
        </div>
        <div class="action-right">
            <button onclick="window.close()" class="btn btn-close">Cerrar</button>
            <button onclick="imprimirNativo()" class="btn btn-print"><i data-lucide="printer" style="width: 20px; height: 20px"></i> Imprimir</button>
            <button onclick="descargarPDF_Reporte()" class="btn btn-pdf"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg> Descargar PDF</button>
        </div>
    </div>

    <div class="document-container" id="documentoReporte">
        
        <header class="doc-header">
            <div class="doc-brand">
                <img src="images/vygLogo.svg" alt="Logo V&G Ingenieros" class="doc-logo">
                <div class="doc-company">
                    <h1>V&G INGENIEROS S.A.</h1>
                    <p>Reporte Maestro de Auditoría y Egresos</p>
                    <p>Managua, Nicaragua | RUC: J0310000XXXXXX</p>
                </div>
            </div>
            <div class="doc-meta">
                <p><strong>Filtro aplicado:</strong> <%= (criterio.isEmpty()) ? "Todos los registros" : criterio %></p>
                <p><strong>Generado por:</strong> <%= user.getUser_name() %></p>
                <p><strong>Fecha de Emisión:</strong> <%= fechaImpresion %></p>
            </div>
        </header>

        <section class="doc-body">
            <table class="doc-table">
                <thead>
                    <tr>
                        <th>Código</th>
                        <th>Tipo</th>
                        <th>Concepto / Beneficiario</th>
                        <th>Proyecto Asociado</th>
                        <th>Generó</th>
                        <th>Autorizó</th>
                        <th>Fecha</th>
                        <th class="text-right">Monto (C$)</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        if(lista != null && !lista.isEmpty()) {
                            for(AuditoriaPagoDTO p : lista) { 
                    %>
                    <tr class="data-row">
                        <td class="td-code"><%= p.getCodigoRecibo() %></td>
                        <td><%= p.getTipoPago() %></td>
                        <td><%= p.getConcepto() %></td>
                        <td><%= p.getNombreProyecto() %></td>
                        <td><%= p.getGeneradoPor() %></td>
                        <td><%= p.getAutorizadoPor() %></td>
                        <td><%= p.getFechaPago() %></td>
                        <td class="text-right td-money"><%= String.format("%,.2f", p.getMontoPagado()) %></td>
                    </tr>
                    <% 
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="8" style="text-align:center; padding: 20px;">No hay registros para mostrar en este informe.</td>
                    </tr>
                    <% } %>
                </tbody>
                <tfoot>
                    <tr class="total-row">
                        <td colspan="6"></td>
                        <td class="text-right total-label">TOTAL GENERAL:</td>
                        <td class="text-right total-amount">C$ <%= String.format("%,.2f", sumaTotal) %></td>
                    </tr>
                </tfoot>
            </table>
        </section>

        <footer class="doc-footer">
            <div class="signatures">
                <div class="sign-box">
                    <div class="sign-line"></div>
                    <p>Preparado y Auditado Por</p>
                    <span><%= user.getUser_name() %> (Administrador)</span>
                </div>
                <div class="sign-box">
                    <div class="sign-line"></div>
                    <p>Visto Bueno / Dirección General</p>
                    <span>Firma Autorizada</span>
                </div>
            </div>
            <div class="legal-text">
                Documento de carácter oficial e interno de V&G INGENIEROS S.A. Representa un extracto contable validado por el sistema V&G Ingenieros. La alteración de las cifras aquí expresadas constituye una violación a las políticas de la empresa.
            </div>
        </footer>

    </div>


    <!-- Inicializacion de Lucide Icons -->
    <script>
        lucide.createIcons();
    </script>
</body>
</html>