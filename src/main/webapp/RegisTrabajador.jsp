<%-- 
    Document   : RegisTrabajador
    Created on : 8 feb 2026, 5:23:37 p.m.
    Author     : Benja
--%>
<%@page import="model.trabajadores"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Usuarios"%>
<%@page import="model.proyectos"%>
<%
    HttpSession sessionActual = request.getSession(false);
    Usuarios usuarioLogeado = (sessionActual != null) ? (Usuarios) sessionActual.getAttribute("usuarioLogeado") : null;

    if (usuarioLogeado == null) {
        response.sendRedirect("login.jsp");
        return; 
    } else if (!usuarioLogeado.getRol().equals("Administrador")) {
        response.sendRedirect("AccDen.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registrar Trabajador | VyGApps</title>
    <link rel="stylesheet" href="CSS/RegisTrabajador.css">
    <link rel="icon" href="images/vyg.svg" type="image/png">
</head>
<body>

    <main class="form-container">
        <section class="form-card">
            <h2>Gestión de Trabajadores</h2>
            <p class="subtitle">Registro de nuevo empleado al sistema</p>

            <form action="RegistrarUsu" method="POST" id="formTrabajador">
                
                <div class="form-grid">
                    <div class="form-group full-width">
                        <label>Nombre Completo</label>
                        <input type="text" name="full_name" required placeholder="Ej: Benjamin Tellería">
                    </div>

                    <div class="form-group">
                        <label>Cédula de Identidad</label>
                        <input type="text" id="cedula" name="cedula" required
                               placeholder="Ej: 001-131105-1013R" 
                               maxlength="16"
                               title="Formato: 3 dígitos, guion, 6 dígitos, guion, 4 dígitos y una letra mayúscula">
                        <small id="errorCedula" class="error-text">Formato inválido (Ej: 001-131105-1013R)</small>
                    </div>

                    <div class="form-group">
                        <label>Edad</label>
                        <input type="number" name="edad" required min="18" placeholder="Ej: 20">
                    </div>

                    <div class="form-group">
                        <label>Teléfono Personal</label>
                        <input type="text" name="telefono" required 
                               placeholder="Ej: 88889999" maxlength="8" pattern="\d{8}"
                               title="Debe contener exactamente 8 números">
                    </div>

                    <div class="form-group">
                        <label>Número de Emergencia</label>
                        <input type="text" name="numero_emergencia" required 
                               placeholder="Ej: 77775555" maxlength="8" pattern="\d{8}"
                               title="Debe contener exactamente 8 números">
                    </div>

                    <div class="form-group full-width">
                        <label>Dirección Domiciliar</label>
                        <textarea name="direccion" required rows="2" 
                                  placeholder="Ej: De los semáforos 2 cuadras al sur, casa color verde."></textarea>
                    </div>

                    <div class="form-group">
                        <label>Lugar de Origen</label>
                        <input type="text" name="origen" placeholder="Ej: Managua">
                    </div>

                    <div class="form-group">
                        <label>Salario Quincenal (C$)</label>
                        <input type="number" name="salario_quincenal" required placeholder="Ej: 4500.00" step="0.01">
                    </div>

                    <div class="form-group full-width">
                        <label>Puesto Asignado</label>
                        <select name="puesto" required>
                            <option value="">Seleccione un puesto</option>
                            <option value="Gerente de proyecto">Gerente de proyecto</option>
                            <option value="Ingeniero residente">Ingeniero/a residente</option>
                            <option value="Arquitecto">Arquitecto/a</option>
                            <option value="Supervisor de obra">Supervisor de obra</option>
                            <option value="Capataz">Capataz</option>
                            <option value="Tecnico operativo">Técnico operativo</option>
                            <option value="Obrero">Obrero / Operativo</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Supervisor a Cargo</label>
                        <select name="supervisor">
                            <option value="">Seleccione un supervisor</option>
                            <%
                                List<trabajadores> listaSuperv = (List<trabajadores>) request.getAttribute("ListaSuperv");
                                if (listaSuperv != null) {
                                    for (trabajadores sv : listaSuperv) {
                            %>
                            <option value="<%=sv.getId_trabajador()%>"><%=sv.getFull_name()%></option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Proyecto Asociado</label>
                        <select name="proyecto">
                            <option value="">Seleccione un proyecto</option>
                            <%
                                List<proyectos> listaP = (List<proyectos>) request.getAttribute("ListarProy");
                                if (listaP != null) {
                                    for (proyectos p : listaP) {
                            %>
                            <option value="<%=p.getProyecto_id()%>"><%=p.getNombre_proyecto()%></option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </div>
                </div> <button type="submit" class="btn-submit"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path><polyline points="17 21 17 13 7 13 7 21"></polyline><polyline points="7 3 7 8 15 8"></polyline></svg> Guardar Trabajador</button>
            </form>
        </section>
    </main>

    <script src="JS/ValidarTrabajador.js"></script>
</body>
</html>