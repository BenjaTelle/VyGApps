/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


/**
 * Script de interactividad para ReporteProyectos
 * @author Benja
 */
document.addEventListener("DOMContentLoaded", () => {
    const inputBusqueda = document.getElementById("inputBusqueda");
    const filasProyectos = document.querySelectorAll(".proyecto-fila");
    const filaVacia = document.getElementById("filaVacia");

    if (inputBusqueda) {
        inputBusqueda.addEventListener("keyup", () => {
            const criterio = inputBusqueda.value.toLowerCase().trim();
            let filasVisibles = 0;

            filasProyectos.forEach(fila => {
                // Buscamos coincidencia en la columna del Proyecto y Supervisor
                const textoProyecto = fila.querySelector(".col-proyecto").textContent.toLowerCase();
                const textoSupervisor = fila.querySelector(".col-supervisor").textContent.toLowerCase();

                if (textoProyecto.includes(criterio) || textoSupervisor.includes(criterio)) {
                    fila.style.display = "";
                    filasVisibles++;
                } else {
                    fila.style.display = "none";
                }
            });

            // Si el buscador no encuentra nada, creamos dinámicamente un mensaje en la tabla
            if (filasVisibles === 0 && filasProyectos.length > 0) {
                if (!document.getElementById("noResultadosFila")) {
                    const tbody = document.querySelector("#tablaProyectos tbody");
                    const tr = document.createElement("tr");
                    tr.id = "noResultadosFila";
                    tr.innerHTML = `<td colspan="5" style="text-align:center; padding: 30px; color: #64748b;">
                                      🔍 No se encontraron coincidencias para: "<strong>${inputBusqueda.value}</strong>"
                                    </td>`;
                    tbody.appendChild(tr);
                }
            } else {
                const filaNoResultados = document.getElementById("noResultadosFila");
                if (filaNoResultados) filaNoResultados.remove();
            }
        });
    }
});