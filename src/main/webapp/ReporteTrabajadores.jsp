<%-- 
    Document   : ReporteTrabajadores
    Created on : 3 abr 2026, 8:08:43 p.m.
    Author     : Benja
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="DTO.ReporteTrabajadorDTO"%> 
<%@page import="model.Usuarios"%>
<%@page import="model.proyectos"%>


<%
    // Seguridad: Solo Administradores
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
    
    if (user == null || !user.getRol().equalsIgnoreCase("Administrador")) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<ReporteTrabajadorDTO> listaTrabajadores = (List<ReporteTrabajadorDTO>) request.getAttribute("ListaTrabajadores");
    List<proyectos> listaProyectos = (List<proyectos>) request.getAttribute("ListaProyectos"); // Para el select del filtro
    
    // Calcular KPIs rápidos
    int totalTrabajadores = 0;
    int totalActivos = 0;
    double nominaEstimada = 0;

    if(listaTrabajadores != null) {
        totalTrabajadores = listaTrabajadores.size();
        for(ReporteTrabajadorDTO t : listaTrabajadores) {
            if(t.getEstado().equalsIgnoreCase("Activo")) {
                totalActivos++;
                nominaEstimada += t.getSalarioBase(); // Suponiendo salario quincenal
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Reporte de Trabajadores | VyGApps</title>
    <link rel="stylesheet" href="CSS/HistorialAsistencia.css"> <link rel="stylesheet" href="CSS/ReporteTrabajadores.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    <link rel="icon" href="images/vyg.svg" type="image/svg+xml">
</head>
<body>

    <div class="page-wrapper" style="max-width: 1100px;">
        
        <div class="admin-header">
            <div class="profile-info">
                <h2>👷‍♂️ Inteligencia Laboral: Reporte de Trabajadores</h2>
                <p>Auditoría general del personal, asignación de proyectos y estimación de nómina.</p>
            </div>
        </div>

        <div class="kpi-container" id="kpi-section">
            <div class="kpi-card">
                <div class="kpi-icon blue-icon">👥</div>
                <div class="kpi-data">
                    <p>Total Registrados</p>
                    <h3><%= totalTrabajadores %></h3>
                </div>
            </div>
            <div class="kpi-card">
                <div class="kpi-icon green-icon">✅</div>
                <div class="kpi-data">
                    <p>Fuerza Laboral Activa</p>
                    <h3><%= totalActivos %></h3>
                </div>
            </div>
            <div class="kpi-card">
                <div class="kpi-icon orange-icon">💰</div>
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
                <button type="submit" class="btn-filtrar">🔍 Aplicar Filtro</button>
            </form>
        </div>

        <div class="card result-card" id="area-impresion">
            <div class="card-header" style="display: flex; justify-content: space-between; align-items: center;">
                <div>
                    <h3>Directorio del Personal</h3>
                </div>
                <% if(listaTrabajadores != null && !listaTrabajadores.isEmpty()) { %>
                    <button onclick="descargarPDF()" class="btn-pdf">📄 Exportar a PDF</button>
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
                            <td><strong>#<%= t.getIdTrabajador() %></strong></td>
                            <td><%= t.getNombreCompleto() %></td>
                            <td><%= t.getNombreProyecto() %></td>
                            <td style="color: #2c3e50; font-weight: bold;">C$ <%= String.format("%,.2f", t.getSalarioBase()) %></td>
                            <td>
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

        <div style="margin-top: 25px; text-align: left;">
            <a href="AdminPage.jsp" class="btn-back">⬅️ Volver al Panel de Control</a>
        </div>

    </div>

   <script>
    function descargarPDF() {
        var elemento = document.getElementById('area-impresion');
        var btnPdf = document.querySelector('.btn-pdf');
        var contenedorTabla = document.querySelector('.table-responsive');
        
        // 1. Ocultamos el botón
        btnPdf.style.display = 'none';

        // 2. Quitamos el scroll de la tabla temporalmente (Vital para que no salga en blanco)
        var overflowOriginal = "";
        if(contenedorTabla) {
            overflowOriginal = contenedorTabla.style.overflow;
            contenedorTabla.style.overflow = 'visible';
        }

        // 3. Forzamos un fondo blanco (si el fondo es transparente, a veces sale negro o en blanco)
        elemento.style.backgroundColor = '#ffffff';

        var opciones = {
            margin:       10,
            filename:     'Reporte_Fuerza_Laboral_VyG.pdf',
            image:        { type: 'jpeg', quality: 0.98 },
            html2canvas:  { 
                scale: 2, 
                useCORS: true, // Ayuda si tienes fuentes o imágenes externas
                scrollY: 0 // Evita errores si la página está scrolleada hacia abajo
            },
            jsPDF:        { unit: 'mm', format: 'a4', orientation: 'landscape' }
        };

        // 4. Usamos setTimeout para darle al navegador 100 milisegundos para aplicar los cambios visuales antes de tomar la "foto"
        setTimeout(function() {
            html2pdf().set(opciones).from(elemento).save().then(function() {
                // 5. Regresamos todo a la normalidad después de descargar
                btnPdf.style.display = 'block';
                elemento.style.backgroundColor = ''; // Limpiamos el fondo
                if(contenedorTabla) {
                    contenedorTabla.style.overflow = overflowOriginal;
                }
            });
        }, 100);
    }
</script>
</body>
</html>