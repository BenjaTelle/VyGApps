<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="java.util.List"%>
<%@page import="model.trabajadores"%>
<%@page import="model.proyectos"%>
<%@page import="model.maquinas"%>
<%@page import="model.Usuarios"%>
<%@page import="model.material"%>

<%
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
    <title>Registrar Uso de Maquinaria | V&G Ingenieros</title>
    
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/UsoMaquinaria.css">
    <script src="JS/menu-movil.js" defer></script>
    <link rel="icon" href="images/vygLogo.svg" type="image/png">
    
    <style>
        .hidden-section {
            display: none;
            background: #f8f9fa;
            border-left: 4px solid #3498db;
            padding: 20px;
            margin-top: 20px;
            border-radius: 8px;
        }
    </style>

    <!-- Lucide Icons CDN -->
    <script src="JS/lucide.min.js"></script>
</head>
<body>

<div class="admin-container">
    <div class="overlay" id="sidebarOverlay"></div>

    <aside class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <img src="images/vygLogo.svg" alt="V&G Ingenieros Logo" class="sidebar-logo">
            <div class="brand-text">
                <h2 style="font-size: 18px;">V&G Ingenieros</h2>
                <span class="panel-badge" style="background:#eafaf1; color:#27ae60;"><%= user.getRol() %></span>
            </div>
        </div>
        <nav class="sidebar-nav">
            <a href="SupervisorPage" class="nav-item"><span>Dashboard Operativo</span></a>
            <a href="RegistrarUso" class="nav-item active" style="background-color: #121216;"><span>Registrar Maquinaria</span></a>
            <a href="HistorialUso" class="nav-item"><span>Historial de Uso</span></a>
            <a href="LogoutSv" class="nav-item logout-link"><span>Cerrar Sesión</span></a>
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
            <div class="form-wrapper">
                <div class="card form-card">
                    <div class="form-header">
                        <h2><i data-lucide="briefcase" style="width: 20px; height: 20px"></i> Registrar Nuevo Uso</h2>
                        <p>Completa los datos operativos de la máquina utilizada hoy.</p>
                    </div>

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
                                <select name="id_maquinaria" id="id_maquinaria" required onchange="adaptarFormulario()">
                                    <option value="" data-tipo="" disabled selected>Seleccione maquinaria</option>
                                    <% 
                                        List<maquinas> ListaM = (List<maquinas>) request.getAttribute("ListarM");
                                        if (ListaM != null) {
                                            for (maquinas m : ListaM) { 
                                    %>
                                    <option value="<%=m.getId_maquina()%>" data-tipo="<%=m.getTipo_maquina()%>"><%=m.getMarca()%> - <%=m.getTipo_maquina()%></option>
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
                                <label for="costo_por_hora" class="financial-label"><i data-lucide="clock" style="width: 20px; height: 20px"></i> Costo por Hora (C$):</label>
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
                                <label for="costo_combustible_total" class="financial-label-alt"><i data-lucide="dollar-sign" style="width: 20px; height: 20px"></i> Costo Total del Combustible (C$):</label>
                                <input type="number" step="0.01" name="costo_combustible_total" id="costo_combustible_total" placeholder="Ej. 2500.00" required>
                            </div>
                        </div>
                        
                        <!-- SECCIÓN DINÁMICA DE TRANSPORTE (OCULTA POR DEFECTO) -->
                        <div id="contenedor_opcional_viaje" style="display: none; margin-top: 20px;">
                            <div class="form-group" style="background: #eafaf1; padding: 15px; border-radius: 8px; border-left: 4px solid #27ae60;">
                                <label style="display: flex; align-items: center; cursor: pointer; margin: 0; color: #121216; font-weight: bold;">
                                    <input type="checkbox" name="incluir_viaje" id="incluir_viaje" onchange="toggleDetallesViaje()" style="width: 20px; height: 20px; margin-right: 10px;">
                                    ¿Registrar detalles de carga/viaje para este turno?
                                </label>
                            </div>
                            
                            <div id="seccion_transporte" class="hidden-section" style="margin-top: 10px;">
                                <h3><i data-lucide="briefcase" style="width: 20px; height: 20px"></i> Detalles de Carga / Viaje</h3>
                                
                                <div class="form-row">
                                    <div class="form-group" id="grupo_material">
                                        <label for="id_material">Material Transportado:</label>
                                        <select name="id_material" id="id_material">
                                            <option value="" disabled selected>Seleccione material</option>
                                            <% 
                                                List<material> listaMateriales = (List<material>) request.getAttribute("ListaMateriales");
                                                if (listaMateriales != null) {
                                                    for (material mat : listaMateriales) { 
                                            %>
                                            <option value="<%=mat.getId_material()%>"><%=mat.getNombre_material()%></option>
                                            <% 
                                                    } 
                                                } 
                                            %>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label for="cantidad_cargada" id="lbl_cantidad">Cantidad Cargada:</label>
                                        <input type="number" step="0.1" name="cantidad_cargada" id="cantidad_cargada" placeholder="Ej. 12.5">
                                    </div>
                                </div>
                                
                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="origen" id="lbl_origen">Punto de Origen:</label>
                                        <input type="text" name="origen" id="origen" placeholder="Ej. Plantel Central">
                                    </div>
                                    <div class="form-group">
                                        <label for="destino" id="lbl_destino">Punto de Destino:</label>
                                        <input type="text" name="destino" id="destino" placeholder="Ej. Proyecto Norte">
                                    </div>
                                </div>
                                
                                <div class="form-row">
                                    <div class="form-group highlight-financial">
                                        <label for="costo_flete">Costo del Flete (C$):</label>
                                        <input type="number" step="0.01" name="costo_flete" id="costo_flete" placeholder="Ej. 850.00">
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="form-actions" style="margin-top: 20px;">
                            <button type="submit" class="btn-submit">Guardar Registro</button>
                            <a href="SupervisorPage" class="btn-cancel">Cancelar</a>
                        </div>

                    </form>
                </div>
            </div>
        </section>
    </main>
</div>

<script>
    function adaptarFormulario() {
        const selectMaquina = document.getElementById('id_maquinaria');
        const opcionSeleccionada = selectMaquina.options[selectMaquina.selectedIndex];
        const tipoMaquina = (opcionSeleccionada.getAttribute('data-tipo') || '').toLowerCase();
        
        const contenedorOpcional = document.getElementById('contenedor_opcional_viaje');
        const checkboxViaje = document.getElementById('incluir_viaje');
        const seccionTransporte = document.getElementById('seccion_transporte');
        const grupoMaterial = document.getElementById('grupo_material');
        const idMaterial = document.getElementById('id_material');
        
        const lblCantidad = document.getElementById('lbl_cantidad');
        const lblOrigen = document.getElementById('lbl_origen');
        const lblDestino = document.getElementById('lbl_destino');
        
        // Reset de estado
        checkboxViaje.checked = false;
        seccionTransporte.style.display = 'none';
        desactivarRequeridos();

        if (tipoMaquina.includes('volquete') || tipoMaquina.includes('camion')) {
            contenedorOpcional.style.display = 'block';
            grupoMaterial.style.display = 'block';
            
            lblCantidad.innerText = 'Cantidad Cargada (m3 / unidades):';
            lblOrigen.innerText = 'Punto de Origen:';
            lblDestino.innerText = 'Punto de Destino:';
            
        } else if (tipoMaquina.includes('pipa') || tipoMaquina.includes('agua')) {
            contenedorOpcional.style.display = 'block';
            grupoMaterial.style.display = 'none';
            idMaterial.value = ""; 
            
            lblCantidad.innerText = 'Capacidad de Agua (Metros Cúbicos):';
            lblOrigen.innerText = 'Punto de Toma de Agua:';
            lblDestino.innerText = 'Punto de Descarga:';
            
        } else {
            // Máquinas que no transportan nada (ej. Retroexcavadora)
            contenedorOpcional.style.display = 'none';
        }
    }

    function toggleDetallesViaje() {
        const checkboxViaje = document.getElementById('incluir_viaje');
        const seccionTransporte = document.getElementById('seccion_transporte');
        const selectMaquina = document.getElementById('id_maquinaria');
        const opcionSeleccionada = selectMaquina.options[selectMaquina.selectedIndex];
        const tipoMaquina = (opcionSeleccionada.getAttribute('data-tipo') || '').toLowerCase();
        
        if (checkboxViaje.checked) {
            seccionTransporte.style.display = 'block';
            activarRequeridos(tipoMaquina);
        } else {
            seccionTransporte.style.display = 'none';
            desactivarRequeridos();
        }
    }
    
    function activarRequeridos(tipoMaquina) {
        const inputsTransporte = document.querySelectorAll('#seccion_transporte input:not([type="hidden"])');
        const idMaterial = document.getElementById('id_material');
        
        inputsTransporte.forEach(input => input.required = true);
        
        if (tipoMaquina.includes('volquete') || tipoMaquina.includes('camion')) {
            idMaterial.required = true;
        } else {
            idMaterial.required = false;
        }
    }
    
    function desactivarRequeridos() {
        const inputsTransporte = document.querySelectorAll('#seccion_transporte input');
        const idMaterial = document.getElementById('id_material');
        
        inputsTransporte.forEach(input => {
            input.required = false;
            input.value = ""; // Limpiar para que no se envíe basura al backend
        });
        idMaterial.required = false;
        idMaterial.value = "";
    }
</script>


    <!-- Inicializacion de Lucide Icons -->
    <script>
        lucide.createIcons();
    </script>
</body>
</html>