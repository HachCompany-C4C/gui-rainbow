#ifndef PASSWORD_H
#define PASSWORD_H

#include <QObject>
#include <QQmlContext>
#include "settings.h"

#define SALT_DEF            "12@a#1B"
#define ENCRYPTED_SUPER     "12645.C6ioNL2"
#define ENCRYPTED_DEF       "12tir.zIbWQ3c"

class Password : public QObject
{
    Q_OBJECT
public:
    Password(QQmlContext *context, Settings *settings);

    Q_INVOKABLE void savePassword(QString user, QString password);
    Q_INVOKABLE void resetPassword(const QString user);
    Q_INVOKABLE QString getPasswordEncrypted(const QString user);
    Q_INVOKABLE QString encrypt(const QString password, const QString salt = SALT_DEF);
    Q_INVOKABLE QString superPasswordEncrypted();
private:
    Settings *mSettings;
    QString mEncryptedDef;
    QString mEncryptedSuper;
    QString mSaltDef;
};

#endif // PASSWORD_H
