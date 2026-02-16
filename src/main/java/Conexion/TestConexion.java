package Conexion;

import java.sql.Connection;

public class TestConexion {

    public static void main(String[] args) {

        Connection con = ConectarBD.conectar();

        if (con != null) {
            System.out.println("✅ CONEXIÓN OK: la base de datos responde");
        } else {
            System.out.println("❌ CONEXIÓN FALLIDA: con es null");
        }
    }
}
