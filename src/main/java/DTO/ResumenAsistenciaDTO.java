/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DTO;

/**
 *
 * @author Benja
 */
public class ResumenAsistenciaDTO {
     // --- Datos de Identificación ---
    private String nombreCompleto;
    private String cedula;
    private String puesto;
    private String nombreProyecto;
    
    // --- KPIs (Indicadores de Rendimiento) ---
    private int totalDiasTrabajados;
    private int totalLlegadasTardias;
    private double porcentajePuntualidad; // Ej. 95.5
    private String horasPromedioPorDia;   // Ej. "08h 30m"

    public String getNombreCompleto() {
        return nombreCompleto;
    }

    public void setNombreCompleto(String nombreCompleto) {
        this.nombreCompleto = nombreCompleto;
    }

    public String getCedula() {
        return cedula;
    }

    public void setCedula(String cedula) {
        this.cedula = cedula;
    }

    public String getPuesto() {
        return puesto;
    }

    public void setPuesto(String puesto) {
        this.puesto = puesto;
    }

    public String getNombreProyecto() {
        return nombreProyecto;
    }

    public void setNombreProyecto(String nombreProyecto) {
        this.nombreProyecto = nombreProyecto;
    }

    public int getTotalDiasTrabajados() {
        return totalDiasTrabajados;
    }

    public void setTotalDiasTrabajados(int totalDiasTrabajados) {
        this.totalDiasTrabajados = totalDiasTrabajados;
    }

    public int getTotalLlegadasTardias() {
        return totalLlegadasTardias;
    }

    public void setTotalLlegadasTardias(int totalLlegadasTardias) {
        this.totalLlegadasTardias = totalLlegadasTardias;
    }

    public double getPorcentajePuntualidad() {
        return porcentajePuntualidad;
    }

    public void setPorcentajePuntualidad(double porcentajePuntualidad) {
        this.porcentajePuntualidad = porcentajePuntualidad;
    }

    public String getHorasPromedioPorDia() {
        return horasPromedioPorDia;
    }

    public void setHorasPromedioPorDia(String horasPromedioPorDia) {
        this.horasPromedioPorDia = horasPromedioPorDia;
    }

    public ResumenAsistenciaDTO() {
    }
    
    

    
}
