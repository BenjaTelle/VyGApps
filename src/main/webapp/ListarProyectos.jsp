<%-- 
    Document   : ListarProyectos
    Created on : 18 feb 2026, 4:03:05 p.m.
    Author     : Benja
--%>

<%@page import="DTO.ListarProyectosDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.proyectos"%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Lista de Proyectos</title>
    <link rel="stylesheet" href="CSS/ListarProyectos.css">
     <link rel="icon" href="images/vyg.svg" type="image/png">
</head>
<body>

<div class="page-wrapper">
    
    <div class="page-header">
        <div>
            <h2>&#127977; Proyectos Activos</h2>
            <p class="subtitle">Listado general de proyectos y estado financiero</p>
        </div>
        <div class="header-tools">
            <input type="text" id="buscador" placeholder="Buscar proyecto..." class="search-input">
            <a href="CrearProyecto" class="btn-main">&#10133; Nuevo Proyecto</a>
        </div>
    </div>

    <div class="cards-container">

        <%
            List<ListarProyectosDTO> lista = (List<ListarProyectosDTO>) request.getAttribute("ListaP");

            if (lista != null && !lista.isEmpty()) {
                for (ListarProyectosDTO p : lista) {
                String mensaje;
                String nombreSup = p.getNombre_supervisor();
                
                // 1. Validamos que no sea nulo de BD
                // 2. Validamos que no venga vacío
                // 3. Validamos que no sea el texto literal "null"
                if(nombreSup != null && !nombreSup.trim().isEmpty() && !nombreSup.equalsIgnoreCase("null")) {
                    mensaje = nombreSup;
                } else {
                    // Le ponemos un poco de HTML para que resalte que falta asignar a alguien
                    mensaje = "<span style='color: #e74c3c; font-style: italic;'>No hay supervisores asignados.</span>";
                }

        %>

        <div class="card">
            <div class="card-header">
                <h3 class="project-title"><%= p.getNombre_proyecto() %></h3>
                </div>
            
            <div class="card-body">
                <div class="info-group">
                    <span class="info-label">&#128119; Supervisor Designado</span>
                    <span class="info-value text-dark">
                        <%= mensaje%> 
                    </span>
                </div>
                
                <div class="info-group financial-group">
                    <span class="info-label">&#128176; Presupuesto Total</span>
                    <span class="info-value money">
                        C$ <%= String.format("%.2f", p.getPresupuesto_total()) %>
                    </span>
                </div>
            </div>

            <div class="card-footer">
                <a href="ListarProyectos?id_proyecto=<%= p.getId()%>" class="btn-detail">Ver Ficha Técnica</a>
            </div>
        </div>

        <%
                }
            } else {
        %>
            <div class="empty-message">
                <p>No hay proyectos registrados en el sistema actualmente.</p>
            </div>
        <%
            }
        %>

    </div>
</div>

<script>
    document.getElementById("buscador").addEventListener("keyup", function() {
        let texto = this.value.toLowerCase();
        let tarjetas = document.querySelectorAll(".card");
        
        tarjetas.forEach(function(tarjeta) {
            let contenido = tarjeta.textContent.toLowerCase();
            if (contenido.includes(texto)) {
                tarjeta.style.display = "flex"; // Mantiene el layout flex de la tarjeta
            } else {
                tarjeta.style.display = "none";
            }
        });
    });
</script>

</body>
</html>