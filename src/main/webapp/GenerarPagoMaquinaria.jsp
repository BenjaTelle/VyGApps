<%-- 
    Document   : GenerarPagoMaquinaria
    Created on : 2 abr 2026, 6:58:12 p.m.
    Author     : Benja
--%>

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
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Liquidar Maquinaria | VyGApps</title>
    <link rel="stylesheet" href="CSS/HistorialAsistencia.css">
    <link rel="stylesheet" href="CSS/AdminFinanzas.css"> 
    <link rel="stylesheet" href="CSS/GenerarPlanilla.css">
    <link rel="icon" href="images/vyg.svg" type="image/svg+xml">
</head>
<body>

    <div class="page-wrapper" style="max-width: 700px;">
        
        <div class="worker-profile-header admin-header">
            <div class="profile-info">
                <h2>🚜 Liquidación de Maquinaria y Equipos</h2>
                <p>Genera las órdenes de pago por el alquiler y uso de maquinaria en los proyectos.</p>
            </div>
        </div>

        <div class="card form-card">
            <div class="form-header">
                <h3>Parámetros de Liquidación</h3>
                <p>Selecciona el rango de fechas. El sistema buscará todos los registros de uso que aún no han sido pagados y calculará su costo automáticamente.</p>
            </div>

            <form action="GenerarPagoMaquinaria" method="POST" class="vyg-form">
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="fecha_inicio">Fecha de Inicio:</label>
                        <input type="date" id="fecha_inicio" name="fecha_inicio" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="fecha_fin">Fecha de Corte (Fin):</label>
                        <input type="date" id="fecha_fin" name="fecha_fin" required>
                    </div>
                </div>

                <div class="info-box" style="border-left-color: #e67e22; background-color: #fdf2e9;">
                    <span class="info-icon">⚙️</span>
                    <div class="info-text" style="color: #d35400;">
                        <strong>Matemática Interna:</strong><br>
                        El sistema calculará las horas de uso cruzando la 'hora_inicio' y 'hora_fin' de los operadores. Luego, multiplicará esas horas por el costo configurado para cada máquina y le sumará el costo del diésel. Los registros ya liquidados anteriormente serán ignorados.
                    </div>
                </div>

                <div class="form-actions">
                    <a href="AdminFinanzas" class="btn-cancelar">Cancelar</a>
                    <button type="submit" class="btn-generar" style="background-color: #e67e22;">
                        🚜 Generar Órdenes de Pago
                    </button>
                </div>
            </form>
        </div>

    </div>

</body>
</html>