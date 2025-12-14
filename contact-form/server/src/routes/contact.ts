import { Router, type Request, type Response } from 'express'
import { validationResult } from 'express-validator'
import type { ContactFormData, ContactResponse, ValidationErrors } from '../types'
import { contactValidationRules } from '../validators/contactValidator'

const router = Router()

router.post(
    '/',
    contactValidationRules,
    (req: Request<object, ContactResponse, ContactFormData>, res: Response<ContactResponse>) => {
        const errors = validationResult(req)

        if (!errors.isEmpty()) {
            // Преобразуем ошибки в удобный формат
            const validationErrors: ValidationErrors = {}

            errors.array().forEach((error) => {
                if (error.type === 'field') {
                    const field = error.path as keyof ValidationErrors
                    // Берём только первую ошибку для каждого поля
                    if (!validationErrors[field]) {
                        validationErrors[field] = error.msg
                    }
                }
            })

            res.status(400).json({
                success: false,
                errors: validationErrors,
            })
            return
        }

        // Данные валидны
        const { name, email, message } = req.body

        console.log('Получено сообщение:')
        console.log(`  Имя: ${name}`)
        console.log(`  Email: ${email}`)
        console.log(`  Сообщение: ${message}`)

        res.status(200).json({
            success: true,
            message: 'Сообщение успешно проверено и принято',
        })
    }
)

export default router
