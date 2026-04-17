<%-- 
    Document   : HistorialCamiones
    Created on : 4 mar 2026, 6:30:33 p.m.
    Author     : Benja
--%>

<%@page import="DTO.HistorialCamionesDTO"%>
<%@page import="model.camiones"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="java.util.List"%>
<%@page import="model.Usuarios"%>

<%
    // Validación de seguridad para la sesión
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
    <title>Historial de Camiones</title>
    <link rel="stylesheet" href="CSS/HistorialCamiones.css">
     <link rel="icon" href="images/vyg.svg" type="image/png">
</head>
<body>

    <div class="table-wrapper">
        <div class="card table-card">
            
            <div class="table-header">
                <div>
                    <h2>&#128666; Historial de Camiones</h2>
                    <p>Consulta todos los viajes de acarreo, materiales y fletes registrados.</p>
                </div>
                <div class="toolbar">
                    <input type="text" id="buscador" placeholder="Buscar viaje..." class="search-input">
                    <a href="HistorialCamiones?accion=nuevoViaje" class="btn-main">&#10133; Registrar Viaje</a>
                </div>
            </div>

            <div class="table-responsive">
                <table class="vyg-table">
                    <thead>
                        <tr>
                            <th>Viaje y Fecha</th>
                            <th>Contexto Operativo</th>
                            <th>Carga</th>
                            <th>Ruta</th>
                            <th>Horario</th>
                            <th>Costo Flete</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            List<HistorialCamionesDTO> listaCamiones = (List<HistorialCamionesDTO>) request.getAttribute("ListaHC");
                            if(listaCamiones != null && !listaCamiones.isEmpty()) {
                                for(HistorialCamionesDTO camion : listaCamiones) {
                        %>
                        <tr>
                            <td>
                                <strong>#<%= camion.getId_ruta() %></strong><br>
                                <small class="text-muted">&#128197; <%= camion.getFecha() %></small>
                            </td>
                            
                            <td>
                                <strong><%= camion.getNombre_proyecto() %></strong><br>
                                <small class="text-muted">&#128668; <%= camion.getTipo_maquina() %></small>
                            </td>
                            
                            <td>
                                <%= camion.getNombre_material() %><br>
                                <small class="text-muted"><%= camion.getCantidad_cargada() %> unidades</small>
                            </td>
                            
                            <td>
                                <%= camion.getOrigen() %><br>
                                <small class="text-muted">&#10145; <%= camion.getDestino() %></small>
                            </td>
                            
                            <td>
                                <%= camion.getHora_salida() %><br>
                                <small class="text-muted">a <%= camion.getHora_entrada() %></small>
                            </td>
                            
                            <td class="text-financial">
                                C$ <%= camion.getCosto_flete() %>
                            </td>
                            
                            <td>
                                <a href="HistorialCamiones?accion=verDetalle&id=<%= camion.getId_ruta() %>" class="btn-icon" title="Ver Detalle">&#128065;</a>
                            </td>
                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="7" style="text-align: center; color: #7f8c8d; padding: 25px;">
                                No hay viajes de camiones registrados en el historial.
                            </td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>

            <div class="table-footer">
                <a href="SupervisorPage" class="btn-cancel">&#11013; Volver al Panel</a>
            </div>

        </div>
    </div>

</body>
</html>