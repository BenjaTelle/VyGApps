<%-- 
    Document   : AsignSup
    Created on : 10 feb 2026, 7:19:44?p.m.
    Author     : Benja
--%>

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
<%@page import="Repository.TrabajadoresDAO"%>
<%@page import="model.trabajadores"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.proyectos"%>
<%@page import="java.util.List"%>
<%@page import="Repository.ProyectoDAO"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Asignar Supervisor</title>
        <link rel="stylesheet" href="CSS/AsignSupervisor.css">
         <link rel="icon" href="images/vyg.svg" type="image/png">
    </head>
    <body>

        <main class="container">

            <section class="card">

                <h2>Asignación de Supervisor</h2>
                <p class="subtitle">
                    Selecciona un trabajador y asígnalo como supervisor de una obra
                </p>

                <form action="AsignSup" method="POST">

                    <!-- TRABAJADOR -->
                    <div class="form-group">
                        <label>Trabajador</label>
                        <select name="id_trabajador" required>
                            <option value="">Seleccione un trabajador</option>
                            <% TrabajadoresDAO tDAO = new TrabajadoresDAO();

                                List<trabajadores> ListaT = tDAO.ListarTrabajadoresSinSuperv();

                                for (trabajadores t : ListaT) {

                            %>

                            <option value="<%=t.getId_trabajador()%>"><%=t.getFull_name()%></option>
                            <%}%>
                        </select>
                    </div>

                    <!-- PROYECTO -->
                    <div class="form-group">
                        <label>Proyecto / Obra</label>
                        <select name="id_proyecto" required>
                            <option value="">Seleccione un proyecto</option>
                            <%
                                ProyectoDAO proyect = new ProyectoDAO();
                                List<proyectos> Listap = proyect.ListarProyectos();

                                for (proyectos p : Listap) {


                            %>

                            <option value="<%=p.getProyecto_id()%>"><%=p.getNombre_proyecto()%></option>

                            <%}%>
                        </select>
                    </div>

                    <!-- MENSAJE VISUAL -->
                    <div class="info-box">
                        <span>!</span>
                        Este trabajador quedará asignado como supervisor del proyecto seleccionado.
                    </div>

                    <!-- BOTÓN -->
                    <button type="submit" class="btn-submit">
                        Asignar Supervisor
                    </button>

                </form>

            </section>

        </main>

    </body>
</html>
