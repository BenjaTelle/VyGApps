package DTO;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author Benja
 */
public class UsuarioDetalle {
    private  String Usern_name;
    private String TrabajadorAsign;
    private String rol;

    public UsuarioDetalle() {
    }

    public UsuarioDetalle(String Usern_name, String TrabajadorAsign, String rol) {
        this.Usern_name = Usern_name;
        this.TrabajadorAsign = TrabajadorAsign;
        this.rol = rol;
    }

    public String getUsern_name() {
        return Usern_name;
    }

    public void setUsern_name(String Usern_name) {
        this.Usern_name = Usern_name;
    }

    public String getTrabajadorAsign() {
        return TrabajadorAsign;
    }

    public void setTrabajadorAsign(String TrabajadorAsign) {
        this.TrabajadorAsign = TrabajadorAsign;
    }

    public String getRol() {
        return rol;
    }

    public void setRol(String rol) {
        this.rol = rol;
    }
    
    
    
}
