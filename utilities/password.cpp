#include <unistd.h>
#include <QDebug>
#include "password.h"

Password::Password(QQmlContext *context, Settings *settings)
{
    Q_ASSERT(context);
    context->setContextProperty("password_mgr", this);
    Q_ASSERT(settings);
    mSettings = settings;
    mEncryptedDef = ENCRYPTED_DEF;
    mEncryptedSuper = ENCRYPTED_SUPER;
    mSaltDef = SALT_DEF;
}

QString Password::encrypt(const QString key, const QString salt)
{
    char* encrypted = NULL;

    QByteArray baKey = key.toLatin1();
    const char *keyPtr = baKey.data();

    QByteArray baSalt = salt.toLatin1();
    const char *saltPtr = baSalt.data();
    encrypted = crypt(keyPtr, saltPtr);
    if(encrypted == NULL)
    {
        qDebug() << "Password::encrypt crypt error";
        return "";
    }

    return QString(encrypted);
}

void Password::savePassword(QString user, QString password)
{
    mSettings->setValue("permission", user+"passwd", encrypt(password));
}

void Password::resetPassword(const QString user)
{
    mSettings->setValue("permission", user+"passwd", ENCRYPTED_DEF);
}

QString Password::getPasswordEncrypted(const QString user)
{
    return mSettings->getValueString("permission", user+"passwd", mEncryptedDef);
}

QString Password::superPasswordEncrypted()
{
    return ENCRYPTED_SUPER;
}
