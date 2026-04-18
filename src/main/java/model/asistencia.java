/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Time;
import java.time.LocalTime;
import java.util.Date;

/**
 *
 * @author Benja
 */
public class asistencia {
    private int id_asistencia;
    private Time hora_entrada;
    private Time hora_salida;
    private Date fecha;
    private int id_trabajador;

    public asistencia() {
    }

    public asistencia(int id_asistencia, Time hora_entrada, Time hora_salida, Date fecha, int id_trabajador) {
        this.id_asistencia = id_asistencia;
        this.hora_entrada = hora_entrada;
        this.hora_salida = hora_salida;
        this.fecha = fecha;
        this.id_trabajador = id_trabajador;
    }

    public int getId_asistencia() {
        return id_asistencia;
    }

    public void setId_asistencia(int id_asistencia) {
        this.id_asistencia = id_asistencia;
    }

    public Time getHora_entrada() {
        return hora_entrada;
    }

    public void setHora_entrada(Time hora_entrada) {
        this.hora_entrada = hora_entrada;
    }

    public Time getHora_salida() {
        return hora_salida;
    }

    public void setHora_salida(Time hora_salida) {
        this.hora_salida = hora_salida;
    }

    public Date getFecha() {
        return fecha;
    }

    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }

    public int getId_trabajador() {
        return id_trabajador;
    }

    public void setId_trabajador(int id_trabajador) {
        this.id_trabajador = id_trabajador;
    }
    
}

