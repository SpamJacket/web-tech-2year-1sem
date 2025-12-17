import { WebSocketServer, WebSocket } from 'ws'
import type {
    IncomingMessage,
    OutgoingMessage,
    ContactSubmitMessage,
    WelcomeMessage,
    ErrorMessage,
    ContactSuccessResponse,
    ContactErrorResponse,
} from './types'
import { validateContactForm } from './validators/contactValidator'

const PORT = parseInt(process.env.PORT || '8080', 10)
const HOST = process.env.HOST || '0.0.0.0'

// Хранение клиентов
const clients = new Set<WebSocket>()
let messageCount = 0

// Создание WebSocket сервера
const wss = new WebSocketServer({ host: HOST, port: PORT })

// Форматирование времени
const getTimestamp = (): string => {
    return new Date().toLocaleTimeString('ru-RU', {
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit',
    })
}

// Логирование
const log = (message: string, level: 'info' | 'success' | 'warning' | 'error' = 'info'): void => {
    const timestamp = getTimestamp()
    const prefix = `[${timestamp}]`

    switch (level) {
        case 'error':
            console.error(`${prefix} ${message}`)
            break
        case 'warning':
            console.warn(`${prefix} ${message}`)
            break
        default:
            console.log(`${prefix} ${message}`)
    }
}

// Отправка сообщения клиенту
const sendMessage = (client: WebSocket, message: OutgoingMessage): void => {
    if (client.readyState === WebSocket.OPEN) {
        client.send(JSON.stringify(message))
    }
}

// Отправка приветственного сообщения
const sendWelcome = (client: WebSocket): void => {
    const welcome: WelcomeMessage = {
        type: 'welcome',
        message: 'Добро пожаловать! Сервер готов принимать данные формы.',
        timestamp: new Date().toISOString(),
    }
    sendMessage(client, welcome)
}

// Отправка ошибки
const sendError = (client: WebSocket, message: string): void => {
    const error: ErrorMessage = {
        type: 'error',
        message,
    }
    sendMessage(client, error)
}

// Обработка отправки контактной формы
const handleContactSubmit = (client: WebSocket, data: ContactSubmitMessage['data'], clientAddress: string): void => {
    const { name, email, message } = data

    log(`📝 Форма от ${clientAddress}: ${name.trim()} <${email.trim()}>`, 'info')

    const result = validateContactForm(name, email, message)

    messageCount++

    if (result.isValid) {
        log('✅ Валидация успешна', 'success')

        const response: ContactSuccessResponse = {
            type: 'contact_response',
            success: true,
            message: 'Сообщение успешно проверено и принято',
        }
        sendMessage(client, response)
    } else {
        const errorList = Object.entries(result.errors)
            .map(([field, error]) => `${field}: ${error}`)
            .join('; ')
        log(`❌ Ошибки валидации: ${errorList}`, 'warning')

        const response: ContactErrorResponse = {
            type: 'contact_response',
            success: false,
            errors: result.errors,
        }
        sendMessage(client, response)
    }
}

// Обработка входящего сообщения
const processMessage = (client: WebSocket, rawMessage: string, clientAddress: string): void => {
    log(`📨 Сообщение от ${clientAddress}`, 'info')

    let parsed: IncomingMessage

    try {
        parsed = JSON.parse(rawMessage) as IncomingMessage
    } catch {
        log(`❌ Ошибка парсинга JSON`, 'error')
        sendError(client, 'Некорректный формат JSON')
        return
    }

    const { type } = parsed

    if (type === 'contact_submit') {
        const { data } = parsed as ContactSubmitMessage
        handleContactSubmit(client, data, clientAddress)
    } else {
        sendError(client, `Неизвестный тип сообщения: ${type}`)
    }
}

// Обработка нового подключения
wss.on('connection', (client, request) => {
    const clientAddress = request.socket.remoteAddress || 'unknown'

    clients.add(client)
    log(`✅ Клиент подключен: ${clientAddress}`, 'success')
    log(`📊 Всего клиентов: ${clients.size}`, 'info')

    // Отправляем приветствие
    sendWelcome(client)

    // Обработка сообщений
    client.on('message', (data) => {
        const message = data.toString()
        processMessage(client, message, clientAddress)
    })

    // Обработка отключения
    client.on('close', () => {
        clients.delete(client)
        log(`👋 Клиент отключен: ${clientAddress}`, 'info')
        log(`📊 Всего клиентов: ${clients.size}`, 'info')
    })

    // Обработка ошибок
    client.on('error', (error) => {
        log(`❌ Ошибка клиента ${clientAddress}: ${error.message}`, 'error')
    })
})

// Обработка ошибок сервера
wss.on('error', (error) => {
    log(`❌ Ошибка сервера: ${error.message}`, 'error')
})

// Запуск сервера
log(`🚀 WebSocket сервер запущен на ws://${HOST}:${PORT}`, 'success')
log(`📧 Ожидание подключений клиентов...`, 'info')

// Graceful shutdown
process.on('SIGINT', () => {
    log('Остановка сервера...', 'info')

    // Закрываем все соединения
    clients.forEach((client) => {
        client.close()
    })

    wss.close(() => {
        log('Сервер остановлен', 'info')
        log(`📊 Всего обработано сообщений: ${messageCount}`, 'info')
        process.exit(0)
    })
})
