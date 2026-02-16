<%-- 
    Document   : RegistrarUsu
    Created on : 11 feb 2026, 7:06:09 p.m.
    Author     : Benja
--%>

<%@page import="model.Usuarios"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.trabajadores"%>
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
    } else if (!usuarioLogeado.getRol().equals("Administrador")) {
        //  Sí está logueado, pero es empleado intentando entrar a zona admin
        response.sendRedirect("AccDen.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Crear Usuario</title>
        <link rel="stylesheet" href="CSS/RegistrarUsu.css">
    </head>
    <body>

        <div class="form-container">

            <div class="form-card">

                <div class="card-icon">🔐</div>

                <h2>Crear Usuario</h2>
                <p class="subtitle">Registro de acceso al sistema</p>

                <form action="CrearUsuario" method="POST">

                    <!-- USERNAME -->
                    <div class="form-group">
                        <label>Nombre de usuario</label>
                        <input type="text" name="user_name" required>
                    </div>

                    <!-- PASSWORD -->
                    <div class="form-group">
                        <label>Contraseña</label>
                        <input type="password" name="pass" required>
                    </div>

                    <!-- ROL -->
                    <div class="form-group">
                        <label>Rol del sistema</label>
                        <select name="rol" id="rolSelect" required>
                            <option value="">Seleccione un rol</option>
                            <option value="Administrador" class="rol-admin">Administrador</option>
                            <option value="Supervisor" class="rol-supervisor">Supervisor</option>
                            <option value="Trabajador" class="rol-trabajador">Trabajador</option>
                        </select>
                    </div>

                    <!-- ASIGNAR TRABAJADOR (OPCIONAL) -->
                    <div class="form-group">
                        <label>Asignar a trabajador (Opcional)</label>
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

                                if (listaTrab == null) {
                                    System.out.println("ListaVaciaaa");
                                }
                            %>

                        </select>
                    </div>

                    <button type="submit" class="btn-submit">
                        Crear Usuario
                    </button>

                </form>

            </div>

        </div>

        <script>
            // Cambio visual dinámico del select según rol
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
