<%-- 
    Document   : MisPagos
    Created on : 11 abr 2026
    Author     : Benja
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="DTO.PagoDTO"%>
<%@page import="java.util.List"%>
<%@page import="model.Usuarios"%>

<%
    // --- LÓGICA DE SEGURIDAD ---
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
    
    if (user == null || !user.getRol().equalsIgnoreCase("Trabajador")) {
        response.sendRedirect("login.jsp");
        return;
    }

    // --- RECUPERACIÓN DE DATOS ---
    List<PagoDTO> listaHistorialPagos = (List<PagoDTO>) request.getAttribute("ListaHistorialPagos");
    
    double totalGanado = 0;
    double totalPendiente = 0;
    int nominasPagadas = 0;

    if (listaHistorialPagos != null) {
        for (PagoDTO p : listaHistorialPagos) {
            if ( p.getEstado().equalsIgnoreCase("Autorizado") || p.getEstado().equalsIgnoreCase("Pagado")) {
                totalGanado += p.getMonto();
                nominasPagadas++;
            } else {
                totalPendiente += p.getMonto();
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Pagos | VyGApps</title>
    
    <link rel="stylesheet" href="CSS/Empleados.css">
    <link rel="stylesheet" href="CSS/MisPagos.css"> 
    <script src="JS/menu-movil.js" defer></script>
    <link rel="icon" href="images/vyg.svg" type="image/png">

    <!-- Lucide Icons CDN -->
    <script src="JS/lucide.min.js"></script>
</head>
<body>

    <div class="admin-container">
        
        <div class="overlay" id="sidebarOverlay"></div>

        <aside class="sidebar" id="sidebar">
            <div class="sidebar-header">
                <img src="images/vyg.svg" alt="Logo VyG Inversiones" class="logo-img">
                <h2 style="font-size: 18px;">VyGApps</h2>
            </div>
            <nav>
                <a href="Home" class="menu-item"> 
                    <span class="menu-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg></span> Mi Perfil
                </a>
                <a href="HistorialAsistenciaSv" class="menu-item">
                    <span class="menu-icon"><i data-lucide="calendar" style="width: 20px; height: 20px"></i></span> Asistencia
                </a>
                <a href="MisPagosSv" class="menu-item active">
                    <span class="menu-icon"><i data-lucide="dollar-sign" style="width: 20px; height: 20px"></i></span> Mis Pagos
                </a>
                <a href="ProyectosTrabajador" class="menu-item">
                    <span class="menu-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path></svg></span> Proyectos
                </a>
            </nav>
        </aside>

        <main class="main-content">
            <header class="header">
                <div class="header-left" style="display: flex; align-items: center; gap: 15px;">
                    <button id="menu-toggle" class="mobile-menu-btn"><i data-lucide="menu" style="width: 24px; height: 24px"></i></button>
                    <div class="header-title">
                        <h1>Historial de Nóminas</h1>
                        <span>Detalle completo de tus ingresos y retribuciones.</span>
                    </div>
                </div>
            </header>

            <div class="kpi-finance-container">
                <div class="kpi-finance-card success">
                    <div class="finance-icon"><i data-lucide="dollar-sign" style="width: 20px; height: 20px"></i></div>
                    <div class="finance-data">
                        <p>Total Ingresado</p>
                        <h3>C$ <%= String.format("%,.2f", totalGanado) %></h3>
                    </div>
                </div>
                
                <div class="kpi-finance-card warning">
                    <div class="finance-icon"><i data-lucide="clock" style="width: 20px; height: 20px"></i></div>
                    <div class="finance-data">
                        <p>Saldo Pendiente</p>
                        <h3>C$ <%= String.format("%,.2f", totalPendiente) %></h3>
                    </div>
                </div>

                <div class="kpi-finance-card">
                    <div class="finance-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg></div>
                    <div class="finance-data">
                        <p>Nóminas Procesadas</p>
                        <h3><%= nominasPagadas %> recibos</h3>
                    </div>
                </div>
            </div>

            <div class="card" style="padding: 0; border-radius: 12px; overflow-x: auto;">
                <table class="table-finance" style="min-width: 600px;">
                    <thead>
                        <tr>
                            <th>ID Nómina</th>
                            <th>Periodo Evaluado</th>
                            <th>Monto Neto</th>
                            <th>Estado</th>
                            <th style="text-align: center;">Acción</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            if (listaHistorialPagos != null && !listaHistorialPagos.isEmpty()) {
                                for (PagoDTO pago : listaHistorialPagos) {
                        %>
                        <tr>
                            <td><strong>#<%= String.format("%04d", pago.getIdPago()) %></strong></td>
                            <td>Del <strong><%= pago.getPeriodoInicio() %></strong> al <strong><%= pago.getPeriodoFin() %></strong></td>
                            <td style="font-weight: bold; color: #121216;">C$ <%= String.format("%,.2f", pago.getMonto()) %></td>
                            <td>
                                <% if (pago.getEstado().equalsIgnoreCase("Autorizado") || pago.getEstado().equalsIgnoreCase("Pagado")) { %>
                                    <span class="badge-estado badge-pagado"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg> Pagado</span>
                                <% } else { %>
                                    <span class="badge-estado badge-pendiente"><i data-lucide="clock" style="display:inline-block; vertical-align:middle; margin-right:4px; width: 14px; height: 14px"></i> Pendiente</span>
                                <% } %>
                            </td>
                            <td style="text-align: center;">
                                <a href="GenerarReciboPDF?id_pago=<%= pago.getIdPago() %>" target="_blank" class="btn-recibo-pdf">
                                    <img src="images/vyg.svg" alt="Icono" class="pdf-icon-logo">
                                    <span>Ver Recibo</span>
                                </a>
                            </td>
                        </tr>
                        <% 
                                }
                            } else { 
                        %>
                        <tr>
                            <td colspan="5" style="text-align: center; padding: 40px; color: #7f8c8d;">
                                <div style="font-size: 40px; margin-bottom: 10px;"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path></svg></div>
                                No tienes historial de pagos registrado actualmente.
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </main>
    </div>


    <!-- Inicializacion de Lucide Icons -->
    <script>
        lucide.createIcons();
    </script>
</body>
</html>