/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Benja
 */
public class material {

   
     private int id_material;
     private double costo_unitario;
     private String unidad_medida;
     private String nombre_material;
     
     
      public material() {
    }

    public material(int id_material, double costo_unitario, String unidad_medida, String nombre_material) {
        this.id_material = id_material;
        this.costo_unitario = costo_unitario;
        this.unidad_medida = unidad_medida;
        this.nombre_material = nombre_material;
    }

    public int getId_material() {
        return id_material;
    }

    public void setId_material(int id_material) {
        this.id_material = id_material;
    }

    public double getCosto_unitario() {
        return costo_unitario;
    }

    public void setCosto_unitario(double costo_unitario) {
        this.costo_unitario = costo_unitario;
    }

    public String getUnidad_medida() {
        return unidad_medida;
    }

    public void setUnidad_medida(String unidad_medida) {
        this.unidad_medida = unidad_medida;
    }

    public String getNombre_material() {
        return nombre_material;
    }

    public void setNombre_material(String nombre_material) {
        this.nombre_material = nombre_material;
    }
      
      
     
}
