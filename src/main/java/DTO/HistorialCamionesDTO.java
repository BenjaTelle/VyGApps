/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DTO;

import java.sql.Date;
import java.sql.Time;

/**
 *
 * @author Benja
 */
public class HistorialCamionesDTO {
    
    private int id_ruta;
    private double  cantidad_cargada;
    private String origen;
    private String destino;
    private Time    hora_salida;
     private Time    hora_entrada;
     private double costo_flete;
     private Date fecha;
     private String nombre_proyecto;
     private String tipo_maquina;
     private   String marca;
     private String nombre_material;

    public int getId_ruta() {
        return id_ruta;
    }

    public void setId_ruta(int id_ruta) {
        this.id_ruta = id_ruta;
    }

    public double getCantidad_cargada() {
        return cantidad_cargada;
    }

    public void setCantidad_cargada(double cantidad_cargada) {
        this.cantidad_cargada = cantidad_cargada;
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

    public Time getHora_salida() {
        return hora_salida;
    }

    public void setHora_salida(Time hora_salida) {
        this.hora_salida = hora_salida;
    }

    public Time getHora_entrada() {
        return hora_entrada;
    }

    public void setHora_entrada(Time hora_entrada) {
        this.hora_entrada = hora_entrada;
    }

    public double getCosto_flete() {
        return costo_flete;
    }

    public void setCosto_flete(double costo_flete) {
        this.costo_flete = costo_flete;
    }

    public Date getFecha() {
        return fecha;
    }

    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }

    public String getNombre_proyecto() {
        return nombre_proyecto;
    }

    public void setNombre_proyecto(String nombre_proyecto) {
        this.nombre_proyecto = nombre_proyecto;
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

    public String getNombre_material() {
        return nombre_material;
    }

    public void setNombre_material(String nombre_material) {
        this.nombre_material = nombre_material;
    }

    public HistorialCamionesDTO() {
    }

    public HistorialCamionesDTO(int id_ruta, double cantidad_cargada, String origen, String destino, Time hora_salida, Time hora_entrada, double costo_flete, Date fecha, String nombre_proyecto, String tipo_maquina, String marca, String nombre_material) {
        this.id_ruta = id_ruta;
        this.cantidad_cargada = cantidad_cargada;
        this.origen = origen;
        this.destino = destino;
        this.hora_salida = hora_salida;
        this.hora_entrada = hora_entrada;
        this.costo_flete = costo_flete;
        this.fecha = fecha;
        this.nombre_proyecto = nombre_proyecto;
        this.tipo_maquina = tipo_maquina;
        this.marca = marca;
        this.nombre_material = nombre_material;
    }
     
     
     
     
     
     
}
