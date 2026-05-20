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
        <title>Auditoría de Pagos | VyGApps</title>

        <link rel="stylesheet" href="CSS/SupervisorPage.css">
        <link rel="stylesheet" href="CSS/AuditoriaPagos.css">


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
                        <span class="panel-badge" style="background:#fceceb; color:#c0392b;">Administrador</span>
                    </div>
                </div>

                <nav class="sidebar-nav">
                    <a href="AdminPage.jsp" class="nav-item">
                        <span class="icon">📊</span>
                        <span>Dashboard Maestro</span>
                    </a>
                    <a href="AdminFinanzas" class="nav-item">
                        <span class="icon">💰</span>
                        <span>Control Financiero</span>
                    </a>
                    <a href="AuditoriaPagosSv" class="nav-item active" style="background-color: #2c3e50;">
                        <span class="icon">🗂️</span>
                        <span>Historial Maestro</span>
                    </a>
                    <a href="LogoutSv" class="nav-item logout-link">
                        <span class="icon">🚪</span>
                        <span>Cerrar Sesión</span>
                    </a>
                </nav>
            </aside>

            <main class="main-content">

                <header class="topbar">
                    <div class="header-left">
                        <button id="menu-toggle" class="mobile-menu-btn">☰</button>
                    </div>
                    <div class="profile-menu">
                        <div class="profile-info">
                            <span class="profile-name"><%= user.getUser_name()%></span>
                            <span class="profile-role">Administrador</span>
                        </div>
                        <img src="images/usuario.png" class="profile-img" alt="Perfil">
                    </div>
                </header>

                <section class="dashboard">

                    <div class="admin-header-banner" style="background: linear-gradient(135deg, #34495e, #2c3e50);">
                        <div class="admin-header-info">
                            <h2>🗂️ Historial Maestro de Pagos</h2>
                            <p>Buscador global de nóminas y uso de maquinaria. Busque por concepto o nombre del proyecto.</p>
                        </div>
                    </div>

                    <div class="card search-card">
                        <form action="AuditoriaPagosSv" method="GET" class="search-form">
                            <input type="text" name="criterio" placeholder="Ej. Carlos Mendoza, Caterpillar o Reparación KM45..." value="<%= busquedaAnterior%>" required>
                            <button type="submit" class="btn-buscar">🔍 Buscar Recibos</button>
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
                                📄 Exportar Informe Oficial
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
                                        <td data-label="Autorizado" style="color: #27ae60; font-weight: bold;">✔️ <%= p.getAutorizadoPor()%></td>
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
                        <a href="AdminFinanzas" class="btn-back">⬅️ Volver al Panel Financiero</a>
                    </div>

                </section>

            </main>
        </div>


    </body>
</html>