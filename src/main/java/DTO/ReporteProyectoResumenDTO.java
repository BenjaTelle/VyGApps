/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DTO;

/**
 *
 * @author Benja
 */
public class ReporteProyectoResumenDTO {
    private int TotalProyectos;
    private int ProyectosActivos;
    private double TotalInvertivo;

    public ReporteProyectoResumenDTO() {
    }

    public ReporteProyectoResumenDTO(int TotalProyectos, int ProyectosActivos, double TotalInvertivo) {
        this.TotalProyectos = TotalProyectos;
        this.ProyectosActivos = ProyectosActivos;
        this.TotalInvertivo = TotalInvertivo;
    }

    public int getTotalProyectos() {
        return TotalProyectos;
    }

    public void setTotalProyectos(int TotalProyectos) {
        this.TotalProyectos = TotalProyectos;
    }

    public int getProyectosActivos() {
        return ProyectosActivos;
    }

    public void setProyectosActivos(int ProyectosActivos) {
        this.ProyectosActivos = ProyectosActivos;
    }

    public double getTotalInvertivo() {
        return TotalInvertivo;
    }

    public void setTotalInvertivo(double TotalInvertivo) {
        this.TotalInvertivo = TotalInvertivo;
    }
    
}
