export interface ContactFormData {
    name: string
    email: string
    message: string
}

export interface ValidationErrors {
    name?: string
    email?: string
    message?: string
}

export interface SuccessResponse {
    success: true
    message: string
}

export interface ErrorResponse {
    success: false
    errors: ValidationErrors
}

export type ContactResponse = SuccessResponse | ErrorResponse
