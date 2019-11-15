/****************************************************************************
** execscript.h - Execute script
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

#ifndef EXECSCRIPT_H
#define EXECSCRIPT_H

#include <QObject>
#include <QQmlContext>
#include <QThread>
#include <QProcess>
#include "file.h"

class ExecScript : public QThread
{
    Q_OBJECT
public:
    explicit ExecScript(QQmlContext *context, File *fileTool);
    Q_INVOKABLE int exec(QString script);
    Q_INVOKABLE QString execOutStd(QString script);
    Q_INVOKABLE QString execOutErr(QString script);
    Q_INVOKABLE QString execOutStdErr(QString script);
    Q_INVOKABLE bool findScriptPack();
    Q_INVOKABLE void preSetCmd(QString cmd);

protected:
    void run();
signals:
    void execScriptDone(QString msg);
    void stdOutput(QString msg);
    void lineCmdCleared();
public slots:

private:
    QString getStdOutput(QProcess &process, QString &standardMsg, bool end = false);

    File *mFileTool;
    QString mLineCmd;
};

#endif // EXECSCRIPT_H
