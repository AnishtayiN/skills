# Skills Evaluation Report — امتیازدهی و بررسی تخصصی اسکیل‌ها

> تاریخ: 2025-07-20
> تعداد کل اسکیل‌ها: 30
> معیارهای امتیازدهی: ساختار (Structure)، وضوح (Clarity)، ارزش عملی (Practical Value)، دقت فعال‌سازی (Trigger Accuracy)، کیفیت خروجی (Output Quality)

---

## خلاصه امتیازات کلی

| رتبه | اسکیل | ساختار | وضوح | ارزش عملی | دقت فعال‌سازی | کیفیت خروجی | **میانگین** |
|------|-------|--------|------|-----------|--------------|-------------|------------|
| 🥇 1 | `debug` | 10 | 10 | 10 | 9 | 9 | **9.6** |
| 🥇 2 | `code-review` | 9 | 10 | 10 | 10 | 9 | **9.6** |
| 🥇 3 | `self-correction` | 9 | 9 | 10 | 8 | 9 | **9.0** |
| 🥈 4 | `api-design` | 10 | 9 | 9 | 9 | 9 | **9.2** |
| 🥈 5 | `refactor` | 9 | 9 | 9 | 9 | 9 | **9.0** |
| 🥈 6 | `test-generation` | 9 | 9 | 9 | 9 | 9 | **9.0** |
| 🥈 7 | `security-audit` | 10 | 9 | 9 | 9 | 9 | **9.2** |
| 🥈 8 | `system-design` | 10 | 9 | 9 | 9 | 9 | **9.2** |
| 🥈 9 | `prompt-engineering` | 10 | 9 | 9 | 8 | 9 | **9.0** |
| 🥉 10 | `chain-of-thought` | 9 | 9 | 9 | 8 | 8 | **8.6** |
| 🥉 11 | `task-planning` | 9 | 9 | 9 | 8 | 9 | **8.8** |
| 🥉 12 | `database-schema` | 9 | 9 | 9 | 9 | 9 | **9.0** |
| 🥉 13 | `git-workflow` | 8 | 9 | 9 | 10 | 8 | **8.8** |
| 🥉 14 | `clean-architecture` | 9 | 9 | 8 | 8 | 9 | **8.6** |
| 🥉 15 | `brainstorming` | 9 | 9 | 8 | 8 | 8 | **8.4** |
| 🥉 16 | `explain-code` | 8 | 9 | 9 | 9 | 8 | **8.6** |
| 🥉 17 | `summarization` | 8 | 9 | 9 | 9 | 8 | **8.6** |
| 🥉 18 | `dockerization` | 9 | 8 | 9 | 9 | 8 | **8.6** |
| 🥉 19 | `documentation` | 9 | 9 | 8 | 8 | 8 | **8.4** |
| 🥉 20 | `ci-cd-pipeline` | 9 | 8 | 9 | 8 | 8 | **8.4** |
| 🥉 21 | `api-integration` | 9 | 9 | 9 | 8 | 8 | **8.6** |
| 🥉 22 | `rag-implementation` | 9 | 9 | 9 | 8 | 8 | **8.6** |
| 🥉 23 | `browser-automation` | 8 | 8 | 8 | 9 | 8 | **8.2** |
| 🥉 24 | `data-analysis` | 8 | 8 | 8 | 8 | 8 | **8.0** |
| 🥉 25 | `technical-writing` | 8 | 8 | 8 | 8 | 8 | **8.0** |
| 🥉 26 | `web-scraping` | 8 | 8 | 8 | 8 | 8 | **8.0** |
| 🥉 27 | `cloud-deployment` | 9 | 8 | 8 | 8 | 7 | **8.0** |
| 🥉 28 | `changelog` | 8 | 8 | 7 | 8 | 8 | **7.8** |
| 🥉 29 | `data-cleaning` | 8 | 8 | 8 | 8 | 8 | **8.0** |

---

## بررسی تک‌تک اسکیل‌ها

---

### 1. `debug` — Universal Code & Agent Debugger ⭐⭐⭐⭐⭐ (9.6/10)

