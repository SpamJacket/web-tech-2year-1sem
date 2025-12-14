import type { InputHTMLAttributes, ReactNode } from 'react'
import styles from './Input.module.css'

interface InputProps extends InputHTMLAttributes<HTMLInputElement> {
    icon?: ReactNode
    error?: boolean
}

export const Input = ({ icon, error, className, ...props }: InputProps) => {
    return (
        <div className={styles.wrapper}>
            {icon && <span className={styles.icon}>{icon}</span>}
            <input
                className={`${styles.input} ${error ? styles.error : ''} ${className || ''}`}
                {...props}
            />
        </div>
    )
}
