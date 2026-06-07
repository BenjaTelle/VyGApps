/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package DTO;

/**
 *
 * @author Benja
 */
public class PagoNominaDTO {
private String nombreTrabajador;
    private String fechaGeneracion;
    private String periodoInicio;
    private String periodoFin;
    private int diasTrabajados;
    private double montoHorasExtras;
    private int diasJustificados;
    private double montoPagado;

    public PagoNominaDTO() {
    }

    public String getNombreTrabajador() {
        return nombreTrabajador;
    }

    public void setNombreTrabajador(String nombreTrabajador) {
        this.nombreTrabajador = nombreTrabajador;
    }

    public String getFechaGeneracion() {
        return fechaGeneracion;
    }

    public void setFechaGeneracion(String fechaGeneracion) {
        this.fechaGeneracion = fechaGeneracion;
    }

    public String getPeriodoInicio() {
        return periodoInicio;
    }

    public void setPeriodoInicio(String periodoInicio) {
        this.periodoInicio = periodoInicio;
    }

    public String getPeriodoFin() {
        return periodoFin;
    }

    public void setPeriodoFin(String periodoFin) {
        this.periodoFin = periodoFin;
    }

    public int getDiasTrabajados() {
        return diasTrabajados;
    }

    public void setDiasTrabajados(int diasTrabajados) {
        this.diasTrabajados = diasTrabajados;
    }

    public double getMontoHorasExtras() {
        return montoHorasExtras;
    }

    public void setMontoHorasExtras(double montoHorasExtras) {
        this.montoHorasExtras = montoHorasExtras;
    }

    public int getDiasJustificados() {
        return diasJustificados;
    }

    public void setDiasJustificados(int diasJustificados) {
        this.diasJustificados = diasJustificados;
    }

    public double getMontoPagado() {
        return montoPagado;
    }

    public void setMontoPagado(double montoPagado) {
        this.montoPagado = montoPagado;
    }
    
    
    
    
    
}
