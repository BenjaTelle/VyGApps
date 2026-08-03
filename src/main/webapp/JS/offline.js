// =========================================
// 1. GESTIÓN DE CONEXIÓN
// =========================================
const btnRetry = document.getElementById('btnRetry');
const statusBox = document.getElementById('statusBox');
const statusText = document.getElementById('statusText');
const statusSpinner = document.getElementById('statusSpinner');
const mainCard = document.getElementById('mainCard');
const titleText = document.getElementById('title-text');
const descText = document.getElementById('desc-text');

function updateStatus(type, message) {
    statusBox.className = 'status-alert ' + type;
    statusText.innerText = message;
    if (type === 'checking') {
        statusSpinner.style.display = 'inline-block';
    } else {
        statusSpinner.style.display = 'none';
    }
}

// Redirigir de regreso
function redirectBack() {
    updateStatus('online', '¡Conexión exitosa! Redirigiendo...');
    titleText.innerText = "¡Conexión Restablecida!";
    titleText.style.color = "#2ecc71";
    descText.innerText = "Estamos devolviéndote al sistema V&G Ingenieros. Por favor espera...";

    setTimeout(() => {
        if (document.referrer && !document.referrer.includes('offline.jsp') && document.referrer !== '') {
            window.location.href = document.referrer;
        } else {
            window.location.href = 'login.jsp';
        }
    }, 1800);
}

// Probar si hay conexión real haciendo fetch a una imagen liviana con cache deshabilitado
function checkRealConnectivity() {
    updateStatus('checking', 'Verificando señal de red...');

    // Si el navegador ya dice que está offline, evitamos el fetch y fallamos directo
    if (!navigator.onLine) {
        setTimeout(() => {
            handleConnectionFailed();
        }, 600);
        return;
    }

    // Si navigator.onLine es true, hacemos un fetch real
    fetch('images/vygLogo.svg?t=' + Date.now(), { method: 'HEAD', cache: 'no-store' })
        .then(response => {
            if (response.ok) {
                redirectBack();
            } else {
                handleConnectionFailed();
            }
        })
        .catch(() => {
            handleConnectionFailed();
        });
}

function handleConnectionFailed() {
    updateStatus('', 'Sigue sin haber conexión');
    mainCard.classList.add('shake');
    setTimeout(() => {
        mainCard.classList.remove('shake');
    }, 500);
}

// Eventos nativos de red del navegador
window.addEventListener('online', checkRealConnectivity);
if (btnRetry) {
    btnRetry.addEventListener('click', checkRealConnectivity);
}



// 2. MINIJUEGO: VYG RUNNER (TRUCK EDITION)

