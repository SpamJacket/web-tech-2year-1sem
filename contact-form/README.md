# 📧 Contact Form Service

Веб-сервис контактной формы обратной связи. Одностраничное приложение для отправки сообщений администратору ресурса.

## 👤 Автор

spamjacket

## 📋 Описание

Проект представляет собой полноценный веб-сервис с клиентской и серверной частью:

- **Frontend** — React SPA с современным адаптивным дизайном
- **Backend** — REST API на Express.js с валидацией данных

После заполнения формы данные отправляются на сервер, где проходят валидацию. Сервер возвращает подтверждение успешной проверки или список ошибок.

## 🛠 Технологии

### Frontend
- **React 19** — UI библиотека
- **TypeScript** — типизация
- **Vite** — сборщик
- **CSS Modules** — стилизация компонентов
- **ESLint + Prettier** — линтинг и форматирование

### Backend
- **Node.js** — среда выполнения
- **Express.js 5** — веб-фреймворк
- **express-validator** — валидация данных
- **TypeScript** — типизация

## 📁 Структура проекта

```
web-tech-2year-1sem/
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
├── server/                     # Backend (Express + TypeScript)
│   ├── src/
│   │   ├── routes/             # Маршруты API
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
# Терминал 1 — Backend (порт 3000)
cd server
npm run dev

# Терминал 2 — Frontend (порт 5173)
cd client
npm run dev
```

### Доступ к приложению

- **Frontend:** http://localhost:5173
- **API:** http://localhost:3000/api

## 📡 API Endpoints

### POST /api/contact

Отправка контактной формы.

**Request:**
```json
{
  "name": "Иван Иванов",
  "email": "ivan@example.com",
  "message": "Здравствуйте! У меня есть вопрос..."
}
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Сообщение успешно проверено и принято"
}
```

**Validation Error (400):**
```json
{
  "success": false,
  "errors": {
    "name": "Имя должно содержать минимум 2 символа",
    "email": "Некорректный формат email",
    "message": "Сообщение должно содержать минимум 10 символов"
  }
}
```

### GET /api/health

Проверка состояния сервера.

**Response:**
```json
{
  "status": "ok",
  "timestamp": "2024-12-14T12:00:00.000Z"
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
