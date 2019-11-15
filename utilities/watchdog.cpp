#include "watchdog.h"
#ifdef __arm__
    #include <systemd/sd-daemon.h>
#endif
#include <fcntl.h>
#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#ifndef Q_OS_WIN
#include <unistd.h>
#endif

Watchdog::Watchdog(QQmlContext *context, QObject *parent) : QObject(parent)
{
    context->setContextProperty("watchdog", this);

}

int Watchdog::sdNotifyWatchdog()
{
#ifdef __arm__
    return sd_notify(0, "WATCHDOG=1");
#else
    return 0;
#endif
}

int Watchdog::sdNotifyReady()
{
#ifdef __arm__
    return sd_notify(0, "READY=1");
#else
    return 0;
#endif
}

int Watchdog::sdNotifyPidNotifyWatchdog(int pid)
{
#ifdef __arm__
    return sd_pid_notify(pid, 0, "WATCHDOG=1");
#else
    Q_UNUSED(pid);
    return 0;
#endif
}

int Watchdog::sdNotifyPidNotifyReady(int pid)
{
#ifdef __arm__
    return sd_pid_notify(pid, 0, "READY=1");
#else
    Q_UNUSED(pid);
    return 0;
#endif
}

int Watchdog::sdNotifyPidNotifyWatchdog()
{
#ifdef __arm__
    pid_t pid = getpid();
    return sd_pid_notify(pid, 0, "WATCHDOG=1");
#else
    return 0;
#endif
}

int Watchdog::sdNotifyPidNotifyReady()
{
#ifdef __arm__
    pid_t pid = getpid();
    return sd_pid_notify(pid, 0, "READY=1");
#else
    return 0;
#endif
}
