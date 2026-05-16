# صلاتي

بداية تطبيق iOS SwiftUI لمواقيت الصلاة بواجهة عربية RTL، وضع ليلي، وتصميم زجاجي Apple-style.

## الحالة الحالية

- تطبيق iOS جاهز للفتح في Xcode.
- الواجهة الرئيسية موجودة.
- العداد يتحدث كل ثانية داخل `PrayerHomeView`.
- المواقيت محلية وثابتة حالياً، بدون API خارجي.
- لا يوجد Widget.
- لا يوجد Live Activity.
- لا يوجد Dynamic Island.
- لا توجد إشعارات.
- لا توجد GitHub Actions أو workflow.

## التجربة على الآيفون

1. افتح المشروع على جهاز Mac.
2. افتح الملف `Salati.xcodeproj` في Xcode.
3. وصل الآيفون بالـ Mac.
4. من أعلى Xcode اختر الآيفون كجهاز التشغيل.
5. افتح إعدادات Target باسم `Salati`.
6. من `Signing & Capabilities` اختر حساب Apple الخاص بك.
7. اضغط `Run`.

## ملاحظة مهمة

GitHub يخزن الكود فقط. تشغيل تطبيق iOS على الآيفون يحتاج Xcode وتوقيع Apple من جهاز Mac أو تجهيز TestFlight لاحقاً بحساب Apple Developer.
