/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Time;

/**
 *
 * @author Benja
 */
public class camiones {

    private Time hora_salida;
    private Time hora_llegada;
    private String origen;
    private String destino;
    private double cantidad_cargada;
    private int id_uso;
    private double costo_flete;
    private int id_material;

    public camiones(Time hora_salida, Time hora_llegada, String origen, String destino, double cantidad_cargada, int id_uso, double costo_flete, int id_material) {
        this.hora_salida = hora_salida;
        this.hora_llegada = hora_llegada;
        this.origen = origen;
        this.destino = destino;
        this.cantidad_cargada = cantidad_cargada;
        this.id_uso = id_uso;
        this.costo_flete = costo_flete;
        this.id_material = id_material;
    }

    public camiones() {
    }

    public Time getHora_salida() {
        return hora_salida;
    }

    public void setHora_salida(Time hora_salida) {
        this.hora_salida = hora_salida;
    }

    public Time getHora_llegada() {
        return hora_llegada;
    }

    public void setHora_llegada(Time hora_llegada) {
        this.hora_llegada = hora_llegada;
    }

    public String getOrigen() {
        return origen;
    }

    public void setOrigen(String origen) {
        this.origen = origen;
    }

    public String getDestino() {
        return destino;
    }

    public void setDestino(String destino) {
        this.destino = destino;
    }

    public double getCantidad_cargada() {
        return cantidad_cargada;
    }

    public void setCantidad_cargada(double cantidad_cargada) {
        this.cantidad_cargada = cantidad_cargada;
    }

    public int getId_uso() {
        return id_uso;
    }

    public void setId_uso(int id_uso) {
        this.id_uso = id_uso;
    }

    public double getCosto_flete() {
        return costo_flete;
    }

    public void setCosto_flete(double costo_flete) {
        this.costo_flete = costo_flete;
    }

    public int getId_material() {
        return id_material;
    }

    public void setId_material(int id_material) {
        this.id_material = id_material;
    }

    
    
}
