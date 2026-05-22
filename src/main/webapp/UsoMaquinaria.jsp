<%-- 
    Document   : UsoMaquinaria
    Created on : 28 feb 2026, 5:36:49 p.m.
    Author     : Benja
--%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="java.util.List"%>
<%@page import="model.trabajadores"%>
<%@page import="model.proyectos"%>
<%@page import="model.maquinas"%>
<%@page import="model.Usuarios"%>

<%
    /**
     * Validación de sesión y control de acceso.
     * @requires sessionActual válida.
     * @requires Rol de usuario = "Supervisor".
     */
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;

    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    if (!user.getRol().equalsIgnoreCase("Supervisor")) {
        response.sendRedirect("AccDen.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registrar Uso de Maquinaria | VyGApps</title>
    
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/UsoMaquinaria.css">
    <script src="JS/menu-movil.js" defer></script>
    <link rel="icon" href="images/vyg.svg" type="image/png">
</head>
<body>

<div class="admin-container">
    <div class="overlay" id="sidebarOverlay"></div>

    <aside class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <img src="images/vyg.svg" alt="VyG Logo" class="sidebar-logo">
            <div class="brand-text">
                <h2>VyGApps</h2>
                <span class="panel-badge" style="background:#eafaf1; color:#27ae60;">Supervisor</span>
            </div>
        </div>
        <nav class="sidebar-nav">
            <a href="SupervisorPage" class="nav-item"><span>Dashboard Operativo</span></a>
            <a href="RegistrarUso" class="nav-item active" style="background-color: #2c3e50;"><span>Registrar Maquinaria</span></a>
            <a href="HistorialUso" class="nav-item"><span>Historial de Uso</span></a>
            <a href="LogoutSv" class="nav-item logout-link"><span>Cerrar Sesión</span></a>
        </nav>
    </aside>

    <main class="main-content">
        <header class="topbar">
            <div class="header-left">
                <button id="menu-toggle" class="mobile-menu-btn">☰</button>
            </div>
            <div class="profile-menu">
                <div class="profile-info">
                    <span class="profile-name"><%= user.getUser_name() %></span>
                    <span class="profile-role">Supervisor</span>
                </div>
                <img src="images/usuario.png" class="profile-img" alt="Perfil">
            </div>
        </header>

        <section class="dashboard">
            <div class="form-wrapper">
                <div class="card form-card">
                    <div class="form-header">
                        <h2>🚜 Registrar Nuevo Uso</h2>
                        <p>Completa los datos operativos de la máquina utilizada hoy.</p>
                    </div>

                    <%--
                        Formulario de registro operativo.
                        @param id_proyect: ID del proyecto seleccionado.
                        @param id_maquinaria: ID de la máquina utilizada.
                        @param id_trabajador: ID del operador asignado.
                        @param fecha, hora_inicio, hora_fin: Tiempos operativos.
                        @param costo_por_hora, combustible, costo_combustible_total: Métricas financieras.
                    --%>
                    <form action="RegistrarUso" method="POST" class="vyg-form">
                        <div class="form-row">
                            <div class="form-group">
                                <label for="id_proyect">Proyecto Asignado:</label>
                                <select name="id_proyect" id="id_proyect" required>
                                    <option value="" disabled selected>Seleccione Proyecto</option>
                                    <% 
                                        List<proyectos> ListaP = (List<proyectos>) request.getAttribute("ListarP");
                                        if (ListaP != null) {
                                            for (proyectos p : ListaP) { 
                                    %>
                                    <option value="<%=p.getProyecto_id()%>"><%=p.getNombre_proyecto()%></option>
                                    <% 
                                            } 
                                        } 
                                    %>
                                </select>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="id_maquinaria">Máquina:</label>
                                <select name="id_maquinaria" id="id_maquinaria" required>
                                    <option value="" disabled selected>Seleccione maquinaria</option>
                                    <% 
                                        List<maquinas> ListaM = (List<maquinas>) request.getAttribute("ListarM");
                                        if (ListaM != null) {
                                            for (maquinas m : ListaM) { 
                                    %>
                                    <option value="<%=m.getId_maquina()%>"><%=m.getMarca()%></option>
                                    <% 
                                            } 
                                        } 
                                    %>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="id_trabajador">Operador (Trabajador):</label>
                                <select name="id_trabajador" id="id_trabajador" required>
                                    <option value="" disabled selected>Seleccione trabajador</option>
                                    <% 
                                        List<trabajadores> ListaT = (List<trabajadores>) request.getAttribute("ListarT");
                                        if (ListaT != null) {
                                            for (trabajadores t : ListaT) { 
                                    %>
                                    <option value="<%=t.getId_trabajador()%>"><%=t.getFull_name()%></option>
                                    <% 
                                            } 
                                        } 
                                    %>
                                </select>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="fecha">Fecha de operación:</label>
                                <input type="date" name="fecha" id="fecha" required>
                            </div>
                            <div class="form-group">
                                <label for="hora_inicio">Hora de Inicio:</label>
                                <input type="time" name="hora_inicio" id="hora_inicio" required>
                            </div>
                            <div class="form-group">
                                <label for="hora_fin">Hora de Fin:</label>
                                <input type="time" name="hora_fin" id="hora_fin" required>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group highlight-financial">
                                <label for="costo_por_hora" class="financial-label">⏱️ Costo por Hora (C$):</label>
                                <input type="number" step="0.01" min="0" name="costo_por_hora" id="costo_por_hora" placeholder="Ej. 500.00" required>
                                <small class="financial-hint">Tarifa operativa de la máquina por cada hora de uso.</small>
                            </div>
                        </div>

                        <hr class="form-divider">

                        <div class="form-row">
                            <div class="form-group">
                                <label for="combustible">Combustible Consumido (Galones):</label>
                                <input type="number" step="0.1" name="combustible" id="combustible" placeholder="Ej. 15.5" required>
                            </div>

                            <div class="form-group highlight-financial">
                                <label for="costo_combustible_total" class="financial-label-alt">💰 Costo Total del Combustible (C$):</label>
                                <input type="number" step="0.01" name="costo_combustible_total" id="costo_combustible_total" placeholder="Ej. 2500.00" required>
                                <small>Monto de la factura para el reporte de gastos del proyecto.</small>
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn-submit">Guardar Registro</button>
                            <a href="SupervisorPage" class="btn-cancel">Cancelar</a>
                        </div>

                    </form>
                </div>
            </div>
        </section>
    </main>
</div>

</body>
</html>