**نقاط قوت:**
- ✅ ساختار عالی 5 فازی (Gather → Classify → Diagnose → Fix → Verify)
- ✅ جدول دسته‌بندی باگ‌ها بسیار مفید و کامل
- ✅ بخش اختصاصی Agent/Loop Bugs بسیار ارزشمند (منحصر به فرد)
- ✅ دو حالت Analysis/Auto-Fix هوشمندانه طراحی شده
- ✅ فایل مرجع `language-patterns.md` برای الگوهای زبانی مختلف
- ✅ تریگرهای فارسی کامل در description

**نقاط ضعف:**
- ⚠️ فاز 4 می‌توانست مثال‌های بیشتری از fix واقعی داشته باشد
- ⚠️ بخش performance debugging مختصر است

**مناسب برای:** تمام Agentهای کدنویسی، debug agent، agent کمکی توسعه

---

### 2. `code-review` — Code Review & Quality Analysis ⭐⭐⭐⭐⭐ (9.6/10)

**نقاط قوت:**
- ✅ 4 Pass Analysis بسیار حرفه‌ای (Correctness → Security → Performance → Maintainability)
- ✅ جدول severity بسیار واضح و کاربردی
- ✅ خروجی ساختاریافته با اولویت‌بندی
- ✅ قوانین ساده و مؤثر (agnitude over verbosity)
- ✅ تریگرهای فارسی کامل

**نقاط ضعف:**
- ⚠️ می‌توانست مثال‌های واقعی‌تری از code review داشته باشد
- ⚠️ بخش test coverage review ندارد

**مناسب برای:** Code Review Agent، QA Agent، agent بررسی PR

---

### 3. `api-design` — RESTful API & GraphQL Design ⭐⭐⭐⭐⭐ (9.2/10)

**نقاط قوت:**
- ✅ جدول REST conventions بسیار کامل
- ✅ فرمت خطا (Error Format) استاندارد و حرفه‌ای
- ✅ پوشش GraphQL علاوه بر REST
- ✅ Versioning, Auth, Rate Limiting همه پوشش داده شده
- ✅ قوانین نامگذاری endpoint روشن

**نقاط ضعف:**
- ⚠️ GraphQL workflow مختصرتر از REST است
- ⚠️ مثال‌های واقعی بیشتر می‌توانست مفید باشد

**مناسب برای:** API Design Agent، Backend Architecture Agent

---

### 4. `security-audit` — Code Security Review ⭐⭐⭐⭐⭐ (9.2/10)

**نقاط قوت:**
- ✅ پوشش کامل OWASP categories
- ✅ جدول severity با مثال‌های واقعی
- ✅ لیست ابزارهای scanning برای هر زبان
- ✅ بخش Dependency Vulnerabilities فراموش نشده
- ✅ خروجی Report ساختاریافته

**نقاط ضعف:**
- ⚠️ می‌توانست edge cases بیشتری پوشش دهد
- ⚠️ بخش cloud-specific security مختصر است

**مناسب برای:** Security Audit Agent، Code Review Agent (بخش security)

---

### 5. `system-design` — Scalable Architecture & Diagrams ⭐⭐⭐⭐⭐ (9.2/10)

**نقاط قوت:**
- ✅ 5 فاز طراحی بسیار منظم
- ✅ پوشش Cross-Cutting Concerns عالی
- ✅ Scalability Analysis با Identification Bottlenecks
- ✅ پشتیبانی از Mermaid diagrams
- ✅ قوانین عملی (technology-specific, justify choices)

**نقاط ضعف:**
- ⚠️ مثال‌های واقعی سیستم‌ها (مثل chat system, e-commerce) می‌توانست داشته باشد
- ⚠️ بخش cost estimation مختصر است

**مناسب برای:** System Design Agent، Architecture Agent، Tech Lead Agent

---

### 6. `refactor` — Code Refactoring & Cleanup ⭐⭐⭐⭐⭐ (9.0/10)

