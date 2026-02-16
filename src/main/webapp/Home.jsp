<%-- 
    Document   : Home
    Created on : 2 feb 2026, 9:08:54 p.m.
    Author     : Benja
--%>

<%@page import="java.util.List"%>
<%@page import="model.trabajadores"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%@ page import="model.Usuarios" %>

<%
    // --- LÓGICA DE SEGURIDAD ---
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;

    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Validar Rol (Asegúrate que coincida con tu BD)
    if (!user.getRol().equalsIgnoreCase("Trabajador")) {
        response.sendRedirect("AccDen.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Usuario | Gestión de Proyectos</title>
    
    <link rel="stylesheet" href="CSS/Empleados.css">
</head>
<body>

    <div class="admin-container">
        
        <aside class="sidebar">
           <div class="sidebar-header">
        <img src="images/vyg.svg" alt="Logo VyG" class="logo-img">
        <h2>VyGApps</h2>
    </div>
            <nav>
                <a href="#" class="menu-item active">
                    <span class="menu-icon">👤</span> Mi Perfil
                </a>
                <a href="#" class="menu-item">
                    <span class="menu-icon">📅</span> Asistencia
                </a>
                <a href="#" class="menu-item">
                    <span class="menu-icon">💰</span> Mis Pagos
                </a>
                <a href="#" class="menu-item">
                    <span class="menu-icon">📂</span> Proyectos
                </a>
            </nav>
        </aside>

        <main class="main-content">
            
            <header class="header">
                <div class="header-title">
                    <%
                           
                            List<trabajadores> ListaT = (List<trabajadores> ) request.getAttribute("ListaT");
                                
                            for(trabajadores t: ListaT)
                            {
                    %>
                    <h1>Hola, <%= t.getFull_name()%></h1>
                    
                 
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
                            <span><%= t.getFull_name() %></span>
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
                     <%}%><!--termina el foreach de listaT-->
                <div class="card">
                    <div class="card-header">
                        <h3>Registrar Asistencia</h3>
                        <span>⏱️</span>
                    </div>
                    <div class="attendance-box">
                        <p style="margin-bottom: 10px; color:#666; font-size:13px;">Hora actual del servidor</p>
                        
                        <div class="time-display">
                            <%= new java.text.SimpleDateFormat("HH:mm").format(new java.util.Date()) %>
                        </div>
                        
                        <form action="AsistenciaServlet" method="POST">
                            <input type="hidden" name="accion" value="marcar_entrada">
                            <button type="submit" class="btn-check-in">
                                Marcar Entrada
                            </button>
                        </form>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <h3>Últimos Pagos</h3>
                        <span>💳</span>
                    </div>
                    <table class="table-container">
                        <thead>
                            <tr>
                                <th>Fecha</th>
                                <th>Concepto</th>
                                <th>Monto</th>
                                <th>Estado</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>30/09/2023</td>
                                <td>Nómina Septiembre</td>
                                <td>$1,200.00</td>
                                <td><span class="status-paid">Pagado</span></td>
                            </tr>
                            <tr>
                                <td>15/09/2023</td>
                                <td>Bono Proyecto X</td>
                                <td>$150.00</td>
                                <td><span class="status-paid">Pagado</span></td>
                            </tr>
                            <tr>
                                <td>30/10/2023</td>
                                <td>Nómina Octubre</td>
                                <td>$1,200.00</td>
                                <td><span class="status-pending">Pendiente</span></td>
                            </tr>
                        </tbody>
                    </table>
                </div>

            </div> </main>
    </div>

</body>
</html>