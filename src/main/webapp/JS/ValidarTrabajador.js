/**
 * Lógica de Validación y Autocompletado para Trabajadores
 * @author Benja
 */
document.addEventListener("DOMContentLoaded", function() {
    
    // Elementos del DOM (Pueden o no existir dependiendo del JSP en el que estemos)
    const inputCedula = document.getElementById("cedula");
    const errorCedula = document.getElementById("errorCedula");
    const form = document.getElementById("formTrabajador");
    const selectTrabajador = document.getElementById('selectTrabajador');

    /* ======================================================================
       1. FORMATEO Y VALIDACIÓN DE LA CÉDULA (Compartido en Registrar y Actualizar)
       ====================================================================== */
    if (inputCedula) {
        inputCedula.addEventListener("input", function(e) {
            // Limpia todo y fuerza mayúsculas
            let val = e.target.value.replace(/[^0-9A-Za-z]/g, '').toUpperCase();
            
            // Inyecta los guiones
            if (val.length > 3 && val.length <= 9) {
                val = val.slice(0, 3) + "-" + val.slice(3);
            } else if (val.length > 9) {
                val = val.slice(0, 3) + "-" + val.slice(3, 9) + "-" + val.slice(9, 14);
            }
            
            e.target.value = val;
            
            // Remueve alertas si el usuario está corrigiendo
            inputCedula.classList.remove("input-error");
            if (errorCedula) errorCedula.style.display = "none";
        });
    }

    if (form) {
        form.addEventListener("submit", function(e) {
            const regexCedula = /^\d{3}-\d{6}-\d{4}[A-Z]$/;
            
            if (inputCedula && inputCedula.value.trim() !== "") {
                if (!regexCedula.test(inputCedula.value)) {
                    e.preventDefault(); // Evita que se recargue/envíe al Servlet
                    if (errorCedula) errorCedula.style.display = "block";
                    inputCedula.classList.add("input-error");
                    inputCedula.focus();
                }
            }
        });
    }


    /* ======================================================================
       2. AUTOCOMPLETADO DE DATOS (Solo aplica en ActualizarTrabajador.jsp)
       ====================================================================== */
    if (selectTrabajador) {
        const toggleFields = (disabled) => {
            const elements = form.querySelectorAll('.form-grid input, .form-grid select, .form-grid textarea, #btn-submit-trabajador');
            elements.forEach(el => {
                el.disabled = disabled;
            });
            const btn = document.getElementById('btn-submit-trabajador');
            if (btn) {
                if (disabled) {
                    btn.style.opacity = '0.6';
                    btn.style.cursor = 'not-allowed';
                } else {
                    btn.style.opacity = '1';
                    btn.style.cursor = 'pointer';
                }
            }
        };

        selectTrabajador.addEventListener('change', function() {
            const selectedOption = this.options[this.selectedIndex];
            
            // Si elige "Seleccione un trabajador", limpiamos el formulario
            if(!selectedOption.value) {
                form.reset();
                toggleFields(true);
                return; 
            }

            // Habilitar campos
            toggleFields(false);

            // Capturamos el paquete de datos ocultos (data-*)
            const data = selectedOption.dataset;

            // Rellenamos los inputs de texto/número
            document.getElementById('in_fullname').value = data.fullname || '';
            document.getElementById('cedula').value = data.cedula || '';
            document.getElementById('in_edad').value = data.edad || '';
            document.getElementById('in_telefono').value = data.telefono || '';
            document.getElementById('in_emergencia').value = data.emergencia || '';
            document.getElementById('in_direccion').value = data.direccion || '';
            document.getElementById('in_salario').value = data.salario || '';
            document.getElementById('in_origen').value = data.origen || '';
            
            // Seleccionamos las opciones correctas en los desplegables
            document.getElementById('in_puesto').value = data.puesto || '';
            document.getElementById('in_supervisor').value = data.idsupervisor || '0';
            document.getElementById('in_proyecto').value = data.idproyecto || '0';
            
            // Restaurar diseño normal de cédula si tenía error
            if (inputCedula) inputCedula.classList.remove("input-error");
            if (errorCedula) errorCedula.style.display = "none";
        });
    }
});