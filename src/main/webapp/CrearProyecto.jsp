<%-- 
    Document   : CrearProyecto
    Created on : 17 feb 2026, 6:34:50 p.m.
    Author     : Benja
--%>

<%@page import="model.trabajadores"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%@page import="java.util.List"%>
<%@page import="model.Usuarios"%>

<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Crear Proyecto</title>
    <link rel="stylesheet" href="CSS/CrearProyecto.css">
</head>
<body>

<div class="container">
    <div class="card">
        <h2>Crear Nuevo Proyecto</h2>
        <p class="subtitle">Complete la información del proyecto</p>

        
        <form action="CrearProyecto" method="post">

            <label for="nombre">Nombre del Proyecto</label>
            <input type="text" id="nombre" name="nombre_proyecto" 
                   placeholder="Ingrese el nombre del proyecto" required>

            <label for="supervisor">Asignar Supervisor</label>
            <select name="id_supervisor" id="supervisor" required>
                <option value="">-- Seleccione un supervisor --</option>

                <%
                    List<trabajadores> lista = (List<trabajadores>) request.getAttribute("ListaSupervisores");

                    if (lista != null) {
                        for (trabajadores t : lista) {
                %>
                    <option value="<%= t.getId_trabajador()%>">
                        <%= t.getFull_name()    %>
                    </option>
                <% 
                        }
                    }
                %>
            </select>

            <button type="submit" class="btn-submit">
                Crear Proyecto
            </button>

        </form>
    </div>
</div>

</body>
</html>