**نقاط قوت:**
- ✅ لیست Code Smells بسیار کامل و کاربردی
- ✅ اصول رفتاری روشن (preserve behavior, small steps)
- ✅ خروجی Before/After با Impact Assessment
- ✅ قوانین محدودکننده خوب (no new features, no new deps)

**نقاط ضعف:**
- ⚠️ می‌توانست الگوهای refactoring بیشتری داشته باشد
- ⚠️ بخش testing after refactoring ندارد

**مناسب برای:** Code Quality Agent، Refactoring Agent

---

### 7. `test-generation` — Test Suite Generation ⭐⭐⭐⭐⭐ (9.0/10)

**نقاط قوت:**
- ✅ جدول Test Framework Detection بسیار مفید
- ✅ 6 نوع test case پوشش داده شده
- ✅ اصول Arrange-Act-Assert
- ✅ قوانین عملی (no brittle tests, focused tests)

**نقاط ضعف:**
- ⚠️ می‌توانست مثال‌های واقعی بیشتری از test generation داشته باشد
- ⚠️ بخش integration test مختصرتر از unit test است

**مناسب برای:** Testing Agent، QA Agent، Code Quality Agent

---

### 8. `self-correction` — Verify & Correct AI Outputs ⭐⭐⭐⭐⭐ (9.0/10)

**نقاط قوت:**
- ✅ 6 دسته خطای سیستماتیک (Factual, Logical, Completeness, Consistency, Calculation, Code)
- ✅ Phase 1: Re-Read ایده عالی‌ای است
- ✅ خروجی Self-Correction Review ساختاریافته
- ✅ اصول صداقت و شفافیت

**نقاط ضعف:**
- ⚠️ می‌توانست مثال‌های واقعی از self-correction داشته باشد
- ⚠️ بخش cascading errors می‌توانست عمیق‌تر باشد

**مناسب برای:** تمام Agentها (به عنوان skill فرعی)، Quality Assurance Agent

---

### 9. `prompt-engineering` — System Prompt Design & Optimization ⭐⭐⭐⭐⭐ (9.0/10)

**نقاط قوت:**
- ✅ لایه‌بندی Prompt Architecture بسیار حرفه‌ای
- ✅ Pattern Library با 3 الگوی پرکاربرد
- ✅ اصول ارزیابی و تست مشخص
- ✅ قوانین عملی (imperative language, constraints last)

**نقاط ضعف:**
- ⚠️ می‌توانست الگوهای بیشتری داشته باشد (ReAct, Self-Ask)
- ⚠️ بخش model-specific considerations ندارد

**مناسب برای:** Prompt Engineering Agent، AI Research Agent

---

### 10. `task-planning` — Project Decomposition & Roadmapping ⭐⭐⭐⭐ (8.8/10)

**نقاط قوت:**
- ✅ اصول شکستن task بسیار خوب (1-4 hours per task)
- ✅ جدول Size/Verifiability/Independence/Naming
- ✅ Milestones + Dependencies + Risk Assessment
- ✅ خروجی با Critical Path Analysis

**نقاط ضعف:**
- ⚠️ می‌توانست مثال‌های واقعی بیشتری داشته باشد
- ⚠️ بخش time estimation مختصر است

**مناسب برای:** Project Planning Agent، Task Manager Agent

---

### 11. `git-workflow` — Git Problem Resolution ⭐⭐⭐⭐ (8.8/10)

**نقاط قوت:**
- ✅ جدول Problem Classification بسیار مفید
- ✅ دستورات دقیق با توضیح
- ✅ Recovery Patterns پرکاربرد
- ✅ Workflow advice برای تیم‌های مختلف

**نقاط ضعف:**
- ⚠️ می‌توانست Git hooks و advanced workflows بیشتری پوشش دهد
- ⚠️ بخش monorepo strategies ندارد

**مناسب برای:** Git Agent، DevOps Agent

---

### 12. `database-schema` — Data Modeling & SQL Schema ⭐⭐⭐⭐ (9.0/10)

