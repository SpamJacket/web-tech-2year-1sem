import { body } from 'express-validator'

export const contactValidationRules = [
    body('name')
        .trim()
        .notEmpty()
        .withMessage('Имя обязательно для заполнения')
        .isLength({ min: 2 })
        .withMessage('Имя должно содержать минимум 2 символа')
        .isLength({ max: 100 })
        .withMessage('Имя не должно превышать 100 символов'),

    body('email')
        .trim()
        .notEmpty()
        .withMessage('Email обязателен для заполнения')
        .isEmail()
        .withMessage('Некорректный формат email')
        .normalizeEmail(),

    body('message')
        .trim()
        .notEmpty()
        .withMessage('Сообщение обязательно для заполнения')
        .isLength({ min: 10 })
        .withMessage('Сообщение должно содержать минимум 10 символов')
        .isLength({ max: 1000 })
        .withMessage('Сообщение не должно превышать 1000 символов'),
]
