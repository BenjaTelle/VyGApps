<%-- Document : ListarProyectos Created on : 18 feb 2026 Author : Benja --%>
    <%@page import="DTO.ListarProyectosDTO" %>
        <%@page contentType="text/html" pageEncoding="UTF-8" %>
            <%@page import="java.util.List" %>
                <%@page import="model.Usuarios" %>

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
                        
    <!-- Lucide Icons CDN -->
    <script src="JS/lucide.min.js"></script>
</head>

                        <body>

                            <div class="admin-container">

                                <div class="overlay" id="sidebarOverlay"></div>

                                <aside class="sidebar" id="sidebar">
                                    <div class="sidebar-header">
                                        <img src="images/vyg.svg" alt="VyG Logo" class="sidebar-logo">
                                        <div class="brand-text">
                                            <h2 style="font-size: 18px;">VyGApps</h2>
                                            <span class="panel-badge">
                                                <%= user.getRol() %>
                                            </span>
                                        </div>
                                    </div>

                                    <nav class="sidebar-nav">
                                        <a href="<%= esAdmin ? " AdminPage.jsp" : "SupervisorPage" %>" class="nav-item">
                                            <i data-lucide="layout-dashboard" style="width: 20px; height: 20px"></i>
                                            <span>Dashboard Maestro</span>
                                        </a>
                                        <a href="ListarProyectos" class="nav-item active <%= esAdmin ? "admin-active" : "" %>">
                                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                                stroke-linejoin="round">
                                                <path
                                                    d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z">
                                                </path>
                                            </svg>
                                            <span>Proyectos Activos</span>
                                        </a>
                                        <% if(!esAdmin) { %>
                                            <a href="RegistrarGastoSv" class="nav-item">
                                                <i data-lucide="dollar-sign" style="width: 20px; height: 20px"></i>
                                                <span>Control de Gastos</span>
                                            </a>
                                            <% } %>
                                                <a href="LogoutSv" class="nav-item logout-link">
                                                    <i data-lucide="log-out" style="width: 20px; height: 20px"></i>
                                                    <span>Cerrar Sesión</span>
                                                </a>
                                    </nav>
                                </aside>

                                <main class="main-content">

                                    <header class="topbar">
                                        <div class="header-left">
                                            <button id="menu-toggle" class="mobile-menu-btn">
                                                <i data-lucide="menu" style="width: 24px; height: 24px"></i>
                                            </button>
                                            <div class="welcome">
                                                <h1>Proyectos Activos</h1>
                                                <span>Listado general y estado operativo de obras.</span>
                                            </div>
                                        </div>

                                        <div class="profile-menu">
                                            <div class="profile-info">
                                                <span class="profile-name">
                                                    <%= user.getUser_name() %>
                                                </span>
                                                <span class="profile-role">
                                                    <%= user.getRol() %>
                                                </span>
                                            </div>
                                            <img src="images/usuario.png" class="profile-img" alt="Perfil">
                                        </div>
                                    </header>

                                    <section class="projects-dashboard">

                                        <div class="header-tools">
                                            <div class="search-box">
                                                <i data-lucide="search" class="search-icon" style="width: 18px; height: 18px"></i>
                                                <input type="text" id="buscador"
                                                    placeholder="Buscar proyecto por nombre..." class="search-input">
                                            </div>
                                        </div>

                                        <div class="cards-container">

                                            <% List<ListarProyectosDTO> lista = (List<ListarProyectosDTO>)
                                                    request.getAttribute("ListaP");

                                                    if (lista != null && !lista.isEmpty()) {
                                                    for (ListarProyectosDTO p : lista) {
                                                    String mensaje;
                                                    String nombreSup = p.getNombre_supervisor();

                                                    if(nombreSup != null && !nombreSup.trim().isEmpty() &&
                                                    !nombreSup.equalsIgnoreCase("null")) {
                                                    mensaje = nombreSup;
                                                    } else {
                                                    mensaje = "<span class='no-supervisor'>Sin asignar</span>";
                                                    }
                                                    %>

                                                    <div class="project-card">
                                                        <div class="card-header">
                                                            <h3 class="project-title">
                                                                <%= p.getNombre_proyecto() %>
                                                            </h3>

                                                            <div class="card-status-wrapper">
                                                                <span class="status-badge status-active">En
                                                                    Proceso</span>

                                                                <% if(esAdmin) { %>
                                                                    <button type="button" class="btn-config"
                                                                        title="Configurar Reglas"
                                                                        onclick="abrirModalConfig('<%= p.getId() %>', '<%= p.getNombre_proyecto() %>')">
                                                                        <i data-lucide="settings" style="width: 16px; height: 16px"></i>
                                                                    </button>
                                                                    <% } %>
                                                            </div>
                                                        </div>

                                                        <div class="card-body">
                                                            <div class="info-group">
                                                                <span class="info-label">Supervisor Designado</span>
                                                                <span class="info-value text-dark">
                                                                    <%= mensaje%>
                                                                </span>
                                                            </div>

                                                            <div class="info-group financial-group">
                                                                <span class="info-label">Presupuesto Total</span>
                                                                <span class="info-value money">C$ <%=
                                                                        String.format("%,.2f", p.getPresupuesto_total())
                                                                        %></span>
                                                            </div>
                                                        </div>

                                                        <div class="card-footer">
                                                            <a href="ListarProyectos?id_proyecto=<%= p.getId()%>"
                                                                class="btn-detail">Ficha Técnica</a>
                                                            <a href="RegistrarGastoSv?id_proyecto=<%= p.getId()%>"
                                                                class="btn-expense">
                                                                <i data-lucide="plus" style="width: 14px; height: 14px"></i>
                                                                Agregar Gasto
                                                            </a>
                                                        </div>
                                                    </div>

                                                    <% } } else { %>
                                                        <div class="empty-message">
                                                            <svg width="40" height="40" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="1.5"
                                                                stroke-linecap="round" stroke-linejoin="round">
                                                                <path
                                                                    d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z">
                                                                </path>
                                                            </svg>
                                                            <p>No hay proyectos registrados en el sistema actualmente.
                                                            </p>
                                                        </div>
                                                        <% } %>

                                        </div>
                                    </section>

                                </main>
                            </div>

                            <% if(esAdmin) { %>
                                <div id="modalConfigProyecto" class="modal-overlay">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h3 id="modalConfigTitle">Configurar Reglas</h3>
                                            <button type="button" class="close-modal"
                                                onclick="cerrarModalConfig()">&times;</button>
                                        </div>

                                        <form action="ConfigurarProyectoSv" method="POST" class="vyg-form">
                                            <input type="hidden" id="config_id_proyecto" name="id_proyecto" value="">

                                            <div class="form-row">
                                                <div class="form-group">
                                                    <label for="config_hora_entrada">Hora de Entrada Oficial</label>
                                                    <input type="time" id="config_hora_entrada"
                                                        name="hora_entrada_oficial" value="08:00" required>
                                                </div>
                                                <div class="form-group">
                                                    <label for="config_hora_salida">Hora de Salida Oficial</label>
                                                    <input type="time" id="config_hora_salida"
                                                        name="hora_salida_oficial" value="17:00" required>
                                                </div>
                                            </div>

                                            <div class="form-group mb-25">
                                                <label for="config_tarifa">Tarifa de Hora Extra (C$ / hr)</label>
                                                <input type="number" step="0.01" id="config_tarifa"
                                                    name="tarifa_hora_extra" placeholder="Ej. 100.00" required>
                                            </div>

                                            <div class="form-actions modal-form-actions">
                                                <button type="button" class="btn-cancelar"
                                                    onclick="cerrarModalConfig()">Cancelar</button>
                                                <button type="submit" class="btn-generar btn-nomina btn-width-auto">Guardar Reglas</button>
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

                        
    <!-- Inicializacion de Lucide Icons -->
    <script>
        lucide.createIcons();
    </script>
</body>

                        </html>