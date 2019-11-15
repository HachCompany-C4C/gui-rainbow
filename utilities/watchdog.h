#ifndef WATCHDOG_H
#define WATCHDOG_H

#include <QObject>
#include <QQmlContext>

class Watchdog : public QObject
{
    Q_OBJECT
public:
    explicit Watchdog(QQmlContext *context, QObject *parent = nullptr);
    Q_INVOKABLE int sdNotifyWatchdog();
    Q_INVOKABLE int sdNotifyReady();
    Q_INVOKABLE int sdNotifyPidNotifyWatchdog(int pid);
    Q_INVOKABLE int sdNotifyPidNotifyReady(int pid);
    Q_INVOKABLE int sdNotifyPidNotifyWatchdog();
    Q_INVOKABLE int sdNotifyPidNotifyReady();
signals:

public slots:
};

#endif // WATCHDOG_H
