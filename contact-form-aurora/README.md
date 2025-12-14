# Contact Form Aurora

Приложение контактной формы для ОС Аврора с WebSocket-взаимодействием. Оба компонента (сервер и клиент) реализованы на Qt/C++ с графическим интерфейсом.

## 👤 Автор

spamjacket

## Структура проекта

```
contact-form-aurora/
├── server/                                    # Qt WebSocket сервер с Admin Panel (для ПК)
│   ├── contact-form-server.pro                # Файл проекта Qt
│   ├── ru.aurora.contactform.server.desktop   # Файл описания приложения
│   ├── src/
│   │   ├── main.cpp                           # Точка входа с Qt Quick
│   │   ├── contactserver.h                    # WebSocket сервер (заголовок)
│   │   ├── contactserver.cpp                  # WebSocket сервер (реализация)
│   │   ├── contactvalidator.h                 # Валидатор формы (заголовок)
│   │   └── contactvalidator.cpp               # Валидатор формы (реализация)
│   ├── qml/                                   # QML интерфейс админ-панели
│   │   ├── ru.aurora.contactform.server.qml   # Главный QML файл
│   │   └── pages/
│   │       └── AdminPage.qml                  # Страница администрирования
│   ├── rpm/
│   │   ├── ru.aurora.contactform.server.spec
│   │   └── ru.aurora.contactform.server.yaml
│   └── icons/                                 # Иконки приложения
│       ├── ru.aurora.contactform.server.svg
│       ├── generate-icons.sh
│       └── */ru.aurora.contactform.server.png
│
├── client/                                    # Qt/QML клиент для Aurora OS
│   ├── contact-form-aurora.pro                # Файл проекта Sailfish/Aurora
│   ├── ru.aurora.contactform.desktop          # Файл описания приложения
│   ├── src/
│   │   ├── main.cpp
│   │   ├── websocketclient.h
│   │   └── websocketclient.cpp
│   ├── qml/
│   │   ├── qml.qrc                            # Файл ресурсов
│   │   ├── ru.aurora.contactform.qml          # Главный QML файл
│   │   ├── pages/
│   │   │   └── ContactPage.qml
│   │   └── components/
│   │       ├── InputField.qml
│   │       ├── TextAreaField.qml
│   │       ├── SubmitButton.qml
│   │       └── Alert.qml
│   ├── rpm/
│   │   ├── ru.aurora.contactform.spec
│   │   └── ru.aurora.contactform.yaml
│   └── icons/                                 # Иконки приложения
│       ├── ru.aurora.contactform.svg
│       ├── generate-icons.sh
│       └── */ru.aurora.contactform.png
│
└── README.md
```

## 🚀 Запуск проекта

### Требования

#### Сервер (ПК)
- Qt 5.12+ (или Qt 6.x)
- Qt WebSockets модуль
- Qt Quick модуль
- C++17 компилятор

#### Клиент (Aurora OS)
- Aurora SDK (или Sailfish SDK)
- Qt 5.6+
- Qt WebSockets модуль
- Sailfish Silica

### Настройка локальной сети

#### Требования
- ПК и мобильное устройство должны быть в одной локальной сети (Wi-Fi)
- Firewall на ПК должен разрешать входящие TCP-подключения на порт 8080

#### Linux (ufw)
```bash
sudo ufw allow 8080/tcp
```

#### Linux (firewalld)
```bash
sudo firewall-cmd --add-port=8080/tcp --permanent
sudo firewall-cmd --reload
```

#### macOS
Обычно не требует дополнительной настройки для локальной сети.
При необходимости разрешите входящие подключения в System Preferences → Security & Privacy → Firewall.

#### Windows
```powershell
netsh advfirewall firewall add rule name="Contact Form Server" dir=in action=allow protocol=TCP localport=8080
```

### 1. Сервер с GUI (на ПК)

#### Сборка с qmake
```bash
cd contact-form-aurora/server
mkdir build && cd build
qmake ..
make
```

#### Сборка с Qt Creator
1. Откройте `server/contact-form-server.pro` в Qt Creator
2. Выберите Desktop Kit
3. Соберите проект (Build → Build Project)

#### Запуск
```bash
./ru.aurora.contactform.server
```

Откроется окно Admin Panel с графическим интерфейсом.

#### Функции Admin Panel

| Раздел | Описание |
|--------|----------|
| **Заголовок** | Статус сервера, количество клиентов и сообщений |
| **Управление сервером** | Настройка адреса/порта, запуск/остановка сервера |
| **Подключенные клиенты** | Список активных подключений с IP-адресами |
| **Полученные сообщения** | Все сообщения с деталями валидации |
| **Журнал событий** | История действий и ошибок |

### 2. Клиент (Aurora OS)

#### Сборка с Aurora SDK

