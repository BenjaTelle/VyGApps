<%-- 
    Document   : Home
    Created on : 2 feb 2026
    Author     : Benja
--%>

<%@page import="DTO.PagoDTO"%>
<%@page import="DTO.UsuarioDetalle"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Usuarios"%>

<%
    // Control de sesión y roles
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
    
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    if (!user.getRol().equalsIgnoreCase("Trabajador")) {
        response.sendRedirect("AccDen.jsp");
        return;
    }

    // Carga de datos dinámicos
    UsuarioDetalle ud = (UsuarioDetalle) request.getAttribute("usuarioLogueadoDetalle");
    List<PagoDTO> listaPagos = (List<PagoDTO>) request.getAttribute("ListaPagos");
    
    String nombreTrabajador = (ud != null && ud.getTrabajadorAsign() != null) ? ud.getTrabajadorAsign() : user.getUser_name();
    String errorAsistencia = (String) sessionActual.getAttribute("errorAsistencia");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Control | VyGApps</title>
    
    <link rel="stylesheet" href="CSS/Empleados.css">
    <script src="JS/menu-movil.js" defer></script>
    <link rel="icon" href="images/vyg.svg" type="image/svg+xml">

    <!-- Lucide Icons CDN -->
    <script src="JS/lucide.min.js"></script>
