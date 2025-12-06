# Cat Tinder

Мини-приложение на Flutter, которое берет случайных котиков и список пород из [TheCatAPI](https://thecatapi.com).

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
<img width="744" height="831" alt="Снимок экрана 2025-12-06 в 15 18 54" src="https://github.com/user-attachments/assets/69a7d8d2-9d55-4448-b891-bc5b54a08e9d" />
<img width="742" height="509" alt="Снимок экрана 2025-12-06 в 15 17 53" src="https://github.com/user-attachments/assets/a13b099e-0ae7-4324-ac6b-c81cc88fee2f" />
<img width="747" height="831" alt="Снимок экрана 2025-12-06 в 15 18 26" src="https://github.com/user-attachments/assets/bacc7304-469a-4f45-9e5d-3696ac533eea" />
<img width="731" height="742" alt="Снимок экрана 2025-12-06 в 15 18 13" src="https://github.com/user-attachments/assets/b20a89a5-2d6b-4583-8d26-8df36771bb48" />


## APK
APK файл находится в `build/app/outputs/flutter-apk/app-release.apk` после сборки.

Собрать APK:
```bash
flutter build apk --release
```

После сборки APK можно установить на устройство:
```bash
flutter install
```

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
