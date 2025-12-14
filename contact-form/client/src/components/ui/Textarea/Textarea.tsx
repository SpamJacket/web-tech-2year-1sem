import type { TextareaHTMLAttributes, ReactNode } from 'react'
import styles from './Textarea.module.css'

interface TextareaProps extends TextareaHTMLAttributes<HTMLTextAreaElement> {
    icon?: ReactNode
    error?: boolean
}

export const Textarea = ({ icon, error, className, ...props }: TextareaProps) => {
    return (
        <div className={styles.wrapper}>
            {icon && <span className={styles.icon}>{icon}</span>}
            <textarea
                className={`${styles.textarea} ${error ? styles.error : ''} ${className || ''}`}
                {...props}
            />
        </div>
    )
}
