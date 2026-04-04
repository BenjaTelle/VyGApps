<%-- 
    Document   : HistorialUso
    Created on : 4 mar 2026
    Author     : Benja
--%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="java.util.List"%>
<%@page import="DTO.HistorialUsoDTO"%>
<%@page import="model.Usuarios"%>

<%
    // Validación de sesión
    HttpSession sessionActual = request.getSession(false);
    Usuarios usuarioLogeado = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;

    if (usuarioLogeado == null) {
        response.sendRedirect("login.jsp");
        return;
    } else if (!usuarioLogeado.getRol().equals("Supervisor")) {
        response.sendRedirect("AccDen.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Historial de Uso de Maquinaria</title>
    <link rel="stylesheet" href="CSS/HistorialUso.css">
    <link rel="icon" href="images/vyg.svg" type="image/png">
</head>
<body>

    <div class="table-wrapper">
        <div class="card table-card">
            
            <div class="table-header">
                <div>
                    <h2>🚜 Historial de Uso de Maquinaria</h2>
                    <p>Consulta todos los registros operativos y costos totales calculados.</p>
                </div>
                <div class="toolbar">
                    <input type="text" id="buscador" placeholder="Buscar registro..." class="search-input">
                    <a href="RegistrarUso" class="btn-main">➕ Registrar Nuevo Uso</a>
                </div>
            </div>

            <div class="table-responsive">
                <table class="vyg-table">
                    <thead>
                        <tr>
                            <th>ID Registro</th>
                            <th>Fecha</th>
                            <th>Horario (Inicio - Fin)</th>
                            <th>Proyecto</th>
                            <th>Máquina</th>
                            <th>Operador</th>
                            <th>Costo/Hora (C$)</th>
                            <th>Combustible (Gal)</th>
                            <th>Costo Total (C$)</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            // Se asume que el Servlet pasa la lista con este nombre de atributo
                            List<HistorialUsoDTO> listaUsos = (List<HistorialUsoDTO>) request.getAttribute("ListaHistorial");
                            
                            if(listaUsos != null && !listaUsos.isEmpty()) {
                                for(HistorialUsoDTO uso : listaUsos) {
                        %>
                        <tr>
                            <td><strong>#<%= uso.getIdUso() %></strong></td>
                            <td><%= uso.getFecha() %></td>
                            <td><%= uso.getHoraInicio() %> a <%= uso.getHoraFin() %></td>
                            
                            <td><%= uso.getNombreProyecto() %></td>
                            <td><%= uso.getNombreMaquina() %></td>
                            <td><%= uso.getNombreTrabajador() %></td>
                            
                            <td style="color: #e67e22; font-weight: bold;">C$ <%= String.format("%,.2f", uso.getCostoPorHora()) %></td>
                            <td><%= uso.getGalonesCombustible() %> Gal.</td>
                            <td class="text-financial" style="color: #27ae60; font-weight: bold;">C$ <%= String.format("%,.2f", uso.getCostoTotal()) %></td>
                            
                            <td>
                                <a href="DetalleUsoSv?id=<%= uso.getIdUso() %>" class="btn-icon" title="Ver Detalle">👁️</a>
                            </td>
                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="10" style="text-align: center; color: #7f8c8d; padding: 30px;">
                                No hay registros de uso de maquinaria en el historial.
                            </td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>

            <div class="table-footer">
                <a href="SupervisorPage" class="btn-cancel">⬅️ Volver al Panel</a>
            </div>

        </div>
    </div>

</body>
</html>