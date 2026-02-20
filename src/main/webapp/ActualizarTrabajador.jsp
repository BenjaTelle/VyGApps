<%-- 
    Document   : ActualizarTrabajador
    Created on : 18 feb 2026, 5:02:10?p.m.
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
        //  No se ha logueado -> Patada al login
        response.sendRedirect("login.jsp");
        return; // Importante para detener la ejecución del resto de la página
    } else if (!usuarioLogeado.getRol().equals("Administrador")) {
        //  Sí está logueado, pero es empleado intentando entrar a zona admin
        response.sendRedirect("AccDen.jsp");
        return;
    }
%>
<%@page import="model.proyectos"%>
<%@page import="model.trabajadores"%>
<%@page import="java.util.List"%>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Actualizar Trabajador</title>
    <link rel="stylesheet" href="CSS/ActualizarTrabajadores.css">
</head>
<body>

<main class="form-container">

<section class="form-card">

    <h2>Gestión de Trabajadores</h2>
    <p class="subtitle">Actualizar datos del trabajador</p>

   
    

    <!-- ? FORM ACTUALIZAR -->
    <form action="ActualizarTrabajadores" method="POST">
 <!-- ? SELECT PARA ELEGIR TRABAJADOR -->
    <div class="form-group">
        <label>Seleccionar Trabajador a Editar</label>
        <select name="id_trabajador">
            <option value="">Seleccione un trabajador</option>

            <%
                List<trabajadores> listaTrab =
                        (List<trabajadores>) request.getAttribute("ListaTrabajadores");
                       
                if (listaTrab != null) {
                    for (trabajadores t : listaTrab) {
                    System.out.println("\n"+t.getId_trabajador());
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
        <!-- CÉDULA -->
        <div class="form-group">
            <label>Cédula</label>
            <input type="text" name="cedula">
        </div>

        <!-- NOMBRE -->
        <div class="form-group">
            <label>Nombre completo</label>
            <input type="text" name="full_name">
        </div>

        <!-- EDAD -->
        <div class="form-group">
            <label>Edad</label>
            <input type="number" name="edad" min="18">
        </div>

        <!-- PUESTO -->
        <div class="form-group">
            <label>Puesto</label>
            <select name="puesto">
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

        <!-- SALARIO -->
        <div class="form-group">
            <label>Salario quincenal</label>
            <input type="number" name="salario_quincenal">
        </div>

        <!-- ORIGEN -->
        <div class="form-group">
            <label>Origen</label>
            <input type="text" name="origen">
        </div>

        <!-- SUPERVISOR -->
        <div class="form-group">
            <label>Supervisor</label>
            <select name="id_supervisor">
                <option value="">Seleccione un supervisor</option>

                <%
                    List<trabajadores> listaSuperv =
                        (List<trabajadores>) request.getAttribute("ListaSuperv");

                    if (listaSuperv != null) {
                        for (trabajadores sv : listaSuperv) {
                %>
                <option value="<%=sv.getId_trabajador()%>">
                    <%=sv.getFull_name()%>
                </option>
                <%
                        }
                    }
                %>
            </select>
        </div>

        <!-- PROYECTO -->
        <div class="form-group">
            <label>Proyecto asociado</label>
            <select name="proyecto">
                <option value="">Seleccione un proyecto</option>

                <%
                    List<proyectos> listaP =
                        (List<proyectos>) request.getAttribute("ListarProyectos");

                    if (listaP != null) {
                        for (proyectos p : listaP) {
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

        <!-- BOTÓN -->
        <button type="submit" class="btn-submit">
            Actualizar trabajador
        </button>

    </form>

</section>

</main>

</body>
</html>