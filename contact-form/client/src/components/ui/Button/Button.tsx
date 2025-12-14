import type { ButtonHTMLAttributes, ReactNode } from 'react'
import styles from './Button.module.css'

interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
    loading?: boolean
    icon?: ReactNode
    children: ReactNode
}

export const Button = ({ loading, icon, children, disabled, className, ...props }: ButtonProps) => {
    return (
        <button
            className={`${styles.button} ${className || ''}`}
            disabled={disabled || loading}
            {...props}
        >
            <span className={styles.content}>
                {loading ? (
                    <>
                        <span className={styles.spinner} />
                        {children}
                    </>
                ) : (
                    <>
                        {icon && <span className={styles.icon}>{icon}</span>}
                        {children}
                    </>
                )}
            </span>
        </button>
    )
}
