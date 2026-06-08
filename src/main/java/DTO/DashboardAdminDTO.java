/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DTO;

import java.util.List;

/**
 *
 * @author Benja
 */
public class DashboardAdminDTO {
    // Métricas Financieras
    private String totalPagadoMes;
    private String totalPendiente;
    private int planillasPendientes;
    private String presupuestoGlobal;
    
    // Alertas del sistema para seguimiento operativo
    private List<String> alertas;
    public String getTotalPagadoMes() { return totalPagadoMes; }
    public void setTotalPagadoMes(String totalPagadoMes) { this.totalPagadoMes = totalPagadoMes; }

    public String getTotalPendiente() { return totalPendiente; }
    public void setTotalPendiente(String totalPendiente) { this.totalPendiente = totalPendiente; }

    public int getPlanillasPendientes() { return planillasPendientes; }
    public void setPlanillasPendientes(int planillasPendientes) { this.planillasPendientes = planillasPendientes; }

    public String getPresupuestoGlobal() { return presupuestoGlobal; }
    public void setPresupuestoGlobal(String presupuestoGlobal) { this.presupuestoGlobal = presupuestoGlobal; }

    public List<String> getAlertas() { return alertas; }
    public void setAlertas(List<String> alertas) { this.alertas = alertas; }
}
