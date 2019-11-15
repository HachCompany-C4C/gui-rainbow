#ifndef SOCVERSION_H
#define SOCVERSION_H

#include <QObject>
#include <QQmlContext>

class SocVersion : public QObject
{
    Q_OBJECT
public:
    explicit SocVersion(QQmlContext *context, QObject *parent = nullptr);

    Q_INVOKABLE QString getSocDesc();
    static QString getSocDescStatic();
signals:

public slots:
};

#endif // SOCVERSION_H
