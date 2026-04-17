<%-- 
    Document   : UsoMaquinaria
    Created on : 28 feb 2026, 5:36:49 p.m.
    Author     : Benja
--%>
<%@page import="model.trabajadores"%>
<%@page import="model.proyectos"%>
<%@page import="model.maquinas"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="model.Usuarios"%>
<%
    // --- LÓGICA DE SEGURIDAD ---
    HttpSession sessionActual = request.getSession(false);
    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;

    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Validar Rol (Asegúrate que coincida con tu BD)
    if (!user.getRol().equalsIgnoreCase("Supervisor")) {
        response.sendRedirect("AccDen.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Registrar Uso de Maquinaria</title>
        <link rel="stylesheet" href="CSS/UsoMaquinaria.css">
         <link rel="icon" href="images/vyg.svg" type="image/png">
    </head>
    <body>

        <div class="form-wrapper">
            <div class="card form-card">
                <div class="form-header">
                    <h2>🚜 Registrar Nuevo Uso</h2>
                    <p>Completa los datos operativos de la máquina utilizada hoy.</p>
                </div>

                <form action="RegistrarUso" method="POST" class="vyg-form">

                    <div class="form-row">
                        <div class="form-group">
                            <label for="id_proyect">Proyecto Asignado:</label>
                            <select name="id_proyect" id="id_proyect" required>
                                <option value="" disabled selected>Seleccione Proyecto</option>
                                <%List<proyectos> ListaP = (List<proyectos>) request.getAttribute("ListarP");
                                    for (proyectos p : ListaP) {
                                %>
                                <option value="<%=p.getProyecto_id()%>" > <%=p.getNombre_proyecto()%></option>
                                <%}%>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="id_maquinaria">Máquina:</label>
                            <select name="id_maquinaria" id="id_maquinaria" required>
                                <option value="" disabled selected>Seleccione maquinaria</option>
                                <%List<maquinas> ListaM = (List<maquinas>) request.getAttribute("ListarM");
                                    for (maquinas m : ListaM) {
                                %>
                                <option value="<%=m.getId_maquina()%>" ><%=m.getMarca()%></option>
                                <%}%>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="id_trabajador">Operador (Trabajador):</label>
                            <select name="id_trabajador" id="id_trabajador" required>
                                <option value="" disabled selected>Seleccione trabajador</option>
                                <%List<trabajadores> ListaT = (List<trabajadores>) request.getAttribute("ListarT");
                                    for (trabajadores t : ListaT) {
                                %>
                                <option value="<%=t.getId_trabajador()%>" ><%=t.getFull_name()%>.</option>
                                <%}%>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="fecha">Fecha de operación:</label>
                            <input type="date" name="fecha" id="fecha" required>
                        </div>
                        <div class="form-group">
                            <label for="hora_inicio">Hora de Inicio:</label>
                            <input type="time" name="hora_inicio" id="hora_inicio" required>
                        </div>
                        <div class="form-group">
                            <label for="hora_fin">Hora de Fin:</label>
                            <input type="time" name="hora_fin" id="hora_fin" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group highlight-financial" style="border-left: 4px solid #e67e22; background-color: #fdf2e9;">
                            <label for="costo_por_hora" style="color: #d35400;">⏱️ Costo por Hora (C$):</label>
                            <input type="number" step="0.01" min="0" name="costo_por_hora" id="costo_por_hora" placeholder="Ej. 500.00" required>
                            <small style="color: #e67e22;">Tarifa operativa de la máquina por cada hora de uso.</small>
                        </div>
                    </div>

                    <hr class="form-divider">

                    <div class="form-row">
                        <div class="form-group">
                            <label for="combustible">Combustible Consumido (Galones):</label>
                            <input type="number" step="0.1" name="combustible" id="combustible" placeholder="Ej. 15.5" required>
                        </div>

                        <div class="form-group highlight-financial">
                            <label for="costo_combustible_total">💰 Costo Total del Combustible (C$):</label>
                            <input type="number" step="0.01" name="costo_combustible_total" id="costo_combustible_total" placeholder="Ej. 2500.00" required>
                            <small>Monto de la factura para el reporte de gastos del proyecto.</small>
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn-submit">Guardar Registro</button>
                        <a href="SupervisorPage" class="btn-cancel">Cancelar</a>
                    </div>

                </form>
            </div>
        </div>

    </body>
</html>