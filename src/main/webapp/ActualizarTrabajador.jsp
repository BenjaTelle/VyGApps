<%-- 
    Document   : ActualizarTrabajador
    Created on : 18 feb 2026
    Author     : Benja
--%>
<%@page import="model.Usuarios"%>
<%@page import="model.proyectos"%>
<%@page import="model.trabajadores"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    HttpSession sessionActual = request.getSession(false);
    Usuarios usuarioLogeado = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;

    if (usuarioLogeado == null) {
        response.sendRedirect("login.jsp");
        return; 
    } else if (!usuarioLogeado.getRol().equals("Administrador")) {
        response.sendRedirect("AccDen.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Actualizar Trabajador | V&G Ingenieros</title>
    <link rel="stylesheet" href="CSS/ActualizarTrabajadores.css">
    <link rel="icon" href="images/vygLogo.svg" type="image/png">

    <!-- Lucide Icons CDN -->
    <script src="JS/lucide.min.js"></script>
</head>
<body>

    <main class="form-container">
        <section class="form-card">
            <h2>Gestión de Trabajadores</h2>
            <p class="subtitle">Actualizar datos de un empleado existente</p>

            <form action="ActualizarTrabajadores" method="POST" id="formTrabajador">
                
                <div class="form-group full-width highlight-select">
                    <label><i data-lucide="search" style="width: 20px; height: 20px"></i> Seleccionar Trabajador a Editar</label>
                    <select name="id_trabajador" id="selectTrabajador" required>
                        <option value="">Seleccione un trabajador de la lista</option>
                        <%
                            List<trabajadores> listaTrab = (List<trabajadores>) request.getAttribute("ListaTrabajadores");
                            if (listaTrab != null) {
                                for (trabajadores t : listaTrab) {
                        %>
                        <option value="<%=t.getId_trabajador()%>"
                                data-cedula="<%= (t.getCedula() != null) ? t.getCedula() : "" %>"
                                data-fullname="<%= (t.getFull_name() != null) ? t.getFull_name() : "" %>"
                                data-edad="<%= t.getEdad() %>"
                                data-telefono="<%= (t.getTelefono() != null) ? t.getTelefono() : "" %>"
                                data-emergencia="<%= (t.getNumero_emergencia() != null) ? t.getNumero_emergencia() : "" %>"
                                data-direccion="<%= (t.getDireccion() != null) ? t.getDireccion() : "" %>"
                                data-salario="<%= t.getSalario_quincenal() %>"
                                data-origen="<%= (t.getOrigen() != null) ? t.getOrigen() : "" %>"
                                data-puesto="<%= (t.getPuesto() != null) ? t.getPuesto() : "" %>"
                                data-idsupervisor="<%= t.getId_supervisor() %>"
                                data-idproyecto="<%= t.getId_proyect() %>">
                            <%=t.getFull_name()%>
                        </option>
                        <%
                                }
                            }
                        %>
                    </select>
                </div>

                <div class="form-grid">
                    <div class="form-group full-width">
                        <label>Nombre Completo</label>
                        <input type="text" id="in_fullname" name="full_name" required disabled>
                    </div>

                    <div class="form-group">
                        <label>Cédula de Identidad</label>
                        <input type="text" id="cedula" name="cedula" maxlength="16" required disabled>
                        <small id="errorCedula" class="error-text">Formato inválido.</small>
                    </div>

                    <div class="form-group">
                        <label>Edad</label>
                        <input type="number" id="in_edad" name="edad" min="18" required disabled>
                    </div>

                    <div class="form-group">
                        <label>Teléfono Personal</label>
                        <input type="text" id="in_telefono" name="telefono" maxlength="8" pattern="\d{8}" required disabled>
                    </div>

                    <div class="form-group">
                        <label>Número de Emergencia</label>
                        <input type="text" id="in_emergencia" name="numero_emergencia" maxlength="8" pattern="\d{8}" required disabled>
                    </div>

                    <div class="form-group full-width">
                        <label>Dirección Domiciliar</label>
                        <textarea id="in_direccion" name="direccion" rows="2" required disabled></textarea>
                    </div>

                    <div class="form-group">
                        <label>Salario Quincenal</label>
                        <input type="number" id="in_salario" name="salario_quincenal" step="0.01" required disabled>
                    </div>
                    <div class="form-group">
                        <label>Origen</label>
                        <input type="text" id="in_origen" name="origen" required disabled>
                    </div>

                    <div class="form-group full-width">
                        <label>Puesto</label>
                        <select id="in_puesto" name="puesto" required disabled>
                            <option value="">Seleccione un puesto</option>
                            <option value="Gerente de proyecto">Gerente de proyecto</option>
                            <option value="Ingeniero residente">Ingeniero/a residente</option>
                            <option value="Arquitecto">Arquitecto/a</option>
                            <option value="Supervisor de obra">Supervisor de obra</option>
                            <option value="Capataz">Capataz</option>
                            <option value="Tecnico operativo">Técnico operativo</option>
                            <option value="Obrero">Obrero / Operativo</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Supervisor</label>
                        <select id="in_supervisor" name="id_supervisor" disabled>
                            <option value="0">Sin Supervisor / N/A</option>
                            <%
                                List<trabajadores> listaSupervAct = (List<trabajadores>) request.getAttribute("ListaSuperv");
                                if (listaSupervAct != null) {
                                    for (trabajadores sv : listaSupervAct) {
                            %>
                            <option value="<%=sv.getId_trabajador()%>"><%=sv.getFull_name()%></option>
                            <% }} %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Proyecto asociado</label>
                        <select id="in_proyecto" name="proyecto" disabled>
                            <option value="0">Sin Proyecto Asignado</option>
                            <%
                                List<proyectos> listaPAct = (List<proyectos>) request.getAttribute("ListarProyectos");
                                if (listaPAct != null) {
                                    for (proyectos p : listaPAct) {
                            %>
                            <option value="<%=p.getProyecto_id()%>"><%=p.getNombre_proyecto()%></option>
                            <% }} %>
                        </select>
                    </div>
                </div>

                <button type="submit" class="btn-submit" id="btn-submit-trabajador" disabled style="opacity: 0.6; cursor: not-allowed;"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="23 4 23 10 17 10"></polyline><polyline points="1 20 1 14 7 14"></polyline><path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"></path></svg> Actualizar Trabajador</button>
            </form>
        </section>
    </main>

    <script src="JS/ValidarTrabajador.js"></script>

    <!-- Inicializacion de Lucide Icons -->
    <script>
        lucide.createIcons();
    </script>
</body>
</html>