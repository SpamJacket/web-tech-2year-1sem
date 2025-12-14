import { useState, type ChangeEvent, type FormEvent } from 'react'
import type { ContactFormData, ContactFormErrors } from '@/types'
import { validateContactForm, hasErrors } from '@/utils'
import { submitContactForm } from '@/api'

type SubmitStatus = 'idle' | 'success' | 'error'

const initialFormData: ContactFormData = {
    name: '',
    email: '',
    message: '',
}

export const useContactForm = () => {
    const [formData, setFormData] = useState<ContactFormData>(initialFormData)
    const [errors, setErrors] = useState<ContactFormErrors>({})
    const [isSubmitting, setIsSubmitting] = useState(false)
    const [submitStatus, setSubmitStatus] = useState<SubmitStatus>('idle')

    const handleChange = (e: ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
        const { name, value } = e.target
        setFormData((prev) => ({ ...prev, [name]: value }))

        // Очищаем ошибку поля при изменении
        if (errors[name as keyof ContactFormErrors]) {
            setErrors((prev) => ({ ...prev, [name]: undefined }))
        }

        // Сбрасываем статус при изменении
        if (submitStatus !== 'idle') {
            setSubmitStatus('idle')
        }
    }

    const handleSubmit = async (e: FormEvent<HTMLFormElement>) => {
        e.preventDefault()

        const validationErrors = validateContactForm(formData)

        if (hasErrors(validationErrors)) {
            setErrors(validationErrors)
            return
        }

        setErrors({})
        setIsSubmitting(true)
        setSubmitStatus('idle')

        try {
            const response = await submitContactForm(formData)

            if (response.success) {
                setSubmitStatus('success')
                setFormData(initialFormData)
            } else {
                setSubmitStatus('error')
                if (response.errors) {
                    setErrors(response.errors)
                }
            }
        } catch {
            setSubmitStatus('error')
        } finally {
            setIsSubmitting(false)
        }
    }

    const resetForm = () => {
        setFormData(initialFormData)
        setErrors({})
        setSubmitStatus('idle')
    }

    return {
        formData,
        errors,
        isSubmitting,
        submitStatus,
        handleChange,
        handleSubmit,
        resetForm,
    }
}
