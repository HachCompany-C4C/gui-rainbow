/****************************************************************************
** execscript.cpp - Execute script
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

#include <QDebug>
#include "execscript.h"

ExecScript::ExecScript(QQmlContext *context, File *fileTool)
{
    Q_ASSERT(context);
    Q_ASSERT(fileTool);
    mFileTool = fileTool;
    context->setContextProperty("exec_script", this);
    mLineCmd = "";
}

int ExecScript::exec(QString script)
{
    return QProcess::execute(script);
}

QString ExecScript::execOutStd(QString script)
{
    QProcess pprocess;
    QStringList options;
    options << "-c" << script;
    pprocess.start("/bin/bash", options);
    int i = 5;

    while(!pprocess.waitForFinished(500))
    {
        if(i == 0) break;

        i --;
    }

    QString standardOutput;

    standardOutput = pprocess.readAllStandardOutput();

    return standardOutput;
}

QString ExecScript::execOutErr(QString script)
{
    QProcess pprocess;
    QStringList options;
    options << "-c" << script;
    pprocess.start("/bin/bash", options);
    int i = 5;

    while(!pprocess.waitForFinished(500))
    {
        if(i == 0) break;

        i --;
    }

    QString standardError;

    standardError = pprocess.readAllStandardError();

    return standardError;
}

QString ExecScript::execOutStdErr(QString script)
{
    QProcess pprocess;
    QStringList options;
    options << "-c" << script;
    pprocess.start("/bin/bash", options);
    int i = 5;

    while(!pprocess.waitForFinished(500))
    {
        if(i == 0) break;

        i --;
    }

    QString standardOutput;

    standardOutput = pprocess.readAllStandardOutput();

    QString standardError;

    standardError = pprocess.readAllStandardError();

    if(standardError != "")
    {
        standardOutput = standardOutput + "\n" + standardError;
    }

    return standardOutput;
}

void ExecScript::preSetCmd(QString cmd)
{
    mLineCmd = cmd;
}

bool ExecScript::findScriptPack()
{
    QString drive = mFileTool->getDrivePath();
    if(drive != "") {
        bool res = mFileTool->findFileByName(drive, "script.tar.bz2");
        if(res) {
            return true;
        }
    }

    return false;
}

QString ExecScript::getStdOutput(QProcess &process, QString &standardMsg, bool end)
{
    QString standardOutput;
    QString standardError;

    standardOutput = process.readAllStandardOutput();
    standardError = process.readAllStandardError();

    if(!standardOutput.isEmpty())
    {
        standardMsg += standardOutput;
    }

    if(!standardError.isEmpty())
    {
        standardMsg += standardError;
    }

    if(!standardOutput.isEmpty() || !standardError.isEmpty() || end)
    {
        emit stdOutput(standardMsg);
    }

    return standardMsg;
}

void ExecScript::run()
{
    qDebug() << "ExecScript::run start";
    QString drive = mFileTool->getDrivePath();
    qDebug() << "ExecScript::run drive: " << drive;

    QProcess pprocess;
    QString standardMsg;
    if(drive != "")
    {
        bool ret = mFileTool->findFileByName(drive, "script.tar.bz2");
        qDebug() << "ExecScript::run find res: " << ret;
        if(ret) {
            QStringList cmds = mLineCmd.split(" ");
            QString package = "";
            if(cmds.length() > 1)
            {
                if(cmds[0] == "execscript" && cmds[1] != "") {
                    package = cmds[1];
                }

                if(cmds[0] == "rm" && cmds[1] == "-rf"
                        && (cmds[2] == "/" || cmds[2] == "/*")) // rm -rf / (rm -rf /*) can't be executed.
                {
                    emit execScriptDone("Permission denied");
                    return;
                }
            }

            if(mLineCmd == "" || package != "")
            {
                QString scriptPack = "script.tar.bz2";
                if(package != "") {
                    scriptPack = package;
                }

                QString cmd = "cp "+drive+"/"+scriptPack+" /home/root/";
                qDebug() << "ExecScript::run cmd:" << cmd;
                QProcess::execute(cmd);
                cmd = "tar jxvf /home/root/"+scriptPack+" -C /home/root/";
                qDebug() << "ExecScript::run cmd:" << cmd;
                QProcess::execute(cmd);

                QStringList args;

                // pprocess.execute("chmod 755 /home/root/script/update.sh");
                cmd = "/home/root/script/update.sh";
                qDebug() << "ExecScript::run cmd:" << cmd;
                args << cmd;
                args << drive;
                pprocess.start("/bin/bash", args);
            } else {
                qDebug() << "ExecScript::run line cmd: " << mLineCmd;
                QStringList options;
                options << "-c" << mLineCmd;
                pprocess.start("/bin/bash", options);
                mLineCmd = "";
                emit lineCmdCleared();
            }

            if(false == pprocess.waitForStarted())
            {
                qDebug() << "ExecScript::run update.sh failed";
                emit execScriptDone("Run script failed");
                return;
            }

            while(!pprocess.waitForFinished(500))
            {
                QString str = getStdOutput(pprocess, standardMsg);

                qDebug() << "ExecScript::run" << str;
            }

            getStdOutput(pprocess, standardMsg, true);

            qDebug() << "ExecScript::run done";

            emit execScriptDone("Done");
            return;
        }
    } else {
        emit execScriptDone("Drive not found");
    }
}
