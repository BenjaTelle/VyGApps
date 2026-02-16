/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

/**
 *
 * @author Benja
 */
public class pago {
    private int pago;
    private double monto_presupuesto;
    private Date fecha_quincena;
    private String Estado;
    private int trabajador;
    private int id_user;
    private int id_jefe;

    public pago() {
    }

    public pago(int pago, double monto_presupuesto, Date fecha_quincena, String Estado, int trabajador, int id_user, int id_jefe) {
        this.pago = pago;
        this.monto_presupuesto = monto_presupuesto;
        this.fecha_quincena = fecha_quincena;
        this.Estado = Estado;
        this.trabajador = trabajador;
        this.id_user = id_user;
        this.id_jefe = id_jefe;
    }

    public int getPago() {
        return pago;
    }

    public void setPago(int pago) {
        this.pago = pago;
    }

    public double getMonto_presupuesto() {
        return monto_presupuesto;
    }

    public void setMonto_presupuesto(double monto_presupuesto) {
        this.monto_presupuesto = monto_presupuesto;
    }

    public Date getFecha_quincena() {
        return fecha_quincena;
    }

    public void setFecha_quincena(Date fecha_quincena) {
        this.fecha_quincena = fecha_quincena;
    }

    public String getEstado() {
        return Estado;
    }

    public void setEstado(String Estado) {
        this.Estado = Estado;
    }

    public int getTrabajador() {
        return trabajador;
    }

    public void setTrabajador(int trabajador) {
        this.trabajador = trabajador;
    }

    public int getId_user() {
        return id_user;
    }

    public void setId_user(int id_user) {
        this.id_user = id_user;
    }

    public int getId_jefe() {
        return id_jefe;
    }

    public void setId_jefe(int id_jefe) {
        this.id_jefe = id_jefe;
    }
    
}
