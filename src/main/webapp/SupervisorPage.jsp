    <%-- 
    Document   : SupervisorPage
    Created on : 3 feb 2026, 7:06:55 p.m.
    Author     : Benja
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Panel Supervisor</title>
    <link rel="stylesheet" href="CSS/SupervisorPage.css">
</head>
<body>

<div class="panel-container">

    <!-- SIDEBAR -->
    <div class="sidebar">

        <div class="sidebar-header">
            <img src="images/vyg.svg" alt="VyG Logo" class="sidebar-logo">
            <h2>Supervisor</h2>
        </div>

        <a href="SupervisorSv?accion=proyectos">Ver proyectos</a>
        <a href="SupervisorSv?accion=pagos">Autorizar pagos</a>
        <a href="SupervisorSv?accion=asistencias">Monitorear asistencias</a>
        <a href="SupervisorSv?accion=maquinaria">Uso de maquinaria</a>
        <a href="SupervisorSv?accion=camiones">Registros de camiones</a>
    </div>

    <!-- CONTENIDO -->
    <div class="main-content">

        <!-- HEADER -->
        <div class="header">
            <h3>Panel de Supervisor</h3>

            <div class="profile-box">
                <img src="images/usuario.png" class="profile-img" alt="Perfil">
                <span class="profile-name">Supervisor</span>
            </div>
        </div>

        <!-- CONTENIDO DINÁMICO -->
        <div class="content-box">
            <%
                String accion = (String) request.getAttribute("accion");

                if (accion == null) {
            %>
                <p>Bienvenido al panel de supervisor.</p>

            <%
                } else if ("proyectos".equals(accion)) {
            %>
                <p>Aquí puedes ver los proyectos asignados.</p>

            <%
                } else if ("pagos".equals(accion)) {
            %>
                <p>Aquí puedes autorizar pagos.</p>

            <%
                } else if ("asistencias".equals(accion)) {
            %>
                <p>Aquí puedes monitorear las asistencias.</p>

            <%
                } else if ("maquinaria".equals(accion)) {
            %>
                <p>Aquí puedes revisar el uso de maquinaria.</p>

            <%
                } else if ("camiones".equals(accion)) {
            %>
                <p>Aquí puedes consultar los registros de camiones.</p>
            <%
                }
            %>
        </div>

    </div>
</div>

</body>
</html>