**نقاط قوت:**
- ✅ فازهای طراحی بسیار منظم (Entities → Attributes → Relationships → Normalize → Index → Metadata)
- ✅ جدول Relationship Patterns کامل
- ✅ خروجی با SQL قابل اجرا + ORM equivalent
- ✅ قوانین عملی (index foreign keys, explicit NULLs)

**نقاط ضعف:**
- ⚠️ می‌توانست مثال‌های واقعی بیشتری داشته باشد
- ⚠️ بخش NoSQL schema design ندارد

**مناسب برای:** Database Agent، Backend Agent

---

### 13. `clean-architecture` — SOLID & DDD Design ⭐⭐⭐⭐ (8.6/10)

**نقاط قوت:**
- ✅ Dependency Rule به خوبی توضیح داده شده
- ✅ SOLID Quick Reference مفید
- ✅ 4 لایه معماری با جزئیات
- ✅ قوانین عملی (tailor to project size)

**نقاط ضعف:**
- ⚠️ بیشتر نظری است تا عملی
- ⚠️ می‌توانست مثال‌های کد بیشتری داشته باشد
- ⚠️ بخش migration from legacy ندارد

**مناسب برای:** Architecture Agent، Senior Developer Agent

---

### 14. `chain-of-thought` — Step-by-Step Reasoning ⭐⭐⭐⭐ (8.6/10)

**نقاط قوت:**
- ✅ 5 تکنیک متنوع (Zero-shot, Few-shot, Decomposition, Self-consistency, Tree of Thought)
- ✅ جدول Problem Type → Technique مفید
- ✅ When NOT to Use بسیار هوشمندانه
- ✅ Verification step با 4 check

**نقاط ضعف:**
- ⚠️ مثال‌های واقعی بیشتری می‌توانست داشته باشد
- ⚠️ بخش tool-augmented reasoning ندارد

**مناسب برای:** Reasoning Agent، Math Agent، Analysis Agent

---

### 15. `brainstorming` — Ideation & Alternative Exploration ⭐⭐⭐⭐ (8.4/10)

**نقاط قوت:**
- ✅ فاز Diverge → Converge بسیار حرفه‌ای
- ✅ 6 نوع Approach متنوع
- ✅ جدول ارزیابی 6 بعدی
- ✅ قوانین محدودکننده خوب (never fewer than 3 options)

**نقاط ضعف:**
- ⚠️ می‌توانست تکنیک‌های خلاقیت بیشتری داشته باشد (SCAMPER, Six Thinking Hats)
- ⚠️ بخش implementation feasibility مختصر است

**مناسب برای:** Strategy Agent، Product Agent، Innovation Agent

---

### 16. `api-integration` — Connect to External Services ⭐⭐⭐⭐ (8.6/10)

**نقاط قوت:**
- ✅ جدول Auth Methods بسیار کامل
- ✅ کد نمونه API Client حرفه‌ای
- ✅ بخش Resilience (retry, rate limit, timeout) عالی
- ✅ OAuth flow توضیح داده شده

**نقاط ضعف:**
- ⚠️ می‌توانست مثال‌های واقعی بیشتری از APIهای محبوب داشته باشد
- ⚠️ بخش webhook handling مختصر است

**مناسب برای:** Integration Agent، Backend Agent

---

### 17. `rag-implementation` — RAG System Implementation ⭐⭐⭐⭐ (8.6/10)

**نقاط قوت:**
- ✅ Architecture diagram واضح
- ✅ جدول Chunking Strategies بسیار مفید
- ✅ مقایسه Embedding Models با هزینه
- ✅ مقایسه Vector Databases
- ✅ Advanced Retrieval Techniques
- ✅ Evaluation metrics

**نقاط ضعف:**
- ⚠️ کد نمونه کامل ندارد (فقط ساختار پروژه)
- ⚠️ بخش production deployment مختصر است

**مناسب برای:** AI/ML Agent، Search Agent، Knowledge Agent

---

### 18. `explain-code` — Code Analysis & Explanation ⭐⭐⭐⭐ (8.6/10)

