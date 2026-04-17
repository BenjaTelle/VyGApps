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
    // Métricas Financieras (KPIs)
    private String totalPagadoMes;        // Ej. "C$ 145,000.00"
    private String totalPendiente;        // Ej. "C$ 42,500.00"
    private int planillasPendientes;      // Ej. 12
    private String presupuestoGlobal;     // Ej. "C$ 1,200,000.00"
    
    // Lista de Alertas (Para iterar si hay supervisores atrasados)
    private List<String> alertas;

    // --- Getters y Setters ---
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
