/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
 package DTO;

public class ReporteTrabajadorDTO {
    private int idTrabajador;
    private String nombreCompleto;
    private String nombreProyecto;
    private double salarioBase;
    private String estado;

    // Getters y Setters
    public int getIdTrabajador() { return idTrabajador; }
    public void setIdTrabajador(int idTrabajador) { this.idTrabajador = idTrabajador; }

    public String getNombreCompleto() { return nombreCompleto; }
    public void setNombreCompleto(String nombreCompleto) { this.nombreCompleto = nombreCompleto; }

    public String getNombreProyecto() { return nombreProyecto; }
    public void setNombreProyecto(String nombreProyecto) { this.nombreProyecto = nombreProyecto; }

    public double getSalarioBase() { return salarioBase; }
    public void setSalarioBase(double salarioBase) { this.salarioBase = salarioBase; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
}