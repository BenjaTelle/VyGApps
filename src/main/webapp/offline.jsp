<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sin Conexión | Kronos Industrial</title>
    <link rel="icon" href="images/KronosIndustrial.svg" type="image/png">
    <link rel="stylesheet" href="CSS/offline.css">
    <script src="JS/offline.js" defer></script>

    <!-- Lucide Icons CDN -->
    <script src="https://unpkg.com/lucide@latest"></script>
</head>
<body>

    <div class="offline-container" id="mainCard">
        
        <div class="icon-wrapper">
            <svg class="wifi-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <line x1="1" y1="1" x2="23" y2="23"></line>
                <path d="M16.72 11.06A10.94 10.94 0 0 1 19 12.5"></path>
                <path d="M5 12.5a10.94 10.94 0 0 1 5.17-2.39"></path>
                <path d="M10.71 5.05A16 16 0 0 1 22.58 9"></path>
                <path d="M1.42 9a15.91 15.91 0 0 1 4.7-2.88"></path>
                <path d="M8.53 16.11a6 6 0 0 1 6.95 0"></path>
                <line x1="12" y1="20" x2="12.01" y2="20"></line>
            </svg>
        </div>

        <h1 id="title-text">Conexión Interrumpida</h1>
        <p class="desc" id="desc-text">
            No pudimos contactar con el servidor de Kronos Industrial. Por favor, revisa tu conexión de red local, wifi o datos móviles.
        </p>

        <div>
            <div class="status-alert" id="statusBox">
                <span class="spinner" id="statusSpinner"></span>
                <span id="statusText">Modo Offline Activo</span>
            </div>
        </div>

        <div>
            <button class="btn-retry" id="btnRetry">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M21.5 2v6h-6M21.34 15.57a10 10 0 1 1-.57-8.38l5.67-5.67"></path>
                </svg>
                Reintentar Conexión
            </button>
        </div>

        <!-- SECCIÓN DE MINIJUEGO INTERACTIVO -->
        <div class="game-section">
            <h2 class="game-title">Kronos Constructor Runner <i data-lucide="truck" style="display:inline-block; vertical-align:middle; margin-left:6px; width: 18px; height: 18px"></i></h2>
            <div class="game-canvas-container">
                <canvas id="gameCanvas" width="560" height="180"></canvas>
            </div>
            <div class="game-score-panel">
                <span>Puntuación: <span id="currentScore">0</span></span>
                <span class="high-score">Récord Offline: <span id="highScore">0</span></span>
            </div>
            <p class="game-instructions">
                Presiona <strong>Espacio</strong>, la flecha <strong>Arriba</strong> o <strong>haz clic/toca el juego</strong> para saltar los conos y barricadas.
            </p>
        </div>

    </div>


    <!-- Inicializacion de Lucide Icons -->
    <script>
        lucide.createIcons();
    </script>
</body>
</html>
