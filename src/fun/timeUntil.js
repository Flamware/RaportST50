const cliProgress = require('cli-progress');

// Date dans le futur (2027) pour que la barre progresse
const endTime = new Date("Jul 24 2026 00:00:00").getTime();
const startTime = new Date("Feb 09 2026 00:00:00").getTime();
const totalDuration = endTime - startTime;

const bar1 = new cliProgress.SingleBar({
    // On définit un format qui utilise une variable personnalisée {myPercentage}
    format: 'Progression | {bar} | {myPercentage}% | {value}/{total} ms',
    hideCursor: true
}, cliProgress.Presets.shades_classic);

bar1.start(totalDuration, 0);

const timer = setInterval(() => {
    const elapsed = Date.now() - startTime;

    // Calcul manuel du pourcentage avec 5 chiffres après la virgule
    const precisePercent = ((elapsed / totalDuration) * 100).toFixed(5);

    // On envoie la valeur actuelle, et on "injecte" notre pourcentage formaté
    bar1.update(Math.floor(elapsed), {
        myPercentage: precisePercent
    });

    if (elapsed >= totalDuration) {
        bar1.stop();
        clearInterval(timer);
    }
}, 2000);