const canvas = document.getElementById('gameCanvas');
if (canvas) {
    const ctx = canvas.getContext('2d');
    const scoreEl = document.getElementById('currentScore');
    const highScoreEl = document.getElementById('highScore');

    // Configuración y records
    let score = 0;
    let highScore = localStorage.getItem('vyg_offline_highscore') || localStorage.getItem('kronos_offline_highscore') || 0;
    if (highScoreEl) highScoreEl.innerText = highScore;

    // Estado del juego
    let gameActive = false;
    let firstPlay = true;
    let obstacles = [];
    let particles = [];
    let gameSpeed = 4.5;
    let frameCount = 0;
    let gravity = 0.55;

    // Personaje: Camión de VyG
    const truck = {
        x: 50,
        y: 0,
        width: 46,
        height: 28,
        vy: 0,
        jumpForce: -9.5,
        isGrounded: false,
        groundY: 140, // Altura del suelo en el lienzo
        draw: function () {
            ctx.save();
            ctx.translate(this.x, this.y);

            // 1. Cuerpo principal (Azul corporativo VyG #1B365D)
            ctx.fillStyle = '#1B365D';
            // Cabina
            ctx.beginPath();
            ctx.roundRect(24, 0, 18, 18, [4, 4, 0, 0]);
            ctx.fill();

            // Tolva/Carga del camión (Gris de construcción)
            ctx.fillStyle = '#475569';
            ctx.beginPath();
            ctx.roundRect(0, 4, 23, 14, 2);
            ctx.fill();

            // Chasis inferior (Gris oscuro)
            ctx.fillStyle = '#1e293b';
            ctx.fillRect(2, 18, 38, 4);

            // 2. Ventana de cabina (Celeste brillante)
            ctx.fillStyle = '#bae6fd';
            ctx.fillRect(34, 3, 6, 6);

            // 3. Ruedas (Círculos oscuros y centro plateado)
            // Rueda Trasera
            ctx.fillStyle = '#0f172a';
            ctx.beginPath();
            ctx.arc(8, 22, 6, 0, Math.PI * 2);
            ctx.fill();
            ctx.fillStyle = '#cbd5e1';
            ctx.beginPath();
            ctx.arc(8, 22, 2, 0, Math.PI * 2);
            ctx.fill();

            // Rueda Delantera
            ctx.fillStyle = '#0f172a';
            ctx.beginPath();
            ctx.arc(32, 22, 6, 0, Math.PI * 2);
            ctx.fill();
            ctx.fillStyle = '#cbd5e1';
            ctx.beginPath();
            ctx.arc(32, 22, 2, 0, Math.PI * 2);
            ctx.fill();

            // 4. Parachoques / Detalles
            ctx.fillStyle = '#f97316'; // Faro
            ctx.fillRect(41, 10, 2, 3);

            ctx.restore();
        },
        jump: function () {
            if (this.isGrounded && gameActive) {
                this.vy = this.jumpForce;
                this.isGrounded = false;
                // Partículas de humo al saltar
                createDust(this.x + 8, this.groundY + 22, 5);
            }
        },
        update: function () {
            // Aplicar gravedad
            this.vy += gravity;
            this.y += this.vy;

            // Controlar choque con el suelo
            if (this.y >= this.groundY) {
                this.y = this.groundY;
                this.vy = 0;
                this.isGrounded = true;
            }
        }
    };

    // Generar partículas de polvo
    function createDust(x, y, count) {
        for (let i = 0; i < count; i++) {
            particles.push({
                x: x,
                y: y,
                vx: -gameSpeed * 0.4 - Math.random() * 2,
                vy: -Math.random() * 2,
                radius: Math.random() * 4 + 2,
                alpha: 1,
                color: '#64748b'
            });
        }
    }

    // Definición de Obstáculos (Conos y Barricadas)
    class Obstacle {
        constructor(x) {
            this.x = x;
            this.type = Math.random() > 0.5 ? 'cone' : 'barrier';
            if (this.type === 'cone') {
                this.width = 16;
                this.height = 24;
                this.y = truck.groundY + (truck.height - this.height);
            } else {
                this.width = 24;
                this.height = 22;
                this.y = truck.groundY + (truck.height - this.height);
            }
        }

        draw() {
            ctx.save();
            ctx.translate(this.x, this.y);

            if (this.type === 'cone') {
                // Cono de construcción (Naranja con franja blanca)
                ctx.fillStyle = '#f97316'; // Naranja brillante
                ctx.beginPath();
                ctx.moveTo(this.width / 2, 0);
                ctx.lineTo(this.width, this.height - 3);
                ctx.lineTo(0, this.height - 3);
                ctx.closePath();
                ctx.fill();

                // Franja blanca
                ctx.fillStyle = '#ffffff';
                ctx.beginPath();
                ctx.moveTo(this.width / 2, 8);
                ctx.lineTo(this.width * 0.75, 14);
                ctx.lineTo(this.width * 0.25, 14);
                ctx.closePath();
                ctx.fill();

                // Base negra del cono
                ctx.fillStyle = '#0f172a';
                ctx.fillRect(-2, this.height - 3, this.width + 4, 3);
            } else {
                // Barricada de obra (Rayas amarillas y negras)
                ctx.fillStyle = '#475569'; // Soporte gris
                ctx.fillRect(2, 0, 3, this.height);
                ctx.fillRect(this.width - 5, 0, 3, this.height);

                // Tablón de peligro
                ctx.fillStyle = '#fbbf24'; // Fondo amarillo
                ctx.fillRect(0, 3, this.width, 10);

                // Líneas diagonales negras de alerta
                ctx.strokeStyle = '#000000';
                ctx.lineWidth = 2.5;
                ctx.beginPath();
                for (let offset = -5; offset < this.width + 10; offset += 8) {
                    ctx.moveTo(offset, 3);
                    ctx.lineTo(offset - 4, 13);
                }
                ctx.stroke();

                // Base
                ctx.fillStyle = '#1e293b';
                ctx.fillRect(0, this.height - 3, this.width, 3);
            }

            ctx.restore();
        }

        update() {
            this.x -= gameSpeed;
        }
    }

    // Reiniciar el juego
    function resetGame() {
        score = 0;
        if (scoreEl) scoreEl.innerText = score;
        obstacles = [];
        particles = [];
        gameSpeed = 4.5;
        truck.y = truck.groundY;
        truck.vy = 0;
        gameActive = true;
        firstPlay = false;
    }

    // Detectar colisión (AABB simple con margen)
    function checkCollision(rect1, rect2) {
        const paddingX = 4;
        const paddingY = 2;
        return (
            rect1.x + paddingX < rect2.x + rect2.width &&
            rect1.x + rect1.width - paddingX > rect2.x &&
            rect1.y + paddingY < rect2.y + rect2.height &&
            rect1.y + rect1.height - paddingY > rect2.y
        );
    }

    // Bucle Principal del Juego (Loop)
    function gameLoop() {
        ctx.fillStyle = '#1e293b';
        ctx.fillRect(0, 0, canvas.width, canvas.height);

        // Dibujar suelo
        ctx.fillStyle = '#334155';
        ctx.fillRect(0, truck.groundY + truck.height - 4, canvas.width, canvas.height - (truck.groundY + truck.height) + 4);

        ctx.strokeStyle = '#e2e8f0';
        ctx.lineWidth = 2;
        ctx.beginPath();
        ctx.moveTo(0, truck.groundY + truck.height - 4);
        ctx.lineTo(canvas.width, truck.groundY + truck.height - 4);
        ctx.stroke();

        frameCount++;
        if (gameActive && frameCount % 60 === 0) {
            score++;
            if (scoreEl) scoreEl.innerText = score;
            if (score % 10 === 0) {
                gameSpeed += 0.4;
            }
        }

        if (gameActive) {
            let minGap = 120 + gameSpeed * 5;
            let maxGap = 280 + gameSpeed * 8;
            let spawnChance = Math.random() < 0.015;

            if (obstacles.length === 0 ||
                (canvas.width - obstacles[obstacles.length - 1].x > minGap && spawnChance)) {
                obstacles.push(new Obstacle(canvas.width));
            }

            if (truck.isGrounded && frameCount % 5 === 0) {
                createDust(truck.x + 8, truck.groundY + 22, 1);
            }
        }

        // Partículas
        for (let i = particles.length - 1; i >= 0; i--) {
            const p = particles[i];
            p.x += p.vx;
            p.y += p.vy;
            p.alpha -= 0.03;
            if (p.alpha <= 0) {
                particles.splice(i, 1);
                continue;
            }
            ctx.save();
            ctx.globalAlpha = p.alpha;
            ctx.fillStyle = p.color;
            ctx.beginPath();
            ctx.arc(p.x, p.y, p.radius, 0, Math.PI * 2);
            ctx.fill();
            ctx.restore();
        }

        // Camión
        truck.update();
        truck.draw();

        // Obstáculos
        for (let i = obstacles.length - 1; i >= 0; i--) {
            const obs = obstacles[i];
            if (gameActive) {
                obs.update();
            }
            obs.draw();

            if (obs.x + obs.width < 0) {
                obstacles.splice(i, 1);
                continue;
            }

            if (gameActive && checkCollision(truck, obs)) {
                gameActive = false;

                if (score > highScore) {
                    highScore = score;
                    localStorage.setItem('vyg_offline_highscore', highScore);
                    if (highScoreEl) highScoreEl.innerText = highScore;
                }

                createDust(truck.x + truck.width / 2, truck.y + truck.height / 2, 12);
                particles.forEach(p => {
                    p.color = '#1B365D';
                    p.vx = (Math.random() - 0.5) * 8;
                    p.vy = (Math.random() - 0.5) * 8;
                });
            }
        }

        if (firstPlay) {
            ctx.fillStyle = 'rgba(15, 23, 42, 0.7)';
            ctx.fillRect(0, 0, canvas.width, canvas.height);

            ctx.fillStyle = '#ffffff';
            ctx.font = 'bold 16px "Segoe UI", Tahoma, sans-serif';
            ctx.textAlign = 'center';
            ctx.fillText('¡MINIJUEGO OFFLINE!', canvas.width / 2, canvas.height / 2 - 10);

            ctx.fillStyle = '#1B365D';
            ctx.font = 'bold 13px "Segoe UI", Tahoma, sans-serif';
            ctx.fillText('Haz clic aquí o presiona Espacio para iniciar', canvas.width / 2, canvas.height / 2 + 15);
        } else if (!gameActive) {
            ctx.fillStyle = 'rgba(15, 23, 42, 0.75)';
            ctx.fillRect(0, 0, canvas.width, canvas.height);

            ctx.fillStyle = '#ef4444';
            ctx.font = 'bold 20px "Segoe UI", Tahoma, sans-serif';
            ctx.textAlign = 'center';
            ctx.fillText('FIN DE LA PARTIDA', canvas.width / 2, canvas.height / 2 - 20);

            ctx.fillStyle = '#ffffff';
            ctx.font = '14px "Segoe UI", Tahoma, sans-serif';
            ctx.fillText('Puntuación lograda: ' + score, canvas.width / 2, canvas.height / 2 + 5);

            ctx.fillStyle = '#1B365D';
            ctx.font = 'bold 13px "Segoe UI", Tahoma, sans-serif';
            ctx.fillText('Haz clic o presiona Espacio para Reintentar', canvas.width / 2, canvas.height / 2 + 30);
        }

        requestAnimationFrame(gameLoop);
    }

    function handleAction(e) {
        if (e.code === 'Space' || e.code === 'ArrowUp' || e.type === 'mousedown' || e.type === 'touchstart') {
            if (e.code === 'Space' || e.code === 'ArrowUp') {
                e.preventDefault();
            }

            if (!gameActive) {
                resetGame();
            } else {
                truck.jump();
            }
        }
    }

    window.addEventListener('keydown', handleAction);
    canvas.addEventListener('mousedown', handleAction);
    canvas.addEventListener('touchstart', function (e) {
        e.preventDefault();
        handleAction(e);
    }, { passive: false });

    gameLoop();
}
