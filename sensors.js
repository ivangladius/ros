console.log('sensors.js geladen');

let beschl = { x: 0, y: 0, z: 0 };
let gyro = { alpha: 0, beta: 0, gamma: 0 };

window.addEventListener('devicemotion', function(event) {
    if (event.acceleration) {
        beschl.x = event.acceleration.x ? event.acceleration.x.toFixed(2) : 'n/a';
        beschl.y = event.acceleration.y ? event.acceleration.y.toFixed(2) : 'n/a';
        beschl.z = event.acceleration.z ? event.acceleration.z.toFixed(2) : 'n/a';
    }
});

window.addEventListener('deviceorientation', function(event) {
    gyro.alpha = event.alpha ? event.alpha.toFixed(2) : 'n/a';
    gyro.beta = event.beta ? event.beta.toFixed(2) : 'n/a';
    gyro.gamma = event.gamma ? event.gamma.toFixed(2) : 'n/a';
});

setInterval(function() {
    document.getElementById('beschl-x').textContent = beschl.x;
    document.getElementById('beschl-y').textContent = beschl.y;
    document.getElementById('beschl-z').textContent = beschl.z;
    document.getElementById('gyro-alpha').textContent = gyro.alpha;
    document.getElementById('gyro-beta').textContent = gyro.beta;
    document.getElementById('gyro-gamma').textContent = gyro.gamma;
}, 500); // Aktualisiert die Werte alle 500 Millisekunden

