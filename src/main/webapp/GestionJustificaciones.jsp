<%-- 
    Sistema de Gestión Operativa - VyGApps
    Document   : GestionJustificaciones
    Created on : 31 may 2026, 7:54:46 p.m.
    Author     : Benja
    Todos los derechos morales reservados © 2026
--%>

<%@page import="java.util.List"%>
<%@page import="model.Usuarios"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
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
    <title>Gestión de Justificaciones | VyGApps</title>
    
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/GestionJustificaciones.css">
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
                <i data-lucide="layout-dashboard" style="width: 20px; height: 20px"></i>
                <span>Dashboard</span>
            </a>
            <a href="AsistenciaGlobal" class="nav-item">
                <i data-lucide="calendar" style="width: 20px; height: 20px"></i>
                <span>Asistencias</span>
            </a>
            <a href="GestionJustificaciones" class="nav-item active">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                <span>Justificaciones</span>
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
                    <h1>Gestión de Justificaciones</h1>
                    <span>Revisión y resolución de incidencias operativas.</span>
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

            <div class="data-card">
                
                <div class="card-header">
                    <h2>Incidencias Pendientes de Revisión</h2>
                </div>

                <div class="table-responsive">
                    <table class="vyg-table">
                        <thead>
                            <tr>
                                <th>Trabajador</th>
                                <th>Fecha</th>
                                <th>Tipo de Incidencia</th>
                                <th>Detalle Registrado</th>
                                <th>Acción</th>
                            </tr>
                        </thead>
                    <tbody>
                            <%
                                List<DTO.IncidenciaDTO> lista = (List<DTO.IncidenciaDTO>) request.getAttribute("ListaIncidencias");

                                if (lista != null && !lista.isEmpty()) {
                                    for (DTO.IncidenciaDTO inc : lista) {
                                        // Generar ID compuesto para el modal
                                        String idCompuesto = inc.getIdTrabajador() + "_" + inc.getFecha().toString();
                            %>
                            <tr>
                                <td data-label="Trabajador" class="worker-name">
                                    <strong><%= inc.getNombreTrabajador() %></strong>
                                </td>
                                <td data-label="Fecha">
                                    <%= inc.getFecha() %>
                                </td>
                                <td data-label="Tipo">
                                    <span class="status-badge badge-danger"><%= inc.getTipoIncidencia() %></span>
                                </td>
                                <td data-label="Detalle">
                                    <%= inc.getDetalle() %>
                                </td>
                                <td data-label="Acción">
                                        <button type="button" class="btn-resolver" onclick="abrirModalResolucion('<%= idCompuesto %>', '<%= inc.getNombreTrabajador() %>', '<%= inc.getTipoIncidencia() %>')">
                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                                        Resolver
                                    </button>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="5" style="text-align: center; color: #94a3b8; padding: 40px;">No hay incidencias pendientes de revisión.</td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>

            </div>

        </section>

    </main>
</div>

<div id="modalResolucion" class="modal-overlay">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Resolución de Incidencia</h3>
            <button type="button" class="close-modal" onclick="cerrarModalResolucion()">&times;</button>
        </div>
        
        <form action="ProcesarJustificacionSv" method="POST" class="vyg-form">
            <input type="hidden" id="id_incidencia" name="id_incidencia" value="">
            
            <div class="info-resumen">
                <span id="texto_resumen" style="font-weight: 600; color: #1e293b;"></span>
            </div>

            <div class="form-group">
                <label for="motivo">Motivo de la Incidencia</label>
                <select id="motivo" name="motivo" class="input-form" required>
                    <option value="">-- Seleccionar Motivo --</option>
                    <option value="Clima/Lluvia">Condiciones Climáticas (Lluvia)</option>
                    <option value="Enfermedad">Enfermedad / Problema de Salud</option>
                    <option value="Permiso Personal">Permiso Personal Autorizado</option>
                    <option value="Problema Transporte">Problema de Transporte</option>
                    <option value="Falta Injustificada">Falta Injustificada</option>
                </select>
            </div>

            <div class="form-group">
                <label for="observaciones">Observaciones (Opcional)</label>
                <textarea id="observaciones" name="observaciones" class="input-form" rows="3" placeholder="Detalles adicionales..."></textarea>
            </div>
            
            <div class="form-group">
                <label>Decisión Final</label>
                <div class="decision-group">
                    <label class="radio-label">
                        <input type="radio" name="estado_resolucion" value="Aprobada" required>
                        <span class="radio-text text-success">Aprobar (No descontar)</span>
                    </label>
                    <label class="radio-label">
                        <input type="radio" name="estado_resolucion" value="Rechazada">
                        <span class="radio-text text-danger">Rechazar (Aplicar descuento)</span>
                    </label>
                </div>
            </div>

            <div class="modal-actions">
                <button type="button" class="btn-cancelar" onclick="cerrarModalResolucion()">Cancelar</button>
                <button type="submit" class="btn-generar">Guardar Resolución</button>
            </div>
        </form>
    </div>
</div>

<script>
    function abrirModalResolucion(id, nombre, tipo) {
        document.getElementById('id_incidencia').value = id;
        document.getElementById('texto_resumen').innerText = "Trabajador: " + nombre + " - Tipo: " + tipo;
        document.getElementById('modalResolucion').classList.add('active');
    }

    function cerrarModalResolucion() {
        document.getElementById('modalResolucion').classList.remove('active');
    }
</script>


    <!-- Inicializacion de Lucide Icons -->
    <script>
        lucide.createIcons();
    </script>
</body>
</html>