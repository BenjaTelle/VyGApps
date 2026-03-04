<%-- 
    Document   : RegistrarCamiones
    Created on : 2 mar 2026, 6:09:32 p.m.
    Author     : Benja
--%>

<%@page import="model.material"%>
<%@page import="model.uso_registros"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="model.Usuarios"%>
<%
    //  Recuperar la sesión (false significa: no crees una nueva si no existe)
    HttpSession sessionActual = request.getSession(false);

    //  Recuperar el usuario
    Usuarios usuarioLogeado = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;

    //  VALIDACIÓN DE SEGURIDAD
    if (usuarioLogeado == null) {
        //  No se ha logueado -> Patada al login
        response.sendRedirect("login.jsp");
        return; // Importante para detener la ejecución del resto de la página
    } else if (!usuarioLogeado.getRol().equals("Supervisor")) {
        //  Sí está logueado, pero es empleado intentando entrar a zona admin
        response.sendRedirect("AccDen.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Registrar Viaje de Camión</title>
    <link rel="stylesheet" href="CSS/RegistrarCamiones.css">
</head>
<body>

    <div class="form-wrapper">
        <div class="card form-card">
            <div class="form-header">
                <h2>&#128666; Registrar Viaje de Camión</h2>
                <p>Controla el ingreso, salida y los costos de flete de los materiales en obra.</p>
            </div>

            <form action="RegistrarCamionesSv" method="POST" class="vyg-form">
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="id_uso">Registro de Maquinaria Asociado:</label>
                        <select name="id_uso" id="id_uso" required>
                            <option value="" disabled selected>Seleccione el registro de maquinaria asociado...</option>
                            <%List<uso_registros> ListaR = (List<uso_registros>) request.getAttribute("ListaUso");
                             for(uso_registros uso:ListaR )
                             {
                             %>
                            <option value="<%= uso.getId_uso() %>" > Registro #<%= uso.getId_uso() %> | Fecha: <%= uso.getFecha() %> | Máquina: <%= uso.getId_maquina() %> (<%= uso.getHora_inicio() %> a <%= uso.getHora_fin() %></option>
                            <%}%>
                            </select>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="id_material">Material Cargado:</label>
                        <select name="id_material" id="id_material" required>
                            <option value="" disabled selected>Seleccione el material...</option>
                            <%List<material> ListaM = (List<material>) request.getAttribute("ListaM");
                                for(material m: ListaM) 
                                {
                            %>
                            <option value="<%=m.getId_material()%>" ><%=m.getNombre_material()%></option>
                             <%}%>
                            </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="cantidad_cargada">Cantidad Cargada (m3):</label>
                        <input type="number" step="0.1" name="cantidad_cargada" id="cantidad_cargada" placeholder="Ej. 12.5 m3" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="origen">Origen:</label>
                        <input type="text" name="origen" id="origen" placeholder="Ej. Plantel Central / Proveedor" required>
                    </div>
                    <div class="form-group">
                        <label for="destino">Destino:</label>
                        <input type="text" name="destino" id="destino" placeholder="Ej. Proyecto Km 45" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="hora_salida">Hora de Salida:</label>
                        <input type="time" name="hora_salida" id="hora_salida" required>
                    </div>
                    <div class="form-group">
                        <label for="hora_llegada">Hora de Llegada:</label>
                        <input type="time" name="hora_llegada" id="hora_llegada" required>
                    </div>
                </div>

                <hr class="form-divider">

                <div class="form-row">
                    <div class="form-group highlight-financial">
                        <label for="costo_flete">&#128176; Costo del Flete / Transporte (C$):</label>
                        <input type="number" step="0.01" name="costo_flete" id="costo_flete" placeholder="Ej. 850.00" required>
                        <small>Costo del viaje para sumarlo a los gastos del proyecto.</small>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-submit">Guardar Viaje</button>
                    <a href="SupervisorPage" class="btn-cancel">Cancelar</a>
                </div>

            </form>
        </div>
    </div>

</body>
</html>