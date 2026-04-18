/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DTO;

/**
 *
 * @author Benja
 */
public class ListarProyectosDTO {
    
    private int id;
    private String nombre_proyecto;
    private String nombre_supervisor;
    private double presupuesto_total;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    
    
    public String getNombre_proyecto() {
        return nombre_proyecto;
    }

    public void setNombre_proyecto(String nombre_proyecto) {
        this.nombre_proyecto = nombre_proyecto;
    }

    public String getNombre_supervisor() {
        return nombre_supervisor;
    }

    public void setNombre_supervisor(String nombre_supervisor) {
        this.nombre_supervisor = nombre_supervisor;
    }

    public double getPresupuesto_total() {
        return presupuesto_total;
    }

    public void setPresupuesto_total(double presupuesto_total) {
        this.presupuesto_total = presupuesto_total;
    }

    public ListarProyectosDTO() {
    }
    
    
    
}
