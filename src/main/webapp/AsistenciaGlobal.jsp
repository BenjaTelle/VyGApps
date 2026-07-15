<%-- 
    Document   : AsistenciaGlobal
    Created on : 31 mar 2026
    Author     : Benja
--%>
<%@page import="DTO.ListarProyectosDTO"%>
<%@page import="DTO.AsistenciaDTO"%>
<%@page import="java.sql.Time"%>
<%@page import="java.util.List"%>
<%@page import="model.Usuarios"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Validación estricta de seguridad y roles
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
    
    if (user == null || (!user.getRol().equalsIgnoreCase("Supervisor") && !user.getRol().equalsIgnoreCase("Administrador"))) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Control Global de Asistencia | Kronos Industrial</title>
    
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/AsistenciaGlobal.css">
    <script src="JS/menu-movil.js" defer></script>
    <link rel="icon" href="images/KronosIndustrial.svg" type="image/svg+xml">

    <!-- Lucide Icons CDN -->
    <script src="JS/lucide.min.js"></script>
</head>
<body>

<div class="admin-container">

    <div class="overlay" id="sidebarOverlay"></div>

    <aside class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <img src="images/KronosIndustrial.svg" alt="Kronos Industrial Logo" class="sidebar-logo">
            <div class="brand-text">
                <h2 style="font-size: 18px;">Kronos Industrial</h2>
                <span class="panel-badge"><%= user.getRol() %></span>
            </div>
        </div>

        <nav class="sidebar-nav">
            <a href="SupervisorPage" class="nav-item">
                <i data-lucide="layout-dashboard" style="width: 20px; height: 20px"></i>
                <span>Dashboard</span>
            </a>
            <a href="AsistenciaGlobal" class="nav-item active">
                <i data-lucide="calendar" style="width: 20px; height: 20px"></i>
                <span>Asistencias</span>
            </a>
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
                    <h1>Control Global de Asistencia</h1>
                    <span>Monitorización operativa y estado de turnos.</span>
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

        <section class="dashboard">

            <div class="attendance-card">
                
                <div class="card-header">
                    <h2>Registro de Asistencias</h2>
                </div>

                <div class="filter-section">
                    <form action="AsistenciaGlobal" method="GET" class="filter-form">
                        
                        <div class="filter-group">
                            <label for="fechaFiltro">Filtrar por Fecha:</label>
                            <input type="date" id="fechaFiltro" name="fecha" value="<%= request.getParameter("fecha") != null ? request.getParameter("fecha") : "" %>" class="filter-input">
                        </div>

                        <div class="filter-group">
                            <label for="proyectoFiltro">Filtrar por Proyecto:</label>
                            <select id="proyectoFiltro" name="id_proyecto" class="filter-input">
                                <option value="">-- Todos los Proyectos --</option>
                                <%
                                    List<ListarProyectosDTO> proyectos = (List<ListarProyectosDTO>) request.getAttribute("ListaProyectos");
                                    String idProyectoFiltro = request.getParameter("id_proyecto");
                                    
                                    if(proyectos != null) {
                                        for(ListarProyectosDTO p : proyectos) {
                                            String selected = (idProyectoFiltro != null && idProyectoFiltro.equals(String.valueOf(p.getId()))) ? "selected" : "";
                                %>
                                    <option value="<%= p.getId() %>" <%= selected %>><%= p.getNombre_proyecto() %></option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>

                        <div class="filter-actions">
                            <button type="submit" class="btn-filter">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"></polygon></svg>
                                Aplicar
                            </button>
                            <a href="AsistenciaGlobal" class="btn-clear">Limpiar</a>
                        </div>
                    </form>
                </div>

                <div class="table-responsive">
                    <table class="vyg-table">
                        <thead>
                            <tr>
                                <th>Trabajador</th>
                                <th>Fecha</th>
                                <th>Hora de Entrada</th>
                                <th>Hora de Salida</th>
                                <th>Estado del Turno</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<AsistenciaDTO> listaAsistencia = (List<AsistenciaDTO>) request.getAttribute("ListaAsistenciaGlobal");

                                if (listaAsistencia != null && !listaAsistencia.isEmpty()) {
                                    for (AsistenciaDTO a : listaAsistencia) {
                            %>
                            <tr>
                                <td data-label="Trabajador" class="worker-name">
                                    <strong><%= a.getNombreTrabajador() != null ? a.getNombreTrabajador() : "Desconocido" %></strong>
                                </td>
                                
                                <td data-label="Fecha">
                                    <%= a.getFecha() != null ? a.getFecha() : "Sin fecha" %>
                                </td>
                                
                                <td data-label="Entrada" class="time-in">
                                    <i data-lucide="clock" style="vertical-align: middle; margin-right: 4px; width: 14px; height: 14px"></i>
                                    <%= a.getHoraEntrada() != null ? a.getHoraEntrada() : "--:--" %>
                                </td>
                                
                                <td data-label="Salida" class="time-out">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" style="vertical-align: middle; margin-right: 4px;"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="16"></line><line x1="8" y1="12" x2="16" y2="12"></line></svg>
                                    <%= a.getHoraSalida() != null ? a.getHoraSalida() : "<span style='color:#94a3b8; font-size:13px; font-weight:normal;'>En turno</span>" %>
                                </td>
                                
                                <td data-label="Estado" class="observation-cell">
                                    <% if(a.getEstado_turno() != null && a.getEstado_turno().equals("Llegada Tardía")) { %>
                                        <span class="status-badge badge-warning">
                                            Llegada Tardía
                                        </span>
                                    <% } else { %>
                                        <span class="status-badge badge-success">
                                            A Tiempo
                                        </span>
                                    <% } %>

                                    <% if(a.getHorasExtras() > 0) { %>
                                        <span class="status-badge badge-info">
                                            <%= a.getHorasExtras() %> Hrs Extras
                                        </span>
                                    <% } %>

                                    <% if(a.getMarcaAnomala() == 1) { %>
                                        <span class="status-badge badge-danger">
                                            Salida Temprana
                                        </span>
                                    <% } %>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="5" class="empty-cell">No hay registros de asistencia con los filtros seleccionados.</td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
                
                <div id="pagination-controls" class="pagination-container"></div>

                <div class="card-footer" style="display: flex; gap: 15px;">
                    <a href="SupervisorPage" class="btn-back">
                        <i data-lucide="arrow-left" style="margin-right: 5px; vertical-align: bottom; width: 16px; height: 16px"></i>
                        Volver al Panel
                    </a>
                    <a href="BuscarDetalleAsis" class="btn-filter" style="text-decoration: none; display: flex; align-items: center;">
                        <i data-lucide="settings" style="margin-right: 5px; vertical-align: bottom; width: 16px; height: 16px"></i>
                        Ver Detalle Empleado
                    </a>
                </div>

            </div>

        </section>

    </main>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const table = document.querySelector(".vyg-table tbody");
        // Seleccionamos todas las filas excepto la que muestra el mensaje de "No hay registros"
        const rows = table.querySelectorAll("tr:not(:has(.empty-cell))"); 
        
        if (rows.length === 0) return; // Si no hay datos, no hacemos nada

        const rowsPerPage = 10; // Resultados por página (puedes cambiarlo)
        let currentPage = 1;
        const totalPages = Math.ceil(rows.length / rowsPerPage);
        const paginationContainer = document.getElementById("pagination-controls");

        function displayRows(page) {
            const start = (page - 1) * rowsPerPage;
            const end = start + rowsPerPage;

            rows.forEach((row, index) => {
                if (index >= start && index < end) {
                    row.style.display = ""; // Muestra la fila
                } else {
                    row.style.display = "none"; // Oculta la fila
                }
            });
        }

        function setupPagination() {
            paginationContainer.innerHTML = ""; // Limpiamos controles previos

            // Botón Anterior
            const prevBtn = document.createElement("button");
            prevBtn.innerText = "Anterior";
            prevBtn.classList.add("page-btn");
            if (currentPage === 1) prevBtn.disabled = true;
            prevBtn.addEventListener("click", () => {
                if (currentPage > 1) {
                    currentPage--;
                    updatePagination();
                }
            });
            paginationContainer.appendChild(prevBtn);

            // Números de Página
            for (let i = 1; i <= totalPages; i++) {
                const pageBtn = document.createElement("button");
                pageBtn.innerText = i;
                pageBtn.classList.add("page-btn");
                if (i === currentPage) pageBtn.classList.add("active");
                pageBtn.addEventListener("click", () => {
                    currentPage = i;
                    updatePagination();
                });
                paginationContainer.appendChild(pageBtn);
            }

            // Botón Siguiente
            const nextBtn = document.createElement("button");
            nextBtn.innerText = "Siguiente";
            nextBtn.classList.add("page-btn");
            if (currentPage === totalPages) nextBtn.disabled = true;
            nextBtn.addEventListener("click", () => {
                if (currentPage < totalPages) {
                    currentPage++;
                    updatePagination();
                }
            });
            paginationContainer.appendChild(nextBtn);
        }

        function updatePagination() {
            displayRows(currentPage);
            setupPagination();
        }

        // Solo dibujamos la paginación si hay más de 1 página
        if (totalPages > 1) {
            updatePagination();
        }
    });
</script>


    <!-- Inicializacion de Lucide Icons -->
    <script>
        lucide.createIcons();
    </script>
</body>
</html>