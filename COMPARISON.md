# 📊 مقایسه کامل: new-skills (ما) vs v2 (مرجع)

> همه ۲۹ اسکیل v2 خونده شده و مقایسه شده

---

## 📈 آمار کلی

| معیار | new-skills | v2 |
|-------|-----------|-----|
| تعداد اسکیل | ۲۵ | ۲۹ |
| میانگین خط/اسکیل | ~۱۵۹ | ~۴۸۰ |
| بزرگترین اسکیل | debugging (180) | api-integration (723) |
| تریگرها | EN+FA | EN+FA+ZH |
| فایل reference | ندارد | دارد (language-patterns) |
| قالب خروجی | ندارد | ۴ قالب در هر اسکیل |
| Edge Cases | ندارد | ۱۵-۱۸ در هر اسکیل |

---

## 🔴 اسکیل‌هایی که در v2 هستن ولی ما نداریم

| # | اسکیل | خطوط | چرا مهمه |
|---|-------|------|---------|
| 1 | **prompt-engineering** | 571 | نوشتن و بهینه‌سازی پرامپت — مهارت پایه همه اجنت‌ها |
| 2 | **chain-of-thought** | 531 | استدلال گام‌به‌گام — کیفیت تصمیم‌گیری اجنت |
| 3 | **self-correction** | 434 | اصلاح خودکار خروجی — جلوگیری از اشتباه تکراری |
| 4 | **rag-implementation** | 571 | پیاده‌سازی RAG — برای پروژه‌های AI ضروری |
| 5 | **brainstorming** | 403 | ایده‌پردازی ساختاریافته |
| 6 | **api-integration** | 723 | اتصال به API خارجی — Stripe, GitHub, OpenAI و... |
| 7 | **web-scraping** | 583 | استخراج داده از وب |
| 8 | **browser-automation** | 487 | اتوماسیون مرورگر با Playwright |
| 9 | **data-analysis** | 402 | تحلیل آماری دیتاست |
| 10 | **data-cleaning** | 505 | پاکسازی داده خام |
| 11 | **technical-writing** | 571 | نوشتن مقالات فنی و آموزشی |
| 12 | **summarization** | 388 | خلاصه‌سازی هوشمند |
| 13 | **changelog** | 456 | تولید یادداشت نسخه |

---

## 🟡 اسکیل‌های مشترک — نقاط ضعف ما

| اسکیل | ما (خط) | v2 (خط) | چه چیزی کم داریم |
|-------|---------|---------|-----------------|
| **debug** | 180 | 505 | مرجع ۱۴ زبان، ۱۵ edge case، ۷ تکنیک پیشرفته، ۵ قالب خروجی، الگوهای agent-specific |
| **code-review** | 150 | 324 | ۵ pass بررسی، threat modeling، الگوهای کد، ۱۴ edge case |
| **refactor** | 120 | 312 | کاتالوگ code smell، تکنیک‌های SOLID، ۱۵ edge case |
| **test-generation** | 140 | 303 | الگوهای mocking، property-based testing، ۱۵ edge case |
| **explain-code** | 80 | 302 | سطوح مختلف توضیح، تکنیک‌های بصری |
| **git-workflow** | 100 | 312 | resolve conflict، bisect، cherry-pick، ۱۵ edge case |
| **clean-architecture** | نداریم | 318 | اصول معماری تمیز، dependency rule |
| **api-design** | 100 | 351 | REST + GraphQL، versioning، error handling |
| **task-planning** | 100 | 450 | MoSCoW، critical path، Walking Skeleton، risk-first |
| **system-design** | 100 | 470 | Back-of-envelope، bounded context، FMEA-lite |
| **database-schema** | 90 | 506 | SQL runnable، multi-tenancy، event sourcing |
| **dockerization** | 80 | 560 | BuildKit، distroless، GPU، ۱۸ edge case |
| **ci-cd** | 80 | 601 | GitHub Actions + GitLab CI، OIDC، canary deploy |
| **deployment** | 80 | 598 | Terraform + CloudFormation، ۳ cloud |
| **security-audit** | 100 | 474 | OWASP deep، taint analysis، supply chain، ۱۸ edge case |
| **documentation** | 80 | 547 | انواع مستندات، doc-as-code، ۱۴ edge case |

---

## 🟢 نقاط قوت ما نسبت به v2

| ویژگی | ما | v2 |
|-------|-----|-----|
| **اولویت‌بندی (P0-P3)** | ✅ | ❌ |
| **سیستم وابستگی** | ✅ | ❌ |
| **حل تعارض** | ✅ | ❌ |
| **مسیریابی خودکار** | ✅ | ❌ |
| **فلسفه مشخص** | ✅ (۳ اصل) | ❌ |
| **نصب تعاملی** | ✅ | ❌ (فقط دستی) |
| **تشخیص اجنت** | ✅ | ❌ |
| **حذف/آپدیت** | ✅ | ❌ |
| **سایت دوزبانه** | ✅ | ❌ |
| **verification skill** | ✅ | ❌ |
| **concurrency-debugging** | ✅ | ❌ |
| **performance-analysis** | ✅ | ❌ |
| **tool-management** | ✅ | ❌ |
| **context-management** | ✅ | ❌ |
| **agent-orchestration** | ✅ | ❌ |

---

## 🔧 ساختار استاندارد v2 که ما نداریم

هر اسکیل v2 این بخش‌ها رو داره که ما نداریم:

1. **Advanced Techniques** (۷ تکنیک پیشرفته)
2. **Common Patterns** (۵ الگوی رایج با کد)
3. **Edge Cases & Pitfalls** (۱۵-۱۸ تله و مورد خاص)
4. **Integration with Other Skills** (جدول اتصال به اسکیل‌های مرتبط)
5. **Output Format Templates** (۳-۴ قالب خروجی: استاندارد، سریع، عمیق)
6. **Rules** (قوانین و محدودیت‌ها)

---

## 📋 برنامه اقدام

### فوری — اسکیل‌های مفقود (۱۳ اسکیل جدید)
- [ ] prompt-engineering
- [ ] chain-of-thought
- [ ] self-correction
- [ ] rag-implementation
- [ ] brainstorming
- [ ] api-integration
- [ ] web-scraping
- [ ] browser-automation
- [ ] data-analysis
- [ ] data-cleaning
- [ ] technical-writing
- [ ] summarization
- [ ] changelog

### مهم — تکمیل اسکیل‌های موجود (اضافه کردن بخش‌های مفقود)
- [ ] اضافه کردن Advanced Techniques به همه اسکیل‌ها
- [ ] اضافه کردن Common Patterns به همه اسکیل‌ها
- [ ] اضافه کردن Edge Cases (حداقل ۱۰ مورد) به همه اسکیل‌ها
- [ ] اضافه کردن Integration table به همه اسکیل‌ها
- [ ] اضافه کردن Output Templates (حداقل ۳ قالب) به همه اسکیل‌ها
- [ ] اضافه کردن Rules به همه اسکیل‌ها

### معمولی — بهبود کیفیت
- [ ] اضافه کردن تریگرهای چینی (ZH) به همه اسکیل‌ها
- [ ] ساخت فایل reference برای debug (language-patterns)
- [ ] اضافه کردن clean-architecture skill
- [ ] آپدیت سایت HTML با اسکیل‌های جدید
