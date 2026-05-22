<%-- 
    Document   : RegistrarCamiones
    Created on : 2 mar 2026, 6:09:32 p.m.
    Author     : Benja
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.material"%>
<%@page import="DTO.HistorialUsoDTO"%> 
<%@page import="java.util.List"%>
<%@page import="model.Usuarios"%>

<%
    /**
     * Validación de sesión y control de acceso.
     * @requires sessionActual válida.
     * @requires Rol de usuario = "Supervisor".
     */
    HttpSession sessionActual = request.getSession(false);
    Usuarios usuarioLogeado = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;

    if (usuarioLogeado == null) {
        response.sendRedirect("login.jsp");
        return;
    } 
    
    if (!usuarioLogeado.getRol().equals("Supervisor")) {
        response.sendRedirect("AccDen.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registrar Viaje de Camión | VyGApps</title>
    
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/RegistrarCamiones.css">
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
            <a href="RegistrarCamionesSv" class="nav-item active"><span>Registrar Camiones</span></a>
            <a href="HistorialCamiones" class="nav-item"><span>Historial de Viajes</span></a>
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
                    <span class="profile-name"><%= usuarioLogeado.getUser_name() %></span>
                    <span class="profile-role">Supervisor</span>
                </div>
                <img src="images/usuario.png" class="profile-img" alt="Perfil">
            </div>
        </header>

        <section class="dashboard">
            <div class="form-wrapper">
                <div class="card form-card">
                    <div class="form-header">
                        <h2>🚛 Registrar Viaje de Camión</h2>
                        <p>Controla el ingreso, salida y los costos de flete de los materiales en obra.</p>
                    </div>

                    <%--
                        Formulario de registro de transporte.
                        @param id_uso: ID del registro de maquinaria base.
                        @param id_material: ID del material transportado.
                        @param cantidad_cargada: Volumen o cantidad transportada.
                        @param origen, destino: Rutas del transporte.
                        @param hora_salida, hora_llegada: Horarios operativos.
                        @param costo_flete: Gasto financiero del transporte.
                    --%>
                    <form action="RegistrarCamionesSv" method="POST" class="vyg-form">
                        <div class="form-row">
                            <div class="form-group">
                                <label for="id_uso">Registro de Maquinaria Asociado:</label>
                                <select name="id_uso" id="id_uso" required>
                                    <option value="" disabled selected>Seleccione el registro de maquinaria asociado...</option>
                                    <%
                                        List<HistorialUsoDTO> ListaR = (List<HistorialUsoDTO>) request.getAttribute("ListaUso");
                                        if (ListaR != null) {
                                            for (HistorialUsoDTO uso : ListaR) {
                                    %>
                                    <option value="<%= uso.getIdUso() %>"> 
                                        Registro #<%= uso.getIdUso() %> | Fecha: <%= uso.getFecha() %> | Máquina: <%= uso.getNombreMaquina() %> (<%= uso.getHoraInicio() %> a <%= uso.getHoraFin() %>)
                                    </option>
                                    <% 
                                            }
                                        } 
                                    %>
                                </select>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="id_material">Material Cargado:</label>
                                <select name="id_material" id="id_material" required>
                                    <option value="" disabled selected>Seleccione el material...</option>
                                    <%
                                        List<material> ListaM = (List<material>) request.getAttribute("ListaM");
                                        if (ListaM != null) {
                                            for (material m: ListaM) {
                                    %>
                                    <option value="<%=m.getId_material()%>"><%=m.getNombre_material()%></option>
                                    <% 
                                            }
                                        }
                                    %>
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <label for="cantidad_cargada">Cantidad Cargada (m3):</label>
                                <input type="number" step="0.1" name="cantidad_cargada" id="cantidad_cargada" placeholder="Ej. 12.5" required>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="origen">Origen:</label>
                                <input type="text" name="origen" id="origen" placeholder="Ej. Plantel Central / Proveedor" required>
                            </div>
                            <div class="form-group">
                                <label for="destino">Destino:</label>
                                <input type="text" name="destino" id="destino" placeholder="Ej. Proyecto Km 45" required>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="hora_salida">Hora de Salida:</label>
                                <input type="time" name="hora_salida" id="hora_salida" required>
                            </div>
                            <div class="form-group">
                                <label for="hora_llegada">Hora de Llegada:</label>
                                <input type="time" name="hora_llegada" id="hora_llegada" required>
                            </div>
                        </div>

                        <hr class="form-divider">

                        <div class="form-row">
                            <div class="form-group highlight-financial">
                                <label for="costo_flete">💰 Costo del Flete / Transporte (C$):</label>
                                <input type="number" step="0.01" name="costo_flete" id="costo_flete" placeholder="Ej. 850.00" required>
                                <small>Costo del viaje para sumarlo a los gastos del proyecto.</small>
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn-submit">Guardar Viaje</button>
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