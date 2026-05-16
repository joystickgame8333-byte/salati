import SwiftUI

struct PrayerHomeView: View {
    @State private var now = Date()

    private let timer = Timer.publish(
        every: 1,
        on: .main,
        in: .common
    ).autoconnect()

    private var prayerTimes: DailyPrayerTimes {
        PrayerTimeProvider.shared.todayTimes()
    }

    private var nextPrayer: PrayerTimeItem {
        prayerTimes.nextPrayer(from: now)
    }

    var body: some View {
        ZStack {
            background

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    header
                    dateCard
                    nextPrayerCard
                    prayerList
                    bottomNavigation
                }
                .padding(.horizontal, 18)
                .padding(.top, 18)
                .padding(.bottom, 24)
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
        .preferredColorScheme(.dark)
        .onReceive(timer) { value in
            now = value
        }
    }

    private var background: some View {
        LinearGradient(
            colors: [
                AppTheme.backgroundTop,
                AppTheme.backgroundMiddle,
                AppTheme.backgroundBottom
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        .overlay {
            LinearGradient(
                colors: [
                    AppTheme.gold.opacity(0.10),
                    .clear,
                    AppTheme.emerald.opacity(0.14)
                ],
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
            .ignoresSafeArea()
        }
    }

    private var header: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "gearshape.fill")
                    .foregroundStyle(AppTheme.gold)
                    .font(.system(size: 17, weight: .bold))
                    .frame(width: 44, height: 44)
                    .background(.white.opacity(0.08))
                    .clipShape(Circle())
            }

            Spacer()

            VStack(spacing: 6) {
                Text("صلاتي")
                    .font(.system(size: 34, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)

                HStack(spacing: 5) {
                    Image(systemName: "location.fill")
                        .font(.caption)
                        .foregroundStyle(AppTheme.gold)

                    Text(prayerTimes.cityName)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.white.opacity(0.72))
                }
            }

            Spacer()

            Button(action: {}) {
                Image(systemName: "line.3.horizontal")
                    .foregroundStyle(.white)
                    .font(.system(size: 18, weight: .bold))
                    .frame(width: 44, height: 44)
                    .background(.white.opacity(0.08))
                    .clipShape(Circle())
            }
        }
    }

    private var dateCard: some View {
        HStack {
            VStack(alignment: .trailing, spacing: 8) {
                Text("مواقيت دقيقة لفلسطين")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(AppTheme.gold)

                Text(gregorianDateText())
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.70))

                Text(hijriDateText())
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(.white.opacity(0.55))
            }
            .multilineTextAlignment(.trailing)

            Spacer()

            ZStack {
                Circle()
                    .fill(AppTheme.gold.opacity(0.16))
                    .frame(width: 70, height: 70)

                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(AppTheme.gold)
            }
        }
        .padding(18)
        .background(glassCard(cornerRadius: 28))
    }

    private var nextPrayerCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 34)
                .fill(
                    LinearGradient(
                        colors: [
                            AppTheme.emerald.opacity(0.40),
                            Color.black.opacity(0.58)
                        ],
                        startPoint: .topTrailing,
                        endPoint: .bottomLeading
                    )
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 34)
                        .stroke(AppTheme.gold.opacity(0.38), lineWidth: 1)
                }

            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .trailing, spacing: 8) {
                        Text("الصلاة القادمة")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(AppTheme.gold)

                        Text(nextPrayer.name.rawValue)
                            .font(.system(size: 42, weight: .heavy, design: .rounded))
                            .foregroundStyle(.white)
                    }
                    .multilineTextAlignment(.trailing)

                    Spacer()

                    Image(systemName: nextPrayer.name.icon)
                        .font(.system(size: 42, weight: .bold))
                        .foregroundStyle(AppTheme.softGold)
                        .shadow(color: AppTheme.gold.opacity(0.45), radius: 18)
                }

                Text(prayerTimes.remainingTimeText(from: now))
                    .font(.system(size: 48, weight: .heavy, design: .rounded))
                    .monospacedDigit()
                    .minimumScaleFactor(0.75)
                    .foregroundStyle(AppTheme.gold)

                Text("متبقي حتى أذان \(nextPrayer.name.rawValue)")
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(.white.opacity(0.65))
            }
            .padding(24)
        }
        .frame(height: 230)
        .shadow(color: AppTheme.gold.opacity(0.13), radius: 25, x: 0, y: 18)
    }

    private var prayerList: some View {
        VStack(spacing: 0) {
            ForEach(prayerTimes.items) { item in
                prayerRow(item)

                if item.name != prayerTimes.items.last?.name {
                    Divider()
                        .background(.white.opacity(0.08))
                        .padding(.horizontal, 18)
                }
            }
        }
        .background(glassCard(cornerRadius: 30))
    }

    private func prayerRow(_ item: PrayerTimeItem) -> some View {
        let isNext = item.name == nextPrayer.name

        return HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(isNext ? AppTheme.gold.opacity(0.18) : Color.white.opacity(0.07))
                    .frame(width: 42, height: 42)

                Image(systemName: item.name.icon)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(isNext ? AppTheme.gold : .white.opacity(0.68))
            }

            Text(timeText(item.time))
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(isNext ? AppTheme.gold : .white)

            Spacer()

            VStack(alignment: .trailing, spacing: 3) {
                Text(item.name.rawValue)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)

                if isNext {
                    Text("القادمة")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(AppTheme.gold)
                }
            }
            .multilineTextAlignment(.trailing)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
        .background {
            if isNext {
                RoundedRectangle(cornerRadius: 22)
                    .fill(AppTheme.emerald.opacity(0.24))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
            }
        }
    }

    private var bottomNavigation: some View {
        HStack {
            navItem(title: "الرئيسية", icon: "house.fill", active: true)
            Spacer()
            navItem(title: "القبلة", icon: "safari.fill", active: false)
            Spacer()
            navItem(title: "الأذكار", icon: "book.closed.fill", active: false)
            Spacer()
            navItem(title: "المزيد", icon: "square.grid.2x2.fill", active: false)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(glassCard(cornerRadius: 28))
    }

    private func navItem(title: String, icon: String, active: Bool) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .bold))

            Text(title)
                .font(.caption2.weight(.bold))
        }
        .foregroundStyle(active ? AppTheme.gold : .white.opacity(0.52))
    }

    private func glassCard(cornerRadius: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(.ultraThinMaterial)
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.white.opacity(0.055))
            }
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(AppTheme.glassBorder, lineWidth: 1)
            }
    }

    private func timeText(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ar")
        formatter.timeZone = TimeZone(identifier: "Asia/Jerusalem")
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }

    private func gregorianDateText() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ar")
        formatter.timeZone = TimeZone(identifier: "Asia/Jerusalem")
        formatter.dateStyle = .full
        return formatter.string(from: now)
    }

    private func hijriDateText() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ar")
        formatter.calendar = Calendar(identifier: .islamicUmmAlQura)
        formatter.timeZone = TimeZone(identifier: "Asia/Jerusalem")
        formatter.dateFormat = "d MMMM yyyy هـ"
        return formatter.string(from: now)
    }
}

#Preview {
    PrayerHomeView()
}
