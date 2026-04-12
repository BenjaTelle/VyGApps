<%-- 
    Document   : AsignProyect
    Created on : 9 feb 2026, 5:24:22 p.m.
    Author     : Benja
--%>
<%@page import="model.Usuarios"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.trabajadores"%>
<%@page import="model.proyectos"%>
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
    <title>Asignar Proyecto</title>
    <link rel="stylesheet" href="CSS/AsignarProyecto.css">
     <link rel="icon" href="images/vyg.svg" type="image/png">
</head>

<body>

    <main class="assign-container">

        <section class="assign-card">

            <div class="card-icon">🔗</div>

            <h2>Asignar Proyecto</h2>
            <p class="subtitle">Vincular trabajador a un proyecto</p>

            <form action="AsignProyecto" method="POST">

                <!-- TRABAJADOR -->
                <div class="form-group">
                    <label>Trabajador</label>
                    <select name="id_trabajador" required>
                        <option value="">Seleccione un trabajador</option>
                        <%
                            List<trabajadores> listaT =
                                (List<trabajadores>) request.getAttribute("ListaT");
                            if (listaT != null) {
                                for (trabajadores t : listaT) {
                                
                                System.out.println("id trabajador"+  t.getId_trabajador());
                        %>
                        <option value="<%=t.getId_trabajador()%>">
                            <%=t.getFull_name()%>
                        </option>
                        <%
                                }
                            }
                        %>
                    </select>
                </div>

                <!-- PROYECTO -->
                <div class="form-group">
                    <label>Proyecto</label>
                    <select name="id_proyecto" required>
                        <option value="">Seleccione un proyecto</option>
                        <%
                            List<proyectos> listaP =
                                (List<proyectos>) request.getAttribute("ListaP");
                            if (listaP != null) {
                                for (proyectos p : listaP) {
                                
                                    System.out.println("id "+p.getProyecto_id());
                        %>
                        <option value="<%=p.getProyecto_id()%>">
                            <%=p.getNombre_proyecto()%>
                        </option>
                        <%
                                }
                            }
                        %>
                    </select>
                </div>

                <button type="submit" class="btn-assign">
                    Asignar proyecto
                </button>

            </form>

        </section>

    </main>

</body>
</html>
