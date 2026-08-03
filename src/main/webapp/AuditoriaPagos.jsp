<%@page import="java.util.List"%>
<%@page import="DTO.AuditoriaPagoDTO"%> 
<%@page import="model.Usuarios"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;

    if (user == null || !user.getRol().equalsIgnoreCase("Administrador")) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<AuditoriaPagoDTO> listaResultados = (List<AuditoriaPagoDTO>) request.getAttribute("ResultadosBusqueda");

    String busquedaAnterior = request.getParameter("criterio");
    if (busquedaAnterior == null)
        busquedaAnterior = "";
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Auditoría de Pagos | V&G Ingenieros</title>

        <link rel="stylesheet" href="CSS/SupervisorPage.css">
        <link rel="stylesheet" href="CSS/AuditoriaPagos.css">


        <script src="JS/menu-movil.js" defer></script>
        <link rel="icon" href="images/vygLogo.svg" type="image/svg+xml">
    
    <!-- Lucide Icons CDN -->
    <script src="JS/lucide.min.js"></script>
</head>
    <body>

        <div class="admin-container">

            <div class="overlay" id="sidebarOverlay"></div>

            <aside class="sidebar" id="sidebar">
                <div class="sidebar-header">
                    <img src="images/vygLogo.svg" alt="V&G Ingenieros Logo" class="sidebar-logo">
                    <div class="brand-text">
                        <h2 style="font-size: 18px;">V&G Ingenieros</h2>
                        <span class="panel-badge"><%= user.getRol() %></span>
                    </div>
                </div>

                <nav class="sidebar-nav">
                    <a href="AdminPage.jsp" class="nav-item">
                        <span class="icon"><i data-lucide="bar-chart-3" style="width: 20px; height: 20px"></i></span>
                        <span>Dashboard Maestro</span>
                    </a>
                    <a href="AdminFinanzas" class="nav-item">
                        <span class="icon"><i data-lucide="dollar-sign" style="width: 20px; height: 20px"></i></span>
                        <span>Control Financiero</span>
                    </a>
                    <a href="AuditoriaPagosSv" class="nav-item active" style="background-color: #121216;">
                        <span class="icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path></svg>️</span>
                        <span>Historial Maestro</span>
                    </a>
                    <a href="LogoutSv" class="nav-item logout-link">
                        <span class="icon"><i data-lucide="log-out" style="width: 20px; height: 20px"></i></span>
                        <span>Cerrar Sesión</span>
                    </a>
                </nav>
            </aside>

            <main class="main-content">

                <header class="topbar">
                    <div class="header-left">
                        <button id="menu-toggle" class="mobile-menu-btn"><i data-lucide="menu" style="width: 24px; height: 24px"></i></button>
                    </div>
                    <div class="profile-menu">
                        <div class="profile-info">
                            <span class="profile-name"><%= user.getUser_name()%></span>
                            <span class="profile-role"><%= user.getRol() %></span>
                        </div>
                        <img src="images/usuario.png" class="profile-img" alt="Perfil">
                    </div>
                </header>

                <section class="dashboard">

                    <div class="admin-header-banner" style="background: linear-gradient(135deg, #1E1E24, #121216);">
                        <div class="admin-header-info">
                            <h2><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path></svg>️ Historial Maestro de Pagos</h2>
                            <p>Buscador global de nóminas y uso de maquinaria. Busque por concepto o nombre del proyecto.</p>
                        </div>
                    </div>

                    <div class="card search-card">
                        <form action="AuditoriaPagosSv" method="GET" class="search-form">
                            <input type="text" name="criterio" placeholder="Ej. Carlos Mendoza, Caterpillar o Reparación KM45..." value="<%= busquedaAnterior%>" required>
                            <button type="submit" class="btn-buscar"><i data-lucide="search" style="width: 20px; height: 20px"></i> Buscar Recibos</button>
                        </form>
                    </div>

                    <div class="card result-card" id="area-impresion">
                        <div class="card-header" style="display: flex; justify-content: space-between; align-items: center;">
                            <div>
                                <h3>Resultados de la Auditoría</h3>
                                <p>Pagos con estado 'Autorizado' encontrados en el sistema.</p>
                            </div>
                            <% if (listaResultados != null && !listaResultados.isEmpty()) {%>
                            <a href="ReporteAuditoriaSv?criterio=<%= busquedaAnterior%>" target="_blank" class="btn-pdf" style="text-decoration: none; display: inline-block; text-align: center;">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg> Exportar Informe Oficial
                            </a>
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
                                        if (listaResultados != null) {
                                            if (!listaResultados.isEmpty()) {
                                                for (AuditoriaPagoDTO p : listaResultados) {
                                    %>
                                    <tr>
                                        <td data-label="Recibo #"><span class="badge-recibo"><%= p.getCodigoRecibo()%></span></td>
                                        <td data-label="Tipo"><span class="badge-tipo"><%= p.getTipoPago()%></span></td>
                                        <td data-label="Concepto"><strong><%= p.getConcepto()%></strong></td>
                                        <td data-label="Proyecto"><%= p.getNombreProyecto()%></td>
                                        <td data-label="Generado"><%= p.getGeneradoPor()%></td>
                                        <td data-label="Autorizado" style="color: #27ae60; font-weight: bold;"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" style="display:inline-block; vertical-align:middle; margin-right:4px;"><polyline points="20 6 9 17 4 12"></polyline></svg><%= p.getAutorizadoPor()%></td>
                                        <td data-label="Fecha"><%= p.getFechaPago()%></td>
                                        <td data-label="Monto" class="monto">C$ <%= String.format("%,.2f", p.getMontoPagado())%></td>
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
                                    <% }%>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div style="margin-top: 25px; padding-bottom: 20px;">
                        <a href="AdminFinanzas" class="btn-back"><i data-lucide="arrow-left" style="width: 20px; height: 20px"></i> Volver al Panel Financiero</a>
                    </div>

                </section>

            </main>
        </div>


    
    <!-- Inicializacion de Lucide Icons -->
    <script>
        lucide.createIcons();
    </script>
</body>
</html>
