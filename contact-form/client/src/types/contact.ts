export interface ContactFormData {
    name: string
    email: string
    message: string
}

export interface ContactFormErrors {
    name?: string
    email?: string
    message?: string
}

export interface ContactApiResponse {
    success: boolean
    message?: string
    errors?: ContactFormErrors
}
