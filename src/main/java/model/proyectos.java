/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Benja
 */
public class proyectos {


        private int proyecto_id;
        private String nombre_proyecto;
        private String supervisor;
        private String estado;
        private Double presupuesto_total;
        
            public proyectos() {
    }

    public proyectos(int proyecto_id, String nombre_proyecto, String supervisor, String estado, Double presupuesto_total) {
        this.proyecto_id = proyecto_id;
        this.nombre_proyecto = nombre_proyecto;
        this.supervisor = supervisor;
        this.estado = estado;
        this.presupuesto_total = presupuesto_total;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public Double getPresupuesto_total() {
        return presupuesto_total;
    }

    public void setPresupuesto_total(Double presupuesto_total) {
        this.presupuesto_total = presupuesto_total;
    }

  

    public int getProyecto_id() {
        return proyecto_id;
    }

    public void setProyecto_id(int proyecto_id) {
        this.proyecto_id = proyecto_id;
    }

    public String getNombre_proyecto() {
        return nombre_proyecto;
    }

    public void setNombre_proyecto(String nombre_proyecto) {
        this.nombre_proyecto = nombre_proyecto;
    }

    public String getSupervisor() {
        return supervisor;
    }

    public void setSupervisor(String supervisor) {
        this.supervisor = supervisor;
    }
            
            
        
}
