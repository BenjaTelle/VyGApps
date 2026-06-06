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
public class AsistenciaDTO {

    private int idTrabajador;
    private String nombreTrabajador;
    private Time horaEntrada;
    private Time horaSalida;
    private Date fecha;
    private String estado_turno;
    private int horasExtras;
    private int marcaAnomala;

    
        
    public AsistenciaDTO() {
    }

    public int getHorasExtras() {
        return horasExtras;
    }

    public void setHorasExtras(int horasExtras) {
        this.horasExtras = horasExtras;
    }

    public int getMarcaAnomala() {
        return marcaAnomala;
    }

    public void setMarcaAnomala(int marcaAnomala) {
        this.marcaAnomala = marcaAnomala;
    }

    public int getIdTrabajador() {
        return idTrabajador;
    }

    public void setIdTrabajador(int idTrabajador) {
        this.idTrabajador = idTrabajador;
    }

    public String getNombreTrabajador() {
        return nombreTrabajador;
    }

    public void setNombreTrabajador(String nombreTrabajador) {
        this.nombreTrabajador = nombreTrabajador;
    }

    public Time getHoraEntrada() {
        return horaEntrada;
    }

    public void setHoraEntrada(Time horaEntrada) {
        this.horaEntrada = horaEntrada;
    }

    public Time getHoraSalida() {
        return horaSalida;
    }

    public void setHoraSalida(Time horaSalida) {
        this.horaSalida = horaSalida;
    }

    public Date getFecha() {
        return fecha;
    }

    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }

    public String getEstado_turno() {
        return estado_turno;
    }

    public void setEstado_turno(String estado_turno) {
        this.estado_turno = estado_turno;
    }

    
    
    
}
