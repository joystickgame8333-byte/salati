import Foundation
import SwiftUI

enum PrayerName: String, CaseIterable, Identifiable, Hashable {
    case fajr = "الفجر"
    case sunrise = "الشروق"
    case dhuhr = "الظهر"
    case asr = "العصر"
    case maghrib = "المغرب"
    case isha = "العشاء"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .fajr:
            return "moon.stars.fill"
        case .sunrise:
            return "sunrise.fill"
        case .dhuhr:
            return "sun.max.fill"
        case .asr:
            return "sun.dust.fill"
        case .maghrib:
            return "sunset.fill"
        case .isha:
            return "moon.fill"
        }
    }
}
