# Work Business — NFC → App Clip + PWA

Минимальный proof-of-concept проекта: NFC-метка → красивая карточка товара → переход на полный сайт.

## Состав

- `ios/` — SwiftUI iOS приложение + App Clip target
- `web/` — веб-часть (Next.js, добавим позже)
- `.github/workflows/ios-build.yml` — автосборка iOS на GitHub Actions macOS runner

## iOS — что внутри

- **ProductApp** — основное iOS приложение (заглушка с экраном «Каталог товаров»). Нужно потому что App Clip формально должен быть прикреплён к parent app.
- **ProductAppClip** — App Clip target. Открывается мгновенно с NFC-метки, показывает карточку товара и ведёт на полный сайт.

Bundle ID: `com.example.productapp` (изменить под свой домен при регистрации в Apple Dev).

Стек:
- Swift 5.10 / SwiftUI
- iOS 16.0+ deployment target
- XcodeGen для генерации `.xcodeproj` из `project.yml`

## Как запустить сборку (GitHub Actions)

### Один раз — создать GitHub репозиторий

1. Зарегистрируйся / залогинься на github.com
2. Создай новый репо: `New repository` → имя `work-business` → **Public** (чтобы macOS runner был бесплатным) → создать
3. Локально:

```bash
cd /root/projects/venv3/агенты/работа_для_бизнеса/code
git init
git branch -M main
git add .
git commit -m "Initial commit: iOS App Clip + GitHub Actions"
git remote add origin https://github.com/<твой-логин>/work-business.git
git push -u origin main
```

### Каждый раз — пуш правок

```bash
git add .
git commit -m "Описание изменений"
git push
```

После push:
1. Зайди в репозиторий на GitHub → вкладка **Actions**
2. Найди свежий запуск **iOS Build (App + App Clip)**
3. Жди ~3-5 минут — macOS runner соберёт проект
4. После завершения — раздел **Artifacts** внизу страницы run → скачать `ios-build-N.zip`
5. Внутри будет `.app` бандл — это собранное приложение

### Что показывает первая сборка

Сейчас workflow собирает приложение **под симулятор без подписи** (`CODE_SIGNING_ALLOWED=NO`). Это проверка что код компилируется. На реальный iPhone эту сборку поставить нельзя — нужна подпись Apple Developer сертификатом.

## Следующий этап — подпись и TestFlight

Когда первая сборка пройдёт зелёная:

1. Зарегистрироваться в Apple Developer Program ($99/год)
2. Создать App ID в developer.apple.com
3. Создать API ключ в App Store Connect (Team key, App Manager role)
4. Добавить ключ в GitHub Secrets репозитория:
   - `APP_STORE_CONNECT_API_KEY` (содержимое .p8 файла)
   - `APP_STORE_CONNECT_KEY_ID`
   - `APP_STORE_CONNECT_ISSUER_ID`
5. Обновить `ios-build.yml` — добавить шаги подписи и заливки в TestFlight через `fastlane match` или `xcodebuild archive` + `xcrun altool`
6. Создать запись приложения в App Store Connect
7. Push → автоматическая заливка в TestFlight → беру iPhone, открываю TestFlight app → ставлю билд

## Локальная разработка

Swift 6.1.2 установлен на этой машине в `/opt/swift`. Подсветка и автокомплит SwiftUI кода работают через VS Code Swift extension.

**Что компилируется локально:** чистая бизнес-логика (модели, парсинг JSON, сетевые запросы) через `swift test`.
**Что не компилируется локально:** iOS-specific код (SwiftUI views, UIKit). Для этого — GitHub Actions.

## Известные ограничения

- На Ubuntu 20.04 невозможно собрать iOS локально через `xtool` (требует GLIBC 2.34+ и OpenSSL 3.0+, у нас 2.31 и 1.1). Поэтому идём через GitHub Actions.
- `.xcodeproj` намеренно не коммитим — генерируется через XcodeGen из `project.yml` в каждой сборке.
- App Clip Experience (привязка URL к App Clip) настраивается в App Store Connect **после** публикации, не в коде.
