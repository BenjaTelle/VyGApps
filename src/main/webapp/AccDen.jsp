<%-- 
    Document   : AccDen
    Created on : 4 feb 2026, 5:18:20 p.m.
    Author     : Benja
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
     <link rel="icon" href="images/vyg.svg" type="image/png">
    <title>Acceso Denegado</title>
    <style>
    /* =========================
       RESET + BASE (Adaptado a tu estilo)
    ========================= */
    body {
        font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
        background-color: #f7f9fb; /* Tu fondo gris claro */
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        margin: 0;
    }

    /* =========================
       TARJETA DE ERROR
    ========================= */
    .error-container {
        background-color: #ffffff;
        padding: 40px;
        /* Usamos tu radio de borde y tu sombra específica */
        border-radius: 6px; 
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
        
        text-align: center;
        max-width: 450px;
        width: 90%;
        
        /* Mantenemos el rojo aquí para indicar "ALTO", 
           pero si prefieres naranja, cambia #e74c3c por #f57c00 */
        border-top: 5px solid #e74c3c; 
    }

    .icon {
        font-size: 70px;
        margin-bottom: 15px;
        display: block;
    }

    h1 {
        color: #e74c3c; /* Rojo de alerta */
        margin: 0 0 15px 0;
        font-size: 22px; /* Ajustado para no ser gigante */
        font-weight: 600; /* Tu peso de fuente */
    }

    p {
        color: #444; /* Tu color de texto secundario */
        line-height: 1.6;
        margin-bottom: 30px;
        font-size: 14px; /* Tu tamaño de fuente estándar */
    }

    /* =========================
       BOTONES (Estilo Brand)
    ========================= */
    .btn-group {
        display: flex;
        gap: 15px;
        justify-content: center;
    }

    .btn {
        text-decoration: none;
        padding: 10px 24px;
        border-radius: 4px; /* Tu radio de borde */
        font-weight: 600;
        font-size: 13px; /* Tu tamaño de fuente de botón */
        border: none;
        cursor: pointer;
        transition: background 0.3s, box-shadow 0.3s;
    }

    /* Botón Primario: COPIA EXACTA DE TU .profile-btn */
    .btn-primary {
        background-color: #f57c00; /* Tu naranja */
        color: #ffffff;
    }

    .btn-primary:hover {
        background-color: #e66f00;
        box-shadow: 0 4px 10px rgba(245, 124, 0, 0.4); /* Tu efecto hover */
    }

    /* Botón Secundario: Neutro */
    .btn-secondary {
        background-color: #ecf0f1;
        color: #333;
    }

    .btn-secondary:hover {
        background-color: #bdc3c7;
    }
</style>
</head>
<body>

    <div class="error-container">
        <span class="icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg></span>
        
        <h1>Acceso Restringido</h1>
        
        <p>
            Lo sentimos, no tienes los permisos necesarios para ver este recurso. 
            Si crees que esto es un error, contacta al administrador del sistema.
        </p>

        <div class="btn-group">
            <a href="javascript:history.back()" class="btn btn-secondary">
                ← Volver
            </a>

            <a href="login.jsp" class="btn btn-primary">
                Ir al Inicio
            </a>
        </div>
    </div>

</body>
</html>