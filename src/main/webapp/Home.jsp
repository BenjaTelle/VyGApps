<%-- 
    Document   : Home
    Created on : 2 feb 2026, 9:08:54 p.m.
    Author     : Benja
--%>

<%@page import="DTO.PagoDTO"%>
<%@page import="DTO.UsuarioDetalle"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Usuarios"%>

<%
    // --- LÓGICA DE SEGURIDAD ---
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
    
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Validar Rol
    if (!user.getRol().equalsIgnoreCase("Trabajador")) {
        response.sendRedirect("AccDen.jsp");
        return;
    }

    // --- RECUPERACIÓN DE DATOS DINÁMICOS DEL SERVLET ---
    UsuarioDetalle ud = (UsuarioDetalle) request.getAttribute("usuarioLogueadoDetalle");
    List<PagoDTO> listaPagos = (List<PagoDTO>) request.getAttribute("ListaPagos");
    
    String nombreTrabajador = (ud != null && ud.getTrabajadorAsign() != null) ? ud.getTrabajadorAsign() : user.getUser_name();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Usuario | VyGApps</title>
    
    <link rel="stylesheet" href="CSS/Empleados.css">
    <script src="JS/menu-movil.js" defer></script>
    <link rel="icon" href="images/vyg.svg" type="image/png">
</head>
<body>

    <div class="admin-container">
        
        <div class="overlay" id="sidebarOverlay"></div>
        
        <aside class="sidebar" id="sidebar">
            <div class="sidebar-header">
                <img src="images/vyg.svg" alt="Logo VyG" class="logo-img">
                <h2>VyGApps</h2>
            </div>
            <nav class="sidebar-nav">
                <a href="Home.jsp" class="menu-item active">
                    <svg class="menu-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                    <span>Mi Perfil</span>
                </a>
                <a href="HistorialAsistenciaSv" class="menu-item">
                    <svg class="menu-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                    <span>Asistencia</span>
                </a>
                <a href="MisPagosSv" class="menu-item">
                    <svg class="menu-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"></line><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path></svg>
                    <span>Mis Pagos</span>
                </a>
                <a href="ProyectosTrabajador" class="menu-item">
                    <svg class="menu-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path></svg>
                    <span>Proyectos</span>
                </a>
            </nav>
        </aside>

        <main class="main-content">
            
            <header class="header">
                <div class="header-left">
                    <button id="menu-toggle" class="mobile-menu-btn">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="3" y1="12" x2="21" y2="12"></line><line x1="3" y1="6" x2="21" y2="6"></line><line x1="3" y1="18" x2="21" y2="18"></line></svg>
                    </button>
                    
                    <div class="header-title">
                        <h1>Hola, <%= nombreTrabajador %></h1>
                        <span>Bienvenido a tu panel de control</span>
                    </div>
                </div>

                <div class="user-profile">
                    <img src="images/usuario.png" alt="Perfil" class="user-avatar">
                    <span class="user-info-text"><%= user.getUser_name() %></span>
                    <a href="LogoutSv" class="btn-logout">Salir</a>
                </div>
            </header>

            <div class="dashboard-grid">

                <div class="card">
                    <div class="card-header">
                        <h3>Mi Información</h3>
                        <div class="header-icon icon-orange">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                        </div>
                    </div>
                    <div class="card-content">
                        <div class="info-row">
                            <span class="info-label">ID Usuario:</span>
                            <span>#<%= user.getId_user()%></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Nombre:</span>
                            <span><%= nombreTrabajador %></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Rol:</span>
                            <span><%= user.getRol() %></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Estado:</span>
                            <span class="status-active">● Activo</span>
                        </div>
                    </div>
                </div>
                     
                <div class="card">
                    <div class="card-header">
                        <h3>Registrar Asistencia</h3>
                        <div class="header-icon icon-green">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                        </div>
                    </div>
                    <div class="attendance-box">
                        <p class="time-label">Hora actual del servidor</p>
                        <div class="time-display">
                            <%= new java.text.SimpleDateFormat("HH:mm").format(new java.util.Date()) %>
                        </div>
                        
                        <% 
                            String horaEntradaRegistrada = (String) sessionActual.getAttribute("horaEntradaRegistrada"); 
                            if (horaEntradaRegistrada == null) {
                        %>
                        <form action="AsistenciaSv" method="POST">
                            <input type="hidden" name="accion" value="marcar_entrada">
                            
                            <div class="input-group">
                                <input type="text" name="codigo_supervisor" class="input-obra" placeholder="Ingrese código de obra" required>
                            </div>

                            <button type="submit" class="btn-check-in">
                                Marcar Entrada
                            </button>
                        </form>
                        <% } else { %>
                        <div class="entry-info">
                            <span>Entraste hoy a las: <strong><%= horaEntradaRegistrada %></strong></span>
                        </div>
                        <form action="AsistenciaSv" method="POST">
                            <input type="hidden" name="accion" value="marcar_salida">
                            <button type="submit" class="btn-check-out">
                                Marcar Salida
                            </button>
                        </form>
                        <% } %>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <h3>Últimos Pagos (Nóminas)</h3>
                        <div class="header-icon icon-blue">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="1" y="4" width="22" height="16" rx="2" ry="2"></rect><line x1="1" y1="10" x2="23" y2="10"></line></svg>
                        </div>
                    </div>
                    <table class="table-container">
                        <thead>
                            <tr>
                                <th>Periodo</th>
                                <th>Monto</th>
                                <th>Estado</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                if (listaPagos != null && !listaPagos.isEmpty()) {
                                    for (PagoDTO pago : listaPagos) {
                            %>
                            <tr>
                                <td><%= pago.getPeriodoInicio() %> al <%= pago.getPeriodoFin() %></td>
                                <td class="monto-bold">C$ <%= String.format("%,.2f", pago.getMonto()) %></td>
                                <td>
                                    <% if (pago.getEstado().equalsIgnoreCase("Autorizado")) { %>
                                        <span class="badge-pagado">Pagado</span>
                                    <% } else { %>
                                        <span class="badge-pendiente">Pendiente</span>
                                    <% } %>
                                </td>
                            </tr>
                            <% 
                                    }
                                } else { 
                            %>
                            <tr>
                                <td colspan="3" class="empty-table">
                                    No hay nóminas registradas para este periodo.
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

            </div> 
        </main>
    </div>

</body>
</html>