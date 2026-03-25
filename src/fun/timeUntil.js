const cliProgress = require('cli-progress');

// Configuration des dates
const endTime = new Date("July 24, 2026 00:00:00").getTime();
const startTime = new Date("February 09, 2026 00:00:00").getTime();
const totalDuration = endTime - startTime;

// Fonction pour compter uniquement les jours de semaine (Lundi-Vendredi)
function getWorkingDaysLeft(now, end) {
    let count = 0;
    let cur = new Date(now);
    const finish = new Date(end);

    while (cur < finish) {
        const dayOfWeek = cur.getDay();
        if (dayOfWeek !== 0 && dayOfWeek !== 6) { // Hors Dimanche (0) et Samedi (6)
            count++;
        }
        cur.setDate(cur.getDate() + 1);
    }
    return count;
}

const bar1 = new cliProgress.SingleBar({
    // Format propre pour ton journal de bord
    format: 'ST50 Magellium | {bar} | {myPercentage}% | Jours ouvrés restants: {workDaysLeft}',
    hideCursor: true,
    barCompleteChar: '\u2588',
    barIncompleteChar: '\u2591'
}, cliProgress.Presets.shades_classic);

bar1.start(totalDuration, 0);

const timer = setInterval(() => {
    const now = Date.now();
    const elapsed = now - startTime;

    // Calcul précis du pourcentage (5 décimales pour voir le mouvement en temps réel)
    const precisePercent = ((elapsed / totalDuration) * 100).toFixed(5);

    // Calcul des jours ouvrés restants
    const workDaysLeft = getWorkingDaysLeft(now, endTime);


    bar1.update(Math.min(elapsed, totalDuration), {
        myPercentage: precisePercent,
        workDaysLeft: workDaysLeft,
    });

    if (elapsed >= totalDuration) {
        bar1.stop();
        console.log("\nStage terminé ! Rapport final déposé.");
        clearInterval(timer);
    }
}, 1000);