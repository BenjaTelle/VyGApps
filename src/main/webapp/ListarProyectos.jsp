<%-- 
    Document   : ListarProyectos
    Created on : 18 feb 2026
    Author     : Benja
--%>
<%@page import="DTO.ListarProyectosDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Usuarios"%>

<%
    // Lógica de seguridad compartida
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
    
    if (user == null || (!user.getRol().equalsIgnoreCase("Supervisor") && !user.getRol().equalsIgnoreCase("Administrador"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    boolean esAdmin = user.getRol().equalsIgnoreCase("Administrador");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Proyectos Activos | VyGApps</title>
    
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/ListarProyectos.css">
    <script src="JS/menu-movil.js" defer></script>
    <script src="JS/BuscadorListaProyectos.js" defer></script>
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
                <span class="panel-badge"><%= user.getRol() %></span>
            </div>
        </div>

        <nav class="sidebar-nav">
            <a href="<%= esAdmin ? "AdminPage.jsp" : "SupervisorPage" %>" class="nav-item">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="9"></rect><rect x="14" y="3" width="7" height="5"></rect><rect x="14" y="12" width="7" height="9"></rect><rect x="3" y="16" width="7" height="5"></rect></svg>
                <span>Dashboard Maestro</span>
            </a>
            <a href="ListarProyectos" class="nav-item active" style="<%= esAdmin ? "background-color: #2c3e50;" : "" %>">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path></svg>
                <span>Proyectos Activos</span>
            </a>
            <% if(!esAdmin) { %>
            <a href="RegistrarGastoSv" class="nav-item">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"></line><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path></svg>
                <span>Control de Gastos</span>
            </a>
            <% } %>
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
                <div class="welcome">
                    <h1>Proyectos Activos</h1>
                    <span>Listado general y estado operativo de obras.</span>
                </div>
            </div>

            <div class="profile-menu">
                <div class="profile-info">
                    <span class="profile-name"><%= user.getUser_name() %></span>
                    <span class="profile-role"><%= user.getRol() %></span>
                </div>
                <img src="images/usuario.png" class="profile-img" alt="Perfil">
            </div>
        </header>

        <section class="projects-dashboard">
            
            <div class="header-tools">
                <div class="search-box">
                    <svg class="search-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                    <input type="text" id="buscador" placeholder="Buscar proyecto por nombre..." class="search-input">
                </div>
            </div>

            <div class="cards-container">

                <%
                    List<ListarProyectosDTO> lista = (List<ListarProyectosDTO>) request.getAttribute("ListaP");

                    if (lista != null && !lista.isEmpty()) {
                        for (ListarProyectosDTO p : lista) {
                        String mensaje;
                        String nombreSup = p.getNombre_supervisor();
                        
                        if(nombreSup != null && !nombreSup.trim().isEmpty() && !nombreSup.equalsIgnoreCase("null")) {
                            mensaje = nombreSup;
                        } else {
                            mensaje = "<span class='no-supervisor'>Sin asignar</span>";
                        }
                %>

                <div class="project-card">
                    <div class="card-header">
                        <h3 class="project-title"><%= p.getNombre_proyecto() %></h3>
                        
                        <div style="display: flex; gap: 8px; align-items: center;">
                            <span class="status-badge status-active">En Proceso</span>
                            
                            <% if(esAdmin) { %>
                            <button type="button" class="btn-config" title="Configurar Reglas" 
                                    onclick="abrirModalConfig('<%= p.getId() %>', '<%= p.getNombre_proyecto() %>')">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="3"></circle><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path></svg>
                            </button>
                            <% } %>
                        </div>
                    </div>
                    
                    <div class="card-body">
                        <div class="info-group">
                            <span class="info-label">Supervisor Designado</span>
                            <span class="info-value text-dark"><%= mensaje%></span>
                        </div>
                        
                        <div class="info-group financial-group">
                            <span class="info-label">Presupuesto Total</span>
                            <span class="info-value money">C$ <%= String.format("%,.2f", p.getPresupuesto_total()) %></span>
                        </div>
                    </div>

                    <div class="card-footer">
                        <a href="ListarProyectos?id_proyecto=<%= p.getId()%>" class="btn-detail">Ficha Técnica</a>
                        <a href="RegistrarGastoSv?id_proyecto=<%= p.getId()%>" class="btn-expense">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-right:4px;"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                            Agregar Gasto
                        </a>
                    </div>
                </div>

                <%
                        }
                    } else {
                %>
                    <div class="empty-message">
                        <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" style="margin-bottom: 10px; color: #94a3b8;"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path></svg>
                        <p>No hay proyectos registrados en el sistema actualmente.</p>
                    </div>
                <%
                    }
                %>

            </div>
        </section>

    </main>
</div>

<% if(esAdmin) { %>
<div id="modalConfigProyecto" class="modal-overlay">
    <div class="modal-content">
        <div class="modal-header">
            <h3 id="modalConfigTitle">Configurar Reglas</h3>
            <button type="button" class="close-modal" onclick="cerrarModalConfig()">&times;</button>
        </div>
        
        <form action="ConfigurarProyectoSv" method="POST" class="vyg-form">
            <input type="hidden" id="config_id_proyecto" name="id_proyecto" value="">
            
            <div class="form-row">
                <div class="form-group">
                    <label for="config_hora_entrada">Hora de Entrada Oficial</label>
                    <input type="time" id="config_hora_entrada" name="hora_entrada_oficial" value="08:00" required>
                </div>
                <div class="form-group">
                    <label for="config_hora_salida">Hora de Salida Oficial</label>
                    <input type="time" id="config_hora_salida" name="hora_salida_oficial" value="17:00" required>
                </div>
            </div>

            <div class="form-group" style="margin-bottom: 25px;">
                <label for="config_tarifa">Tarifa de Hora Extra (C$ / hr)</label>
                <input type="number" step="0.01" id="config_tarifa" name="tarifa_hora_extra" placeholder="Ej. 100.00" required>
            </div>
            
            <div class="form-actions" style="display: flex; justify-content: flex-end; gap: 10px; border-top: 1px solid #eaeaea; padding-top: 15px;">
                <button type="button" class="btn-cancelar" onclick="cerrarModalConfig()">Cancelar</button>
                <button type="submit" class="btn-generar btn-nomina" style="width: auto;">Guardar Reglas</button>
            </div>
        </form>
    </div>
</div>

<script>
    function abrirModalConfig(id, nombre) {
        document.getElementById('config_id_proyecto').value = id;
        document.getElementById('modalConfigTitle').innerText = 'Configurar: ' + nombre;
        document.getElementById('modalConfigProyecto').classList.add('active');
    }
    function cerrarModalConfig() {
        document.getElementById('modalConfigProyecto').classList.remove('active');
    }
</script>
<% } %>

</body>
</html>