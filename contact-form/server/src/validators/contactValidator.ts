import type { ValidationErrors } from '../types'

const MIN_NAME_LENGTH = 2
const MAX_NAME_LENGTH = 100
const MIN_MESSAGE_LENGTH = 10
const MAX_MESSAGE_LENGTH = 1000

const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/

export interface ValidationResult {
    isValid: boolean
    errors: ValidationErrors
}

const validateName = (name: string): string | undefined => {
    const trimmed = name.trim()

    if (!trimmed) {
        return 'Имя обязательно для заполнения'
    }

    if (trimmed.length < MIN_NAME_LENGTH) {
        return 'Имя должно содержать минимум 2 символа'
    }

    if (trimmed.length > MAX_NAME_LENGTH) {
        return 'Имя не должно превышать 100 символов'
    }

    return undefined
}

const validateEmail = (email: string): string | undefined => {
    const trimmed = email.trim()

    if (!trimmed) {
        return 'Email обязателен для заполнения'
    }

    if (!EMAIL_REGEX.test(trimmed)) {
        return 'Некорректный формат email'
    }

    return undefined
}

const validateMessage = (message: string): string | undefined => {
    const trimmed = message.trim()

    if (!trimmed) {
        return 'Сообщение обязательно для заполнения'
    }

    if (trimmed.length < MIN_MESSAGE_LENGTH) {
        return 'Сообщение должно содержать минимум 10 символов'
    }

    if (trimmed.length > MAX_MESSAGE_LENGTH) {
        return 'Сообщение не должно превышать 1000 символов'
    }

    return undefined
}

export const validateContactForm = (
    name: string,
    email: string,
    message: string
): ValidationResult => {
    const errors: ValidationErrors = {}

    const nameError = validateName(name)
    const emailError = validateEmail(email)
    const messageError = validateMessage(message)

    if (nameError) errors.name = nameError
    if (emailError) errors.email = emailError
    if (messageError) errors.message = messageError

    return {
        isValid: Object.keys(errors).length === 0,
        errors,
    }
}
