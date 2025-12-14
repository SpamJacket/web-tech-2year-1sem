import type { ContactFormData, ContactApiResponse } from '@/types'

const API_URL = '/api/contact'

export const submitContactForm = async (data: ContactFormData): Promise<ContactApiResponse> => {
    const response = await fetch(API_URL, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(data),
    })

    return response.json()
}
