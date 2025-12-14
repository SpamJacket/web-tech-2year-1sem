import express from 'express'
import contactRouter from './routes/contact'

const app = express()
const PORT = process.env.PORT || 3000

// Middleware для парсинга JSON
app.use(express.json())

// Middleware для парсинга URL-encoded данных
app.use(express.urlencoded({ extended: true }))

// Роуты
app.use('/api/contact', contactRouter)

// Health check endpoint
app.get('/api/health', (_req, res) => {
    res.json({ status: 'ok', timestamp: new Date().toISOString() })
})

// Обработка несуществующих роутов
app.use((_req, res) => {
    res.status(404).json({ error: 'Маршрут не найден' })
})

// Запуск сервера
app.listen(PORT, () => {
    console.log(`🚀 Сервер запущен на http://localhost:${PORT}`)
    console.log(`📧 API контактной формы: POST http://localhost:${PORT}/api/contact`)
})
