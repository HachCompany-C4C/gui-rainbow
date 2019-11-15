/****************************************************************************
** upgrade.h - Update software
**
** Created on: 2017-10-31
**
** Author: BW
**
** Copyright (C) 2016 Hach DDC
**              All Rights Reserved
**
**
** Notes:
**
****************************************************************************/

#ifndef UPGRADE_H
#define UPGRADE_H

#include <QObject>
#include <QProcess>
#include <QCloseEvent>
#include <QThread>
#include <QQmlContext>
#include <QFile>
#include "jsonparse.h"
#include "file.h"

class Upgrade : public QThread
{
    Q_OBJECT
public:
    explicit Upgrade(JsonParse *jsonParse, QQmlContext *context, File *file, Settings *settings);

    Q_INVOKABLE bool startProcess();
    Q_INVOKABLE QString getStandardOutput();
    Q_INVOKABLE bool getStatus();
    Q_INVOKABLE float processPersent();
    Q_INVOKABLE QString error();
    Q_INVOKABLE QString errorFlag();

    enum E_State {
        E_Init,
        E_WaitStart,
        E_FlashMCU,
        E_WaitBoot,
        E_QueryMCU,
        E_UpdateApp
    };

private:
    int findPersent(QByteArray output);
    QStringList findError(QByteArray output);
    int startFlashMCU(QString &result);
    int queryFlashProgress(int & ack);
    QString queryFlashResult(int & ack);
    bool setFlashMCUCompleteFlag();
    bool createScript();
    void updateError(QStringList err);
    void updateError(QString err, QString type = "");

    QByteArray standardOutput;
    QByteArray standardError;
    int mProcessPersent;
    QStringList mError;
    JsonParse *mJsonParse;
    E_State mState;
    File *mFile;
    Settings *mSettings;

protected:
    void closeEvent(QCloseEvent *);
    void run();

signals:
    void message();

public slots:
    void readStandardOutput();
    void readStandardError();
    void finishProcess(int exitCode, QProcess::ExitStatus exitStatus);
};

#endif // UPGRADE_H
