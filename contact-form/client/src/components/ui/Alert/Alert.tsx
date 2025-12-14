import type { ReactNode } from 'react'
import styles from './Alert.module.css'
import { ErrorIcon, SuccessIcon } from '../Icons/Icons'

interface AlertProps {
    variant: 'success' | 'error'
    children: ReactNode
}

export const Alert = ({ variant, children }: AlertProps) => {
    return (
        <div className={`${styles.alert} ${styles[variant]}`}>
            <span className={styles.icon}>
                {variant === 'success' ? <SuccessIcon /> : <ErrorIcon />}
            </span>
            {children}
        </div>
    )
}
