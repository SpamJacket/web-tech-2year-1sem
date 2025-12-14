import {
    Input,
    Textarea,
    Button,
    Alert,
    FormField,
    UserIcon,
    EmailIcon,
    MessageIcon,
    SendIcon,
    ChatIcon,
} from '@components/ui'
import { useContactForm } from '@hooks/useContactForm'
import styles from './ContactForm.module.css'

export const ContactForm = () => {
    const { formData, errors, isSubmitting, submitStatus, handleChange, handleSubmit } =
        useContactForm()

    const hasValidationErrors = Object.keys(errors).length > 0

    return (
        <div className={styles.container}>
            <div className={styles.card}>
                <header className={styles.header}>
                    <div className={styles.iconWrapper}>
                        <ChatIcon className={styles.icon} />
                    </div>
                    <h1 className={styles.title}>Свяжитесь с нами</h1>
                    <p className={styles.subtitle}>Мы будем рады ответить на ваши вопросы</p>
                </header>

                <form className={styles.form} onSubmit={handleSubmit}>
                    {submitStatus === 'success' && (
                        <Alert variant="success">Сообщение успешно отправлено!</Alert>
                    )}

                    {submitStatus === 'error' && !hasValidationErrors && (
                        <Alert variant="error">Произошла ошибка. Попробуйте ещё раз.</Alert>
                    )}

                    <FormField label="Имя" htmlFor="name" error={errors.name}>
                        <Input
                            type="text"
                            id="name"
                            name="name"
                            placeholder="Ваше имя"
                            icon={<UserIcon />}
                            error={!!errors.name}
                            value={formData.name}
                            onChange={handleChange}
                            disabled={isSubmitting}
                        />
                    </FormField>

                    <FormField label="Email" htmlFor="email" error={errors.email}>
                        <Input
                            type="email"
                            id="email"
                            name="email"
                            placeholder="your@email.com"
                            icon={<EmailIcon />}
                            error={!!errors.email}
                            value={formData.email}
                            onChange={handleChange}
                            disabled={isSubmitting}
                        />
                    </FormField>

                    <FormField label="Сообщение" htmlFor="message" error={errors.message}>
                        <Textarea
                            id="message"
                            name="message"
                            placeholder="Напишите ваше сообщение..."
                            icon={<MessageIcon />}
                            error={!!errors.message}
                            value={formData.message}
                            onChange={handleChange}
                            disabled={isSubmitting}
                        />
                    </FormField>

                    <Button type="submit" loading={isSubmitting} icon={<SendIcon />}>
                        {isSubmitting ? 'Отправка...' : 'Отправить сообщение'}
                    </Button>
                </form>
            </div>
        </div>
    )
}
