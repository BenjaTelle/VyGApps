/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


/**
 * Archivo: buscadorCamiones.js
 * Descripción: Script para el filtrado dinámico en tiempo real de la tabla de historial de camiones.
 * Utiliza el evento 'keyup' para buscar coincidencias de texto en las filas de la tabla.
 * Fecha de creación: 4 mar 2026
 * Autor: Benja
 */

document.addEventListener("DOMContentLoaded", function() {
    // Referencias a los elementos del DOM
    const inputBuscador = document.getElementById("buscador");
    const filasTabla = document.querySelectorAll("#tablaCamiones tbody tr.fila-dato");

    // Validamos que los elementos existan en la vista antes de asignar eventos
    if (inputBuscador && filasTabla.length > 0) {
        
        inputBuscador.addEventListener("keyup", function(event) {
            const terminoBusqueda = event.target.value.toLowerCase();
            
            // Iteramos sobre cada fila con la clase .fila-dato
            filasTabla.forEach(function(fila) {
                const textoFila = fila.textContent.toLowerCase();
                
                // Mostramos u ocultamos la fila según la coincidencia
                if (textoFila.includes(terminoBusqueda)) {
                    fila.style.display = "";
                } else {
                    fila.style.display = "none";
                }
            });
        });
    }
});