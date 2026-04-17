<%-- 
    Document   : VerDetalle
    Created on : 6 mar 2026, 4:26:49 p.m.
    Author     : Benja
--%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="DTO.HistorialCamionesDTO"%>
<%@page import="model.Usuarios"%>
<%
    // Validación de seguridad de sesión
    HttpSession sessionActual = request.getSession(false);
    Usuarios usuarioLogeado = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;

    if (usuarioLogeado == null) {
        response.sendRedirect("login.jsp");
        return;
    } else if (!usuarioLogeado.getRol().equals("Supervisor")) {
        response.sendRedirect("AccDen.jsp");
        return;
    }

    // Recuperamos el objeto DTO que envió el Servlet
    HistorialCamionesDTO detalle = (HistorialCamionesDTO) request.getAttribute("verDetalle");
    
    // Si por alguna razón el objeto llega nulo, lo regresamos al historial
    if(detalle == null){
        response.sendRedirect("CamionesSv?accion=listar");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Detalle de Viaje #<%= detalle.getId_ruta() %></title>
    <link rel="stylesheet" href="CSS/DetalleCamion.css">
     <link rel="icon" href="images/vyg.svg" type="image/png">
</head>
<body>

    <div class="detail-wrapper">
        <div class="card detail-card">
            
            <div class="detail-header">
                <div class="header-title">
                    <h2>&#128203; Manifiesto de Viaje #<%= detalle.getId_ruta() %></h2>
                    <p>Ficha técnica del acarreo de materiales</p>
                </div>
                <div class="header-date">
                    <span>Fecha de Operación</span>
                    <strong><%= detalle.getFecha() %></strong>
                </div>
            </div>

            <div class="detail-body">
                
                <div class="section-title">&#128681; Datos de Ruta y Proyecto</div>
                <div class="detail-grid-full">
                    <div class="info-box border-brown">
                        <span class="info-label">Proyecto Asignado</span>
                        <span class="info-value"><%= detalle.getNombre_proyecto() %></span>
                    </div>
                    
                    <div class="route-box">
                        <div class="route-point">
                            <span class="info-label">Punto de Origen</span>
                            <span class="info-value"><%= detalle.getOrigen() %></span>
                        </div>
                        <div class="route-arrow">&#10141;</div>
                        <div class="route-point">
                            <span class="info-label">Punto de Destino</span>
                            <span class="info-value"><%= detalle.getDestino() %></span>
                        </div>
                    </div>
                </div>

                <div class="section-title" style="margin-top: 25px;">&#128230; Detalles de Carga y Horarios</div>
                <div class="detail-grid-half">
                    <div class="info-box">
                        <span class="info-label">Material Transportado</span>
                        <span class="info-value"><%= detalle.getNombre_material() %></span>
                    </div>
                    
                    <div class="info-box highlight-box">
                        <span class="info-label">Volumen / Cantidad Cargada</span>
                        <span class="info-value"><%= detalle.getCantidad_cargada() %> unidades</span>
                    </div>

                    <div class="info-box">
                        <span class="info-label">Máquina Cargadora</span>
                        <span class="info-value"><%= detalle.getTipo_maquina() %> <%= detalle.getMarca() %></span>
                    </div>

                    <div class="info-box">
                        <span class="info-label">Horario de Tránsito</span>
                        <span class="info-value">Salida: <%= detalle.getHora_salida() %> | Llegada: <%= detalle.getHora_entrada() %></span>
                    </div>
                </div>

                <div class="financial-section">
                    <span class="financial-label">Costo Total del Flete</span>
                    <span class="financial-value">C$ <%= String.format("%.2f", detalle.getCosto_flete()) %></span>
                </div>

            </div>

            <div class="detail-footer">
                <a href="HistorialCamiones?accion=ListarCamiones" class="btn-back">&#11013; Regresar al Historial</a>
                <button class="btn-print" onclick="window.print()">&#128424; Imprimir Comprobante</button>
            </div>

        </div>
    </div>

</body>
</html>