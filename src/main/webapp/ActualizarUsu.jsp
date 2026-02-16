<%-- 
    Document   : ActualizarUsu
    Created on : 16 feb 2026, 5:22:05 p.m.
    Author     : Benja
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="java.util.List"%>
<%@page import="model.Usuarios"%>
<%@page import="model.trabajadores"%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Actualizar Usuario</title>
    <link rel="stylesheet" href="CSS/ActualizarUsu.css">
</head>
<body>

<div class="form-container">
    <div class="form-card">

        <div class="card-icon">✏️</div>

        <h2>Actualizar Usuario</h2>
        <p class="subtitle">Seleccione el usuario y modifique la información</p>

        <form action="ActualizarUsuario" method="POST">

            <div class="form-group">
                <label>Seleccionar Usuario</label>
                <select name="id_usuario" required>
                    <option value="">Seleccione un usuario</option>

                    <%
                        List<Usuarios> listaUsuarios = (List<Usuarios>) request.getAttribute("ListaUsuarios");
                        if (listaUsuarios != null) {
                            for (Usuarios u : listaUsuarios) {
                    %>
                        <option value="<%=%>">
                            <%= %>
                        </option>
                    <%
                            }
                        }
                    %>
                </select>
            </div>

            <div class="form-group">
                <label>Nombre de usuario</label>
                <input type="text" name="user_name" required>
            </div>

            <div class="form-group">
                <label>Nueva contraseña</label>
                <input type="password" name="pass" required>
            </div>

            <div class="form-group">
                <label>Rol del sistema</label>
                <select name="rol" id="rolSelect" required>
                    <option value="">Seleccione un rol</option>
                    <option value="Administrador">Administrador</option>
                    <option value="Supervisor">Supervisor</option>
                    <option value="Trabajador">Trabajador</option>
                </select>
            </div>

            <div class="form-group">
                <label>Asignar a trabajador</label>
                <select name="id_trabajador">
                    <option value="">Sin asignar</option>

                    <%
                        List<trabajadores> listaTrab = (List<trabajadores>) request.getAttribute("ListaT");
                        if (listaTrab != null) {
                            for (trabajadores t : listaTrab) {
                    %>
                        <option value="<%= t.getId_trabajador()%>">
                            <%= t.getFull_name()%>
                        </option>
                    <%
                            }
                        }
                    %>
                </select>
            </div>

            <button type="submit" class="btn-submit">
                Actualizar Usuario
            </button>

        </form>

    </div>
</div>

<script>
const rolSelect = document.getElementById("rolSelect");

rolSelect.addEventListener("change", function () {
    this.classList.remove("admin-color", "supervisor-color", "trabajador-color");

    if (this.value === "Administrador") {
        this.classList.add("admin-color");
    } else if (this.value === "Supervisor") {
        this.classList.add("supervisor-color");
    } else if (this.value === "Trabajador") {
        this.classList.add("trabajador-color");
    }
});
</script>

</body>
</html>
