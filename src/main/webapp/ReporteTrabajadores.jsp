<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="DTO.ReporteTrabajadorDTO"%> 
<%@page import="model.Usuarios"%>
<%@page import="model.proyectos"%>

<%
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
    
    if (user == null || !user.getRol().equalsIgnoreCase("Administrador")) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<ReporteTrabajadorDTO> listaTrabajadores = (List<ReporteTrabajadorDTO>) request.getAttribute("ListaTrabajadores");
    List<proyectos> listaProyectos = (List<proyectos>) request.getAttribute("ListaProyectos");
    
    int totalTrabajadores = 0;
    int totalActivos = 0;
    double nominaEstimada = 0;

    if(listaTrabajadores != null) {
        totalTrabajadores = listaTrabajadores.size();
        for(ReporteTrabajadorDTO t : listaTrabajadores) {
            if(t.getEstado().equalsIgnoreCase("Activo")) {
                totalActivos++;
                nominaEstimada += t.getSalarioBase();
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reporte de Trabajadores | VyGApps</title>
    
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/ReporteTrabajadores.css">
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
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
                <span class="panel-badge" style="background: #FDE8E8; color: #991B1B;"><%= user.getRol() %></span>
            </div>
        </div>

        <nav class="sidebar-nav">
            <a href="AdminPage.jsp" class="nav-item">
                <span class="icon"><i data-lucide="bar-chart-3" style="width: 20px; height: 20px"></i></span>
                <span>Dashboard Maestro</span>
            </a>
            <a href="ReporteTrabajadoresSv" class="nav-item active" style="background-color: #121216;">
                <span class="icon"><i data-lucide="users" style="width: 20px; height: 20px"></i></span>
                <span>Reporte Trabajadores</span>
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

            <div class="admin-header-banner" style="background: linear-gradient(135deg, #1E1E24, #121216);">
                <div class="admin-header-info">
                    <h2> Reporte de Trabajadores</h2>
                    <p>Auditoría general del personal, asignación de proyectos y estimación de nómina.</p>
                </div>
            </div>

            <div class="kpi-container" id="kpi-section">
                <div class="kpi-card">
                    <div class="kpi-icon blue-icon"><i data-lucide="users" style="width: 20px; height: 20px"></i></div>
                    <div class="kpi-data">
                        <p>Total Registrados</p>
                        <h3><%= totalTrabajadores %></h3>
                    </div>
                </div>
                <div class="kpi-card">
                    <div class="kpi-icon green-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg></div>
                    <div class="kpi-data">
                        <p>Fuerza Laboral Activa</p>
                        <h3><%= totalActivos %></h3>
                    </div>
                </div>
                <div class="kpi-card">
                    <div class="kpi-icon orange-icon"><i data-lucide="dollar-sign" style="width: 20px; height: 20px"></i></div>
                    <div class="kpi-data">
                        <p>Nómina Base (Activos)</p>
                        <h3>C$ <%= String.format("%,.2f", nominaEstimada) %></h3>
                    </div>
                </div>
            </div>

            <div class="filter-card">
                <form action="ReporteTrabajadoresSv" method="GET" class="filter-form">
                    <div class="filter-group">
                        <label for="id_proyecto">Filtrar por Proyecto:</label>
                        <select name="id_proyecto" id="id_proyecto">
                            <option value="0">Todos los Proyectos</option>
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
                            <option value="Activo">Solo Activos</option>
                            <option value="Inactivo">Solo Inactivos</option>
                        </select>
                    </div>
                    <button type="submit" class="btn-filtrar"><i data-lucide="search" style="width: 20px; height: 20px"></i> Aplicar Filtro</button>
                </form>
            </div>

            <div class="card result-card" id="area-impresion">
                <div class="card-header" style="display: flex; justify-content: space-between; align-items: center;">
                    <div>
                        <h3>Directorio del Personal</h3>
                    </div>
                    <% if(listaTrabajadores != null && !listaTrabajadores.isEmpty()) { %>
                        <button onclick="descargarPDF()" class="btn-pdf"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg> Exportar a PDF</button>
                    <% } %>
                </div>
                
                <div class="table-responsive">
                    <table class="vyg-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Nombre Completo</th>
                                <th>Proyecto Asignado</th>
                                <th>Salario Base (Q)</th>
                                <th>Estado</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                if(listaTrabajadores != null && !listaTrabajadores.isEmpty()) {
                                    for(ReporteTrabajadorDTO t : listaTrabajadores) { 
                            %>
                            <tr>
                                <td data-label="ID"><strong>#<%= t.getIdTrabajador() %></strong></td>
                                <td data-label="Nombre Completo"><%= t.getNombreCompleto() %></td>
                                <td data-label="Proyecto Asignado"><%= t.getNombreProyecto() %></td>
                                <td data-label="Salario Base (Q)" style="color: #121216; font-weight: bold;">C$ <%= String.format("%,.2f", t.getSalarioBase()) %></td>
                                <td data-label="Estado">
                                    <% if(t.getEstado().equalsIgnoreCase("Activo")) { %>
                                        <span class="badge badge-activo">Activo</span>
                                    <% } else { %>
                                        <span class="badge badge-inactivo">Inactivo</span>
                                    <% } %>
                                </td>
                            </tr>
                            <% 
                                    }
                                } else { 
                            %>
                            <tr>
                                <td colspan="5" class="empty-message">No se encontraron trabajadores con los filtros aplicados.</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div style="margin-top: 25px; text-align: left; padding-bottom: 30px;">
                <a href="AdminPage.jsp" class="btn-back"><i data-lucide="arrow-left" style="width: 20px; height: 20px"></i> Volver al Panel de Control</a>
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
            filename:     'Reporte_Fuerza_Laboral_VyG.pdf',
            image:        { type: 'jpeg', quality: 0.98 },
            html2canvas:  { 
                scale: 2, 
                useCORS: true,
                scrollY: 0
            },
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

    <!-- Inicializacion de Lucide Icons -->
    <script>
        lucide.createIcons();
    </script>
</body>
</html>
