/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Date;
import java.sql.Time;




/**
 *
 * @author Benja
 */
public class uso_registros {

  
     
    private int id_uso;
    private Date fecha;
    private Time hora_inicio;
    private Time hora_fin;
    private double combustible;
    private int id_maquina;
    private int id_proyect;
    private int id_trabajador;
    private double costoT_combustible;
    private double Costo_hora;
    
     public uso_registros() {
    }

    public uso_registros(int id_uso, Date fecha, Time hora_inicio, Time hora_fin, double combustible, int id_maquina, int id_proyect, int id_trabajador, double costoT_combustible) {
        this.id_uso = id_uso;
        this.fecha = fecha;
        this.hora_inicio = hora_inicio;
        this.hora_fin = hora_fin;
        this.combustible = combustible;
        this.id_maquina = id_maquina;
        this.id_proyect = id_proyect;
        this.id_trabajador = id_trabajador;
        this.costoT_combustible = costoT_combustible;
    }

    public double getCosto_hora() {
        return Costo_hora;
    }

    public void setCosto_hora(double Costo_hora) {
        this.Costo_hora = Costo_hora;
    }

    public double getCostoT_combustible() {
        return costoT_combustible;
    }

    public void setCostoT_combustible(double costoT_combustible) {
        this.costoT_combustible = costoT_combustible;
    }


    public int getId_uso() {
        return id_uso;
    }

    public void setId_uso(int id_uso) {
        this.id_uso = id_uso;
    }

    public Date getFecha() {
        return fecha;
    }

    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }

    public Time getHora_inicio() {
        return hora_inicio;
    }

    public void setHora_inicio(Time hora_inicio) {
        this.hora_inicio = hora_inicio;
    }

    public Time getHora_fin() {
        return hora_fin;
    }

    public void setHora_fin(Time hora_fin) {
        this.hora_fin = hora_fin;
    }

  

    public double getCombustible() {
        return combustible;
    }

    public void setCombustible(double combustible) {
        this.combustible = combustible;
    }

    public int getId_maquina() {
        return id_maquina;
    }

    public void setId_maquina(int id_maquina) {
        this.id_maquina = id_maquina;
    }

    public int getId_proyect() {
        return id_proyect;
    }

    public void setId_proyect(int id_proyect) {
        this.id_proyect = id_proyect;
    }

    public int getId_trabajador() {
        return id_trabajador;
    }

    public void setId_trabajador(int id_trabajador) {
        this.id_trabajador = id_trabajador;
    }
}
