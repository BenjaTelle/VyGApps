/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


function imprimirNativo() {
    window.print();
}

function descargarPDF_Reporte() {
    // Ocultar botones temporalmente
    const actionBar = document.getElementById('actionBar');
    actionBar.style.display = 'none';
    
    // Contenedor a exportar
    const elemento = document.getElementById('documentoReporte');
    
    // Configuración estricta para evitar cortes de tabla
    const opciones = {
        margin:       [10, 10, 10, 10], // top, left, bottom, right (mm)
        filename:     'Reporte_Oficial_Auditoria_Kronos.pdf',
        image:        { type: 'jpeg', quality: 1.0 },
        html2canvas:  { scale: 2, useCORS: true },
        jsPDF:        { unit: 'mm', format: 'letter', orientation: 'landscape' },
        pagebreak:    { mode: ['avoid-all', 'css', 'legacy'] }
    };

    html2pdf().set(opciones).from(elemento).save().then(() => {
        // Restaurar botones tras descargar
        actionBar.style.display = 'flex';
    });
}