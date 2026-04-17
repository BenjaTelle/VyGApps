<%-- 
    Document   : GestionPresupuestos
    Created on : 2 abr 2026, 6:30:59 p.m.
    Author     : Benja
--%>
<%@page import="model.proyectos"%>
<%-- 
    Document   : GestionPresupuestos
    Created on : [Fecha Actual]
    Author     : Benja
--%>
<%@page import="java.util.List"%>
<%@page import="Repository.ProyectoDAO"%> 
<%@page import="model.Usuarios"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Lógica de seguridad ESTRICTA (Solo Administradores)
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;
    
    if (user == null || !user.getRol().equalsIgnoreCase("Administrador")) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Recibimos la lista de proyectos desde el Servlet
    List<proyectos> listaProyectos = (List<proyectos>) request.getAttribute("ListaProyectos");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestión de Presupuestos | VyGApps</title>
    <link rel="stylesheet" href="CSS/HistorialAsistencia.css">
    <link rel="stylesheet" href="CSS/AdminFinanzas.css"> 
    <link rel="stylesheet" href="CSS/GestionPresupuestos.css">
    <link rel="icon" href="images/vyg.svg" type="image/svg+xml">
</head>
<body>

    <div class="page-wrapper" style="max-width: 900px;">
        
        <div class="worker-profile-header admin-header">
            <div class="profile-info">
                <h2>📊 Inyección y Control de Presupuestos</h2>
                <p>Asigna fondos a los proyectos activos para cubrir las nóminas y gastos operativos.</p>
            </div>
        </div>

        <div class="budget-container">
            
            <div class="card budget-form-card">
                <div class="card-header">
                    <h3>➕ Inyectar Capital</h3>
                    <p>Suma fondos al presupuesto actual de un proyecto.</p>
                </div>
                
                    <form action="GestionPresupuestos" method="POST" class="vyg-form">
                    <div class="form-group">
                        <label for="id_proyecto">Seleccionar Proyecto:</label>
                        <select id="id_proyecto" name="id_proyecto" required>
                            <option value="">-- Elija un proyecto --</option>
                            <% 
                                if(listaProyectos != null) {
                                    for(proyectos p : listaProyectos) { 
                            %>
                                <option value="<%= p.getProyecto_id()%>"><%= p.getNombre_proyecto() %></option>
                            <% 
                                    }
                                } 
                            %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="monto_adicional">Monto a Inyectar (C$):</label>
                        <input type="number" id="monto_adicional" name="monto_adicional" step="0.01" min="1" placeholder="Ej. 50000.00" required>
                    </div>

                    <button type="submit" class="btn-submit-budget">📥 Asignar Fondos</button>
                </form>
            </div>

            <div class="card budget-table-card">
                <div class="card-header">
                    <h3>💰 Estado de Proyectos</h3>
                </div>
                
                <div class="table-responsive" style="padding: 0;">
                    <table class="vyg-table">
                        <thead>
                            <tr>
                                <th>Proyecto</th>
                                <th style="text-align: right;">Presupuesto Disponible</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                if(listaProyectos != null && !listaProyectos.isEmpty()) {
                                    for(proyectos p : listaProyectos) { 
                            %>
                            <tr>
                                <td><strong><%= p.getNombre_proyecto() %></strong></td>
                                <td style="text-align: right; color: #27ae60; font-weight: bold;">
                                    C$ <%= String.format("%,.2f", p.getPresupuesto_total()) %>
                                </td>
                            </tr>
                            <% 
                                    }
                                } else { 
                            %>
                            <tr>
                                <td colspan="2" style="text-align: center; color: #7f8c8d;">No hay proyectos activos.</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

        </div> <div style="margin-top: 25px;">
            <a href="AdminFinanzas" class="btn-back">⬅️ Volver al Panel Financiero</a>
        </div>

    </div>

</body>
</html>