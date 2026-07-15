<%-- 
    Document   : AutorizarGastos
    Created on : 17 may 2026, 8:54:36 p.m.
    Author     : Benja
--%>

<%@page import="model.GastosProyecto"%>
<%@page import="java.util.List"%>
<%@page import="model.Usuarios"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // --- LÓGICA DE SEGURIDAD ESTRICTA (Solo Administradores) ---
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
    
    if (user == null || !user.getRol().equalsIgnoreCase("Administrador")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bandeja de Gastos Pendientes | Kronos Industrial</title>
    
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/AutorizarGastos.css">
    
    <script src="JS/menu-movil.js" defer></script>
    <link rel="icon" href="images/KronosIndustrial.svg" type="image/svg+xml">

    <!-- Lucide Icons CDN -->
    <script src="https://unpkg.com/lucide@latest"></script>
</head>
<body>

<div class="admin-container">

    <div class="overlay" id="sidebarOverlay"></div>

    <aside class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <img src="images/KronosIndustrial.svg" alt="Kronos Industrial Logo" class="sidebar-logo">
            <div class="brand-text">
                <h2 style="font-size: 18px;">Kronos Industrial</h2>
                <span class="panel-badge" style="background: #FDE8E8; color: #991B1B;"><%= user.getRol() %></span>
            </div>
        </div>

        <nav class="sidebar-nav">
            <a href="AdminPage.jsp" class="nav-item">
                <span class="icon"><i data-lucide="bar-chart-3" style="width: 20px; height: 20px"></i></span>
                <span>Dashboard Maestro</span>
            </a>
            <a href="AdminFinanzas" class="nav-item">
                <span class="icon"><i data-lucide="dollar-sign" style="width: 20px; height: 20px"></i></span>
                <span>Control Financiero</span>
            </a>
            <a href="AutorizarGastosSv" class="nav-item active" style="background-color: #121216;">
                <span class="icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 2v20l2-1 2 1 2-1 2 1 2-1 2 1 2-1 2 1V2l-2 1-2-1-2 1-2-1-2 1-2-1-2 1z"></path><path d="M16 8H8"></path><path d="M16 12H8"></path><path d="M12 16H8"></path></svg></span>
                <span>Bandeja de Gastos</span>
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
                    <h1>Bandeja de Gastos Pendientes</h1>
                    <span>Audita, aprueba o rechaza los egresos menores reportados por los supervisores.</span>
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
            
            <div class="audit-card">
                <div class="card-header-table">
                    <h2><i data-lucide="clipboard" style="width: 20px; height: 20px"></i> Solicitudes de Reembolso / Caja Chica</h2>
                    <p>Haga clic en aprobar para descontar del presupuesto del proyecto o rechazar ingresando una justificación.</p>
                </div>
                
                <div class="table-responsive">
                    <table class="vyg-table">
                        <thead>
                            <tr>
                                <th>Obra / Proyecto</th>
                                <th>Concepto / Categoría</th>
                                <th>Fecha Gasto</th>
                                <th>Monto</th>
                                <th>Comprobante</th>
                                <th style="text-align: center;">Resolución de Auditoría</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<GastosProyecto> lista = (List<GastosProyecto>) request.getAttribute("GastosPendientes");
                                
                                if (lista != null && !lista.isEmpty()) {
                                    for (GastosProyecto g : lista) {
                            %>
                            <tr>
                                <td data-label="Proyecto">
                                    <span class="project-badge">PRY-<%= String.format("%03d", g.getIdProyecto()) %></span>
                                </td>
                                
                                <td data-label="Concepto">
                                    <strong class="item-title"><%= g.getConcepto() %></strong><br>
                                    <span class="category-text"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path></svg> <%= g.getCategoria() %></span>
                                </td>
                                
                                <td data-label="Fecha Gasto">
                                    <span class="date-text"><%= g.getFechaGasto() %></span>
                                </td>
                                
                                <td data-label="Monto" class="money-text">
                                    C$ <%= String.format("%,.2f", g.getMonto()) %>
                                </td>
                                
                                <td data-label="Comprobante">
                                    <span class="invoice-badge">
                                        <%= (g.getNroComprobante() != null && !g.getNroComprobante().trim().isEmpty()) ? g.getNroComprobante() : "Sin factura" %>
                                    </span>
                                </td>
                                
                                <td data-label="Resolución">
                                    <form action="AutorizarGastosSv" method="POST" class="approval-form">
                                        <input type="hidden" name="id_gasto" value="<%= g.getIdGasto() %>">
                                        
                                        <input type="text" name="observaciones" placeholder="Nota o motivo de rechazo..." class="input-obs">
                                        
                                        <div class="btn-actions-group">
                                            <button type="submit" name="accion" value="Aprobar" class="btn-approve" onclick="return confirm('¿Aprobar este gasto oficialmente?');">Aprobar</button>
                                            <button type="submit" name="accion" value="Rechazar" class="btn-reject" onclick="return confirm('¿Está seguro de rechazar este egreso?');">Rechazar</button>
                                        </div>
                                    </form>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="6" class="empty-cell">
                                    <div class="empty-state-wrapper">
                                        <span class="empty-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg></span>
                                        <p>¡Excelente trabajo! No hay gastos pendientes de revisión en este momento.</p>
                                    </div>
                                </td>
                            </tr>
                            <% 
                                } 
                            %>
                        </tbody>
                    </table>
                </div>
                
                <div class="card-footer">
                    <a href="AdminFinanzas" class="btn-back"><i data-lucide="arrow-left" style="width: 20px; height: 20px"></i> Volver a Finanzas</a>
                </div>
                
            </div>
            
        </section>

    </main>
</div>


    <!-- Inicializacion de Lucide Icons -->
    <script>
        lucide.createIcons();
    </script>
</body>
</html>
