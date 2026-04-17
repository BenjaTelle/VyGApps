/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DTO;

public class AuditoriaPagoDTO {
    
    private String codigoRecibo; // Ej. NOM-001 o MAQ-005 para diferenciarlos
    private String tipoPago;     // "Nómina" o "Maquinaria"
    private String concepto;     // Nombre del trabajador o de la máquina
    private String nombreProyecto;
    private String generadoPor;
    private String autorizadoPor;
    private String fechaPago;
    private double montoPagado;

    // Genera aquí tus Getters y Setters...
    public String getCodigoRecibo() { return codigoRecibo; }
    public void setCodigoRecibo(String codigoRecibo) { this.codigoRecibo = codigoRecibo; }
    
    public String getTipoPago() { return tipoPago; }
    public void setTipoPago(String tipoPago) { this.tipoPago = tipoPago; }
    
    public String getConcepto() { return concepto; }
    public void setConcepto(String concepto) { this.concepto = concepto; }
    
    public String getNombreProyecto() { return nombreProyecto; }
    public void setNombreProyecto(String nombreProyecto) { this.nombreProyecto = nombreProyecto; }
    
    public String getGeneradoPor() { return generadoPor; }
    public void setGeneradoPor(String generadoPor) { this.generadoPor = generadoPor; }
    
    public String getAutorizadoPor() { return autorizadoPor; }
    public void setAutorizadoPor(String autorizadoPor) { this.autorizadoPor = autorizadoPor; }
    
    public String getFechaPago() { return fechaPago; }
    public void setFechaPago(String fechaPago) { this.fechaPago = fechaPago; }
    
    public double getMontoPagado() { return montoPagado; }
    public void setMontoPagado(double montoPagado) { this.montoPagado = montoPagado; }
}