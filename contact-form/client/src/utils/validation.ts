import type { ContactFormData, ContactFormErrors } from '@/types'

export const validateContactForm = (data: ContactFormData): ContactFormErrors => {
    const errors: ContactFormErrors = {}

    // Валидация имени
    if (!data.name.trim()) {
        errors.name = 'Имя обязательно для заполнения'
    } else if (data.name.trim().length < 2) {
        errors.name = 'Имя должно содержать минимум 2 символа'
    } else if (data.name.trim().length > 100) {
        errors.name = 'Имя не должно превышать 100 символов'
    }

    // Валидация email
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    if (!data.email.trim()) {
        errors.email = 'Email обязателен для заполнения'
    } else if (!emailRegex.test(data.email)) {
        errors.email = 'Некорректный формат email'
    }

    // Валидация сообщения
    if (!data.message.trim()) {
        errors.message = 'Сообщение обязательно для заполнения'
    } else if (data.message.trim().length < 10) {
        errors.message = 'Сообщение должно содержать минимум 10 символов'
    } else if (data.message.trim().length > 1000) {
        errors.message = 'Сообщение не должно превышать 1000 символов'
    }

    return errors
}

export const hasErrors = (errors: ContactFormErrors): boolean => {
    return Object.keys(errors).length > 0
}