</head>
<body>

    <div class="admin-container">
        
        <div class="overlay" id="sidebarOverlay"></div>
        
        <aside class="sidebar" id="sidebar">
            <div class="sidebar-header">
                <img src="images/vyg.svg" alt="Logotipo VyGApps" class="logo-img">
                <h2 style="font-size: 18px;">VyGApps</h2>
            </div>
            <nav class="sidebar-nav">
                <a href="Home" class="menu-item active">
                    <svg class="menu-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                    <span>Panel de Control</span>
                </a>
                <a href="HistorialAsistenciaSv" class="menu-item">
                    <i data-lucide="calendar" class="menu-icon" style="width: 20px; height: 20px"></i>
                    <span>Registro de Asistencia</span>
                </a>
                <a href="MisPagosSv" class="menu-item">
                    <i data-lucide="dollar-sign" class="menu-icon" style="width: 20px; height: 20px"></i>
                    <span>Historial de Nómina</span>
                </a>
                <a href="ProyectosTrabajador" class="menu-item">
                    <svg class="menu-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path></svg>
                    <span>Proyectos Asignados</span>
                </a>
                <a href="Configuracion.jsp" class="menu-item">
                    <i data-lucide="settings" class="menu-icon" style="width: 20px; height: 20px"></i>
                    <span>Configuración de Perfil</span>
                </a>
            </nav>
        </aside>

        <main class="main-content">
            
            <header class="header">
                <div class="header-left">
                    <button id="menu-toggle" class="mobile-menu-btn">
                        <i data-lucide="menu" style="width: 24px; height: 24px"></i>
                    </button>
                    
                    <div class="header-title">
                        <h1>Hola, <%= nombreTrabajador %></h1>
                        <span>Resumen operativo y asistencia diaria</span>
                    </div>
                </div>

                <div class="user-profile">
                    <img src="images/usuario.png" alt="Foto de perfil" class="user-avatar">
                    <span class="user-info-text"><%= user.getUser_name() %></span>
                    <a href="LogoutSv" class="btn-logout">Cerrar Sesión</a>
                </div>
            </header>

            <div class="dashboard-grid">

                <div class="card">
                    <div class="card-header">
                        <h3>Perfil Operativo</h3>
                        <div class="header-icon icon-orange">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                        </div>
                    </div>
                    <div class="card-content">
                        <div class="info-row">
                            <span class="info-label">Identificador:</span>
                            <span>#<%= user.getId_user()%></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Nombre Completo:</span>
                            <span><%= nombreTrabajador %></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Nivel de Acceso:</span>
                            <span><%= user.getRol() %></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Estado Actual:</span>
                            <span class="status-active">Activo</span>
                        </div>
                    </div>
                </div>
                     
                <div class="card">
                    <div class="card-header">
                        <h3>Control de Asistencia</h3>
                        <div class="header-icon icon-green">
                            <i data-lucide="clock" style="width: 20px; height: 20px"></i>
                        </div>
                    </div>
                    
                    <div class="attendance-box">
                        
                        <% if (errorAsistencia != null) { %>
                            <div class="alert-box">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="flex-shrink: 0;"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path><line x1="12" y1="9" x2="12" y2="13"></line><line x1="12" y1="17" x2="12.01" y2="17"></line></svg>
                                <div>
                                    <strong>Notificación:</strong> <%= errorAsistencia %>
                                    
                                    <% if (errorAsistencia.contains("autorización") || errorAsistencia.contains("antes de la hora")) { %>
                                        <div style="margin-top: 8px;">
                                            <button type="button" class="btn-autorizar-salida" onclick="document.getElementById('modalSalidaTemprana').classList.add('active')">
                                                <i data-lucide="lock" style="width: 16px; height: 16px"></i>
                                                Autorizar Salida
                                            </button>
                                        </div>
                                    <% } %>
                                </div>
                            </div>
                        <% 
                                sessionActual.removeAttribute("errorAsistencia");
                            } 
                        %>

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
                                <input type="text" name="codigo_supervisor" class="input-obra" placeholder="Ingrese código asignado" required autocomplete="off">
                            </div>

                            <button type="submit" class="btn-check-in">
                                Registrar Entrada
                            </button>
                        </form>
                        <% } else { %>
                        <div class="entry-info">
                            <span>Ingreso validado a las: <strong><%= horaEntradaRegistrada %></strong></span>
                        </div>
                        <form action="AsistenciaSv" method="POST">
                            <input type="hidden" name="accion" value="marcar_salida">
                            <button type="submit" class="btn-check-out">
                                Registrar Salida
                            </button>
                        </form>
                        <% } %>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <h3>Últimas Nóminas</h3>
                        <div class="header-icon icon-blue">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="1" y="4" width="22" height="16" rx="2" ry="2"></rect><line x1="1" y1="10" x2="23" y2="10"></line></svg>
                        </div>
                    </div>
                    <table class="table-container">
                        <thead>
                            <tr>
                                <th>Periodo Registrado</th>
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
                                        <span class="badge-pagado">Procesado</span>
                                    <% } else { %>
                                        <span class="badge-pendiente">En Proceso</span>
                                    <% } %>
                                </td>
                            </tr>
                            <% 
                                    }
                                } else { 
                            %>
                            <tr>
                                <td colspan="3" class="empty-table">
                                    No se encontraron registros de nómina recientes.
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

            </div> 
        </main>
    </div>

    <div id="modalSalidaTemprana" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Autorización de Supervisor</h3>
                <button type="button" class="close-modal" onclick="document.getElementById('modalSalidaTemprana').classList.remove('active')">&times;</button>
            </div>
            <form action="AsistenciaSv" method="POST" class="vyg-form">
                <input type="hidden" name="accion" value="marcar_salida">
                
                <div class="form-group" style="margin-bottom: 25px;">
                    <label for="codigo_supervisor_modal">Código Maestro de la Obra:</label>
                    <input type="password" id="codigo_supervisor_modal" name="codigo_supervisor" class="input-modal" required placeholder="Código de validación">
                </div>
                
                <div class="modal-actions">
                    <button type="button" class="btn-cancelar" onclick="document.getElementById('modalSalidaTemprana').classList.remove('active')">Cancelar</button>
                    <button type="submit" class="btn-generar">Validar Salida</button>
                </div>
            </form>
        </div>
    </div>


    <!-- Inicializacion de Lucide Icons -->
    <script>
        lucide.createIcons();
    </script>
</body>
</html>