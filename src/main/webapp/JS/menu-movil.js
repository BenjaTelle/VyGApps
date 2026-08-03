/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


/**
 * Script para el manejo del Menú Lateral (Sidebar) Responsivo
 * Proyecto: VyGApps
 * Autor: Benja
 */

document.addEventListener("DOMContentLoaded", function() {
    // 1. Capturamos los elementos del DOM
    const menuBtn = document.getElementById("menu-toggle");
    const sidebar = document.getElementById("sidebar");
    const overlay = document.getElementById("sidebarOverlay");

    // Verificamos que los elementos existan en la página actual para evitar errores
    if (menuBtn && sidebar && overlay) {
        
        /**
         * Función para abrir el menú
         */
        const abrirMenu = () => {
            sidebar.classList.add("active");
            overlay.classList.add("active");
            // Bloqueamos el scroll del cuerpo para que no se mueva el fondo
            document.body.style.overflow = "hidden";
        };

        /**
         * Función para cerrar el menú
         */
        const cerrarMenu = () => {
            sidebar.classList.remove("active");
            overlay.classList.remove("active");
            // Devolvemos el scroll al cuerpo
            document.body.style.overflow = "auto";
        };

        // Evento al hacer clic en el botón hamburguesa (☰)
        menuBtn.addEventListener("click", function(e) {
            e.preventDefault();
            abrirMenu();
        });

        // Evento al hacer clic en la capa oscura (Overlay)
        overlay.addEventListener("click", cerrarMenu);

        // Opcional: Cerrar el menú si se presiona la tecla Escape
        document.addEventListener("keydown", function(e) {
            if (e.key === "Escape" && sidebar.classList.contains("active")) {
                cerrarMenu();
            }
        });
    }
});

// Registro de Service Worker para soporte offline
if ('serviceWorker' in navigator) {
    window.addEventListener('load', function() {
        navigator.serviceWorker.register('JS/sw.js')
            .then(function(reg) {
                console.log('Service Worker registrado con éxito para VyGApps:', reg.scope);
            })
            .catch(function(err) {
                console.warn('Error al registrar Service Worker:', err);
            });
    });
}

// Redirección inmediata al perder conexión de red
window.addEventListener('offline', function() {
    window.location.href = 'offline.jsp';
});