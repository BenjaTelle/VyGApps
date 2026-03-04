<%-- 
    Document   : ListarProyectos
    Created on : 18 feb 2026, 4:03:05 p.m.
    Author     : Benja
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.proyectos"%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Lista de Proyectos</title>
    <link rel="stylesheet" href="CSS/ListarProyectos.css">
</head>
<body>

<div class="container">
    <h2>Proyectos Activos</h2>
    <p class="subtitle">Listado general de proyectos registrados</p>

    <div class="cards-container">

        <%
            List<proyectos> lista = 
                (List<proyectos>) request.getAttribute("ListaP");

            if (lista != null && !lista.isEmpty()) {
                for (proyectos p : lista) {
        %>

        <div class="card">
            <div class="card-content">
                <h3><%= p.getNombre_proyecto() %></h3>
            </div>
        </div>

        <%
                }
            } else {
        %>
            <div class="empty-message">
                No hay proyectos registrados.
            </div>
        <%
            }
        %>

    </div>
</div>

</body>
</html>
