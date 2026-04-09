const cliProgress = require('cli-progress');

// Configuration des dates (Année, Mois-1, Jour)
const startTime = new Date(2026, 1, 9).getTime(); // 9 Février 2026
const endTime = new Date(2026, 6, 24, 23, 59, 59).getTime(); // 24 Juillet 2026
const totalDuration = endTime - startTime;

// Liste des jours fériés en France pour 2026
const holidays = [
    "2026-01-01", "2026-04-06", "2026-05-01", "2026-05-08",
    "2026-05-14", "2026-05-25", "2026-07-14", "2026-08-15",
    "2026-11-01", "2026-11-11", "2026-12-25"
];

// Formate localement pour éviter les bugs de fuseau horaire de .toISOString()
function formatDate(date) {
    const d = new Date(date);
    let month = '' + (d.getMonth() + 1);
    let day = '' + d.getDate();
    let year = d.getFullYear();

    if (month.length < 2) month = '0' + month;
    if (day.length < 2) day = '0' + day;

    return [year, month, day].join('-');
}

// Compte les jours ouvrés (Lun-Ven, hors jours fériés) entre deux dates
function getWorkingDaysCount(start, end) {
    let count = 0;
    let cur = new Date(start);
    const finish = new Date(end);

    while (cur <= finish) {
        const dayOfWeek = cur.getDay();
        const curDateStr = formatDate(cur);

        // 0 = Dimanche, 6 = Samedi
        if (dayOfWeek !== 0 && dayOfWeek !== 6 && !holidays.includes(curDateStr)) {
            count++;
        }
        cur.setDate(cur.getDate() + 1);
    }
    return count;
}

// Initialisation de la barre
const bar1 = new cliProgress.SingleBar({
    format: 'ST50 Magellium | {bar} | {myPercentage}% | Jours ouvrés restants: {workDaysLeft}',
    hideCursor: true,
    barCompleteChar: '\u2588',
    barIncompleteChar: '\u2591'
}, cliProgress.Presets.shades_classic);

// Calcul des constantes
const totalWorkingDays = getWorkingDaysCount(startTime, endTime);

bar1.start(totalDuration, 0);

const timer = setInterval(() => {
    const now = Date.now();
    const elapsed = now - startTime;

    // Calcul basé sur les jours ouvrés
    const workedDaysSoFar = getWorkingDaysCount(startTime, now);
    const workDaysLeft = getWorkingDaysCount(now, endTime);

    // Pourcentage précis basé sur les jours ouvrés
    const precisePercent = ((workedDaysSoFar / totalWorkingDays) * 100).toFixed(5);

    bar1.update(Math.min(elapsed, totalDuration), {
        myPercentage: Math.min(precisePercent, 100),
        workDaysLeft: Math.max(workDaysLeft, 0),
    });

    if (now >= endTime) {
        bar1.stop();
        console.log("\n🚀 Stage terminé ! Rapport final déposé.");
        clearInterval(timer);
    }
}, 1000);