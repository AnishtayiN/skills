# 🤖 Agent Skills Pack — پک کامل اسکیل‌های هوشمند

> **29 اسکیل حرفه‌ای برای agent‌های برنامه‌نویسی هوش مصنوعی**
> پشتیبانی از: Claude Code / Cursor / Hermes / Windsurf / Cline / Continue / Aider / OpenHands / و هر agent مبتنی بر سیستم اسکیل

---

## 📋 فهرست مطالب

- [معرفی](#-معرفی)
- [پیش‌نیازها](#-پیش‌نیازها)
- [نصب و راه‌اندازی](#-نصب-و-راه‌اندازی)
  - [Claude Code](#1-claude-code)
  - [Cursor](#2-cursor)
  - [Hermes](#3-hermes)
  - [Windsurf](#4-windsurf)
  - [Cline](#5-cline)
  - [Continue](#6-continue)
  - [Aider](#7-aider)
  - [OpenHands](#8-openhands)
  - [سایر agent ها](#9-سایر-agent-ها)
- [دسته‌بندی اسکیل‌ها](#-دسته‌بندی-اسکیل‌ها)
- [ساختار هر اسکیل](#-ساختار-هر-اسکیل)
- [نحوه استفاده](#-نحوه-استفاده)
- [توسعه و سفارشی‌سازی](#-توسعه-و-سفارشی‌سازی)
- [سوالات متداول](#-سوالات-متداول)

---

## 🔍 معرفی

این مجموعه شامل **29 اسکیل حرفه‌ای** است که قابلیت‌های agent‌های برنامه‌نویسی هوش مصنوعی را به شدت ارتقا می‌دهد. هر اسکیل شامل:

- **فرآیند کاری ساختاریافته** با مراحل دقیق
- **تکنیک‌های پیشرفته** سطح اکسپرت
- **الگوهای رایج** با مثال‌های عملی و کد
- **موارد خاص و تله‌ها** برای جلوگیری از خطاهای رایج
- **قالب‌های خروجی متنوع** (استاندارد، سریع، عمیق)
- **تریگرهای دوزبانه** (فارسی + انگلیسی)

**مجموع: 13,800+ خط دستورالعمل حرفه‌ای**

---

## ✅ پیش‌نیازها

| پیش‌نیاز | حداقل نسخه | توضیح |
|----------|------------|-------|
| Node.js | 18+ | برای agent های مبتنی بر JS |
| Python | 3.9+ | برای اسکریپت‌های کمکی |
| Git | 2.30+ | برای مدیریت نسخه |
| یک Agent هوش مصنوعی | آخرین نسخه | Claude Code، Cursor، Hermes و غیره |

---

## 🚀 نصب و راه‌اندازی

### 1. Claude Code

Claude Code از فایل‌های markdown در دایرکتوری `.claude/` استفاده می‌کند.

```bash
# مرحله 1: ایجاد دایرکتوری اسکیل‌ها در پروژه
mkdir -p .claude/skills

# مرحله 2: کپی کردن همه اسکیل‌ها
cp -r agent-skills-pack/* .claude/skills/

# مرحله 3: ساختار نهایی
# .claude/skills/
# ├── README.md
# ├── debug/SKILL.md
# ├── code-review/SKILL.md
# ├── refactor/SKILL.md
# └── ... (29 اسکیل)
```

**فعال‌سازی خودکار:** Claude Code به طور خودکار فایل‌های `SKILL.md` را در دایرکتوری `.claude/skills/` شناسایی می‌کند. نیازی به تنظیم اضافی نیست.

**تنظیم دستی (اختیاری):** اگر می‌خواهید اسکیل‌های خاصی فعال باشند:

```json
// .claude/settings.json
{
  "skills": [
    ".claude/skills/debug/SKILL.md",
    ".claude/skills/code-review/SKILL.md",
    ".claude/skills/refactor/SKILL.md"
  ]
}
```

---

### 2. Cursor

Cursor از rules و patterns پشتیبانی می‌کند.

```bash
# مرحله 1: ایجاد دایرکتوری
mkdir -p .cursor/rules

# مرحله 2: تبدیل اسکیل‌ها به فرمت Cursor
# هر اسکیل را به یک فایل .md در .cursor/rules/ کپی کنید
for skill in agent-skills-pack/*/SKILL.md; do
  name=$(basename $(dirname $skill))
  cp "$skill" ".cursor/rules/${name}.md"
done
```

یا به صورت **Global Rules** (برای همه پروژه‌ها):

```bash
# macOS/Linux
mkdir -p ~/.cursor/rules
cp agent-skills-pack/*/SKILL.md ~/.cursor/rules/

# هر اسکیل به عنوان یک rule جداگانه عمل می‌کند
```

**نکته:** Cursor همچنین از فایل `.cursorrules` در ریشه پروژه پشتیبانی می‌کند. می‌توانید محتوای اسکیل‌های مورد نیاز را در این فایل ادغام کنید.

---

### 3. Hermes

Hermes از سیستم اسکیل مشابه Claude Code استفاده می‌کند.

```bash
# مرحله 1: ایجاد دایرکتوری اسکیل‌ها
mkdir -p ~/.hermes/skills

# مرحله 2: کپی کردن همه اسکیل‌ها
cp -r agent-skills-pack/* ~/.hermes/skills/
```

فایل تنظیمات Hermes:

```yaml
# ~/.hermes/config.yaml
skills:
  directory: ~/.hermes/skills
  auto_load: true
  # اسکیل‌های خاصی که همیشه فعال باشند
  always_active:
    - debug
    - code-review
  # اسکیل‌هایی که فقط با تریگر فعال شوند
  trigger_based:
    - dockerization
    - ci-cd-pipeline
    - cloud-deployment
```

---

### 4. Windsurf

```bash
# مرحله 1: ایجاد دایرکتوری
mkdir -p .windsurf/rules

# مرحله 2: کپی کردن اسکیل‌ها
for skill in agent-skills-pack/*/SKILL.md; do
  name=$(basename $(dirname $skill))
  cp "$skill" ".windsurf/rules/${name}.md"
done
```

---

### 5. Cline

```bash
# مرحله 1: ایجاد دایرکتوری
mkdir -p .cline/skills

# مرحله 2: کپی کردن همه اسکیل‌ها
cp -r agent-skills-pack/* .cline/skills/
```

تنظیم در `.cline/settings.json`:

```json
// .cline/settings.json
{
  "customSkills": [
    ".cline/skills/debug/SKILL.md",
    ".cline/skills/code-review/SKILL.md",
    ".cline/skills/refactor/SKILL.md",
    ".cline/skills/test-generation/SKILL.md",
    ".cline/skills/prompt-engineering/SKILL.md",
    ".cline/skills/rag-implementation/SKILL.md"
  ]
}
```

---

### 6. Continue

Continue از فایل `~/.continue/config.yaml` پشتیبانی می‌کند.

```bash
# مرحله 1: ایجاد دایرکتوری
mkdir -p ~/.continue/skills

# مرحله 2: کپی کردن
cp -r agent-skills-pack/* ~/.continue/skills/
```

تنظیم در `~/.continue/config.yaml`:

```yaml
skills:
  - path: ~/.continue/skills/debug/SKILL.md
    name: debug
    description: "Debug any code"
  - path: ~/.continue/skills/code-review/SKILL.md
    name: code-review
    description: "Review code quality"
  # ... سایر اسکیل‌ها
```

---

### 7. Aider

Aider از فایل‌های conventions استفاده می‌کند.

```bash
# مرحله 1: ایجاد دایرکتوری
mkdir -p ~/.aider

# مرحله 2: ادغام اسکیل‌های منتخب در فایل conventions
# Aider همه اسکیل‌ها را به صورت یکجا لود نمی‌کند
# بهتر است اسکیل‌های مرتبط با کار فعلی را انتخاب کنید

cat agent-skills-pack/debug/SKILL.md > ~/.aider/conventions.md
echo "\n---\n" >> ~/.aider/conventions.md
cat agent-skills-pack/code-review/SKILL.md >> ~/.aider/conventions.md
echo "\n---\n" >> ~/.aider/conventions.md
cat agent-skills-pack/refactor/SKILL.md >> ~/.aider/conventions.md
```

**نکته:** Aider محدودیت اندازه context دارد. پیشنهاد می‌شود فقط اسکیل‌های مورد نیاز هر پروژه را در conventions.md قرار دهید.

---

### 8. OpenHands

```bash
# مرحله 1: ایجاد دایرکتوری
mkdir -p ~/.openhands/skills

# مرحله 2: کپی کردن
cp -r agent-skills-pack/* ~/.openhands/skills/
```

تنظیم در `config.toml`:

```toml
[skills]
directory = "~/.openhands/skills"
auto_load = true
max_skills_per_request = 10
```

---

### 9. سایر Agent ها

برای هر agent دیگری که از سیستم اسکیل/ rule پشتیبانی می‌کند:

1. **پیدا کردن مسیر اسکیل‌ها:** ببینید agent فایل‌های markdown را از کجا می‌خواند
2. **کپی کردن:** فایل‌های SKILL.md را در آن مسیر قرار دهید
3. **تنظیم:** اگر agent فایل تنظیمات دارد، مسیر اسکیل‌ها را مشخص کنید

**الگوی کلی:**

```bash
# الگوی عمومی برای هر agent
AGENT_SKILL_DIR=~/.your-agent/skills
mkdir -p "$AGENT_SKILL_DIR"
cp -r agent-skills-pack/* "$AGENT_SKILL_DIR/"
```

**بررسی سریع:** اگر agent شما از MCP (Model Context Protocol) پشتیبانی می‌کند، می‌توانید اسکیل‌ها را از طریق سرور MCP نیز منتشر کنید.

---

## 📦 دسته‌بندی اسکیل‌ها

### 🧑‍💻 توسعه نرم‌افزار (Software Development)

| # | اسکیل | خطوط | توضیح |
|---|-------|------:|-------|
| 1 | **debug** | 505 | دیباگ و رفع باگ‌های پیچیده + مرجع ۱۴ زبان |
| 2 | **code-review** | 324 | بررسی کد، پیدا کردن باگ و بهبود کیفیت |
| 3 | **refactor** | 312 | بازنویسی و تمیز کردن کد بدون تغییر عملکرد |
| 4 | **test-generation** | 303 | نوشتن تست‌های واحد و یکپارچه |
| 5 | **explain-code** | 302 | تحلیل و توضیح کدهای پیچیده و ناشناخته |
| 6 | **git-workflow** | 312 | مدیریت گیت، برنچ‌ها، مارج و رفع کانفلیکت |
| 7 | **clean-architecture** | 318 | طراحی پروژه بر اساس اصول معماری تمیز |
| 8 | **api-design** | 351 | طراحی استاندارد APIهای RESTful یا GraphQL |

### 🧠 مهندسی پرامپت و خودیاری (Prompting & AI Meta-Skills)

| # | اسکیل | خطوط | توضیح |
|---|-------|------:|-------|
| 9 | **prompt-engineering** | 571 | نوشتن و بهینه‌سازی پرامپت‌های سیستم |
| 10 | **chain-of-thought** | 531 | تحریک هوش مصنوعی برای استدلال گام‌به‌گام |
| 11 | **self-correction** | 434 | بررسی و اصلاح خروجی‌های خود هوش مصنوعی |
| 12 | **rag-implementation** | 571 | پیاده‌سازی RAG (بازیابی مبتنی بر تولید) |

### 🏗️ برنامه‌ریزی و معماری (Planning & Architecture)

| # | اسکیل | خطوط | توضیح |
|---|-------|------:|-------|
| 13 | **brainstorming** | 403 | ایده‌پردازی و بررسی راه‌حل‌های جایگزین |
| 14 | **task-planning** | 450 | شکستن پروژه‌های بزرگ به تسک‌های کوچک |
| 15 | **system-design** | 470 | طراحی سیستم‌های مقیاس‌پذیر |
| 16 | **database-schema** | 505 | طراحی دیتابیس، جداول و روابط |

### ☁️ دواپس و زیرساخت (DevOps & Cloud)

| # | اسکیل | خطوط | توضیح |
|---|-------|------:|-------|
| 17 | **dockerization** | 560 | نوشتن Dockerfile و docker-compose |
| 18 | **ci-cd-pipeline** | 601 | راه‌اندازی پایپ‌لاین‌های CI/CD |
| 19 | **cloud-deployment** | 597 | استقرار روی AWS، GCP یا Azure |
| 20 | **security-audit** | 473 | بررسی کد از نظر مشکلات امنیتی |

### 📊 داده و تحلیل (Data & Analysis)

| # | اسکیل | خطوط | توضیح |
|---|-------|------:|-------|
| 21 | **data-analysis** | 402 | تحلیل دیتاست‌ها و استخراج آمار |
| 22 | **data-cleaning** | 505 | پاکسازی و پیش‌پردازش داده‌های خام |
| 23 | **web-scraping** | 583 | استخراج داده از سایت‌ها |

### ✍️ محتوا و مستندسازی (Content & Docs)

| # | اسکیل | خطوط | توضیح |
|---|-------|------:|-------|
| 24 | **documentation** | 547 | نوشتن README و مستندات API |
| 25 | **changelog** | 456 | تولید یادداشت‌های نسخه |
| 26 | **technical-writing** | 571 | نوشتن مقالات فنی و آموزشی |
| 27 | **summarization** | 388 | خلاصه‌سازی فایل‌ها و جلسات |

### 🤖 اتوماسیون و مرورگر (Automation)

| # | اسکیل | خطوط | توضیح |
|---|-------|------:|-------|
| 28 | **browser-automation** | 487 | کار با Playwright یا Puppeteer |
| 29 | **api-integration** | 723 | اتصال به سرویس‌های خارجی |

---

## 🏗️ ساختار هر اسکیل

```
skill-name/
├── SKILL.md                    # فایل اصلی اسکیل
└── references/                 # فایل‌های مرجع (اختیاری)
    └── language-patterns.md    # الگوهای خاص زبان
```

### بخش‌های هر SKILL.md:

```yaml
---
name: skill-name               # نام شناسه‌ای اسکیل
description: >-                  # توضیح + تریگرها (فارسی + انگلیسی)
  When to trigger this skill...
---
```

**بخش‌های بدنه:**

| بخش | محتوا |
|------|-------|
| **Overview** | معرفی و هدف اسکیل |
| **Workflow** | فرآیند کاری گام‌به‌گام |
| **Advanced Techniques** | 5-7 تکنیک سطح اکسپرت |
| **Common Patterns** | 5 الگوی رایج با مثال کد |
| **Edge Cases & Pitfalls** | 10-18 تله و مورد خاص |
| **Integration** | اتصال با اسکیل‌های مرتبط |
| **Output Format** | 3-4 قالب خروجی (استاندارد، سریع، عمیق) |
| **Rules** | قوانین و محدودیت‌ها |

---

## 💡 نحوه استفاده

### استفاده مستقیم

بعد از نصب، agent به طور خودکار اسکیل مناسب را شناسایی می‌کند. فقط کافیست درخواست خود را بگویید:

```
"این کد رو دیباگ کن"
"یه تست کامل برای این تابع بنویس"
"این پروژه رو داکرایز کن"
"یه API RESTful برای فروشگاه آنلاین طراحی کن"
"این دیتاست رو تحلیل کن"
```

### ترکیب اسکیل‌ها

اسکیل‌ها طوری طراحی شدن که با هم کار کنند. مثلاً:

1. **بازنگری کامل کد:** `code-review` -> `debug` -> `refactor` -> `test-generation`
2. **طراحی و پیاده‌سازی:** `brainstorming` -> `system-design` -> `database-schema` -> `api-design` -> `clean-architecture`
3. **استقرار کامل:** `dockerization` -> `ci-cd-pipeline` -> `security-audit` -> `cloud-deployment`
4. **تحلیل داده:** `web-scraping` -> `data-cleaning` -> `data-analysis` -> `documentation`
5. **بهبود هوش مصنوعی:** `prompt-engineering` -> `chain-of-thought` -> `rag-implementation` -> `self-correction`

---

## 🔧 توسعه و سفارشی‌سازی

### ویرایش اسکیل موجود

```bash
# هر اسکیل یک فایل markdown ساده است
# فقط کافیه ویرایشش کنید
vim .claude/skills/debug/SKILL.md
```

### ساخت اسکیل جدید

```bash
# مرحله 1: ایجاد دایرکتوری
mkdir -p .claude/skills/my-custom-skill

# مرحله 2: ایجاد فایل SKILL.md
cat > .claude/skills/my-custom-skill/SKILL.md << 'EOF'
---
name: my-custom-skill
description: >-
  توضیح اسکیل + تریگرها
  Use this skill when...
---

# My Custom Skill

## Overview
...

## Workflow
...
EOF
```

### اضافه کردن فایل مرجع

```bash
# فایل‌های مرجع اسکیل‌های بزرگ را سبک‌تر نگه می‌دارند
mkdir -p .claude/skills/my-skill/references
vim .claude/skills/my-skill/references/advanced-patterns.md
```

---

## ❓ سوالات متداول

### آیا این اسکیل‌ها با همه مدل‌ها کار می‌کنند؟
بله. این اسکیل‌ها بر اساس markdown نوشته شده‌اند و با هر مدلی که از system prompt / instructions پشتیبانی می‌کند کار می‌کنند: Claude, GPT-4, Gemini, Llama, Mistral و غیره.

### آیا می‌توانم فقط بخشی از اسکیل‌ها را نصب کنم؟
بله. فقط پوشه‌های مورد نظر خود را کپی کنید. هر اسکیل کاملاً مستقل عمل می‌کند.

### آیا اسکیل‌ها به زبان فارسی هستند؟
تریگرها و توضیحات دوزبانه (فارسی + انگلیسی) هستند. بدنه اسکیل‌ها به انگلیسی نوشته شده تا agent بهترین عملکرد را داشته باشد.

### چگونه اسکیل جدید اضافه کنم؟
از ساختار استاندارد پیروی کنید: پوشه با نام اسکیل + فایل `SKILL.md` با frontmatter مناسب. به بخش [توسعه و سفارشی‌سازی](#-توسعه-و-سفارشی‌سازی) مراجعه کنید.

### حجم اسکیل‌ها چقدر تاثیر روی context window می‌گذارد؟
اسکیل‌ها فقط زمانی لود می‌شوند که تریگر شوند (lazy loading). بنابراین تاثیر زیادی روی context window ندارند.

### آیا می‌توانم این اسکیل‌ها را تجاری کنم؟
این اسکیل‌ها تحت لایسنس MIT منتشر شده‌اند. می‌توانید آزادانه استفاده، تغییر و توزیع کنید.

---

## 📊 آمار

| متریک | مقدار |
|--------|------:|
| تعداد کل اسکیل‌ها | **29** |
| مجموع خطوط دستورالعمل | **~13,800+** |
| تعداد تکنیک‌های پیشرفته | **~200** |
| تعداد الگوهای رایج | **~145** |
| تعداد تله‌ها و موارد خاص | **~380** |
| تعداد قالب‌های خروجی | **~100** |
| زبان‌های پشتیبانی‌شده (دیباگ) | **14** |
| زبان‌های تریگر | **2** (فارسی + انگلیسی) |

---

## 📄 لایسنس

MIT License — استفاده آزاد برای شخصی و تجاری.

---

<div align="center">
  <p>ساخته شده با عشق برای جامعه برنامه‌نویسان فارسی‌زبان</p>
  <p>v2.0 — ارتقای کامل</p>
</div>
