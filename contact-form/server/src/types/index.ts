// Данные контактной формы
export interface ContactFormData {
    name: string
    email: string
    message: string
}

// Ошибки валидации
export interface ValidationErrors {
    name?: string
    email?: string
    message?: string
}

// WebSocket сообщения

// Входящее сообщение: отправка контактной формы
export interface ContactSubmitMessage {
    type: 'contact_submit'
    data: ContactFormData
}

// Тип входящих сообщений
export type IncomingMessage = ContactSubmitMessage

// Ответ при успешной валидации
export interface ContactSuccessResponse {
    type: 'contact_response'
    success: true
    message: string
}

// Ответ при ошибках валидации
export interface ContactErrorResponse {
    type: 'contact_response'
    success: false
    errors: ValidationErrors
}

// Приветственное сообщение
export interface WelcomeMessage {
    type: 'welcome'
    message: string
    timestamp: string
}

// Общая ошибка
export interface ErrorMessage {
    type: 'error'
    message: string
}

// Тип исходящих сообщений
export type OutgoingMessage =
    | ContactSuccessResponse
    | ContactErrorResponse
    | WelcomeMessage
    | ErrorMessage
