<%-- 
    Document   : RegistrarGasto
    Created on : 16 may 2026, 8:02:20 p.m.
    Author     : Benja
--%>
<%@page import="model.Usuarios"%>
<%@page import="model.proyectos"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // --- LÓGICA DE SEGURIDAD ---
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;

    if (user == null || (!user.getRol().equalsIgnoreCase("Supervisor") && !user.getRol().equalsIgnoreCase("Administrador"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Obtenemos el ID del proyecto si viene desde la Ficha Técnica (para autoseleccionarlo)
    String idProyectoParam = request.getParameter("id_proyecto");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registrar Gasto | VyGApps</title>

    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/RegistrarGasto.css"> 
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
                <span class="panel-badge"><%= user.getRol() %></span>
            </div>
        </div>

        <nav class="sidebar-nav">
            <a href="SupervisorPage" class="nav-item">
                <span class="icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="20" x2="12" y2="10"></line><line x1="18" y1="20" x2="18" y2="4"></line><line x1="6" y1="20" x2="6" y2="16"></line></svg></span>
                <span>Dashboard</span>
            </a>
            <a href="ListarProyectos" class="nav-item">
                <span class="icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="7" width="20" height="14" rx="2" ry="2"></rect><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"></path></svg></span>
                <span>Proyectos Activos</span>
            </a>
            <a href="LogoutSv" class="nav-item logout-link">
                <span class="icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" y1="12" x2="9" y2="12"></line></svg></span>
                <span>Cerrar Sesión</span>
            </a>
        </nav>
    </aside>

    <main class="main-content">

        <header class="topbar">
            <div class="header-left">
                <button id="menu-toggle" class="mobile-menu-btn"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="3" y1="12" x2="21" y2="12"></line><line x1="3" y1="6" x2="21" y2="6"></line><line x1="3" y1="18" x2="21" y2="18"></line></svg></button>
                <div class="welcome">
                    <h1>Registrar Gasto de Proyecto</h1>
                    <span>Sube facturas, viáticos o compras de caja chica para auditoría.</span>
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

            <div class="form-card">
                <div class="card-header">
                    <h2><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"></line><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path></svg> Formulario de Registro de Gastos</h2>
                    <p>Completa la información detallada del gasto. Quedará en estado "Pendiente" hasta ser aprobado por administración.</p>
                </div>

                <form action="RegistrarGastoSv" method="POST" class="expense-form">
                    
                    <input type="hidden" name="id_user_registra" value="<%= user.getId_user() %>">

                    <div class="form-row">
                        <div class="form-group full-width">
                            <label>Proyecto Asociado <span class="required">*</span></label>
                            <select name="id_proyecto" required>
                                <option value="" disabled <%= (idProyectoParam == null) ? "selected" : "" %>>-- Seleccione un proyecto activo --</option>
                                <%
                                    List<proyectos> listaProyectos = (List<proyectos>) request.getAttribute("ListaProyectos");
                                    if (listaProyectos != null) {
                                        for (proyectos p : listaProyectos) {
                                        System.out.println("nombre "+ p.getNombre_proyecto());
                                            // Verifica si el ID coincide con el que viene por URL para autoseleccionarlo
                                            String isSelected = (idProyectoParam != null && idProyectoParam.equals(String.valueOf(p.getProyecto_id()))) ? "selected" : "";
                                %>
                                <option value="<%= p.getProyecto_id() %>" <%= isSelected %>> <%= p.getNombre_proyecto() %></option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Concepto del Gasto <span class="required">*</span></label>
                            <input type="text" name="concepto" placeholder="Ej: Compra de cemento extra" required>
                        </div>
                        <div class="form-group">
                            <label>Categoría <span class="required">*</span></label>
                            <select name="categoria" required>
                                <option value="" disabled selected>-- Seleccione una --</option>
                                <option value="Materiales"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="7" width="20" height="14" rx="2" ry="2"></rect><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"></path></svg> Materiales e Insumos</option>
                                <option value="Combustible">Combustible / Transporte</option>
                                <option value="Alimentacion"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="7" width="20" height="14" rx="2" ry="2"></rect><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"></path></svg> Alimentación / Viáticos</option>
                                <option value="Mantenimiento"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="7" width="20" height="14" rx="2" ry="2"></rect><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"></path></svg> Repuestos y Mantenimiento</option>
                                <option value="Otros"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="7" width="20" height="14" rx="2" ry="2"></rect><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"></path></svg> Otros Gastos</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Monto Gastado (C$) <span class="required">*</span></label>
                            <input type="number" step="0.01" name="monto" placeholder="Ej: 1500.50" required>
                        </div>
                        <div class="form-group">
                            <label>Fecha del Gasto Físico <span class="required">*</span></label>
                            <input type="date" name="fecha_gasto" required>
                        </div>
                        <div class="form-group">
                            <label>Nro. de Comprobante / Factura</label>
                            <input type="text" name="nro_comprobante" placeholder="Opcional. Ej: FAC-00123">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group full-width">
                            <label>Descripción Detallada o Justificación</label>
                            <textarea name="descripcion" rows="4" placeholder="Explica brevemente por qué fue necesario este gasto..."></textarea>
                        </div>
                    </div>

                    <div class="form-actions">
                        <a href="javascript:history.back()" class="btn-cancel">Cancelar</a>
                        <button type="submit" class="btn-submit"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg> Registrar Gasto</button>
                    </div>

                </form>
            </div>

        </section>

    </main>
</div>

</body>
</html>