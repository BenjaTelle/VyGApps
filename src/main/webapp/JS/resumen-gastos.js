document.addEventListener("DOMContentLoaded", function() {
    const inputBuscador = document.getElementById("buscadorTabla");
    const filasTabla = document.querySelectorAll("#tablaDashboard tbody tr.fila-dato");

    if (inputBuscador && filasTabla.length > 0) {
        inputBuscador.addEventListener("keyup", function(e) {
            const termino = e.target.value.toLowerCase();
            filasTabla.forEach(function(fila) {
                const texto = fila.textContent.toLowerCase();
                fila.style.display = texto.includes(termino) ? "" : "none";
            });
        });
    }
});

/* Imprimir nativamente (Usa el @media print del CSS) */
function imprimirNativo() {
    window.print();
}

/* Generar el PDF corporativo desde la plantilla oculta */
function descargarPDF() {
    const elementoImpresion = document.getElementById('plantilla-oficial');
    
    // Lo hacemos visible temporalmente solo para que la librería pueda tomar la foto
    elementoImpresion.style.position = 'relative';
    elementoImpresion.style.left = '0';

    const opciones = {
        margin:       10,
        filename:     'Reporte_Egresos_Kronos.pdf',
        image:        { type: 'jpeg', quality: 0.98 },
        html2canvas:  { scale: 2, useCORS: true },
        jsPDF:        { unit: 'mm', format: 'a4', orientation: 'landscape' }
    };

    html2pdf().set(opciones).from(elementoImpresion).save().then(function() {
        // Lo devolvemos a su estado oculto
        elementoImpresion.style.position = 'absolute';
        elementoImpresion.style.left = '-9999px';
    });
}