<%-- 
    Document   : DetalleAsistenciaTrabajador
    Created on : [Fecha Actual]
    Author     : Benja
--%>
<%@page import="java.util.List"%>
<%@page import="DTO.AsistenciaDTO"%> 
<%@page import="DTO.ResumenAsistenciaDTO"%> 
<%@page import="model.Usuarios"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Lógica de seguridad
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
    
    if (user == null || (!user.getRol().equalsIgnoreCase("Supervisor") && !user.getRol().equalsIgnoreCase("Administrador"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    ResumenAsistenciaDTO resumen = (ResumenAsistenciaDTO) request.getAttribute("DetalleAsistencia");
    List<AsistenciaDTO> historial = (List<AsistenciaDTO>) request.getAttribute("HistorialAsistencia");
    
    if(resumen == null) {
        response.sendRedirect("AsistenciaGlobal.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalle de Asistencia | <%= resumen.getNombreCompleto() %></title>
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/DetalleAsistencia.css">
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
            <img src="images/vyg.svg" alt="VyG Logo" class="sidebar-logo">
            <div class="brand-text">
                <h2 style="font-size: 18px;">VyGApps</h2>
                <span class="panel-badge"><%= user.getRol() %></span>
            </div>
        </div>

        <nav class="sidebar-nav">
            <a href="SupervisorPage" class="nav-item">
                <span class="icon"><i data-lucide="bar-chart-3" style="width: 20px; height: 20px"></i></span>
                <span>Dashboard</span>
            </a>
            <a href="AsistenciaGlobal" class="nav-item active">
                <span class="icon"><i data-lucide="calendar" style="width: 20px; height: 20px"></i></span>
                <span>Asistencias</span>
            </a>
            <a href="LogoutSv" class="nav-item logout-link">
                <span class="icon"><i data-lucide="log-out" style="width: 20px; height: 20px"></i></span>
                <span>Cerrar Sesión</span>
            </a>
        </nav>
    </aside>

    <main class="main-content">

        <header class="topbar">
            <div class="header-left">
                <button id="menu-toggle" class="mobile-menu-btn"><i data-lucide="menu" style="width: 24px; height: 24px"></i></button>
                <div class="welcome">
                    <h1>Detalle de Asistencia</h1>
                    <span>Reporte individual del trabajador.</span>
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

        <div class="worker-profile-header">
            <div class="profile-info-text">
                <h2><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg> <%= resumen.getNombreCompleto() %></h2>
                <p><strong>Cédula:</strong> <%= resumen.getCedula() %> | <strong>Puesto:</strong> <%= resumen.getPuesto() %></p>
                <p><strong>Proyecto Actual:</strong> <i data-lucide="briefcase" style="width: 20px; height: 20px"></i> <%= resumen.getNombreProyecto() %></p>
            </div>
            <button onclick="window.print()" class="btn-print"><i data-lucide="printer" style="width: 20px; height: 20px"></i> Imprimir Reporte</button>
        </div>

        <div class="kpi-grid">
            <div class="kpi-card">
                <span class="kpi-icon"><i data-lucide="calendar" style="width: 20px; height: 20px"></i></span>
                <div class="kpi-data">
                    <h3><%= resumen.getTotalDiasTrabajados() %></h3>
                    <p>Días Trabajados</p>
                </div>
            </div>
            <div class="kpi-card">
                <span class="kpi-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path><line x1="12" y1="9" x2="12" y2="13"></line><line x1="12" y1="17" x2="12.01" y2="17"></line></svg></span>
                <div class="kpi-data">
                    <h3 style="color: #122744;"><%= resumen.getTotalLlegadasTardias() %></h3>
                    <p>Llegadas Tardías</p>
                </div>
            </div>
            <div class="kpi-card">
                <span class="kpi-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><circle cx="12" cy="12" r="6"></circle><circle cx="12" cy="12" r="2"></circle></svg></span>
                <div class="kpi-data">
                    <h3 style="color: #27ae60;"><%= resumen.getPorcentajePuntualidad() %>%</h3>
                    <p>Nivel de Puntualidad</p>
                </div>
            </div>
            <div class="kpi-card">
                <span class="kpi-icon"><i data-lucide="clock" style="width: 20px; height: 20px"></i></span>
                <div class="kpi-data">
                    <h3><%= resumen.getHorasPromedioPorDia() != null ? resumen.getHorasPromedioPorDia() : "0h" %></h3>
                    <p>Promedio Diario</p>
                </div>
            </div>
        </div>

        <div class="card attendance-card">
            <div class="card-header" style="padding: 20px 30px; border-bottom: 1px solid #eee;">
                <h2 style="font-size: 18px; color: var(--primary-color);"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg> Historial Detallado</h2>
            </div>

            <div class="table-responsive">
                <table class="vyg-table">
                    <thead>
                        <tr>
                            <th>Fecha</th>
                            <th>Hora de Entrada</th>
                            <th>Hora de Salida</th>
                            <th>Estado del Turno</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (historial != null && !historial.isEmpty()) {
                                for (AsistenciaDTO a : historial) {
                        %>
                        <tr>
                            <td data-label="Fecha"><strong><%= a.getFecha() %></strong></td>
                            <td data-label="Hora de Entrada" class="time-in"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg> <%= a.getHoraEntrada()%></td>
                            <td data-label="Hora de Salida" class="time-out"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="15" y1="9" x2="9" y2="15"></line><line x1="9" y1="9" x2="15" y2="15"></line></svg> <%= a.getHoraSalida()!= null ? a.getHoraSalida(): "En turno" %></td>
                            <td data-label="Estado del Turno">
                                <% if(a.getEstado_turno()!= null && a.getEstado_turno().equals("Llegada Tardía")) { %>
                                    <span class="badge-warning"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path><line x1="12" y1="9" x2="12" y2="13"></line><line x1="12" y1="17" x2="12.01" y2="17"></line></svg> Llegada Tardía</span>
                                <% } else { %>
                                    <span class="badge-ok"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" style="display:inline-block; vertical-align:middle; margin-right:4px;"><polyline points="20 6 9 17 4 12"></polyline></svg>A tiempo</span>
                                <% } %>
                                
                                <% if(a.getMarcaAnomala() == 1) { %>
                                    <br><span class="badge-danger"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="15" y1="9" x2="9" y2="15"></line><line x1="9" y1="9" x2="15" y2="15"></line></svg> Anómalo / Salida Temp.</span>
                                <% } %>
                                
                                <% if(a.getHorasExtras() > 0) { %>
                                    <br><span class="badge-info"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="16"></line><line x1="8" y1="12" x2="16" y2="12"></line></svg> <%= a.getHorasExtras() %>h Extras</span>
                                <% } %>
                            </td>
                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="4" class="empty-cell" style="text-align: center; padding: 30px; color: #7f8c8d;">
                                No hay registros para este trabajador.
                            </td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
            
            <div class="card-footer">
                <a href="BuscarDetalleAsis" class="btn-back"><i data-lucide="arrow-left" style="width: 20px; height: 20px"></i> Volver al listado </a>
            </div>
        </div>

    </main>
</div>


    <!-- Inicializacion de Lucide Icons -->
    <script>
        lucide.createIcons();
    </script>
</body>
</html>
