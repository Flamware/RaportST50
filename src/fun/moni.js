const cliProgress = require('cli-progress');

const hourlySalary = 5.9;
const today = new Date();
const monthIndex = today.getMonth();
const currentYear = today.getFullYear();

// Get number of days in current month
const numberOfDaysInMonth = new Date(currentYear, monthIndex , 0).getDate();

// Jours fériés 2026
const holidays2026 = [
    new Date(2026, 0, 1).getTime(),  // Jour de l'an
    new Date(2026, 3, 5).getTime(),  // Pâques
    new Date(2026, 3, 6).getTime(),  // Lundi de Pâques
    new Date(2026, 3, 24).getTime(), // Pentecôte (Avril en 2026 !)
    new Date(2026, 3, 25).getTime(), // Lundi de Pentecôte
    new Date(2026, 4, 1).getTime(),  // Fête du Travail
    new Date(2026, 4, 8).getTime(),  // Victoire 1945
    new Date(2026, 4, 14).getTime(), // Ascension
    new Date(2026, 4, 15).getTime(), // Pont de l'Ascension
    new Date(2026, 4, 29).getTime(), // Moto
    new Date(2026, 6, 14).getTime(), // Fête Nationale
    new Date(2026, 7, 27).getTime(), // Fin contrat
    new Date(2026, 7, 28).getTime(), // Fin contrat
    new Date(2026, 7, 29).getTime(), // Fin contrat
    new Date(2026, 7, 30).getTime(), // Fin contrat
    new Date(2026, 7, 31).getTime(), // Fin contrat

];

// Get the number of working days in a date range
function getWorkingDaysBetween(year, month, startDay, endDay) {
    if (startDay > endDay) return 0;
    let count = 0;
    for (let day = startDay; day <= endDay; day++) {
        const date = new Date(year, month - 1, day);
        const dayOfWeek = date.getDay();

        // On compare les timestamps calés à minuit pour éviter les décalages de fuseau horaire
        const midnightTimestamp = new Date(year, month - 1, day, 0, 0, 0, 0).getTime();

        const isWeekend = (dayOfWeek === 0 || dayOfWeek === 6);
        const isHoliday = holidays2026.includes(midnightTimestamp);

        if (!isWeekend && !isHoliday) {
            count++;
        }
    }
    return count;
}

// CORRECTION : On s'arrête à HIER (today.getDate() - 1) pour les jours révolus
const workingDaysBeforeToday = getWorkingDaysBetween(currentYear, monthIndex + 1, 1, today.getDate() - 1);
const hoursStrictlyElapsed = workingDaysBeforeToday * 7;

// Total working days in month
const totalWorkingDaysInMonth = getWorkingDaysBetween(currentYear, monthIndex + 1, 1, numberOfDaysInMonth);
const totalHours = totalWorkingDaysInMonth * 7;
const totalSalary = totalHours * hourlySalary;

const bar1 = new cliProgress.SingleBar({
    format: 'ST50 Magellium | {bar} | {myPercentage}% | Salaire: {currentSalary}€ / {totalSalary}€',
    hideCursor: true,
    barCompleteChar: '\u2588',
    barIncompleteChar: '\u2591'
}, cliProgress.Presets.shades_classic);

// Initialisation de la barre avec 0 heure aujourd'hui (sera mis à jour dans 1 sec)
bar1.start(totalHours, hoursStrictlyElapsed, {
    myPercentage: ((hoursStrictlyElapsed / totalHours) * 100).toFixed(2),
    currentSalary: (hoursStrictlyElapsed * hourlySalary).toFixed(2),
    totalSalary: totalSalary.toFixed(2)
});

// Update in real time based on actual time elapsed
const timer = setInterval(() => {
    const now = new Date();
    const workDayStart = new Date(now);
    workDayStart.setHours(8, 0, 0, 0);
    const workDayEnd = new Date(now);
    workDayEnd.setHours(15, 0, 0, 0);

    const dayOfWeek = now.getDay();
    const dateStr = now.toISOString().slice(0, 10);
    const isWorkingDay = dayOfWeek !== 0 && dayOfWeek !== 6 && !holidays2026.includes(new Date(dateStr).getTime());

    let realHoursWorkedToday = 0;

    if (isWorkingDay) {
        if (now >= workDayStart && now <= workDayEnd) {
            realHoursWorkedToday = (now - workDayStart) / (1000 * 60 * 60);
        } else if (now > workDayEnd) {
            realHoursWorkedToday = 7; // Journée terminée
        }
    }

    // CORRECTION : On ajoute simplement les heures du jour aux heures des jours passés
    const totalRealHoursWorked = hoursStrictlyElapsed + realHoursWorkedToday;

    const percentage = Math.min((totalRealHoursWorked / totalHours) * 100, 100).toFixed(2);
    const currentSalary = (totalRealHoursWorked * hourlySalary).toFixed(2);

    bar1.update(totalRealHoursWorked, {
        myPercentage: percentage,
        currentSalary: currentSalary,
        totalSalary: totalSalary.toFixed(2)
    });

    if (totalRealHoursWorked >= totalHours) {
        clearInterval(timer);
        bar1.stop();
    }
}, 1000);