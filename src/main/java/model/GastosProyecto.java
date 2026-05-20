/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
/**
 *
 * @author Benja
 */

package model;

import java.sql.Date;
import java.sql.Timestamp;

public class GastosProyecto {
    private int idGasto;
    private int idProyecto;
    private String concepto;
    private String descripcion;
    private double monto;
    private Date fechaGasto;
    private String nroComprobante;
    private String categoria;
    private int idUserRegistra;
    private Timestamp fechaRegistro;
    private String estado;
    private Integer idUserAutoriza; // Usamos Integer porque puede ser NULL
    private Timestamp fechaAutorizacion;
    private String observaciones;

    // Constructores
    public GastosProyecto() {}

    // Constructor para registrar un nuevo gasto (sin ID, sin datos de autorización)
    public GastosProyecto(int idProyecto, String concepto, String descripcion, double monto, Date fechaGasto, String nroComprobante, String categoria, int idUserRegistra) {
        this.idProyecto = idProyecto;
        this.concepto = concepto;
        this.descripcion = descripcion;
        this.monto = monto;
        this.fechaGasto = fechaGasto;
        this.nroComprobante = nroComprobante;
        this.categoria = categoria;
        this.idUserRegistra = idUserRegistra;
    }

    // Getters y Setters
    public int getIdGasto() { return idGasto; }
    public void setIdGasto(int idGasto) { this.idGasto = idGasto; }

    public int getIdProyecto() { return idProyecto; }
    public void setIdProyecto(int idProyecto) { this.idProyecto = idProyecto; }

    public String getConcepto() { return concepto; }
    public void setConcepto(String concepto) { this.concepto = concepto; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public double getMonto() { return monto; }
    public void setMonto(double monto) { this.monto = monto; }

    public Date getFechaGasto() { return fechaGasto; }
    public void setFechaGasto(Date fechaGasto) { this.fechaGasto = fechaGasto; }

    public String getNroComprobante() { return nroComprobante; }
    public void setNroComprobante(String nroComprobante) { this.nroComprobante = nroComprobante; }

    public String getCategoria() { return categoria; }
    public void setCategoria(String categoria) { this.categoria = categoria; }

    public int getIdUserRegistra() { return idUserRegistra; }
    public void setIdUserRegistra(int idUserRegistra) { this.idUserRegistra = idUserRegistra; }

    public Timestamp getFechaRegistro() { return fechaRegistro; }
    public void setFechaRegistro(Timestamp fechaRegistro) { this.fechaRegistro = fechaRegistro; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public Integer getIdUserAutoriza() { return idUserAutoriza; }
    public void setIdUserAutoriza(Integer idUserAutoriza) { this.idUserAutoriza = idUserAutoriza; }

    public Timestamp getFechaAutorizacion() { return fechaAutorizacion; }
    public void setFechaAutorizacion(Timestamp fechaAutorizacion) { this.fechaAutorizacion = fechaAutorizacion; }

    public String getObservaciones() { return observaciones; }
    public void setObservaciones(String observaciones) { this.observaciones = observaciones; }
}



