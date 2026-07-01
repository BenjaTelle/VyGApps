/**
 * Archivo: buscadorUso.js
 * Descripción: Script de búsqueda dinámica en tiempo real para el historial de uso de maquinaria.
 * Filtra las filas de la tabla por cualquier columna basándose en el término introducido.
 */

document.addEventListener("DOMContentLoaded", function() {
    const inputBuscador = document.getElementById("buscador");
    const tabla = document.getElementById("tablaUso");
    
    if (inputBuscador && tabla) {
        const filas = tabla.querySelectorAll("tbody tr.fila-dato");
        
        // Crear fila para mensaje de "Sin resultados" dinámicamente si no existe
        let filaVacia = document.getElementById("fila-sin-resultados");
        if (!filaVacia) {
            const columnas = tabla.querySelectorAll("thead th").length;
            filaVacia = document.createElement("tr");
            filaVacia.id = "fila-sin-resultados";
            filaVacia.style.display = "none";
            filaVacia.innerHTML = `
                <td colspan="${columnas}" class="empty-message" style="text-align: center; padding: 25px; color: #64748b;">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="display:inline-block; vertical-align:middle; margin-right:8px; color:#94a3b8;"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                    No se encontraron coincidencias para la búsqueda.
                </td>
            `;
            tabla.querySelector("tbody").appendChild(filaVacia);
        }

        inputBuscador.addEventListener("keyup", function(event) {
            const termino = event.target.value.toLowerCase().trim();
            let encontradas = 0;
            
            filas.forEach(function(fila) {
                const texto = fila.textContent.toLowerCase();
                if (texto.includes(termino)) {
                    fila.style.display = "";
                    encontradas++;
                } else {
                    fila.style.display = "none";
                }
            });
            
            // Mostrar o ocultar mensaje si no hay filas visibles
            if (encontradas === 0 && termino !== "") {
                filaVacia.style.display = "";
            } else {
                filaVacia.style.display = "none";
            }
        });
    }
});
