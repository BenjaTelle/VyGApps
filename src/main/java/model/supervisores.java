/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Benja
 */
public class supervisores {
    private int id_proyecto; 
    private int id_trabajador;

    public int getId_proyecto() {
        return id_proyecto;
    }

    public void setId_proyecto(int id_proyecto) {
        this.id_proyecto = id_proyecto;
    }

    public int getId_trabajador() {
        return id_trabajador;
    }

    public void setId_trabajador(int id_trabajador) {
        this.id_trabajador = id_trabajador;
    }

    public supervisores() {
    }

    public supervisores(int id_proyecto, int id_trabajador) {
        this.id_proyecto = id_proyecto;
        this.id_trabajador = id_trabajador;
    }
    
    
    
}