**نقاط قوت:**
- ✅ لایه‌بندی توضیحات (1-sentence → High-level → Detailed) بسیار هوشمندانه
- ✅ Mental Model ساختاریافته
- ✅ قوانین ساده و مؤثر
- ✅ Potential Questions بخش خوبی است

**نقاط ضعف:**
- ⚠️ می‌توانست مثال‌های واقعی بیشتری داشته باشد
- ⚠️ بخش visual diagrams ندارد

**مناسب برای:** Code Explanation Agent، Documentation Agent، Teaching Agent

---

### 19. `summarization` — Condense Anything Into Key Points ⭐⭐⭐⭐ (8.6/10)

**نقاط قوت:**
- ✅ 4 نوع خروجی متنوع (File, Meeting, Executive, Codebase)
- ✅ مرحله Identify Purpose بسیار مهم و خوب
- ✅ قوانین (fidelity over brevity, no invented info)
- ✅ Inverted pyramid principle

**نقاط ضعف:**
- ⚠️ می‌توانست تکنیک‌های summarization بیشتری داشته باشد
- ⚠️ بخش multi-document summarization ندارد

**مناسب برای:** Summarization Agent، Meeting Agent، Documentation Agent

---

### 20. `dockerization` — Dockerfile & Docker Compose ⭐⭐⭐⭐ (8.6/10)

**نقاط قوت:**
- ✅ اصول Dockerfile بسیار خوب (base image, multi-stage, layer caching)
- ✅ Language-specific patterns برای 5 زبان
- ✅ Troubleshooting table مفید
- ✅ خروجی کامل (Dockerfile + compose + .dockerignore)

**نقاط ضعف:**
- ⚠️ می‌توانست Docker security best practices بیشتری داشته باشد
- ⚠️ بخش Kubernetes migration ندارد

**مناسب برای:** DevOps Agent، Deployment Agent

---

### 21. `ci-cd-pipeline` — Build, Test & Deploy Automation ⭐⭐⭐⭐ (8.4/10)

**نقاط قوت:**
- ✅ پوشش GitHub Actions + GitLab CI
- ✅ جدول Language-Specific Test Commands
- ✅ بخش Debugging Existing Pipelines مفید
- ✅ Matrix builds, caching, parallel jobs

**نقاط ضعف:**
- ⚠️ مثال‌های واقعی pipeline بیشتری می‌توانست داشته باشد
- ⚠️ بخش security scanning در pipeline مختصر است
- ⚠️ بخش multi-environment deployment ندارد

**مناسب برای:** DevOps Agent، CI/CD Agent

---

### 22. `technical-writing` — Articles, Tutorials & Explainers ⭐⭐⭐⭐ (8.0/10)

**نقاط قوت:**
- ✅ 3 نوع ساختار مقاله (Tutorial, Explainer, Deep Dive)
- ✅ قوانین نویسندگی خوب (hook, one idea per paragraph)
- ✅ Example-first principle

**نقاط ضعف:**
- ⚠️ می‌توانست SEO considerations داشته باشد
- ⚠️ بخش audience adaptation مختصر است
- ⚠️ مثال‌های واقعی بیشتری می‌توانست داشته باشد

**مناسب برای:** Content Agent، Blog Agent، Education Agent

---

### 23. `browser-automation` — Playwright, Puppeteer & E2E ⭐⭐⭐⭐ (8.2/10)

**نقاط قوت:**
- ✅ مقایسه ابزارها (Playwright, Puppeteer, Cypress, Selenium)
- ✅ اصول reliable automation (semantic selectors, no sleep)
- ✅ جدول common patterns
- ✅ TypeScript by default

**نقاط ضعف:**
- ⚠️ مثال‌های واقعی بیشتری می‌توانست داشته باشد
- ⚠️ بخش visual regression testing مختصر است
- ⚠️ بخش mobile testing ندارد

**مناسب برای:** QA Agent، Testing Agent، Scraping Agent

---

### 24. `documentation` — Project & Code Documentation ⭐⭐⭐⭐ (8.4/10)

