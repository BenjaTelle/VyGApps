<%@page import="DTO.DeduccionDTO"%>
<%@page import="model.trabajadores"%>
<%@page import="java.util.List"%>
<%@page import="model.Usuarios"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    HttpSession sessionActual = request.getSession(false);
    Usuarios usuarioLogeado = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;

    if (usuarioLogeado == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String rol = usuarioLogeado.getRol();
    if (!rol.equalsIgnoreCase("Administrador") && !rol.equalsIgnoreCase("Supervisor")) {
        response.sendRedirect("AccDen.jsp");
        return;
    }

    List<trabajadores> listaTrabajadores = (List<trabajadores>) request.getAttribute("listaTrabajadores");
    List<DeduccionDTO> listaDeducciones = (List<DeduccionDTO>) request.getAttribute("listaDeducciones");
    
    String homeLink = rol.equalsIgnoreCase("Administrador") ? "AdminPage.jsp" : "SupervisorPage";
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Deducciones | V&G Ingenieros</title>
    
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
    <link rel="stylesheet" href="CSS/FormulariosGeneracion.css">
    <script src="JS/menu-movil.js" defer></script>
    <link rel="icon" href="images/vygLogo.svg" type="image/svg+xml">

    <!-- Lucide Icons CDN -->
    <script src="JS/lucide.min.js"></script>
    <style>
        .deducciones-card {
            background: #ffffff;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            margin-bottom: 25px;
        }
        .form-grid-ded {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }
        .form-group-ded {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        .form-group-ded label {
            font-weight: 600;
            font-size: 14px;
            color: #334155;
        }
        .form-group-ded input, .form-group-ded select {
            padding: 10px 14px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-size: 14px;
            outline: none;
            transition: border-color 0.2s;
        }
        .form-group-ded input:focus, .form-group-ded select:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }
        .btn-submit-ded {
            background-color: #2563eb;
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: background-color 0.2s;
        }
        .btn-submit-ded:hover {
            background-color: #1d4ed8;
        }
        .badge-pendiente {
            background-color: #fef3c7;
            color: #d97706;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
        }
        .badge-aplicada {
            background-color: #dcfce7;
            color: #15803d;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
        }
        .table-ded {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        .table-ded th, .table-ded td {
            padding: 12px 16px;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
            font-size: 14px;
        }
        .table-ded th {
            background-color: #f8fafc;
            color: #475569;
            font-weight: 600;
        }
        .btn-del {
            background: none;
            border: none;
            color: #ef4444;
            cursor: pointer;
            padding: 4px;
            border-radius: 4px;
        }
        .btn-del:hover {
            background-color: #fee2e2;
        }
    </style>
</head>
<body>

<div class="admin-container">

    <div class="overlay" id="sidebarOverlay"></div>

    <aside class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <img src="images/vygLogo.svg" alt="V&G Ingenieros Logo" class="sidebar-logo">
            <div class="brand-text">
                <h2 style="font-size: 18px;">V&G Ingenieros</h2>
                <span class="panel-badge"><%= rol %></span>
            </div>
        </div>

        <nav class="sidebar-nav">
            <a href="<%= homeLink %>" class="nav-item">
                <i data-lucide="layout-dashboard" style="width: 20px; height: 20px"></i>
                <span>Dashboard</span>
            </a>
            <% if (rol.equalsIgnoreCase("Administrador")) { %>
            <a href="VerUsuarios" class="nav-item">
                <i data-lucide="users" style="width: 20px; height: 20px"></i>
                <span>Gestión de Usuarios</span>
            </a>
            <a href="ReporteTrabajadoresSv" class="nav-item">
                <i data-lucide="shield" style="width: 20px; height: 20px"></i>
                <span>Gestión Laboral</span>
            </a>
            <a href="AdminFinanzas" class="nav-item">
                <i data-lucide="dollar-sign" style="width: 20px; height: 20px"></i>
                <span>Control Financiero</span>
            </a>
            <% } else { %>
            <a href="RegistrarGastoSv" class="nav-item">
                <i data-lucide="dollar-sign" style="width: 20px; height: 20px"></i>
                <span>Control de Gastos</span>
            </a>
            <a href="GestionJustificaciones" class="nav-item">
                <i data-lucide="file-text" style="width: 20px; height: 20px"></i>
                <span>Justificaciones</span>
            </a>
            <% } %>
            
            <a href="Deducciones" class="nav-item active" style="background-color: #121216;">
                <i data-lucide="minus-circle" style="width: 20px; height: 20px"></i>
                <span>Deducciones</span>
            </a>
            
            <a href="Configuracion.jsp" class="nav-item">
                <i data-lucide="settings" style="width: 20px; height: 20px"></i>
                <span>Configuración</span>
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
                    <h1>Módulo de Deducciones</h1>
                    <span>Registro de deducciones aplicables a la próxima planilla.</span>
                </div>
            </div>

            <div class="profile-menu">
                <div class="profile-info">
                    <span class="profile-name"><%= usuarioLogeado.getUser_name() %></span>
                    <span class="profile-role"><%= rol %></span>
                </div>
                <img src="images/usuario.png" class="profile-img" alt="Perfil">
            </div>
        </header>

        <section class="dashboard">

            <div class="deducciones-card">
                <h2 style="margin-bottom: 8px; color: #0f172a; font-size: 18px;">
                    <i data-lucide="plus-circle" style="width: 20px; height: 20px; display: inline-block; vertical-align: middle;"></i> Registrar Nueva Deducción
                </h2>
                <p style="color: #64748b; font-size: 14px; margin-bottom: 20px;">
                    La deducción registrada se aplicará automáticamente en el próximo cálculo de nómina del trabajador.
                </p>

                <form action="Deducciones" method="POST">
                    <div class="form-grid-ded">
                        <div class="form-group-ded">
                            <label for="id_trabajador">Trabajador *</label>
                            <select name="id_trabajador" id="id_trabajador" required>
                                <option value="">Seleccione un trabajador</option>
                                <%
                                    if (listaTrabajadores != null) {
                                        for (trabajadores t : listaTrabajadores) {
                                %>
                                <option value="<%= t.getId_trabajador() %>"><%= t.getFull_name() %> (<%= t.getPuesto() %>)</option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>

                        <div class="form-group-ded">
                            <label for="concepto">Concepto (Opcional)</label>
                            <input type="text" name="concepto" id="concepto" placeholder="Ej: Adelanto de sueldo, equipo dañando...">
                        </div>

                        <div class="form-group-ded">
                            <label for="monto">Cantidad a Deducir (C$) *</label>
                            <input type="number" name="monto" id="monto" min="0.01" step="0.01" placeholder="0.00" required>
                        </div>
                    </div>

                    <button type="submit" class="btn-submit-ded">
                        <i data-lucide="save" style="width: 18px; height: 18px"></i> Guardar Deducción
                    </button>
                </form>
            </div>

            <div class="deducciones-card">
                <h2 style="margin-bottom: 15px; color: #0f172a; font-size: 18px;">
                    <i data-lucide="list" style="width: 20px; height: 20px; display: inline-block; vertical-align: middle;"></i> Historial de Deducciones
                </h2>

                <div style="overflow-x: auto;">
                    <table class="table-ded">
                        <thead>
                            <tr>
                                <th># ID</th>
                                <th>Trabajador</th>
                                <th>Concepto</th>
                                <th>Monto Deducido</th>
                                <th>Fecha Registro</th>
                                <th>Estado</th>
                                <th style="text-align: center;">Acción</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (listaDeducciones != null && !listaDeducciones.isEmpty()) {
                                    for (DeduccionDTO d : listaDeducciones) {
                            %>
                            <tr>
                                <td><strong>#<%= d.getIdDeduccion() %></strong></td>
                                <td><%= d.getNombreTrabajador() %></td>
                                <td><%= (d.getConcepto() != null && !d.getConcepto().trim().isEmpty()) ? d.getConcepto() : "<span style='color:#94a3b8; font-style:italic;'>Sin concepto</span>" %></td>
                                <td style="font-weight: bold; color: #dc2626;">C$ <%= String.format("%,.2f", d.getMonto()) %></td>
                                <td><%= d.getFechaRegistro() != null ? d.getFechaRegistro().toString().substring(0, 16) : "--" %></td>
                                <td>
                                    <% if ("Pendiente".equalsIgnoreCase(d.getEstado())) { %>
                                        <span class="badge-pendiente">Pendiente</span>
                                    <% } else { %>
                                        <span class="badge-aplicada">Aplicada en Planilla</span>
                                    <% } %>
                                </td>
                                <td style="text-align: center;">
                                    <% if ("Pendiente".equalsIgnoreCase(d.getEstado())) { %>
                                    <form action="Deducciones" method="POST" style="display: inline;" onsubmit="return confirm('¿Desea cancelar esta deducción pendiente?');">
                                        <input type="hidden" name="action" value="eliminar">
                                        <input type="hidden" name="id_deduccion" value="<%= d.getIdDeduccion() %>">
                                        <button type="submit" class="btn-del" title="Cancelar deducción">
                                            <i data-lucide="trash-2" style="width: 18px; height: 18px"></i>
                                        </button>
                                    </form>
                                    <% } else { %>
                                        <span style="color: #cbd5e1;">--</span>
                                    <% } %>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="7" style="text-align: center; color: #94a3b8; padding: 20px;">
                                    No hay deducciones registradas hasta el momento.
                                </td>
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

<!-- Inicializacion de Lucide Icons -->
<script>
    lucide.createIcons();
</script>
</body>
</html>
