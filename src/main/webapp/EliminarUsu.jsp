<%-- 
    Document   : EliminarUsu
    Created on : 16 feb 2026, 9:16:04 p.m.
    Author     : Benja
--%>
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
        <link rel="stylesheet" href="CSS/EliminarUsu.css">
         <link rel="icon" href="images/vyg.svg" type="image/png">
    </head>
    <body>

        <div class="delete-container">
            <h2>Eliminar Usuario</h2>

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
            <form action="EliminarUsu" method="post">

                <label for="usuario">Seleccionar Usuario</label>
                <select name="id_user" id="usuario" required>
                    <option value="">-- Seleccione un usuario --</option>

                    <%
                        List<Usuarios> ListaU = (List<Usuarios>) request.getAttribute("ListaUsuarios");

                        for (Usuarios u : ListaU) {


                    %>
                    <option value="<%=u.getId_user()%>"><%=u.getUser_name()%></option>

                    <%}%>
                </select>


                <button type="submit" class="btn-delete">
                    Eliminar Usuario
                </button>

            </form>
        </div>

    </body>
</html>