**نقاط قوت:**
- ✅ ساختار README بسیار کامل
- ✅ ساختار API Documentation حرفه‌ای
- ✅ Code Docstrings guidelines
- ✅ Accuracy/Completeness/Clarity validation

**نقاط ضعف:**
- ⚠️ می‌توانست doc generation tools بیشتری پوشش دهد
- ⚠️ بخش i18n documentation ندارد

**مناسب برای:** Documentation Agent، Open Source Agent

---

### 25. `changelog` — Release Notes from Git History ⭐⭐⭐⭐ (7.8/10)

**نقاط قوت:**
- ✅ پشتیبانی از Conventional Commits
- ✅ دسته‌بندی استاندارد (Breaking, Features, Fixes, etc.)
- ✅ Enrichment با issue links و contributor credits

**نقاط ضعف:**
- ⚠️ نسبتاً ساده‌تر از سایر اسکیل‌ها
- ⚠️ می‌توانست automated changelog tools بیشتری پوشش دهد
- ⚠️ بخش breaking change migration مختصر است

**مناسب برای:** Release Agent، DevOps Agent

---

### 26. `data-analysis` — Dataset Exploration & Statistics ⭐⭐⭐⭐ (8.0/10)

**نقاط قوت:**
- ✅ Data Profile step بسیار مهم
- ✅ جدول Chart Types مفید
- ✅ Statistical methods متنوع
- ✅ Key Findings output

**نقاط ضعف:**
- ⚠️ می‌توانست مثال‌های واقعی بیشتری داشته باشد
- ⚠️ بخش time series analysis مختصر است
- ⚠️ بخش A/B testing ندارد

**مناسب برای:** Data Analyst Agent، Analytics Agent

---

### 27. `data-cleaning` — Raw Data Preprocessing ⭐⭐⭐⭐ (8.0/10)

**نقاط قوت:**
- ✅ Data Quality Report اولیه
- ✅ جدول Missing Value Strategies بسیار کامل
- ✅ 8 فاز پاکسازی منظم
- ✅ Before/After summary

**نقاط ضعف:**
- ⚠️ می‌توانست مثال‌های واقعی بیشتری داشته باشد
- ⚠️ بخش text data cleaning مختصر است

**مناسب برای:** Data Agent، ETL Agent

---

### 28. `web-scraping` — Extract Data from Websites ⭐⭐⭐⭐ (8.0/10)

**نقاط قوت:**
- ✅ جدول approach selection مفید
- ✅ کد نمونه scraper ساختاریافته
- ✅ Rate limiting و error handling
- ✅ Anti-scraping detection

**نقاط ضعف:**
- ⚠️ می‌توانست scraping APIهای بیشتری پوشش دهد
- ⚠️ بخش JavaScript-heavy sites مختصر است
- ⚠️ بخش legal considerations ندارد

**مناسب برای:** Data Collection Agent، Scraping Agent

---

### 29. `cloud-deployment` — AWS, GCP & Azure ⭐⭐⭐⭐ (8.0/10)

**نقاط قوت:**
- ✅ جدول App Type → Cloud Service بسیار مفید
- ✅ Platform-specific notes برای 3 ارائه‌دهنده
- ✅ IaC (Terraform) structure
- ✅ Cost estimation mention

**نقاط ضعف:**
- ⚠️ مثال‌های واقعی بیشتری می‌توانست داشته باشد
- ⚠️ بخش serverless patterns مختصر است
- ⚠️ بخش monitoring و observability ندارد

**مناسب برای:** DevOps Agent، Cloud Agent، Deployment Agent

---

### 30. `browser-automation` (بررسی مجدد)

**امتیاز نهایی: 8.2/10**

**مناسب برای:** QA Agent، E2E Testing Agent

---

## دسته‌بندی پیشنهادی برای Agentها

### 🤖 Agentهای کدنویسی (Coding Agent)
| اولویت | اسکیل | امتیاز |
|---------|-------|--------|
| ۱ | `debug` | 9.6 |
| ۲ | `code-review` | 9.6 |
| ۳ | `refactor` | 9.0 |
| ۴ | `test-generation` | 9.0 |
| ۵ | `self-correction` | 9.0 |

