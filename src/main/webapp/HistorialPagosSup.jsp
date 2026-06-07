<%-- 
    Document   : HistorialPagosSup
    Created on : 3 abr 2026
    Author     : Benja
--%>
<%@page import="java.util.List"%>
<%@page import="DTO.AuditoriaPagoDTO"%> 
<%@page import="model.Usuarios"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
    
    if (user == null || (!user.getRol().equalsIgnoreCase("Supervisor") && !user.getRol().equalsIgnoreCase("Administrador"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<AuditoriaPagoDTO> listaHistorial = (List<AuditoriaPagoDTO>) request.getAttribute("HistorialSupervisor");
    
    double totalGastado = 0;
    if(listaHistorial != null) {
        for(AuditoriaPagoDTO p : listaHistorial) {
            totalGastado += p.getMontoPagado();
        }
    }
    
    String filtroMes = request.getParameter("mes");
    if(filtroMes == null) filtroMes = ""; 
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historial de Pagos | VyGApps</title>
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/HistorialPagosSup.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    <script src="JS/menu-movil.js" defer></script>
    <link rel="icon" href="images/vyg.svg" type="image/svg+xml">
</head>
<body>

<div class="admin-container">

    <div class="overlay" id="sidebarOverlay"></div>

    <aside class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <img src="images/vyg.svg" alt="VyG Logo" class="sidebar-logo">
            <div class="brand-text">
                <h2>VyGApps</h2>
                <span class="panel-badge"><%= user.getRol() %></span>
            </div>
        </div>

        <nav class="sidebar-nav">
            <a href="SupervisorPage" class="nav-item">
                <span class="icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="20" x2="12" y2="10"></line><line x1="18" y1="20" x2="18" y2="4"></line><line x1="6" y1="20" x2="6" y2="16"></line></svg></span>
                <span>Dashboard</span>
            </a>
            <a href="CentroPagos" class="nav-item active">
                <span class="icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"></line><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path></svg></span>
                <span>Planillas y Pagos</span>
            </a>
            <a href="LogoutSv" class="nav-item logout-link">
                <span class="icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" y1="12" x2="9" y2="12"></line></svg></span>
                <span>Cerrar Sesión</span>
            </a>
        </nav>
    </aside>

    <main class="main-content">

        <header class="topbar">
            <div class="header-left">
                <button id="menu-toggle" class="mobile-menu-btn">☰</button>
                <div class="welcome">
                    <h1>Historial de Pagos</h1>
                    <span>Registro de nóminas y usos de maquinaria aprobados.</span>
                </div>
            </div>

            <div class="profile-menu">
                <div class="profile-info">
                    <span class="profile-name"><%= user.getUser_name() %></span>
                    <span class="profile-role"><%= user.getRol() %></span>
                </div>
                <img src="images/usuario.png" class="profile-img" alt="Perfil">
            </div>
        </header>

        <section class="dashboard" id="area-impresion">

            <div class="kpi-container">
                <div class="kpi-card">
                    <span class="kpi-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"></line><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path></svg></span>
                    <div class="kpi-data">
                        <p>Total Autorizado (Filtrado)</p>
                        <h3>C$ <%= String.format("%,.2f", totalGastado) %></h3>
                    </div>
                </div>
                
                <div class="kpi-card search-card no-print">
                    <form action="HistorialPagosSupSv" method="GET" class="filter-form">
                        <input type="month" name="mes" value="<%= filtroMes %>" class="input-mes">
                        <button type="submit" class="btn-filtrar">Filtrar Mes</button>
                    </form>
                </div>
            </div>

            <div class="result-card">
                <div class="card-header no-print">
                    <h3><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg> Recibos y Autorizaciones</h3>
                    <% if(listaHistorial != null && !listaHistorial.isEmpty()) { %>
                        <button onclick="descargarPDF()" class="btn-pdf"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg> Generar PDF</button>
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
                                <td data-label="Recibo #"><span class="badge-recibo"><%= p.getCodigoRecibo() %></span></td>
                                <td data-label="Tipo"><span class="badge-tipo"><%= p.getTipoPago() %></span></td>
                                <td data-label="Concepto"><strong><%= p.getConcepto() %></strong></td>
                                <td data-label="Fecha Aprobación"><%= p.getFechaPago() %></td>
                                <td data-label="Monto" class="monto">C$ <%= String.format("%,.2f", p.getMontoPagado()) %></td>
                            </tr>
                            <% 
                                    }
                                } else { 
                            %>
                            <tr>
                                <td colspan="5" class="empty-cell">No tienes pagos registrados en este periodo.</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

        </section>

    </main>
</div>

<script>
    function descargarPDF() {
        var elemento = document.getElementById('area-impresion');
        var botones = document.querySelectorAll('.no-print');
        
        botones.forEach(btn => btn.style.display = 'none');

        var opciones = {
            margin:       10,
            filename:     'Reporte_Pagos_Proyecto.pdf',
            image:        { type: 'jpeg', quality: 0.98 },
            html2canvas:  { scale: 2 },
            jsPDF:        { unit: 'mm', format: 'a4', orientation: 'portrait' } 
        };

        html2pdf().set(opciones).from(elemento).save().then(function(){
            botones.forEach(btn => btn.style.display = '');
        });
    }
</script>

</body>
</html>