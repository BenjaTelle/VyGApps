package DTO;

import java.sql.Timestamp;

public class DeduccionDTO {
    private int idDeduccion;
    private int idTrabajador;
    private String nombreTrabajador;
    private String concepto;
    private double monto;
    private String estado;
    private Timestamp fechaRegistro;
    private Integer idUserRegistra;

    public DeduccionDTO() {}

    public int getIdDeduccion() {
        return idDeduccion;
    }

    public void setIdDeduccion(int idDeduccion) {
        this.idDeduccion = idDeduccion;
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

    public String getConcepto() {
        return concepto;
    }

    public void setConcepto(String concepto) {
        this.concepto = concepto;
    }

    public double getMonto() {
        return monto;
    }

    public void setMonto(double monto) {
        this.monto = monto;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public Timestamp getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(Timestamp fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }

    public Integer getIdUserRegistra() {
        return idUserRegistra;
    }

    public void setIdUserRegistra(Integer idUserRegistra) {
        this.idUserRegistra = idUserRegistra;
    }
}
