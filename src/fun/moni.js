const cliProgress = require('cli-progress');

const hourlySalary = 5.9;
const today = new Date();
const monthIndex = today.getMonth(); // 0-11
const currentYear = today.getFullYear();

// Get number of days in current month
const numberOfDaysInMonth = new Date(currentYear, monthIndex + 1, 0).getDate();

// Get the number of working days in a date range
function getWorkingDaysBetween(year, month, startDay, endDay) {
    let count = 0;
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
    for (let day = startDay; day <= endDay; day++) {
        const date = new Date(year, month - 1, day);
        const dayOfWeek = date.getDay();
        const dateStr = date.toISOString().slice(0, 10);
        if (
            dayOfWeek !== 0 && dayOfWeek !== 6 && // Hors Dimanche (0) et Samedi (6)
            !holidays.includes(dateStr) // Hors jours fériés
        ) {
            count++;
        }
    }
    return count;
}

// Get working days since beginning of month until today
const workingDaysElapsed = getWorkingDaysBetween(currentYear, monthIndex + 1, 1, today.getDate());
const hoursElapsed = workingDaysElapsed * 7;
const salaryEarned = hoursElapsed * hourlySalary;

// Get total working days in month (for progress bar total)
const totalWorkingDaysInMonth = getWorkingDaysBetween(currentYear, monthIndex + 1, 1, numberOfDaysInMonth);
const totalHours = totalWorkingDaysInMonth * 7;
const totalSalary = totalHours * hourlySalary;

const bar1 = new cliProgress.SingleBar({
    format: 'ST50 Magellium | {bar} | {myPercentage}% | Salaire: {currentSalary}€ / {totalSalary}€',
    hideCursor: true,
    barCompleteChar: '\u2588',
    barIncompleteChar: '\u2591'
}, cliProgress.Presets.shades_classic);

bar1.start(totalHours, hoursElapsed, {
    myPercentage: ((hoursElapsed / totalHours) * 100).toFixed(2),
    currentSalary: salaryEarned.toFixed(2),
    totalSalary: totalSalary.toFixed(2)
});

// Update in real time based on actual time elapsed
const timer = setInterval(() => {
    const now = new Date();
    const workDayStart = new Date(now);
    workDayStart.setHours(8, 0, 0, 0); // Work day starts at 8:00 AM
    const workDayEnd = new Date(now);
    workDayEnd.setHours(15, 0, 0, 0); // Work day ends at 3:00 PM (7 hours: 8am-3pm)

    let realHoursWorkedToday = 0;

    // Calculate real hours worked today if within work hours
    if (now >= workDayStart && now <= workDayEnd) {
        realHoursWorkedToday = (now - workDayStart) / (1000 * 60 * 60); // Convert ms to hours
    } else if (now > workDayEnd) {
        realHoursWorkedToday = (workDayEnd - workDayStart) / (1000 * 60 * 60); // Full 7 hours if after work
    }

    // Calculate total hours: previous days + today's real hours
    const totalRealHoursWorked = hoursElapsed - (hoursElapsed % 7) + realHoursWorkedToday;

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
