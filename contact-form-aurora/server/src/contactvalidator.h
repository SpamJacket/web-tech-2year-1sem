#ifndef CONTACTVALIDATOR_H
#define CONTACTVALIDATOR_H

#include <QString>
#include <QRegularExpression>

struct ValidationResult {
    QString nameError;
    QString emailError;
    QString messageError;
    
    bool isValid() const {
        return nameError.isEmpty() && 
               emailError.isEmpty() && 
               messageError.isEmpty();
    }
};

class ContactValidator
{
public:
    ContactValidator();
    
    ValidationResult validate(const QString &name, 
                             const QString &email, 
                             const QString &message) const;
    
    QString validateName(const QString &name) const;
    QString validateEmail(const QString &email) const;
    QString validateMessage(const QString &message) const;

private:
    QRegularExpression m_emailRegex;
    
    static const int MIN_NAME_LENGTH = 2;
    static const int MAX_NAME_LENGTH = 100;
    static const int MIN_MESSAGE_LENGTH = 10;
    static const int MAX_MESSAGE_LENGTH = 1000;
};

#endif // CONTACTVALIDATOR_H

