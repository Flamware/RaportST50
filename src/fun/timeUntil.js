const cliProgress = require('cli-progress');

// Configuration des dates
const endTime = new Date("July 24, 2026 00:00:00").getTime();
const startTime = new Date("February 09, 2026 00:00:00").getTime();
const totalDuration = endTime - startTime;

// Liste des jours fériés en France pour 2026 (format YYYY-MM-DD)
const holidays = [
    "2026-01-01", // Jour de l'an
    "2026-04-05", // Pâques (dimanche)
    "2026-04-06", // Lundi de Pâques
    "2026-05-01", // Fête du Travail
    "2026-05-08", // Victoire 1945
    "2026-05-14", // Ascension
    "2026-05-24", // Pentecôte (dimanche)
    "2026-05-25", // Lundi de Pentecôte
    "2026-07-14", // Fête Nationale
    "2026-08-15", // Assomption
    "2026-11-01", // Toussaint
    "2026-11-11", // Armistice
    "2026-12-25", // Noël
];

// Fonction utilitaire pour formater une date en YYYY-MM-DD
function formatDate(date) {
    return date.toISOString().slice(0, 10);
}

// Fonction pour compter uniquement les jours de semaine (Lundi-Vendredi), hors jours fériés
function getWorkingDaysLeft(now, end) {
    let count = 0;
    let cur = new Date(now);
    const finish = new Date(end);

    while (cur < finish) {
        const dayOfWeek = cur.getDay();
        const curDateStr = formatDate(cur);
        if (
            dayOfWeek !== 0 && dayOfWeek !== 6 && // Hors Dimanche (0) et Samedi (6)
            !holidays.includes(curDateStr) // Hors jours fériés
        ) {
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