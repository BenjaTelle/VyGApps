<%-- 
    Document   : VerUsuarios
    Created on : 20 feb 2026, 5:11:42 p.m.
    Author     : Benja
--%>

<%@page import="DTO.UsuarioDetalle"%>
<%@page import="java.util.List"%>
<%@page import="model.Usuarios"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Lista de Usuarios</title>
    <link rel="stylesheet" href="CSS/VerUsuarios.css">
     <link rel="icon" href="images/vyg.svg" type="image/png">
</head>
<body>

<div class="container">

    <h2>Usuarios del Sistema</h2>
    <p class="subtitle">Listado general de cuentas registradas</p>

    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>Usuario</th>
                    <th>Trabajador Asignado</th>
                    <th>Rol</th>
                </tr>
            </thead>
            <tbody>

            <%
                List<UsuarioDetalle> lista =
                        (List<UsuarioDetalle>) request.getAttribute("ListaUsuariosDetalle");

                if (lista != null && !lista.isEmpty()) {
                    for (UsuarioDetalle ud : lista) {

                        String claseRol = "";

                        if (ud.getRol().equals("Trabajador")) {
                            claseRol = "rol-trabajador";
                        } else if (ud.getRol().equals("Supervisor")) {
                            claseRol = "rol-supervisor";
                        } else if (ud.getRol().equals("Administrador")) {
                            claseRol = "rol-admin";
                        }
            %>

                <tr>
                    <td><%= ud.getUsern_name()%></td>
                    <td><%= ud.getTrabajadorAsign() %></td>
                    <td>
                        <span class="rol-badge <%= claseRol %>">
                            <%= ud.getRol()%>
                        </span>
                    </td>
                </tr>

            <%
                    }
                } else {
            %>
                <tr>
                    <td colspan="3" class="empty">
                        No hay usuarios registrados.
                    </td>
                </tr>
            <%
                }
            %>

            </tbody>
        </table>
    </div>

</div>

</body>
</html>
