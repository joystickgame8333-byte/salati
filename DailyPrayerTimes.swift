import Foundation

struct PrayerTimeItem: Identifiable, Equatable {
    var id: PrayerName { name }

    let name: PrayerName
    let time: Date
}

struct DailyPrayerTimes {
    let cityName: String
    let date: Date

    let fajr: Date
    let sunrise: Date
    let dhuhr: Date
    let asr: Date
    let maghrib: Date
    let isha: Date

    var items: [PrayerTimeItem] {
        [
            PrayerTimeItem(name: .fajr, time: fajr),
            PrayerTimeItem(name: .sunrise, time: sunrise),
            PrayerTimeItem(name: .dhuhr, time: dhuhr),
            PrayerTimeItem(name: .asr, time: asr),
            PrayerTimeItem(name: .maghrib, time: maghrib),
            PrayerTimeItem(name: .isha, time: isha)
        ]
    }

    func nextPrayer(from now: Date = Date()) -> PrayerTimeItem {
        if let next = items.first(where: { $0.time > now }) {
            return next
        }

        let tomorrowFajr = Calendar.current.date(byAdding: .day, value: 1, to: fajr) ?? fajr
        return PrayerTimeItem(name: .fajr, time: tomorrowFajr)
    }

    func remainingTimeText(from now: Date = Date()) -> String {
        let next = nextPrayer(from: now)
        let seconds = max(Int(next.time.timeIntervalSince(now)), 0)

        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let secondsLeft = seconds % 60

        return String(format: "%02d:%02d:%02d", hours, minutes, secondsLeft)
    }
}
