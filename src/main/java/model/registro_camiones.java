/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalTime;

/**
 *
 * @author Benja
 */
public class registro_camiones {

 
    private int id_ruta;
    private LocalTime hora_salida;
    private LocalTime hora_llegada;
    private String origen;
    private  String destino;
    private String material_cargado;
    private int cantidad_carga;
    private int id_uso;
    
    
       public registro_camiones() {
    }

    public registro_camiones(int id_ruta, LocalTime hora_salida, LocalTime hora_llegada, String origen, String destino, String material_cargado, int cantidad_carga, int id_uso) {
        this.id_ruta = id_ruta;
        this.hora_salida = hora_salida;
        this.hora_llegada = hora_llegada;
        this.origen = origen;
        this.destino = destino;
        this.material_cargado = material_cargado;
        this.cantidad_carga = cantidad_carga;
        this.id_uso = id_uso;
    }

    public int getId_ruta() {
        return id_ruta;
    }

    public void setId_ruta(int id_ruta) {
        this.id_ruta = id_ruta;
    }

    public LocalTime getHora_salida() {
        return hora_salida;
    }

    public void setHora_salida(LocalTime hora_salida) {
        this.hora_salida = hora_salida;
    }

    public LocalTime getHora_llegada() {
        return hora_llegada;
    }

    public void setHora_llegada(LocalTime hora_llegada) {
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

    public String getMaterial_cargado() {
        return material_cargado;
    }

    public void setMaterial_cargado(String material_cargado) {
        this.material_cargado = material_cargado;
    }

    public int getCantidad_carga() {
        return cantidad_carga;
    }

    public void setCantidad_carga(int cantidad_carga) {
        this.cantidad_carga = cantidad_carga;
    }

    public int getId_uso() {
        return id_uso;
    }

    public void setId_uso(int id_uso) {
        this.id_uso = id_uso;
    }
    
    
}

