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
        GeometryReader { proxy in
            let metrics = HomeLayoutMetrics(size: proxy.size)

            ZStack {
                background

                VStack(spacing: metrics.sectionSpacing) {
                    header(metrics)
                    dateCard(metrics)
                    nextPrayerCard(metrics)
                    prayerList(metrics)

                    Spacer(minLength: 0)

                    bottomNavigation(metrics)
                }
                .salatiSafeAreaPadding(.horizontal, metrics.horizontalPadding)
                .salatiSafeAreaPadding(.top, metrics.topPadding)
                .salatiSafeAreaPadding(.bottom, metrics.bottomPadding)
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

    private func header(_ metrics: HomeLayoutMetrics) -> some View {
        HStack {
            iconButton(
                systemName: "gearshape.fill",
                color: AppTheme.gold,
                size: metrics.headerIconSize,
                iconSize: metrics.headerButtonIconSize
            )

            Spacer(minLength: 10)

            VStack(spacing: metrics.headerTitleSpacing) {
                Text("صلاتي")
                    .font(.system(size: metrics.titleFontSize, weight: .heavy, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.80)
                    .foregroundStyle(.white)

                HStack(spacing: 5) {
                    Image(systemName: "location.fill")
                        .font(.system(size: metrics.locationIconSize, weight: .bold))
                        .foregroundStyle(AppTheme.gold)

                    Text(prayerTimes.cityName)
                        .font(.system(size: metrics.locationFontSize, weight: .medium))
                        .lineLimit(1)
                        .minimumScaleFactor(0.78)
                        .foregroundStyle(.white.opacity(0.72))
                }
            }

            Spacer(minLength: 10)

            iconButton(
                systemName: "line.3.horizontal",
                color: .white,
                size: metrics.headerIconSize,
                iconSize: metrics.headerButtonIconSize
            )
        }
        .frame(height: metrics.headerHeight)
    }

    private func iconButton(
        systemName: String,
        color: Color,
        size: CGFloat,
        iconSize: CGFloat
    ) -> some View {
        Button(action: {}) {
            Image(systemName: systemName)
                .foregroundStyle(color)
                .font(.system(size: iconSize, weight: .bold))
                .frame(width: size, height: size)
                .background(.white.opacity(0.08))
                .clipShape(Circle())
        }
    }

    private func dateCard(_ metrics: HomeLayoutMetrics) -> some View {
        HStack(spacing: metrics.dateContentSpacing) {
            VStack(alignment: .trailing, spacing: metrics.dateTextSpacing) {
                Text("مواقيت دقيقة لفلسطين")
                    .font(.system(size: metrics.dateTitleFontSize, weight: .bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.76)
                    .foregroundStyle(AppTheme.gold)

                Text(gregorianDateText())
                    .font(.system(size: metrics.dateBodyFontSize, weight: .regular))
                    .lineLimit(1)
                    .minimumScaleFactor(0.70)
                    .foregroundStyle(.white.opacity(0.70))

                Text(hijriDateText())
                    .font(.system(size: metrics.dateFootnoteFontSize, weight: .medium))
                    .lineLimit(1)
                    .minimumScaleFactor(0.76)
                    .foregroundStyle(.white.opacity(0.55))
            }
            .multilineTextAlignment(.trailing)

            Spacer(minLength: 10)

            ZStack {
                Circle()
                    .fill(AppTheme.gold.opacity(0.16))
                    .frame(width: metrics.sealSize, height: metrics.sealSize)

                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: metrics.sealIconSize, weight: .bold))
                    .foregroundStyle(AppTheme.gold)
            }
        }
        .padding(metrics.datePadding)
        .frame(height: metrics.dateCardHeight)
        .background(glassCard(cornerRadius: metrics.dateCornerRadius))
    }

    private func nextPrayerCard(_ metrics: HomeLayoutMetrics) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: metrics.nextCardCornerRadius)
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
                    RoundedRectangle(cornerRadius: metrics.nextCardCornerRadius)
                        .stroke(AppTheme.gold.opacity(0.38), lineWidth: 1)
                }

            VStack(spacing: metrics.nextCardSpacing) {
                HStack {
                    VStack(alignment: .trailing, spacing: metrics.nextTitleSpacing) {
                        Text("الصلاة القادمة")
                            .font(.system(size: metrics.nextLabelFontSize, weight: .semibold))
                            .lineLimit(1)
                            .foregroundStyle(AppTheme.gold)

                        Text(nextPrayer.name.rawValue)
                            .font(.system(size: metrics.nextNameFontSize, weight: .heavy, design: .rounded))
                            .lineLimit(1)
                            .minimumScaleFactor(0.78)
                            .foregroundStyle(.white)
                    }
                    .multilineTextAlignment(.trailing)

                    Spacer(minLength: 14)

                    Image(systemName: nextPrayer.name.icon)
                        .font(.system(size: metrics.nextIconSize, weight: .bold))
                        .foregroundStyle(AppTheme.softGold)
                        .shadow(color: AppTheme.gold.opacity(0.42), radius: metrics.nextIconShadowRadius)
                }

                Text(prayerTimes.remainingTimeText(from: now))
                    .font(.system(size: metrics.countdownFontSize, weight: .heavy, design: .rounded))
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)
                    .foregroundStyle(AppTheme.gold)

                Text("متبقي حتى أذان \(nextPrayer.name.rawValue)")
                    .font(.system(size: metrics.nextCaptionFontSize, weight: .medium))
                    .lineLimit(1)
                    .minimumScaleFactor(0.82)
                    .foregroundStyle(.white.opacity(0.65))
            }
            .padding(metrics.nextCardPadding)
        }
        .frame(height: metrics.nextCardHeight)
        .shadow(color: AppTheme.gold.opacity(0.12), radius: metrics.cardShadowRadius, x: 0, y: metrics.cardShadowY)
    }

    private func prayerList(_ metrics: HomeLayoutMetrics) -> some View {
        VStack(spacing: 0) {
            ForEach(prayerTimes.items) { item in
                prayerRow(item, metrics: metrics)

                if item.name != prayerTimes.items.last?.name {
                    Divider()
                        .background(.white.opacity(0.08))
                        .padding(.horizontal, metrics.rowDividerInset)
                }
            }
        }
        .frame(height: metrics.prayerListHeight)
        .background(glassCard(cornerRadius: metrics.listCornerRadius))
        .clipShape(RoundedRectangle(cornerRadius: metrics.listCornerRadius))
    }

    private func prayerRow(_ item: PrayerTimeItem, metrics: HomeLayoutMetrics) -> some View {
        let isNext = item.name == nextPrayer.name

        return HStack(spacing: metrics.rowSpacing) {
            ZStack {
                Circle()
                    .fill(isNext ? AppTheme.gold.opacity(0.18) : Color.white.opacity(0.07))
                    .frame(width: metrics.rowIconSize, height: metrics.rowIconSize)

                Image(systemName: item.name.icon)
                    .font(.system(size: metrics.rowIconFontSize, weight: .bold))
                    .foregroundStyle(isNext ? AppTheme.gold : .white.opacity(0.68))
            }

            Text(timeText(item.time))
                .font(.system(size: metrics.rowTimeFontSize, weight: .bold, design: .rounded))
                .monospacedDigit()
                .lineLimit(1)
                .foregroundStyle(isNext ? AppTheme.gold : .white)

            Spacer(minLength: 8)

            VStack(alignment: .trailing, spacing: metrics.rowTextSpacing) {
                Text(item.name.rawValue)
                    .font(.system(size: metrics.rowNameFontSize, weight: .bold))
                    .lineLimit(1)
                    .foregroundStyle(.white)

                if isNext {
                    Text("القادمة")
                        .font(.system(size: metrics.badgeFontSize, weight: .bold))
                        .lineLimit(1)
                        .foregroundStyle(AppTheme.gold)
                }
            }
            .multilineTextAlignment(.trailing)
        }
        .padding(.horizontal, metrics.rowHorizontalPadding)
        .frame(height: metrics.rowHeight)
        .background {
            if isNext {
                RoundedRectangle(cornerRadius: metrics.activeRowCornerRadius)
                    .fill(AppTheme.emerald.opacity(0.24))
                    .padding(.horizontal, metrics.activeRowHorizontalInset)
                    .padding(.vertical, metrics.activeRowVerticalInset)
            }
        }
    }

    private func bottomNavigation(_ metrics: HomeLayoutMetrics) -> some View {
        HStack {
            navItem(title: "الرئيسية", icon: "house.fill", active: true, metrics: metrics)
            Spacer()
            navItem(title: "القبلة", icon: "safari.fill", active: false, metrics: metrics)
            Spacer()
            navItem(title: "الأذكار", icon: "book.closed.fill", active: false, metrics: metrics)
            Spacer()
            navItem(title: "المزيد", icon: "square.grid.2x2.fill", active: false, metrics: metrics)
        }
        .padding(.horizontal, metrics.navHorizontalPadding)
        .frame(height: metrics.navHeight)
        .background(glassCard(cornerRadius: metrics.navCornerRadius))
    }

    private func navItem(title: String, icon: String, active: Bool, metrics: HomeLayoutMetrics) -> some View {
        VStack(spacing: metrics.navItemSpacing) {
            Image(systemName: icon)
                .font(.system(size: metrics.navIconSize, weight: .bold))

            Text(title)
                .font(.system(size: metrics.navTitleFontSize, weight: .bold))
                .lineLimit(1)
                .minimumScaleFactor(0.80)
        }
        .frame(minWidth: metrics.navItemMinWidth)
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

private struct HomeLayoutMetrics {
    private let height: CGFloat
    private let width: CGFloat

    init(size: CGSize) {
        self.height = size.height
        self.width = size.width
    }

    private var isTight: Bool { height < 700 }
    private var isCompact: Bool { height < 780 }
    private var isNarrow: Bool { width < 380 }

    var horizontalPadding: CGFloat { isNarrow ? 14 : 18 }
    var topPadding: CGFloat { isTight ? 8 : (isCompact ? 10 : 14) }
    var bottomPadding: CGFloat { isTight ? 8 : 12 }
    var sectionSpacing: CGFloat { isTight ? 8 : (isCompact ? 10 : 14) }

    var headerHeight: CGFloat { isTight ? 44 : (isCompact ? 50 : 56) }
    var headerIconSize: CGFloat { isTight ? 36 : (isCompact ? 40 : 42) }
    var headerButtonIconSize: CGFloat { isTight ? 15 : 17 }
    var titleFontSize: CGFloat { isTight ? 27 : (isCompact ? 30 : 32) }
    var headerTitleSpacing: CGFloat { isTight ? 3 : 5 }
    var locationIconSize: CGFloat { isTight ? 10 : 12 }
    var locationFontSize: CGFloat { isTight ? 12 : 13 }

    var dateCardHeight: CGFloat { isTight ? 74 : (isCompact ? 84 : 94) }
    var datePadding: CGFloat { isTight ? 12 : (isCompact ? 14 : 16) }
    var dateContentSpacing: CGFloat { isTight ? 12 : 16 }
    var dateTextSpacing: CGFloat { isTight ? 4 : 6 }
    var dateTitleFontSize: CGFloat { isTight ? 14 : (isCompact ? 15 : 17) }
    var dateBodyFontSize: CGFloat { isTight ? 12 : 14 }
    var dateFootnoteFontSize: CGFloat { isTight ? 11 : 12 }
    var sealSize: CGFloat { isTight ? 46 : (isCompact ? 54 : 62) }
    var sealIconSize: CGFloat { isTight ? 23 : (isCompact ? 27 : 31) }
    var dateCornerRadius: CGFloat { isTight ? 22 : 26 }

    var nextCardHeight: CGFloat { isTight ? 152 : (isCompact ? 178 : 206) }
    var nextCardPadding: CGFloat { isTight ? 16 : (isCompact ? 18 : 22) }
    var nextCardSpacing: CGFloat { isTight ? 7 : (isCompact ? 9 : 12) }
    var nextTitleSpacing: CGFloat { isTight ? 4 : 7 }
    var nextLabelFontSize: CGFloat { isTight ? 13 : 15 }
    var nextNameFontSize: CGFloat { isTight ? 30 : (isCompact ? 35 : 40) }
    var nextIconSize: CGFloat { isTight ? 31 : (isCompact ? 36 : 40) }
    var nextIconShadowRadius: CGFloat { isTight ? 12 : 16 }
    var countdownFontSize: CGFloat { isTight ? 33 : (isCompact ? 39 : 46) }
    var nextCaptionFontSize: CGFloat { isTight ? 11 : 13 }
    var nextCardCornerRadius: CGFloat { isTight ? 28 : 32 }
    var cardShadowRadius: CGFloat { isTight ? 14 : 22 }
    var cardShadowY: CGFloat { isTight ? 10 : 16 }

    var rowHeight: CGFloat { isTight ? 38 : (isCompact ? 43 : 48) }
    var prayerListHeight: CGFloat { (rowHeight * 6) + 5 }
    var rowIconSize: CGFloat { isTight ? 30 : (isCompact ? 34 : 38) }
    var rowIconFontSize: CGFloat { isTight ? 13 : (isCompact ? 15 : 16) }
    var rowTimeFontSize: CGFloat { isTight ? 14 : (isCompact ? 15 : 17) }
    var rowNameFontSize: CGFloat { isTight ? 14 : (isCompact ? 15 : 16) }
    var badgeFontSize: CGFloat { isTight ? 9 : 11 }
    var rowSpacing: CGFloat { isTight ? 10 : 12 }
    var rowTextSpacing: CGFloat { isTight ? 1 : 2 }
    var rowHorizontalPadding: CGFloat { isTight ? 12 : 14 }
    var rowDividerInset: CGFloat { isTight ? 14 : 18 }
    var activeRowCornerRadius: CGFloat { isTight ? 18 : 20 }
    var activeRowHorizontalInset: CGFloat { isTight ? 6 : 8 }
    var activeRowVerticalInset: CGFloat { isTight ? 3 : 5 }
    var listCornerRadius: CGFloat { isTight ? 24 : 28 }

    var navHeight: CGFloat { isTight ? 54 : (isCompact ? 60 : 66) }
    var navHorizontalPadding: CGFloat { isTight ? 14 : 18 }
    var navIconSize: CGFloat { isTight ? 15 : 17 }
    var navTitleFontSize: CGFloat { isTight ? 10 : 11 }
    var navItemSpacing: CGFloat { isTight ? 4 : 6 }
    var navItemMinWidth: CGFloat { isNarrow ? 48 : 54 }
    var navCornerRadius: CGFloat { isTight ? 24 : 28 }
}

private extension View {
    @ViewBuilder
    func salatiSafeAreaPadding(_ edges: Edge.Set, _ length: CGFloat) -> some View {
        if #available(iOS 17.0, *) {
            self.safeAreaPadding(edges, length)
        } else {
            self.padding(edges, length)
        }
    }
}

#Preview {
    PrayerHomeView()
}
