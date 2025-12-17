# 📧 Contact Form Service

Веб-сервис контактной формы обратной связи. Одностраничное приложение для отправки сообщений администратору ресурса.

## 👤 Автор

spamjacket

## 📋 Описание

Проект представляет собой полноценный веб-сервис с клиентской и серверной частью:

- **Frontend** — React SPA с современным адаптивным дизайном
- **Backend** — WebSocket сервер на ws с валидацией данных

После заполнения формы данные отправляются на сервер через WebSocket, где проходят валидацию. Сервер возвращает подтверждение успешной проверки или список ошибок.

## 🛠 Технологии

### Frontend
- **React 19** — UI библиотека
- **TypeScript** — типизация
- **Vite** — сборщик
- **CSS Modules** — стилизация компонентов
- **ESLint + Prettier** — линтинг и форматирование

### Backend
- **Node.js** — среда выполнения
- **ws** — WebSocket сервер
- **TypeScript** — типизация

## 📁 Структура проекта

```
contact-form/
├── client/                     # Frontend (React + TypeScript)
│   ├── src/
│   │   ├── api/                # API функции
│   │   ├── components/         # React компоненты
│   │   │   ├── ContactForm/    # Компонент формы
│   │   │   └── ui/             # UI компоненты
│   │   │       ├── Alert/
│   │   │       ├── Button/
│   │   │       ├── FormField/
│   │   │       ├── Icons/
│   │   │       ├── Input/
│   │   │       └── Textarea/
│   │   ├── hooks/              # Кастомные хуки
│   │   ├── types/              # TypeScript типы
│   │   └── utils/              # Утилиты (валидация)
│   ├── package.json
│   ├── tsconfig.json
│   └── vite.config.ts
│
├── server/                     # Backend (WebSocket + TypeScript)
│   ├── src/
│   │   ├── validators/         # Правила валидации
│   │   ├── types/              # TypeScript типы
│   │   └── index.ts            # Точка входа
│   ├── package.json
│   └── tsconfig.json
│
└── README.md
```

## 🚀 Запуск проекта

### Требования
- Node.js 18+
- npm 9+

### Установка зависимостей

```bash
# Frontend
cd client
npm install

# Backend
cd ../server
npm install
```

### Запуск в режиме разработки

```bash
# Терминал 1 — Backend (WebSocket порт 8080)
cd server
npm run dev

# Терминал 2 — Frontend (порт 5173)
cd client
npm run dev
```

### Доступ к приложению

- **Frontend:** http://localhost:5173
- **WebSocket Server:** ws://localhost:8080

## 📡 WebSocket Protocol

### Подключение

При подключении клиент получает приветственное сообщение:

```json
{
  "type": "welcome",
  "message": "Добро пожаловать! Сервер готов принимать данные формы.",
  "timestamp": "2024-12-14T12:00:00.000Z"
}
```

### Отправка контактной формы

**Request:**
```json
{
  "type": "contact_submit",
  "data": {
    "name": "Иван Иванов",
    "email": "ivan@example.com",
    "message": "Здравствуйте! У меня есть вопрос..."
  }
}
```

**Success Response:**
```json
{
  "type": "contact_response",
  "success": true,
  "message": "Сообщение успешно проверено и принято"
}
```

**Validation Error:**
```json
{
  "type": "contact_response",
  "success": false,
  "errors": {
    "name": "Имя должно содержать минимум 2 символа",
    "email": "Некорректный формат email",
    "message": "Сообщение должно содержать минимум 10 символов"
  }
}
```

**General Error:**
```json
{
  "type": "error",
  "message": "Некорректный формат JSON"
}
```

## ✅ Валидация

| Поле | Правила |
|------|---------|
| **Имя** | Обязательно, 2-100 символов |
| **Email** | Обязательно, валидный формат |
| **Сообщение** | Обязательно, 10-1000 символов |

Валидация выполняется как на клиенте, так и на сервере.

## 📱 Адаптивность

Приложение адаптировано под различные устройства:

| Устройство | Ширина экрана |
|------------|---------------|
| Mobile | от 360px |
| Tablet | от 768px |
| Laptop | от 1024px |
| Desktop | от 1366px |

## 🔧 Скрипты

### Frontend (client/)

| Команда | Описание |
|---------|----------|
| `npm run dev` | Запуск dev-сервера |
| `npm run build` | Сборка для production |
| `npm run preview` | Превью production сборки |
| `npm run lint` | Проверка ESLint |
| `npm run lint:fix` | Автоисправление ESLint |
| `npm run format` | Форматирование Prettier |
| `npm run type-check` | Проверка типов |

### Backend (server/)

| Команда | Описание |
|---------|----------|
| `npm run dev` | Запуск с hot-reload |
| `npm run build` | Компиляция TypeScript |
| `npm start` | Запуск production |
| `npm run lint` | Проверка ESLint |
| `npm run format` | Форматирование Prettier |

## 🔗 Совместимость

Сервер совместим с клиентом Aurora OS (`contact-form-aurora`). Оба используют одинаковый WebSocket протокол.
