/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

/**
 * Efectos visuales para el Panel de Administrador
 * @author Benja
 */
document.addEventListener("DOMContentLoaded", () => {
    const cards = document.querySelectorAll(".dashboard-card");

    // Animación de aparición suave progresiva
    cards.forEach((card, index) => {
        card.style.opacity = "0";
        card.style.transform = "translateY(15px)";
        card.style.transition = "all 0.3s ease-out";

        setTimeout(() => {
            card.style.opacity = "1";
            card.style.transform = "translateY(0)";
        }, 100 * index);
    });
});
