# Cat Tinder

Мини-приложение на Flutter, которое берет случайных котиков и список пород из [TheCatAPI](https://thecatapi.com). Пастельная тема с яркими акцентами, свайпы, табы и детальные карточки.

## Реализованные фичи
- Главный экран показывает случайного котика с породой и кратким описанием.
- Свайпы влево/вправо или кнопки дизлайк/лайк меняют котика; свайп/лайк вправо увеличивает счетчик.
- Тап по карточке открывает экран деталей с фото, описанием и 3–4 характеристиками породы.
- Таб-бар переключает на экран «Список пород» с краткой карточкой; по тапу открывается детальный просмотр породы.
- Диалог с сообщением об ошибке при сетевых сбоях и кнопкой «Повторить».
- Кастомная иконка приложения + кэширование картинок через `CachedNetworkImage`.

## API
- Случайное изображение котика: `GET https://api.thecatapi.com/v1/images/search?limit=1&has_breeds=1`
- Список пород: `GET https://api.thecatapi.com/v1/breeds`
- Можно передать ключ `x-api-key` через параметр запуска: `--dart-define=THE_CAT_API_KEY=<your_key>`

## Скриншоты
![Главный экран](assets/readme/home.png)
![Детали котика](assets/readme/detail.png)
![Список пород](assets/readme/breeds.png)

## APK
- [Скачать актуальный APK](build/app/outputs/flutter-apk/app-release.apk) (создается командой `flutter build apk --release`).

## Запуск и разработка
1) Установить зависимости: `flutter pub get`
2) (Опционально) Пересобрать иконки после правок: `flutter pub run flutter_launcher_icons`
3) Запуск: `flutter run --dart-define=THE_CAT_API_KEY=<ключ>` (ключ не обязателен)
4) Форматирование: `dart format lib test`
5) Статический анализ: `flutter analyze`

## Стек
- Flutter 3, Material 3, кастомная тема
- `http` для запросов к TheCatAPI
- `cached_network_image` для загрузки и кэширования картинок
- `flutter_lints` и `analysis_options.yaml` для статического анализа
