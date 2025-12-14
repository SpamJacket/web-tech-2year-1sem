#include "contactvalidator.h"

ContactValidator::ContactValidator()
    : m_emailRegex(QStringLiteral("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$"))
{
}

ValidationResult ContactValidator::validate(const QString &name, 
                                           const QString &email, 
                                           const QString &message) const
{
    ValidationResult result;
    result.nameError = validateName(name);
    result.emailError = validateEmail(email);
    result.messageError = validateMessage(message);
    return result;
}

QString ContactValidator::validateName(const QString &name) const
{
    QString trimmed = name.trimmed();
    
    if (trimmed.isEmpty()) {
        return QStringLiteral("Имя обязательно для заполнения");
    }
    
    if (trimmed.length() < MIN_NAME_LENGTH) {
        return QStringLiteral("Имя должно содержать минимум 2 символа");
    }
    
    if (trimmed.length() > MAX_NAME_LENGTH) {
        return QStringLiteral("Имя не должно превышать 100 символов");
    }
    
    return QString();
}

QString ContactValidator::validateEmail(const QString &email) const
{
    QString trimmed = email.trimmed();
    
    if (trimmed.isEmpty()) {
        return QStringLiteral("Email обязателен для заполнения");
    }
    
    QRegularExpressionMatch match = m_emailRegex.match(trimmed);
    if (!match.hasMatch()) {
        return QStringLiteral("Некорректный формат email");
    }
    
    return QString();
}

QString ContactValidator::validateMessage(const QString &message) const
{
    QString trimmed = message.trimmed();
    
    if (trimmed.isEmpty()) {
        return QStringLiteral("Сообщение обязательно для заполнения");
    }
    
    if (trimmed.length() < MIN_MESSAGE_LENGTH) {
        return QStringLiteral("Сообщение должно содержать минимум 10 символов");
    }
    
    if (trimmed.length() > MAX_MESSAGE_LENGTH) {
        return QStringLiteral("Сообщение не должно превышать 1000 символов");
    }
    
    return QString();
}

