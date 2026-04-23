<%-- 
    Document   : MisPagos
    Created on : 11 abr 2026, 6:49:35 p.m.
    Author     : Benja
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="DTO.PagoDTO"%>
<%@page import="java.util.List"%>
<%@page import="model.Usuarios"%>

<%
    // --- LÓGICA DE SEGURIDAD ---
    // Verificamos que exista una sesión activa y que el usuario tenga el rol de Trabajador
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
    
    if (user == null || !user.getRol().equalsIgnoreCase("Trabajador")) {
        response.sendRedirect("login.jsp");
        return;
    }

    // --- RECUPERACIÓN DE DATOS ---
    // Obtenemos la lista enviada por el Servlet MisPagosSv
    List<PagoDTO> listaHistorialPagos = (List<PagoDTO>) request.getAttribute("ListaHistorialPagos");
    
    // Variables para el resumen financiero (KPIs)
    double totalGanado = 0;
    double totalPendiente = 0;
    int nominasPagadas = 0;

    if (listaHistorialPagos != null) {
        for (PagoDTO p : listaHistorialPagos) {
            if ( p.getEstado().equalsIgnoreCase("Autorizado")) {
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
    <link rel="icon" href="images/vyg.svg" type="image/png">
</head>
<body>

    <div class="admin-container">
        <aside class="sidebar">
            <div class="sidebar-header">
                <img src="images/vyg.svg" alt="Logo VyG" class="logo-img">
                <h2>VyGApps</h2>
            </div>
            <nav>
                <a href="Home" class="menu-item"> 
                    <span class="menu-icon">👤</span> Mi Perfil
                </a>
                <a href="HistorialAsistenciaSv" class="menu-item">
                    <span class="menu-icon">📅</span> Asistencia
                </a>
                <a href="MisPagosSv" class="menu-item active">
                    <span class="menu-icon">💰</span> Mis Pagos
                </a>
                <a href="ProyectosTrabajador" class="menu-item">
                    <span class="menu-icon">📂</span> Proyectos
                </a>
            </nav>
        </aside>

        <main class="main-content">
            <header class="header">
                <div class="header-title">
                    <h1>Historial de Nóminas</h1>
                    <span>Detalle completo de tus ingresos y retribuciones quincenales.</span>
                </div>
            </header>

            <div class="kpi-finance-container">
                <div class="kpi-finance-card success">
                    <div class="finance-icon">💵</div>
                    <div class="finance-data">
                        <p>Total Ingresado (Histórico)</p>
                        <h3>C$ <%= String.format("%,.2f", totalGanado) %></h3>
                    </div>
                </div>
                
                <div class="kpi-finance-card warning">
                    <div class="finance-icon">⏳</div>
                    <div class="finance-data">
                        <p>Saldo Pendiente</p>
                        <h3>C$ <%= String.format("%,.2f", totalPendiente) %></h3>
                    </div>
                </div>

                <div class="kpi-finance-card">
                    <div class="finance-icon">📑</div>
                    <div class="finance-data">
                        <p>Nóminas Procesadas</p>
                        <h3><%= nominasPagadas %> recibos</h3>
                    </div>
                </div>
            </div>

            <div class="card" style="padding: 0; overflow: hidden; border-radius: 12px;">
                <table class="table-finance">
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
                            <td style="font-weight: bold; color: #2c3e50;">C$ <%= String.format("%,.2f", pago.getMonto()) %></td>
                            <td>
                                <% if (pago.getEstado().equalsIgnoreCase("Autorizado") || pago.getEstado().equalsIgnoreCase("Pagado")) { %>
                                    <span class="badge-estado badge-pagado">✅ Pagado</span>
                                <% } else { %>
                                    <span class="badge-estado badge-pendiente">⏳ Pendiente</span>
                                <% } %>
                            </td>
                            <td style="text-align: center;">
                                <%-- Enlace dinámico al Servlet generador de PDF --%>
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
                                <div style="font-size: 40px; margin-bottom: 10px;">📂</div>
                                No tienes historial de pagos registrado en el sistema actualmente.
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </main>
    </div>

</body>
</html>