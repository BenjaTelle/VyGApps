<%-- 
    Document   : GenerarPlanilla
    Author     : Benja
--%>
<%@page import="model.Usuarios"%>
<%@page import="DTO.CicloPlanillaDTO"%>
<%@page import="java.util.List"%>
<%@page import="DTO.PagoNominaDTO"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Lógica de seguridad ESTRICTA (Solo Administradores)
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
    
    if (user == null || !user.getRol().equalsIgnoreCase("Administrador")) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Recuperar los ciclos calculados desde CargarPlanillaSv
    CicloPlanillaDTO cicloAdmin = (CicloPlanillaDTO) request.getAttribute("cicloAdmin");
    CicloPlanillaDTO cicloOp = (CicloPlanillaDTO) request.getAttribute("cicloOperativo");
    
    // Recuperar los historiales de pago
    List<PagoNominaDTO> histAdmin = (List<PagoNominaDTO>) request.getAttribute("historialAdmin");
    List<PagoNominaDTO> histOp = (List<PagoNominaDTO>) request.getAttribute("historialOperativo");
    
    // Formateadores de fecha (Visual y para Base de Datos)
    DateTimeFormatter formatoVisual = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    DateTimeFormatter formatoSQL = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    // --- VARIABLES CICLO ADMINISTRATIVO ---
    String fechaUltimaAdmin = "--";
    String fechaProximaAdmin = "--";
    String sqlInicioAdmin = "";
    String sqlFinAdmin = "";
    String sqlUltimaEjecucionAdmin = "";
    boolean habilitadoAdmin = false;

    if (cicloAdmin != null) {
        fechaUltimaAdmin = cicloAdmin.getUltimaEjecucion().format(formatoVisual);
        fechaProximaAdmin = cicloAdmin.getProximoPago().format(formatoVisual);
        sqlInicioAdmin = cicloAdmin.getUltimaEjecucion().plusDays(1).format(formatoSQL);
        sqlFinAdmin = cicloAdmin.getProximoPago().format(formatoSQL);
        sqlUltimaEjecucionAdmin = cicloAdmin.getUltimaEjecucion().format(formatoSQL);
        habilitadoAdmin = cicloAdmin.isHabilitado();
    }

    // --- VARIABLES CICLO OPERATIVO ---
    String fechaUltimaOp = "--";
    String fechaProximaOp = "--";
    String sqlInicioOp = "";
    String sqlFinOp = "";
    String sqlUltimaEjecucionOp = "";
    boolean habilitadoOp = false;

    if (cicloOp != null) {
        fechaUltimaOp = cicloOp.getUltimaEjecucion().format(formatoVisual);
        fechaProximaOp = cicloOp.getProximoPago().format(formatoVisual);
        sqlInicioOp = cicloOp.getUltimaEjecucion().plusDays(1).format(formatoSQL);
        sqlFinOp = cicloOp.getProximoPago().format(formatoSQL);
        sqlUltimaEjecucionOp = cicloOp.getUltimaEjecucion().format(formatoSQL);
        habilitadoOp = cicloOp.isHabilitado();
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Control de Planilla | VyGApps</title>
    
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/FormulariosGeneracion.css">
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
            <a href="AdminPage.jsp" class="nav-item">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="9"></rect><rect x="14" y="3" width="7" height="5"></rect><rect x="14" y="12" width="7" height="9"></rect><rect x="3" y="16" width="7" height="5"></rect></svg>
                <span>Dashboard Maestro</span>
            </a>
            <a href="AdminFinanzas" class="nav-item">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"></line><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path></svg>
                <span>Control Financiero</span>
            </a>
            
            <div class="nav-section-title" style="color: #94a3b8; font-size: 12px; margin: 15px 0 5px 15px; text-transform: uppercase; font-weight: bold;">Nómina</div>
            
            <a href="#" id="btnGenerarVista" class="nav-item active" style="background-color: #2c3e50;">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                <span>Generar Pagos</span>
            </a>
            
            <a href="#" id="btnHistorialVista" class="nav-item">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="8" y1="6" x2="21" y2="6"></line><line x1="8" y1="12" x2="21" y2="12"></line><line x1="8" y1="18" x2="21" y2="18"></line><line x1="3" y1="6" x2="3.01" y2="6"></line><line x1="3" y1="12" x2="3.01" y2="12"></line><line x1="3" y1="18" x2="3.01" y2="18"></line></svg>
                <span>Historial Detallado</span>
            </a>

            <div style="margin-top: auto;"></div>
            <a href="LogoutSv" class="nav-item logout-link" style="margin-top: 15px;">
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
                    <h1>Módulo de Planillas</h1>
                    <span>Ejecución automatizada y desglose de pagos.</span>
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

            <div id="vistaGenerar" class="generator-wrapper">
                
                <div class="generator-header bg-nomina">
                    <div class="header-content">
                        <h2>Control de Planilla</h2>
                        <p>Gestión automatizada de nóminas operativas y administrativas.</p>
                    </div>
                    <button class="btn-settings" title="Ajustar Ciclos de Pago">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="3"></circle><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path></svg>
                    </button>
                </div>

                <div class="form-card">
                    <div class="info-box info-blue">
                        <svg class="info-icon" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>
                        <div class="info-text">
                            <strong>Ejecución Automatizada</strong>
                            El sistema procesa los pagos en base a los ciclos configurados. El botón de ejecución se habilitará únicamente cuando se alcance la fecha de vencimiento.
                        </div>
                    </div>

                    <div class="cycle-grid">
                        
                        <div class="cycle-card">
                            <div class="cycle-icon">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="8.5" cy="7" r="4"></circle><polyline points="17 11 19 13 23 9"></polyline></svg>
                            </div>
                            <div class="cycle-details">
                                <h3>Planilla Administrativa</h3>
                                <span class="badge badge-14">Ciclo: 14 Días</span>
                                
                                <div class="cycle-dates">
                                    <div class="date-row">
                                        <span>Última Ejecución:</span>
                                        <strong><%= fechaUltimaAdmin %></strong>
                                    </div>
                                    <div class="date-row highlight">
                                        <span>Próximo Pago:</span>
                                        <strong><%= fechaProximaAdmin %></strong>
                                    </div>
                                </div>
                            </div>
                            <form action="GenerarPlanilla" method="POST">
                                <input type="hidden" name="tipo_nomina" value="Administrativa">
                                <input type="hidden" name="dias_ciclo" value="14">
                                <input type="hidden" name="ultima_ejecucion" value="<%= sqlUltimaEjecucionAdmin %>">
                                <input type="hidden" name="fecha_inicio" value="<%= sqlInicioAdmin %>">
                                <input type="hidden" name="proximo_pago" value="<%= sqlFinAdmin %>">
                                
                                <button type="submit" class="btn-generar btn-nomina" <%= !habilitadoAdmin ? "disabled" : "" %>>
                                    Procesar Pago
                                </button>
                            </form>
                        </div>

                        <div class="cycle-card">
                            <div class="cycle-icon icon-operativo">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                            </div>
                            <div class="cycle-details">
                                <h3>Planilla Operativa</h3>
                                <span class="badge badge-15">Ciclo: 15 Días</span>
                                
                                <div class="cycle-dates">
                                    <div class="date-row">
                                        <span>Última Ejecución:</span>
                                        <strong><%= fechaUltimaOp %></strong>
                                    </div>
                                    <div class="date-row highlight">
                                        <span>Próximo Pago:</span>
                                        <strong><%= fechaProximaOp %></strong>
                                    </div>
                                </div>
                            </div>
                            <form action="GenerarPlanilla" method="POST">
                                <input type="hidden" name="tipo_nomina" value="Operativa">
                                <input type="hidden" name="dias_ciclo" value="15">
                                <input type="hidden" name="ultima_ejecucion" value="<%= sqlUltimaEjecucionOp %>">
                                <input type="hidden" name="fecha_inicio" value="<%= sqlInicioOp %>">
                                <input type="hidden" name="proximo_pago" value="<%= sqlFinOp %>">
                                
                                <button type="submit" class="btn-generar btn-nomina" <%= !habilitadoOp ? "disabled" : "" %>>
                                    Procesar Pago
                                </button>
                            </form>
                        </div>

                    </div>
                </div>
            </div>

            <div id="vistaHistorial" class="generator-wrapper" style="display: none;">
                <div class="generator-header" style="background: linear-gradient(135deg, #1e293b 0%, #334155 100%);">
                    <div class="header-content">
                        <h2>Historial de Planillas Pagadas</h2>
                        <p>Desglose de horas extras, justificaciones y montos netos por trabajador.</p>
                    </div>
                </div>

                <div class="form-card" style="padding: 20px; margin-bottom: 20px;">
                    <h3 style="margin-bottom: 15px; color: #1e293b; border-bottom: 2px solid #e2e8f0; padding-bottom: 10px;">Personal Operativo (Obreros/Albañiles)</h3>
                    <div style="overflow-x: auto;">
                        <table style="width: 100%; border-collapse: collapse; text-align: left;">
                            <thead>
                                <tr style="background-color: #f1f5f9; color: #475569; font-size: 14px;">
                                    <th style="padding: 12px; border-bottom: 1px solid #cbd5e1;">Trabajador</th>
                                    <th style="padding: 12px; border-bottom: 1px solid #cbd5e1;">Periodo Pagado</th>
                                    <th style="padding: 12px; border-bottom: 1px solid #cbd5e1; text-align: center;">Días Pagados</th>
                                    <th style="padding: 12px; border-bottom: 1px solid #cbd5e1; text-align: center;">Días Justificados</th>
                                    <th style="padding: 12px; border-bottom: 1px solid #cbd5e1; text-align: right;">Ingreso por Extras</th>
                                    <th style="padding: 12px; border-bottom: 1px solid #cbd5e1; text-align: right; font-weight: bold; color: #0f172a;">Pago Neto Final</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (histOp != null && !histOp.isEmpty()) { 
                                    for (PagoNominaDTO p : histOp) { %>
                                <tr style="border-bottom: 1px solid #e2e8f0; font-size: 14px;">
                                    <td style="padding: 12px; font-weight: bold; color: #334155;"><%= p.getNombreTrabajador() %></td>
                                    <td style="padding: 12px; color: #64748b;"><%= p.getPeriodoInicio() %> al <%= p.getPeriodoFin() %></td>
                                    <td style="padding: 12px; text-align: center;"><%= p.getDiasTrabajados() %></td>
                                    <td style="padding: 12px; text-align: center;"><%= p.getDiasJustificados() %></td>
                                    <td style="padding: 12px; color: #10b981; font-weight: bold; text-align: right;">C$ <%= String.format("%.2f", p.getMontoHorasExtras()) %></td>
                                    <td style="padding: 12px; font-weight: bold; color: #0f172a; text-align: right; background-color: #f8fafc;">C$ <%= String.format("%.2f", p.getMontoPagado()) %></td>
                                </tr>
                                <% } } else { %>
                                <tr><td colspan="6" style="padding: 15px; text-align: center; color: #94a3b8;">No hay pagos registrados para este sector.</td></tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
                
                <div class="form-card" style="padding: 20px;">
                    <h3 style="margin-bottom: 15px; color: #1e293b; border-bottom: 2px solid #e2e8f0; padding-bottom: 10px;">Personal Administrativo (Ingenieros/Dirección)</h3>
                    <div style="overflow-x: auto;">
                        <table style="width: 100%; border-collapse: collapse; text-align: left;">
                            <thead>
                                <tr style="background-color: #f1f5f9; color: #475569; font-size: 14px;">
                                    <th style="padding: 12px; border-bottom: 1px solid #cbd5e1;">Trabajador</th>
                                    <th style="padding: 12px; border-bottom: 1px solid #cbd5e1;">Periodo Pagado</th>
                                    <th style="padding: 12px; border-bottom: 1px solid #cbd5e1; text-align: center;">Días Pagados</th>
                                    <th style="padding: 12px; border-bottom: 1px solid #cbd5e1; text-align: center;">Días Justificados</th>
                                    <th style="padding: 12px; border-bottom: 1px solid #cbd5e1; text-align: right;">Ingreso por Extras</th>
                                    <th style="padding: 12px; border-bottom: 1px solid #cbd5e1; text-align: right; font-weight: bold; color: #0f172a;">Pago Neto Final</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (histAdmin != null && !histAdmin.isEmpty()) { 
                                    for (PagoNominaDTO p : histAdmin) { %>
                                <tr style="border-bottom: 1px solid #e2e8f0; font-size: 14px;">
                                    <td style="padding: 12px; font-weight: bold; color: #334155;"><%= p.getNombreTrabajador() %></td>
                                    <td style="padding: 12px; color: #64748b;"><%= p.getPeriodoInicio() %> al <%= p.getPeriodoFin() %></td>
                                    <td style="padding: 12px; text-align: center;"><%= p.getDiasTrabajados() %></td>
                                    <td style="padding: 12px; text-align: center;"><%= p.getDiasJustificados() %></td>
                                    <td style="padding: 12px; color: #10b981; font-weight: bold; text-align: right;">C$ <%= String.format("%.2f", p.getMontoHorasExtras()) %></td>
                                    <td style="padding: 12px; font-weight: bold; color: #0f172a; text-align: right; background-color: #f8fafc;">C$ <%= String.format("%.2f", p.getMontoPagado()) %></td>
                                </tr>
                                <% } } else { %>
                                <tr><td colspan="6" style="padding: 15px; text-align: center; color: #94a3b8;">No hay pagos registrados para este sector.</td></tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div>

        </section>
    </main>
</div>

<div id="modalAjustes" class="modal-overlay">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Ajustar Parámetros de Ciclo</h3>
            <button type="button" class="close-modal" id="cerrarModalBtn">&times;</button>
        </div>
        <form action="AjustarCicloSv" method="POST" class="vyg-form">
            
            <div class="form-group" style="margin-bottom: 15px;">
                <label for="tipo_nomina_modal">Seleccionar Planilla:</label>
                <select name="tipo_nomina" id="tipo_nomina_modal" required style="width: 100%; padding: 10px; border: 1px solid #cbd5e1; border-radius: 6px; outline: none;">
                    <option value="Administrativa">Planilla Administrativa (Ingenieros/Relevancia)</option>
                    <option value="Operativa">Planilla Operativa (Obreros/Albañiles)</option>
                </select>
            </div>
            
            <div class="form-group" style="margin-bottom: 15px;">
                <label for="dias_ciclo_modal">Días del Ciclo (Frecuencia):</label>
                <input type="number" id="dias_ciclo_modal" name="dias_ciclo" min="7" max="30" value="15" required style="width: 100%; padding: 10px; border: 1px solid #cbd5e1; border-radius: 6px; outline: none;">
            </div>
            
            <div class="form-group" style="margin-bottom: 25px;">
                <label for="ultima_ejecucion_modal">Nueva Fecha Base (Último pago realizado):</label>
                <input type="date" id="ultima_ejecucion_modal" name="ultima_ejecucion" required style="width: 100%; padding: 10px; border: 1px solid #cbd5e1; border-radius: 6px; outline: none;">
            </div>
            
            <div class="form-actions" style="display: flex; justify-content: flex-end; gap: 10px; border-top: none; padding-top: 0;">
                <button type="button" class="btn-cancelar" id="cancelarModalBtn">Cancelar</button>
                <button type="submit" class="btn-generar btn-nomina" style="width: auto;">Guardar Cambios</button>
            </div>
        </form>
    </div>
</div>

<script>
    // --- LÓGICA DEL MODAL ---
    window.addEventListener("load", function() {
        const modal = document.getElementById("modalAjustes");
        const btnAbrir = document.querySelector(".btn-settings");
        const btnCerrar = document.getElementById("cerrarModalBtn");
        const btnCancelar = document.getElementById("cancelarModalBtn");

        if (modal && btnAbrir) {
            btnAbrir.addEventListener("click", function(event) {
                event.preventDefault(); 
                modal.classList.add("active");
            });

            function cerrarModal(event) {
                if (event) event.preventDefault();
                modal.classList.remove("active");
            }

            if (btnCerrar) btnCerrar.addEventListener("click", cerrarModal);
            if (btnCancelar) btnCancelar.addEventListener("click", cerrarModal);

            window.addEventListener("click", function(event) {
                if (event.target === modal) {
                    cerrarModal();
                }
            });
        }
    });

    // --- LÓGICA DE INTERCAMBIO DE VISTAS (SPA) ---
    document.addEventListener("DOMContentLoaded", function() {
        const btnGenerar = document.getElementById("btnGenerarVista");
        const btnHistorial = document.getElementById("btnHistorialVista");
        const vistaGenerar = document.getElementById("vistaGenerar");
        const vistaHistorial = document.getElementById("vistaHistorial");

        btnGenerar.addEventListener("click", function(e) {
            e.preventDefault();
            vistaGenerar.style.display = "block";
            vistaHistorial.style.display = "none";
            btnGenerar.classList.add("active");
            btnGenerar.style.backgroundColor = "#2c3e50";
            btnHistorial.classList.remove("active");
            btnHistorial.style.backgroundColor = "transparent";
        });

        btnHistorial.addEventListener("click", function(e) {
            e.preventDefault();
            vistaGenerar.style.display = "none";
            vistaHistorial.style.display = "block";
            btnHistorial.classList.add("active");
            btnHistorial.style.backgroundColor = "#2c3e50";
            btnGenerar.classList.remove("active");
            btnGenerar.style.backgroundColor = "transparent";
        });
    });
</script>

</body>
</html>