1. Откройте Aurora SDK IDE
2. Откройте проект `client/contact-form-aurora.pro`
3. Выберите целевую платформу (Aurora armv7hl или i486)
4. Соберите проект (Build → Build Project)
5. Создайте RPM пакет (Build → Deploy)

#### Сборка из командной строки

```bash
cd contact-form-aurora/client

# Для эмулятора (i486)
sb2 -t AuroraOS-4.0.2.xxx-i486 qmake
sb2 -t AuroraOS-4.0.2.xxx-i486 make

# Для устройства (armv7hl)
sb2 -t AuroraOS-4.0.2.xxx-armv7hl qmake
sb2 -t AuroraOS-4.0.2.xxx-armv7hl make
```

#### Установка на устройство

```bash
# Копирование RPM на устройство
scp RPMS/ru.aurora.contactform-1.0.0-1.armv7hl.rpm nemo@<device-ip>:~/

# На устройстве
devel-su pkcon install-local ru.aurora.contactform-1.0.0-1.armv7hl.rpm
```

## Использование

### Шаг 1: Запуск сервера на ПК

```bash
cd server/build
./ru.aurora.contactform.server
```

1. В открывшейся Admin Panel укажите адрес и порт
2. Нажмите "▶ Запустить сервер"
3. В панели отобразятся доступные IP-адреса для подключения

### Шаг 2: Настройка клиента на Aurora устройстве

1. Запустите приложение "Contact Form" (Контактная форма)
2. В поле "Адрес сервера" введите адрес вашего сервера:
   - Например: `ws://192.168.1.100:8080`
3. Нажмите кнопку "Подключиться"
4. Дождитесь успешного подключения (индикатор станет зелёным)

### Шаг 3: Отправка формы

1. Заполните поля формы:
   - **Имя** — минимум 2 символа
   - **Email** — корректный email адрес
   - **Сообщение** — минимум 10 символов
2. Нажмите кнопку "Отправить"
3. Дождитесь ответа от сервера:
   - ✅ Зелёное уведомление — форма принята
   - ❌ Красные подсказки под полями — ошибки валидации

### Шаг 4: Мониторинг в Admin Panel

1. В панели "Подключенные клиенты" появится IP устройства
2. В панели "Полученные сообщения" отобразятся данные формы
3. В "Журнале событий" можно отслеживать все действия

## Протокол WebSocket

### Приветственное сообщение (сервер → клиент)
```json
{
  "type": "welcome",
  "message": "Добро пожаловать! Сервер готов принимать данные формы.",
  "timestamp": "2024-01-15T12:00:00Z"
}
```

### Отправка формы (клиент → сервер)
```json
{
  "type": "contact_submit",
  "data": {
    "name": "Иван Иванов",
    "email": "ivan@example.com",
    "message": "Текст сообщения для администратора..."
  }
}
```

### Успешный ответ (сервер → клиент)
```json
{
  "type": "contact_response",
  "success": true,
  "message": "Сообщение успешно проверено и принято"
}
```

### Ответ с ошибками валидации (сервер → клиент)
```json
{
  "type": "contact_response",
  "success": false,
  "errors": {
    "name": "Имя должно содержать минимум 2 символа",
    "email": "Некорректный формат email",
    "message": "Сообщение обязательно для заполнения"
  }
}
```

### Ошибка (сервер → клиент)
```json
{
  "type": "error",
  "message": "Некорректный формат JSON"
}
```

## Правила валидации

| Поле | Правило | Сообщение об ошибке |
|------|---------|---------------------|
| Имя | Обязательное | Имя обязательно для заполнения |
| Имя | Минимум 2 символа | Имя должно содержать минимум 2 символа |
| Имя | Максимум 100 символов | Имя не должно превышать 100 символов |
| Email | Обязательное | Email обязателен для заполнения |
| Email | Корректный формат | Некорректный формат email |
| Сообщение | Обязательное | Сообщение обязательно для заполнения |
| Сообщение | Минимум 10 символов | Сообщение должно содержать минимум 10 символов |
| Сообщение | Максимум 1000 символов | Сообщение не должно превышать 1000 символов |

## Устранение неполадок

### Нет подключения к серверу
1. Убедитесь, что устройство и ПК находятся в одной Wi-Fi сети
2. Проверьте правильность IP-адреса сервера
3. Убедитесь, что сервер запущен (зелёный статус в Admin Panel)
4. Проверьте настройки firewall на ПК

### Connection refused
- Сервер не запущен или использует другой порт
- Firewall блокирует подключения

### Timeout при подключении
- Неправильный IP-адрес
- Устройство в другой сети
- Проблемы с Wi-Fi соединением

### Ошибки валидации
- Проверьте требования к полям (см. таблицу валидации выше)
- Убедитесь, что все поля заполнены
