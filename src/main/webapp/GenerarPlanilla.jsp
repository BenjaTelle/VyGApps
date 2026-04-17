<%-- 
    Document   : GenerarPlanilla
    Created on : 2 abr 2026, 5:48:15 p.m.
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
    <title>Generar Nómina | VyGApps</title>
    <link rel="stylesheet" href="CSS/HistorialAsistencia.css">
    <link rel="stylesheet" href="CSS/AdminFinanzas.css"> 
    <link rel="stylesheet" href="CSS/GenerarPlanilla.css">
    <link rel="icon" href="images/vyg.svg" type="image/svg+xml">
</head>
<body>

    <div class="page-wrapper" style="max-width: 700px;"> <div class="worker-profile-header admin-header">
            <div class="profile-info">
                <h2>⚙️ Asistente de Cálculo de Nómina</h2>
                <p>Configura el periodo quincenal para generar los pagos pendientes.</p>
            </div>
        </div>

        <div class="card form-card">
            <div class="form-header">
                <h3>Parámetros de la Quincena</h3>
                <p>Selecciona las fechas de inicio y fin. El sistema evaluará la asistencia de todos los trabajadores activos en este rango.</p>
            </div>

            <form action="GenerarPlanilla" method="POST" class="vyg-form">
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="fecha_inicio">Fecha de Inicio del Periodo:</label>
                        <input type="date" id="fecha_inicio" name="fecha_inicio" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="fecha_fin">Fecha de Fin del Periodo:</label>
                        <input type="date" id="fecha_fin" name="fecha_fin" required>
                    </div>
                </div>

                <div class="info-box">
                    <span class="info-icon">ℹ️</span>
                    <div class="info-text">
                        <strong>¿Cómo funciona el cálculo?</strong><br>
                        El sistema tomará el salario quincenal de cada trabajador, lo dividirá entre 15 días y lo multiplicará por los días que el trabajador tenga registros de entrada en el rango de fechas seleccionado. Los días sin marcar asistencia serán descontados automáticamente.
                    </div>
                </div>

                <div class="form-actions">
                    <a href="AdminFinanzas" class="btn-cancelar">Cancelar</a>
                    <button type="submit" class="btn-generar">
                        🚀 Procesar y Generar Planillas
                    </button>
                </div>
            </form>
        </div>

    </div>

</body>
</html>