### 🏗️ Agentهای معماری و طراحی (Architecture Agent)
| اولویت | اسکیل | امتیاز |
|---------|-------|--------|
| ۱ | `system-design` | 9.2 |
| ۲ | `api-design` | 9.2 |
| ۳ | `clean-architecture` | 8.6 |
| ۴ | `database-schema` | 9.0 |
| ۵ | `task-planning` | 8.8 |

### 🔒 Agentهای امنیتی (Security Agent)
| اولویت | اسکیل | امتیاز |
|---------|-------|--------|
| ۱ | `security-audit` | 9.2 |
| ۲ | `code-review` | 9.6 |
| ۳ | `debug` | 9.6 |

### 🚀 Agentهای DevOps و استقرار (DevOps Agent)
| اولویت | اسکیل | امتیاز |
|---------|-------|--------|
| ۱ | `dockerization` | 8.6 |
| ۲ | `ci-cd-pipeline` | 8.4 |
| ۳ | `cloud-deployment` | 8.0 |
| ۴ | `git-workflow` | 8.8 |

### 📊 Agentهای داده (Data Agent)
| اولویت | اسکیل | امتیاز |
|---------|-------|--------|
| ۱ | `rag-implementation` | 8.6 |
| ۲ | `data-analysis` | 8.0 |
| ۳ | `data-cleaning` | 8.0 |
| ۴ | `web-scraping` | 8.0 |

### 🧠 Agentهای هوش مصنوعی (AI Agent)
| اولویت | اسکیل | امتیاز |
|---------|-------|--------|
| ۱ | `prompt-engineering` | 9.0 |
| ۲ | `chain-of-thought` | 8.6 |
| ۳ | `self-correction` | 9.0 |
| ۴ | `rag-implementation` | 8.6 |

### 📝 Agentهای مستندسازی و محتوا (Documentation Agent)
| اولویت | اسکیل | امتیاز |
|---------|-------|--------|
| ۱ | `documentation` | 8.4 |
| ۲ | `technical-writing` | 8.0 |
| ۳ | `summarization` | 8.6 |
| ۴ | `changelog` | 7.8 |

---

## ⭐ Top 5 اسکیل‌های برتر (must-have برای هر agent)

1. **`debug`** (9.6) — ضروری برای هر agent که با کد سروکار دارد
2. **`code-review`** (9.6) — ضروری برای کیفیت کد
3. **`self-correction`** (9.0) — ضروری برای تمام agentها (fault tolerance)
4. **`api-design`** (9.2) — ضروری برای backend agents
5. **`system-design`** (9.2) — ضروری برای architecture agents

---

## ⚠️ اسکیل‌هایی که نیاز به بهبود دارند

| اسکیل | مشکل اصلی | پیشنهاد بهبود |
|-------|-----------|---------------|
| `changelog` | ساده و محدود | اضافه کردن automated tools و semantic versioning |
| `cloud-deployment` | مثال‌های کم | اضافه کردن مثال‌های واقعی و cost calculator |
| `web-scraping` | ملاحظات قانونی ندارد | اضافه کردن legal/ethical considerations |
| `data-cleaning` | Text cleaning مختصر | اضافه کردن NLP text cleaning patterns |
| `technical-writing` | SEO ندارد | اضافه کردن SEO و content strategy |

---

## نتیجه‌گیری

تمام 30 اسکیل در سطح **خوب تا عالی** (7.8 تا 9.6) امتیازدهی شدند. هیچ اسکیل ضعیفی وجود ندارد. بهترین اسکیل‌ها `debug` و `code-review` هستند که هر دو 9.6 امتیاز دارند و باید در تمام agentهای کدنویسی استفاده شوند.

**توصیه نهایی:** برای هر agent، حداقل 3-5 اسکیل از دسته‌بندی مرتبط انتخاب کنید. اسکیل `self-correction` باید به عنوان یک skill فرعی در تمام agentها فعال باشد.
