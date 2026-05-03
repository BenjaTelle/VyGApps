/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


/**
 * Interacciones para la Bandeja de Autorizaciones
 * @author Benja
 */

document.addEventListener("DOMContentLoaded", () => {
    // Si hay una alerta en pantalla, la desvanece suavemente a los 8 segundos
    const alertBox = document.getElementById("alertBox");
    if (alertBox) {
        setTimeout(() => {
            alertBox.style.transition = "opacity 0.5s ease";
            alertBox.style.opacity = "0";
            setTimeout(() => alertBox.remove(), 500);
        }, 8000);
    }
});

/**
 * Cierre manual de las alertas
 */
function dismissAlert() {
    const alertBox = document.getElementById("alertBox");
    if (alertBox) {
        alertBox.style.transition = "opacity 0.3s ease";
        alertBox.style.opacity = "0";
        setTimeout(() => alertBox.remove(), 300);
    }
}

/**
 * Cuadro de confirmación personalizado
 */
function confirmApproval(tipo, itemNombre, monto) {
    const tipoTexto = tipo === 'nomina' ? 'la nómina del colaborador' : 'el pago de maquinaria para';
    return confirm(`¿Estás seguro de autorizar ${tipoTexto} "${itemNombre}" por un monto total de C$ ${monto}? Se debitará del presupuesto asignado a la obra.`);
}