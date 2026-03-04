/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Benja
 */
public class maquinas {

    
    private int id_maquina;
    private String tipo_maquina;
    private String marca;
    private String funcion;
    private double costo_por_hora;
    
    public maquinas() {
    }

    public maquinas(int id_maquina, String tipo_maquina, String marca, String funcion, double costo_por_hora) {
        this.id_maquina = id_maquina;
        this.tipo_maquina = tipo_maquina;
        this.marca = marca;
        this.funcion = funcion;
        this.costo_por_hora = costo_por_hora;
    }

    public double getCosto_por_hora() {
        return costo_por_hora;
    }

    public void setCosto_por_hora(double costo_por_hora) {
        this.costo_por_hora = costo_por_hora;
    }

    

    public int getId_maquina() {
        return id_maquina;
    }

    public void setId_maquina(int id_maquina) {
        this.id_maquina = id_maquina;
    }

    public String getTipo_maquina() {
        return tipo_maquina;
    }

    public void setTipo_maquina(String tipo_maquina) {
        this.tipo_maquina = tipo_maquina;
    }

    public String getMarca() {
        return marca;
    }

    public void setMarca(String marca) {
        this.marca = marca;
    }

    public String getFuncion() {
        return funcion;
    }

    public void setFuncion(String funcion) {
        this.funcion = funcion;
    }
    
}
