/*
 * Script para el buscador en tiempo real de tarjetas de proyectos
 * Permite buscar por Nombre, Supervisor o Presupuesto.
 */

document.addEventListener("DOMContentLoaded", function() {
    
    const buscador = document.getElementById("buscador");

    if (buscador) {
        buscador.addEventListener("keyup", function() {
            // Convertimos lo que el usuario escribe a minúsculas
            let texto = this.value.toLowerCase();
            let tarjetas = document.querySelectorAll(".project-card");
            
            tarjetas.forEach(function(tarjeta) {
                // textContent captura TODO el texto visible dentro de la tarjeta
                // (Título, nombre del supervisor, monto del presupuesto, etc.)
                let contenidoTarjeta = tarjeta.textContent.toLowerCase();
                
                if (contenidoTarjeta.includes(texto)) {
                    tarjeta.style.display = "flex"; 
                } else {
                    tarjeta.style.display = "none";
                }
            });
        });
    }
});