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
     <link rel="icon" href="images/KronosIndustrial.svg" type="image/png">
</head>
<body>

    <div class="detail-wrapper">
        <div class="card detail-card">
            
            <div class="detail-header">
                <div class="header-title">
                    <h2><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="display:inline-block; vertical-align:middle; margin-right:6px;"><path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"></path><rect x="8" y="2" width="8" height="4" rx="1" ry="1"></rect></svg>Manifiesto de Viaje #<%= detalle.getId_ruta() %></h2>
                    <p>Ficha técnica del acarreo de materiales</p>
                </div>
                <div class="header-date">
                    <span>Fecha de Operación</span>
                    <strong><%= detalle.getFecha() %></strong>
                </div>
            </div>

            <div class="detail-body">
                
                <div class="section-title"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="display:inline-block; vertical-align:middle; margin-right:6px;"><path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z"></path><line x1="4" y1="22" x2="4" y2="15"></line></svg>Datos de Ruta y Proyecto</div>
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
                        <div class="route-arrow"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" style="display:inline-block; vertical-align:middle; margin:0 8px;"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg></div>
                        <div class="route-point">
                            <span class="info-label">Punto de Destino</span>
                            <span class="info-value"><%= detalle.getDestino() %></span>
                        </div>
                    </div>
                </div>

                <div class="section-title" style="margin-top: 25px;"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="display:inline-block; vertical-align:middle; margin-right:6px;"><line x1="16.5" y1="9.4" x2="7.5" y2="4.21"></line><polygon points="12 22.08 12 12 3 6.92 3 17.08 12 22.08"></polygon><polygon points="12 22.08 12 12 21 6.92 21 17.08 12 22.08"></polygon><polygon points="12 12 3 6.92 12 1.84 21 6.92 12 12"></polygon></svg>Detalles de Carga y Horarios</div>
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
                <a href="HistorialCamiones?accion=ListarCamiones" class="btn-back"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" style="display:inline-block; vertical-align:middle; margin-right:4px;"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>Regresar al Historial</a>
                <button class="btn-print" onclick="window.print()"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="display:inline-block; vertical-align:middle; margin-right:6px;"><polyline points="6 9 6 2 18 2 18 9"></polyline><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"></path><rect x="6" y="14" width="12" height="8"></rect></svg>Imprimir Comprobante</button>
            </div>

        </div>
    </div>

</body>
</html>