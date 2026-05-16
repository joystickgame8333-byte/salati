import Foundation

final class PrayerTimeProvider {
    static let shared = PrayerTimeProvider()

    private let timeZone = TimeZone(identifier: "Asia/Jerusalem") ?? .current

    private init() {}

    func todayTimes(cityName: String = "تل السبع / بئر السبع") -> DailyPrayerTimes {
        let now = Date()

        return DailyPrayerTimes(
            cityName: cityName,
            date: now,
            fajr: makeTime(hour: 4, minute: 15),
            sunrise: makeTime(hour: 5, minute: 42),
            dhuhr: makeTime(hour: 12, minute: 32),
            asr: makeTime(hour: 15, minute: 56),
            maghrib: makeTime(hour: 19, minute: 20),
            isha: makeTime(hour: 20, minute: 45)
        )
    }

    private func makeTime(hour: Int, minute: Int) -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone

        let now = Date()
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        components.hour = hour
        components.minute = minute
        components.second = 0

        return calendar.date(from: components) ?? now
    }
}
