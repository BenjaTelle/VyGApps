<%-- 
    Document   : BuscarDetalleAsisTrabajador
    Created on : 31 mar 2026, 7:11:44 p.m.
    Author     : Benja
--%>




<%@page import="model.trabajadores"%>
<%@page import="Repository.TrabajadoresDAO"%>
<%@page import="java.util.List"%>



<%@page import="model.Usuarios"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>



<%

    // --- LÓGICA DE SEGURIDAD ---
    HttpSession sessionActual = request.getSession(false);

    Usuarios user = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;

    // Solo Supervisores y Administradores pueden ver este directorio
    if (user == null || (!user.getRol().equalsIgnoreCase("Supervisor") && !user.getRol().equalsIgnoreCase("Administrador"))) {

        response.sendRedirect("login.jsp");

        return;

    }

%>



<!DOCTYPE html>

<html lang="es">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <title>Directorio de Trabajadores | VyGApps</title>



        <!-- CSS Base de las tablas -->

        <link rel="stylesheet" href="CSS/BuscarDetalleAsisTrabajador.css">

        <!-- CSS Específico de esta vista (Buscador y Botones) -->

        <link rel="stylesheet" href="CSS/Directorio.css"> 

        <link rel="icon" href="images/vyg.svg" type="image/svg+xml">

    </head>

    <body>



        <div class="page-wrapper">

            <div class="card attendance-card">



                <div class="card-header">

                    <h2>👥 Directorio del Personal</h2>

                    <p>Selecciona un trabajador para ver su historial detallado de asistencia y rendimiento.</p>

                </div>



                <!-- BARRA DE BÚSQUEDA INTEGRADA -->

                <div class="search-container">

                    <input type="text" id="buscador" placeholder="🔍 Buscar por nombre o puesto...">

                </div>



                <div class="table-responsive">

                    <!-- ID de tabla para que el JS la identifique -->

                    <table class="vyg-table" id="tablaTrabajadores">

                        <thead>

                            <tr>

                                <th>Nombre Completo</th>

                                <th>Puesto Asignado</th>

                                <th style="text-align: center;">Acción</th>

                            </tr>

                        </thead>

                        <tbody>

                            <%                            // Recibimos la lista de trabajadores enviada por el Servlet
                                List<trabajadores> listaTrabajadores = (List<trabajadores>) request.getAttribute("ListaTrabajadores");

                                if (listaTrabajadores != null && !listaTrabajadores.isEmpty()) {

                                    for (trabajadores t : listaTrabajadores) {

                            %>

                            <tr>

                                <!-- Nombre -->

                                <td><strong><%= t.getFull_name()%></strong></td>



                                <!-- Puesto -->

                                <td style="color: #555;"><%= t.getPuesto()%></td>



                                <!-- Botón de Acción -->

                                <td style="text-align: center;">

                                    <a href="DetalleAsistenciaTrabajador?id_trabajador=<%= t.getId_trabajador()%>" class="btn-view" title="Ver Detalle de Asistencia">

                                        👁️ Ver Detalle

                                    </a>

                                </td>

                            </tr>

                            <%

                                }

                            } else {

                            %>

                            <tr>

                                <td colspan="3" class="empty-message">No hay trabajadores registrados en el sistema.</td>

                            </tr>

                            <%                            }

                            %>

                        </tbody>

                    </table>

                </div>



                <div class="card-footer">

                    <a href="SupervisorPage" class="btn-back">⬅️ Volver al Panel de Supervisor</a>

                </div>



            </div>

        </div>



        <!-- SCRIPT DE BÚSQUEDA EN TIEMPO REAL (Lógica moderna) -->

        <script>

            document.getElementById("buscador").addEventListener("keyup", function () {

                let texto = this.value.toLowerCase();



                // Seleccionamos todas las filas SOLO dentro del <tbody> para no ocultar los encabezados (<th>)

                let filas = document.querySelectorAll("#tablaTrabajadores tbody tr");



                filas.forEach(function (fila) {

                    // textContent atrapa todo el texto de esa fila (Nombre + Puesto)

                    let contenido = fila.textContent.toLowerCase();



                    if (contenido.includes(texto)) {

                        // Mantiene el formato original de la fila en la tabla

                        fila.style.display = "";

                    } else {

                        // Oculta la fila si no coincide

                        fila.style.display = "none";

                    }

                });

            });

        </script>



    </body>

</html>