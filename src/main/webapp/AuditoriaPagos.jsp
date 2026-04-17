<%-- 
    Document   : AuditoriaPagos
    Created on : 2 abr 2026, 7:22:55 p.m.
    Author     : Benja
--%>

<%@page import="java.util.List"%>
<%@page import="DTO.AuditoriaPagoDTO"%> 
<%@page import="model.Usuarios"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Seguridad: Solo Administradores
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
    
    if (user == null || !user.getRol().equalsIgnoreCase("Administrador")) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Lista de resultados
    List<AuditoriaPagoDTO> listaResultados = (List<AuditoriaPagoDTO>) request.getAttribute("ResultadosBusqueda");
    
    String busquedaAnterior = request.getParameter("criterio");
    if(busquedaAnterior == null) busquedaAnterior = "";
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Auditoría de Pagos | VyGApps</title>
    <link rel="stylesheet" href="CSS/HistorialAsistencia.css">
    <link rel="stylesheet" href="CSS/AdminFinanzas.css"> 
    <link rel="stylesheet" href="CSS/AuditoriaPagos.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    <link rel="icon" href="images/vyg.svg" type="image/svg+xml">
</head>
<body>

    <div class="page-wrapper" style="max-width: 1100px;">
        
        <div class="worker-profile-header admin-header" style="background: linear-gradient(135deg, #34495e, #2c3e50);">
            <div class="profile-info">
                <h2>🗂️ Historial Maestro de Pagos</h2>
                <p>Buscador global de nóminas y uso de maquinaria. Busque por concepto o nombre del proyecto.</p>
            </div>
        </div>

        <div class="card search-card">
            <form action="AuditoriaPagosSv" method="GET" class="search-form">
                <input type="text" name="criterio" placeholder="Ej. Carlos Mendoza, Caterpillar o Reparación KM45..." value="<%= busquedaAnterior %>" required>
                <button type="submit" class="btn-buscar">🔍 Buscar Recibos</button>
            </form>
        </div>

        <div class="card result-card" id="area-impresion">
            <div class="card-header" style="display: flex; justify-content: space-between; align-items: center;">
                <div>
                    <h3>Resultados de la Auditoría</h3>
                    <p>Pagos con estado 'Autorizado' encontrados en el sistema.</p>
                </div>
                <% if(listaResultados != null && !listaResultados.isEmpty()) { %>
                    <button onclick="descargarPDF()" class="btn-pdf">📄 Exportar PDF</button>
                <% } %>
            </div>
            
            <div class="table-responsive">
                <table class="vyg-table">
                    <thead>
                        <tr>
                            <th>Recibo #</th>
                            <th>Tipo</th>
                            <th>Concepto / Beneficiario</th>
                            <th>Proyecto</th>
                            <th>Generado Por</th>
                            <th>Autorizado Por</th>
                            <th>Fecha</th>
                            <th>Monto Final</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            if(listaResultados != null) {
                                if(!listaResultados.isEmpty()) {
                                    for(AuditoriaPagoDTO p : listaResultados) { 
                        %>
                        <tr>
                            <td><span class="badge-recibo"><%= p.getCodigoRecibo() %></span></td>
                            <td><span style="font-size: 12px; background: #eee; padding: 3px 6px; border-radius: 4px;"><%= p.getTipoPago() %></span></td>
                            <td><strong><%= p.getConcepto() %></strong></td>
                            <td><%= p.getNombreProyecto() %></td>
                            <td><%= p.getGeneradoPor() %></td>
                            <td style="color: #27ae60; font-weight: bold;">✔️ <%= p.getAutorizadoPor() %></td>
                            <td><%= p.getFechaPago() %></td>
                            <td class="monto">C$ <%= String.format("%,.2f", p.getMontoPagado()) %></td>
                        </tr>
                        <% 
                                    }
                                } else { 
                        %>
                        <tr>
                            <td colspan="8" class="empty-message">No se encontraron pagos autorizados con ese criterio de búsqueda.</td>
                        </tr>
                        <% 
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="8" class="empty-message" style="color: #7f8c8d;">Utilice el buscador de arriba para consultar el historial de pagos.</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <div style="margin-top: 25px;">
            <a href="AdminFinanzas" class="btn-back">⬅️ Volver al Panel Financiero</a>
        </div>

    </div>

    <script>
        function descargarPDF() {
            var elemento = document.getElementById('area-impresion');
            var botones = document.querySelector('.btn-pdf');
            botones.style.display = 'none';

            var opciones = {
                margin:       10,
                filename:     'Auditoria_Pagos_VyGApps.pdf',
                image:        { type: 'jpeg', quality: 0.98 },
                html2canvas:  { scale: 2 },
                jsPDF:        { unit: 'mm', format: 'a4', orientation: 'landscape' } 
            };

            html2pdf().set(opciones).from(elemento).save().then(function(){
                botones.style.display = 'block';
            });
        }
    </script>
</body>
</html>