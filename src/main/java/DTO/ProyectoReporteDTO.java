/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DTO;

/**
 *
 * @author Benja
 */
public class ProyectoReporteDTO {
    private String nombreProyecto;
    private String supervisor;
    private int cantidadTrabajadores;
    private double TotalPagado;
    private String Estado;

    public ProyectoReporteDTO() {
    }

    public ProyectoReporteDTO(String nombreProyecto, String supervisor, int cantidadTrabajadores, double TotalPagado, String Estado) {
        this.nombreProyecto = nombreProyecto;
        this.supervisor = supervisor;
        this.cantidadTrabajadores = cantidadTrabajadores;
        this.TotalPagado = TotalPagado;
        this.Estado = Estado;
    }

    public String getNombreProyecto() {
        return nombreProyecto;
    }

    public void setNombreProyecto(String nombreProyecto) {
        this.nombreProyecto = nombreProyecto;
    }

    public String getSupervisor() {
        return supervisor;
    }

    public void setSupervisor(String supervisor) {
        this.supervisor = supervisor;
    }

    public int getCantidadTrabajadores() {
        return cantidadTrabajadores;
    }

    public void setCantidadTrabajadores(int cantidadTrabajadores) {
        this.cantidadTrabajadores = cantidadTrabajadores;
    }

    public double getTotalPagado() {
        return TotalPagado;
    }

    public void setTotalPagado(double TotalPagado) {
        this.TotalPagado = TotalPagado;
    }

    public String getEstado() {
        return Estado;
    }

    public void setEstado(String Estado) {
        this.Estado = Estado;
    }
    
    
    
}
