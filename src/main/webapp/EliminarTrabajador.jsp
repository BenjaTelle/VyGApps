<%-- 
    Document   : EliminarTrabajador
    Created on : 18 feb 2026, 6:47:06 p.m.
    Author     : Benja
--%>

<%@page import="model.trabajadores"%>
<%@page import="java.util.List"%>
<%@page import="Repository.UsuarioDAO"%>
<%@page import="model.Usuarios"%>
<%
    //  Recuperar la sesión (false significa: no crees una nueva si no existe)
    HttpSession sessionActual = request.getSession(false);

    //  Recuperar el usuario
    Usuarios usuarioLogeado = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;

    //  VALIDACIÓN DE SEGURIDAD
    if (usuarioLogeado == null) {
        //  No se ha logueado, vuelve al login 
        response.sendRedirect("login.jsp");
        return; // Importante para detener la ejecución del resto de la página
    } else if (!usuarioLogeado.getRol().equals("Administrador")) {
        //  Sí está logueado, pero es empleado intentando entrar a zona admin
        response.sendRedirect("AccDen.jsp");
        return;
    }
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Eliminar Usuario</title>
        <link rel="stylesheet" href="CSS/EliminarTrabajadores.css">
    </head>
    <body>

        <div class="delete-container">
            <h2>Eliminar Trabajadores</h2>

            <p class="warning-text">Esta acción es permanente y no se puede deshacer.</p>

            <%
                String mensaje = (String) request.getAttribute("mensaje");
                String tipo = (String) request.getAttribute("tipo");

                if (mensaje != null) {
            %>
            <div class="alert <%= tipo%>">
                <%= mensaje%>
            </div>
            <% } %>
            <form action="EliminarTrabajadores" method="post">

                <label for="trabajador">Seleccionar Trabajador</label>
                <select name="id_trabajador" id="usuario" required>
                    <option value="">-- Seleccione un trabajador --</option>

                    <%
                        List<trabajadores> ListaU = (List<trabajadores>) request.getAttribute("ListaT");

                        for (trabajadores u : ListaU) {


                    %>
                    <option value="<%=u.getId_trabajador()%>"><%=u.getFull_name()%></option>

                    <%}%>
                </select>


                <button type="submit" class="btn-delete">
                    Eliminar Usuario
                </button>

            </form>
        </div>

    </body>
</html>
