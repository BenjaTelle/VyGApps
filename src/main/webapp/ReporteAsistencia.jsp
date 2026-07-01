<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="DTO.ReporteAsistenciaDTO"%> 
<%@page import="model.Usuarios"%>
<%@page import="model.proyectos"%>

<%
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
    
    if (user == null || !user.getRol().equalsIgnoreCase("Administrador")) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<ReporteAsistenciaDTO> listaAsistencia = (List<ReporteAsistenciaDTO>) request.getAttribute("ListaAsistencia");
    List<proyectos> listaProyectos = (List<proyectos>) request.getAttribute("ListaProyectos");
    
    int totalRegistros = 0;
    int totalPresentes = 0;
    int totalAusencias = 0;

    if(listaAsistencia != null) {
        totalRegistros = listaAsistencia.size();
        for(ReporteAsistenciaDTO a : listaAsistencia) {
            if("Presente".equalsIgnoreCase(a.getEstado()) || "Tardanza".equalsIgnoreCase(a.getEstado())) {
                totalPresentes++;
            } else if ("Ausente".equalsIgnoreCase(a.getEstado())) {
                totalAusencias++;
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reporte de Asistencia | VyGApps</title>
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/ReporteTrabajadores.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    <script src="JS/menu-movil.js" defer></script>
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
                <span class="panel-badge" style="background:#fceceb; color:#c0392b;"><%= user.getRol() %></span>
            </div>
        </div>
        <nav class="sidebar-nav">
            <a href="AdminPage.jsp" class="nav-item"><span class="icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="20" x2="12" y2="10"></line><line x1="18" y1="20" x2="18" y2="4"></line><line x1="6" y1="20" x2="6" y2="16"></line></svg></span><span>Dashboard Maestro</span></a>
            <a href="ReporteAsistenciaSv" class="nav-item active" style="background-color: #2c3e50;"><span class="icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg></span><span>Auditoría Asistencia</span></a>
            <a href="LogoutSv" class="nav-item logout-link"><span class="icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" y1="12" x2="9" y2="12"></line></svg></span><span>Cerrar Sesión</span></a>
        </nav>
    </aside>

    <main class="main-content">
        <header class="topbar">
            <div class="header-left">
                <button id="menu-toggle" class="mobile-menu-btn"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="3" y1="12" x2="21" y2="12"></line><line x1="3" y1="6" x2="21" y2="6"></line><line x1="3" y1="18" x2="21" y2="18"></line></svg></button>
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
            <div class="admin-header-banner" style="background: linear-gradient(135deg, #34495e, #2c3e50);">
                <div class="admin-header-info">
                    <h2>Auditoría de Asistencia</h2>
                    <p>Control de entradas, salidas y puntualidad de la fuerza laboral por rangos de fecha.</p>
                </div>
            </div>

            <div class="kpi-container" id="kpi-section">
                <div class="kpi-card">
                    <div class="kpi-icon blue-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"></path><rect x="8" y="2" width="8" height="4" rx="1" ry="1"></rect></svg></div>
                    <div class="kpi-data">
                        <p>Registros en el periodo</p>
                        <h3><%= totalRegistros %></h3>
                    </div>
                </div>
                <div class="kpi-card">
                    <div class="kpi-icon green-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg></div>
                    <div class="kpi-data">
                        <p>Asistencias (Inc. Tardanzas)</p>
                        <h3><%= totalPresentes %></h3>
                    </div>
                </div>
                <div class="kpi-card">
                    <div class="kpi-icon orange-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="15" y1="9" x2="9" y2="15"></line><line x1="9" y1="9" x2="15" y2="15"></line></svg></div>
                    <div class="kpi-data">
                        <p>Ausencias Marcadas</p>
                        <h3 style="color: #e74c3c;"><%= totalAusencias %></h3>
                    </div>
                </div>
            </div>

            <div class="filter-card">
                <form action="ReporteAsistenciaSv" method="GET" class="filter-form">
                    <div class="filter-group">
                        <label for="fechaInicio">Desde:</label>
                        <input type="date" name="fechaInicio" id="fechaInicio" required>
                    </div>
                    <div class="filter-group">
                        <label for="fechaFin">Hasta:</label>
                        <input type="date" name="fechaFin" id="fechaFin" required>
                    </div>
                    <div class="filter-group">
                        <label for="id_proyecto">Proyecto:</label>
                        <select name="id_proyecto" id="id_proyecto">
                            <option value="0">Todos</option>
                            <% if(listaProyectos != null) { 
                                for(proyectos p : listaProyectos) { %>
                                    <option value="<%= p.getProyecto_id() %>"><%= p.getNombre_proyecto() %></option>
                            <%  } } %>
                        </select>
                    </div>
                    <div class="filter-group">
                        <label for="estado">Estado:</label>
                        <select name="estado" id="estado">
                            <option value="Todos">Todos</option>
                            <option value="Presente">Presente</option>
                            <option value="Tardanza">Tardanza</option>
                            <option value="Ausente">Ausente</option>
                        </select>
                    </div>
                    <button type="submit" class="btn-filtrar">Filtrar Fechas</button>
                </form>
            </div>

            <div class="card result-card" id="area-impresion">
                <div class="card-header" style="display: flex; justify-content: space-between; align-items: center;">
                    <div>
                        <h3>Registro de Movimientos</h3>
                    </div>
                    <% if(listaAsistencia != null && !listaAsistencia.isEmpty()) { %>
                        <button onclick="descargarPDF()" class="btn-pdf">Exportar a PDF</button>
                    <% } %>
                </div>
                
                <div class="table-responsive">
                    <table class="vyg-table">
                        <thead>
                            <tr>
                                <th>Fecha</th>
                                <th>Trabajador</th>
                                <th>Proyecto</th>
                                <th>Entrada</th>
                                <th>Salida</th>
                                <th>Estado</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                if(listaAsistencia != null && !listaAsistencia.isEmpty()) {
                                    for(ReporteAsistenciaDTO a : listaAsistencia) { 
                            %>
                            <tr>
                                <td data-label="Fecha"><strong><%= a.getFecha() %></strong></td>
                                <td data-label="Trabajador"><%= a.getNombreTrabajador() %></td>
                                <td data-label="Proyecto"><%= a.getNombreProyecto() %></td>
                                <td data-label="Entrada"><%= (a.getHoraEntrada() != null) ? a.getHoraEntrada() : "--:--" %></td>
                                <td data-label="Salida"><%= (a.getHoraSalida() != null) ? a.getHoraSalida() : "--:--" %></td>
                                <td data-label="Estado">
                                    <% if("Presente".equalsIgnoreCase(a.getEstado())) { %>
                                        <span class="badge badge-activo" style="background-color: #2ecc71; color: white;">Presente</span>
                                    <% } else if ("Tardanza".equalsIgnoreCase(a.getEstado())) { %>
                                        <span class="badge badge-inactivo" style="background-color: #f1c40f; color: black;">Tardanza</span>
                                    <% } else { %>
                                        <span class="badge" style="background-color: #e74c3c; color: white; padding: 4px 8px; border-radius: 4px; font-size: 0.85em;">Ausente</span>
                                    <% } %>
                                </td>
                            </tr>
                            <% 
                                    }
                                } else { 
                            %>
                            <tr>
                                <td colspan="6" class="empty-message">Seleccione un rango de fechas o ajuste los filtros para ver la asistencia.</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div style="margin-top: 25px; text-align: left; padding-bottom: 30px;">
                <a href="AdminPage.jsp" class="btn-back">Volver al Panel de Control</a>
            </div>
        </section>
    </main>
</div>

<script>
    function descargarPDF() {
        var elemento = document.getElementById('area-impresion');
        var btnPdf = document.querySelector('.btn-pdf');
        var contenedorTabla = document.querySelector('.table-responsive');
        
        btnPdf.style.display = 'none';

        var overflowOriginal = "";
        if(contenedorTabla) {
            overflowOriginal = contenedorTabla.style.overflow;
            contenedorTabla.style.overflow = 'visible';
        }

        elemento.style.backgroundColor = '#ffffff';

        var opciones = {
            margin:       10,
            filename:     'Auditoria_Asistencia_VyG.pdf',
            image:        { type: 'jpeg', quality: 0.98 },
            html2canvas:  { scale: 2, useCORS: true, scrollY: 0 },
            jsPDF:        { unit: 'mm', format: 'a4', orientation: 'landscape' }
        };

        setTimeout(function() {
            html2pdf().set(opciones).from(elemento).save().then(function() {
                btnPdf.style.display = 'block';
                elemento.style.backgroundColor = ''; 
                if(contenedorTabla) {
                    contenedorTabla.style.overflow = overflowOriginal;
                }
            });
        }, 100);
    }
</script>
</body>
</html>
