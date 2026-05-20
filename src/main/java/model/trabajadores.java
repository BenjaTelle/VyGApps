/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Benja
 */
public class trabajadores {

    public trabajadores(String cedula, String full_name, int edad, String puesto, double salario_quincenal, String origen, int id_supervisor, int id_proyect) {
        this.cedula = cedula;
        this.full_name = full_name;
        this.edad = edad;
        this.puesto = puesto;
        this.salario_quincenal = salario_quincenal;
        this.origen = origen;
        this.id_supervisor = id_supervisor;
        this.id_proyect = id_proyect;
        
    }
    private int id_trabajador;
    private String cedula;
    private String full_name;
    private int edad;
    private String puesto;
    private double salario_quincenal;
    private String origen;
    private int id_supervisor;
    private int id_proyect;
    private String telefono;
    private String numero_emergencia;
    private String direccion;
    
    
    public trabajadores() {
    }

    public trabajadores(int id_trabajador, String cedula, String full_name, int edad, String puesto, double salario_quincenal, String origen, int id_supervisor, int id_proyect) {
        this.id_trabajador = id_trabajador;
        this.cedula = cedula;
        this.full_name = full_name;
        this.edad = edad;
        this.puesto = puesto;
        this.salario_quincenal = salario_quincenal;
        this.origen = origen;
        this.id_supervisor = id_supervisor;
        this.id_proyect = id_proyect;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getNumero_emergencia() {
        return numero_emergencia;
    }

    public void setNumero_emergencia(String numero_emergencia) {
        this.numero_emergencia = numero_emergencia;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }



    public int getId_trabajador() {
        return id_trabajador;
    }

    public void setId_trabajador(int id_trabajador) {
        this.id_trabajador = id_trabajador;
    }

    public String getCedula() {
        return cedula;
    }

    public void setCedula(String cedula) {
        this.cedula = cedula;
    }

    public String getFull_name() {
        return full_name;
    }

    public void setFull_name(String full_name) {
        this.full_name = full_name;
    }

    public int getEdad() {
        return edad;
    }

    public void setEdad(int edad) {
        this.edad = edad;
    }

    public String getPuesto() {
        return puesto;
    }

    public void setPuesto(String puesto) {
        this.puesto = puesto;
    }

    public double getSalario_quincenal() {
        return salario_quincenal;
    }

    public void setSalario_quincenal(double salario_quincenal) {
        this.salario_quincenal = salario_quincenal;
    }

    public String getOrigen() {
        return origen;
    }

    public void setOrigen(String origen) {
        this.origen = origen;
    }

    public int getId_supervisor() {
        return id_supervisor;
    }

    public void setId_supervisor(int id_supervisor) {
        this.id_supervisor = id_supervisor;
    }

    public int getId_proyect() {
        return id_proyect;
    }

    public void setId_proyect(int id_proyect) {
        this.id_proyect = id_proyect;
    }
    
    
}
