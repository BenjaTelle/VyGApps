/**
 * Sistema de Gestión Operativa - VyGApps
 * @author Benjamin Telleria
 * Todos los derechos morales reservados © 2026
 */
package DTO;

import java.time.LocalDate;

public class CicloPlanillaDTO {
    private String tipoNomina;
    private int diasCiclo;
    private LocalDate ultimaEjecucion;
    private LocalDate proximoPago;
    private boolean habilitado;

    public String getTipoNomina() { return tipoNomina; }
    public void setTipoNomina(String tipoNomina) { this.tipoNomina = tipoNomina; }

    public int getDiasCiclo() { return diasCiclo; }
    public void setDiasCiclo(int diasCiclo) { this.diasCiclo = diasCiclo; }

    public LocalDate getUltimaEjecucion() { return ultimaEjecucion; }
    public void setUltimaEjecucion(LocalDate ultimaEjecucion) { this.ultimaEjecucion = ultimaEjecucion; }

    public LocalDate getProximoPago() { return proximoPago; }
    public void setProximoPago(LocalDate proximoPago) { this.proximoPago = proximoPago; }

    public boolean isHabilitado() { return habilitado; }
    public void setHabilitado(boolean habilitado) { this.habilitado = habilitado; }
}