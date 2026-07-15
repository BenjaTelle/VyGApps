<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="java.util.List"%>
<%@page import="DTO.ResumenGastoDTO"%> 
<%@page import="model.proyectos"%>
<%@page import="model.Usuarios"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.time.format.DateTimeFormatter"%>

<%
    HttpSession sessionActual = request.getSession(false);
    Usuarios usuarioLogeado = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;

    if (usuarioLogeado == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    if (!usuarioLogeado.getRol().equals("Administrador")) {
        response.sendRedirect("AccDen.jsp");
        return;
    }

    List<ResumenGastoDTO> listaGastos = (List<ResumenGastoDTO>) request.getAttribute("ListaGastos");
    double totalEgresos = 0;
    int totalTransacciones = 0;

    if (listaGastos != null) {
        totalTransacciones = listaGastos.size();
        for (ResumenGastoDTO gasto : listaGastos) {
            totalEgresos += gasto.getMonto();
        }
    }

    String fechaFiltro = (String) request.getAttribute("fechaFiltro");
    String tipoFiltro = (String) request.getAttribute("tipoFiltro");
    String fechaImpresion = LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss"));
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Resumen Diario de Gastos | Kronos Industrial</title>

        <link rel="stylesheet" href="CSS/AdminPage.css">
        <link rel="stylesheet" href="CSS/ResumenDiario.css">

        <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
        <script src="JS/menu-movil.js" defer></script>
        <script src="JS/resumen-gastos.js" defer></script>
        <link rel="icon" href="images/KronosIndustrial.svg" type="image/png">
    </head>
    <body>

        <div class="admin-container no-print">
            <div class="overlay" id="sidebarOverlay"></div>

            <aside class="sidebar" id="sidebar">
                <div class="sidebar-header">
                    <img src="images/KronosIndustrial.svg" alt="Kronos Industrial Logo" class="sidebar-logo">
                    <div class="brand-text">
                        <h2 style="font-size: 18px;">Kronos Industrial</h2>
                        <span class="panel-badge"><%= usuarioLogeado.getRol() %></span>
                    </div>
                </div>
                <nav class="sidebar-nav">
                    <a href="AdminPage.jsp" class="nav-item">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="9"></rect><rect x="14" y="3" width="7" height="5"></rect><rect x="14" y="12" width="7" height="9"></rect><rect x="3" y="16" width="7" height="5"></rect></svg>
                        <span>Dashboard Maestro</span>
                    </a>
                    <a href="AdminFinanzas" class="nav-item">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"></line><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path></svg>
                        <span>Control Financiero</span>
                    </a>
                    <a href="ResumenDiarioSv" class="nav-item active">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                        <span>Resumen Diario</span>
                    </a>
                    <a href="LogoutSv" class="nav-item logout-link">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" y1="12" x2="9" y2="12"></line></svg>
                        <span>Cerrar Sesión</span>
                    </a>
                </nav>
            </aside>

            <main class="main-content">
                <header class="topbar">
                    <div class="header-left">
                        <button id="menu-toggle" class="mobile-menu-btn">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="3" y1="12" x2="21" y2="12"></line><line x1="3" y1="6" x2="21" y2="6"></line><line x1="3" y1="18" x2="21" y2="18"></line></svg>
                        </button>
                    </div>
                    <div class="profile-menu">
                        <div class="profile-info">
                            <span class="profile-name"><%= usuarioLogeado.getUser_name()%></span>
                            <span class="profile-role"><%= usuarioLogeado.getRol() %></span>
                        </div>
                        <img src="images/usuario.png" class="profile-img" alt="Perfil">
                    </div>
                </header>

                <section class="dashboard">
                    <div class="admin-header-banner">
                        <div class="admin-header-info">
                            <h2>Resumen de Gastos Operativos</h2>
                            <p>Auditoría general de egresos por nómina, maquinaria y fletes.</p>
                        </div>
                    </div>

                    <div class="kpi-container">
                        <div class="kpi-card">
                            <div class="kpi-icon">
                                <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="#121216" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="7" width="20" height="14" rx="2" ry="2"></rect><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"></path></svg>
                            </div>
                            <div class="kpi-data">
                                <p>Transacciones</p>
                                <h3><%= totalTransacciones%></h3>
                            </div>
                        </div>
                        <div class="kpi-card">
                            <div class="kpi-icon icon-danger">
                                <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="#c0392b" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"></line><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path></svg>
                            </div>
                            <div class="kpi-data">
                                <p>Egresos Totales</p>
                                <h3 class="text-danger">C$ <%= String.format("%,.2f", totalEgresos)%></h3>
                            </div>
                        </div>
                    </div>

                    <div class="filter-card">
                        <form action="ResumenDiarioSv" method="GET" class="filter-form">
                            <div class="filter-group">
                                <label for="fechaFiltro">Fecha de Operación:</label>
                                <input type="date" name="fechaFiltro" id="fechaFiltro" value="<%= fechaFiltro%>">
                            </div>

                            <div class="filter-group">
                                <label for="tipoFiltro">Categoría de Gasto:</label>
                                <select name="tipoFiltro" id="tipoFiltro">
                                    <option value="Todos" <%= "Todos".equals(tipoFiltro) ? "selected" : ""%>>Todas las categorías</option>
                                    <option value="Nomina" <%= "Nomina".equals(tipoFiltro) ? "selected" : ""%>>Nómina / Planilla</option>
                                    <option value="Maquinaria" <%= "Maquinaria".equals(tipoFiltro) ? "selected" : ""%>>Uso de Maquinaria</option>
                                    <option value="Flete" <%= "Flete".equals(tipoFiltro) ? "selected" : ""%>>Acarreo / Fletes</option>
                                </select>
                            </div>

                            <div class="filter-group">
                                <label for="idProyecto">Proyecto:</label>
                                <select name="idProyecto" id="idProyecto">
                                    <option value="0">Todos los Proyectos</option>
                                    <%
                                        List<proyectos> listaProyectos = (List<proyectos>) request.getAttribute("ListaProyectos");
                                        Integer idProySeleccionado = (Integer) request.getAttribute("idProyecto");
                                        if (listaProyectos != null) {
                                            for (proyectos p : listaProyectos) {
                                    %>
                                    <option value="<%= p.getProyecto_id()%>" <%= (idProySeleccionado != null && idProySeleccionado == p.getProyecto_id()) ? "selected" : ""%>><%= p.getNombre_proyecto()%></option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                            </div>

                            <button type="submit" class="btn-primary">Filtrar</button>
                        </form>
                    </div>

                    <div class="card result-card">
                        <div class="card-header">
                            <div class="header-title">
                                <h3>Detalle Operativo</h3>
                            </div>
                            <div class="header-actions">
                                <div class="search-box">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                                    <input type="text" id="buscadorTabla" placeholder="Buscar...">
                                </div>
                                <% if (listaGastos != null && !listaGastos.isEmpty()) { %>
                                <button onclick="imprimirNativo()" class="btn-print">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 6 2 18 2 18 9"></polyline><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"></path><rect x="6" y="14" width="12" height="8"></rect></svg>
                                    Imprimir
                                </button>
                                <button onclick="descargarPDF()" class="btn-pdf">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                                    Exportar PDF
                                </button>
                                <% } %>
                            </div>
                        </div>

                        <div class="table-responsive">
                            <table class="vyg-table" id="tablaDashboard">
                                <thead>
                                    <tr>
                                        <th>Referencia</th>
                                        <th>Categoría</th>
                                        <th>Proyecto</th>
                                        <th>Concepto</th>
                                        <th>Fecha</th>
                                        <th class="text-right">Monto (C$)</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        if (listaGastos != null && !listaGastos.isEmpty()) {
                                            for (ResumenGastoDTO gasto : listaGastos) {
                                    %>
                                    <tr class="fila-dato">
                                        <td class="ref-id">#<%= gasto.getIdReferencia()%></td>
                                        <td><%= gasto.getCategoria()%></td>
                                        <td><%= gasto.getNombreProyecto()%></td>
                                        <td><%= gasto.getConcepto()%></td>
                                        <td><%= gasto.getFechaOperacion()%></td>
                                        <td class="text-right text-monto"><%= String.format("%,.2f", gasto.getMonto())%></td>
                                    </tr>
                                    <%
                                        }
                                    } else {
                                    %>
                                    <tr>
                                        <td colspan="6" class="empty-message">No se registraron egresos con los criterios seleccionados.</td>
                                    </tr>
                                    <% }%>
                                </tbody>
                            </table>
                        </div>
                    </div>

                </section>
            </main>
        </div>

        <div id="plantilla-oficial" class="plantilla-oculta">
            <div class="plantilla-header">
                <div class="plantilla-brand">
                    <img src="images/KronosIndustrial.svg" alt="Logo">
                    <div class="brand-text-print">
                        <h1>KRONOS INDUSTRIAL S.A.</h1>
                        <p>Reporte Maestro de Auditoría y Egresos</p>
                        <p>Managua, Nicaragua | RUC: J0310000XXXXXX</p>
                    </div>
                </div>
                <div class="plantilla-meta">
                    <p><strong>Filtro aplicado:</strong> <%= (tipoFiltro == null || tipoFiltro.equals("Todos")) ? "General" : tipoFiltro%></p>
                    <p><strong>Generado por:</strong> <%= usuarioLogeado.getUser_name()%></p>
                    <p><strong>Fecha de Emisión:</strong> <%= fechaImpresion%></p>
                </div>
            </div>

            <div class="plantilla-divisor"></div>

            <table class="plantilla-tabla">
                <thead>
                    <tr>
                        <th>CÓDIGO</th>
                        <th>TIPO</th>
                        <th>CONCEPTO / BENEFICIARIO</th>
                        <th>PROYECTO ASOCIADO</th>
                        <th>FECHA</th>
                        <th class="text-right">MONTO (C$)</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if (listaGastos != null && !listaGastos.isEmpty()) {
                            for (ResumenGastoDTO gasto : listaGastos) {
                    %>
                    <tr>
                        <td class="bold-text"><%= gasto.getCategoria().substring(0, 3).toUpperCase()%>-<%= gasto.getIdReferencia()%></td>
                        <td><%= gasto.getCategoria()%></td>
                        <td><%= gasto.getConcepto()%></td>
                        <td><%= gasto.getNombreProyecto()%></td>
                        <td><%= gasto.getFechaOperacion()%></td>
                        <td class="text-right"><%= String.format("%,.2f", gasto.getMonto())%></td>
                    </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>

            <div class="plantilla-totales">
                <span class="total-label">TOTAL GENERAL:</span>
                <span class="total-monto">C$ <%= String.format("%,.2f", totalEgresos)%></span>
            </div>

            <div class="plantilla-firmas">
                <div class="firma-caja">
                    <div class="linea-firma"></div>
                    <p class="firma-titulo">PREPARADO Y AUDITADO POR</p>
                    <p class="firma-sub"><%= usuarioLogeado.getUser_name()%> (Administrador)</p>
                </div>
                <div class="firma-caja">
                    <div class="linea-firma"></div>
                    <p class="firma-titulo">VISTO BUENO / DIRECCIÓN GENERAL</p>
                    <p class="firma-sub">Firma Autorizada</p>
                </div>
            </div>
        </div>

    </body>
</html>