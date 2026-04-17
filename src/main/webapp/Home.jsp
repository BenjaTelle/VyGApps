<%-- 
    Document   : Home
    Created on : 2 feb 2026, 9:08:54 p.m.
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
                <a href="Home.jsp" class="menu-item active">
                    <span class="menu-icon">👤</span> Mi Perfil
                </a>
                <a href="HistorialAsistenciaSv" class="menu-item">
                    <span class="menu-icon">📅</span> Asistencia
                </a>
                <a href="MisPagosSv" class="menu-item">
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
                    <h1>Hola, <%= nombreTrabajador %></h1>
                    <span>Bienvenido a tu panel de control</span>
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
                        <span>✏️</span>
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
                            <span style="color: #27ae60; font-weight:bold;">● Activo</span>
                        </div>
                    </div>
                </div>
                     
                <div class="card">
                    <div class="card-header">
                        <h3>Registrar Asistencia</h3>
                        <span>⏱️</span>
                    </div>
                    <div class="attendance-box">
                        <p style="margin-bottom: 10px; color:#666; font-size:13px;">Hora actual del servidor</p>
                        <div class="time-display" style="font-size: 24px; font-weight: bold; margin-bottom: 15px; color: #2c3e50;">
                            <%= new java.text.SimpleDateFormat("HH:mm").format(new java.util.Date()) %>
                        </div>
                        
                        <% 
                            String horaEntradaRegistrada = (String) sessionActual.getAttribute("horaEntradaRegistrada"); 
                            if (horaEntradaRegistrada == null) {
                        %>
                        <form action="AsistenciaSv" method="POST">
                            <input type="hidden" name="accion" value="marcar_entrada">
                            
                            <div style="margin-bottom: 15px;">
                                <input type="text" name="codigo_supervisor" placeholder="Ingrese código de obra" 
                                       required style="width: 100%; padding: 10px; border: 1px solid #bdc3c7; border-radius: 6px; text-transform: uppercase; font-weight: bold; text-align: center; letter-spacing: 2px;">
                            </div>

                            <button type="submit" class="btn-check-in" style="background-color: #27ae60; color: white; border: none; padding: 12px; border-radius: 8px; width: 100%; font-weight: bold; cursor: pointer;">
                                Marcar Entrada
                            </button>
                        </form>
                        <% } else { %>
                        <div class="entry-info" style="background-color: #e8f8f5; padding: 10px; border-radius: 6px; border-left: 4px solid #1abc9c; margin-bottom: 15px; font-size: 14px;">
                            <span>Entraste hoy a las: <strong style="color: #16a085;"><%= horaEntradaRegistrada %></strong></span>
                        </div>
                        <form action="AsistenciaSv" method="POST">
                            <input type="hidden" name="accion" value="marcar_salida">
                            <button type="submit" class="btn-check-out" style="background-color: #e74c3c; color: white; border: none; padding: 12px; border-radius: 8px; width: 100%; font-weight: bold; cursor: pointer;">
                                Marcar Salida
                            </button>
                        </form>
                        <% } %>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <h3>Últimos Pagos (Nóminas)</h3>
                        <span>💳</span>
                    </div>
                    <table class="table-container" style="width: 100%; text-align: left; border-collapse: collapse; margin-top: 15px;">
                        <thead>
                            <tr style="border-bottom: 2px solid #eee;">
                                <th style="padding: 10px 5px;">Periodo</th>
                                <th style="padding: 10px 5px;">Monto</th>
                                <th style="padding: 10px 5px;">Estado</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                if (listaPagos != null && !listaPagos.isEmpty()) {
                                    for (PagoDTO pago : listaPagos) {
                            %>
                            <tr style="border-bottom: 1px solid #eee;">
                                <td style="padding: 10px 5px;">
                                    <%= pago.getPeriodoInicio() %> al <%= pago.getPeriodoFin() %>
                                </td>
                                <td style="padding: 10px 5px; font-weight: bold;">
                                    C$ <%= String.format("%,.2f", pago.getMonto()) %>
                                </td>
                                <td style="padding: 10px 5px;">
                                    <% if (pago.getEstado().equalsIgnoreCase("Autorizado")) { %>
                                        <span style="color:#27ae60; background:#e8f8f5; padding: 3px 8px; border-radius: 12px; font-size: 12px;">Pagado</span>
                                    <% } else { %>
                                        <span style="color:#e67e22; background:#fdf2e9; padding: 3px 8px; border-radius: 12px; font-size: 12px;">Pendiente</span>
                                    <% } %>
                                </td>
                            </tr>
                            <% 
                                    }
                                } else { 
                            %>
                            <tr>
                                <td colspan="3" style="padding: 20px; text-align: center; color: #999; font-size: 13px;">
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