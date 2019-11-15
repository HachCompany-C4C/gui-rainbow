/****************************************************************************
** upgrade.cpp - Update software
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

#include <QGuiApplication>
#include <QFile>
#include <QDebug>
//#include <QQmlEngine>
//#include <QQmlComponent>
//#include <QQmlProperty>
//#include <QQuickView>
#include "upgrade.h"
#include "file.h"
#include "settings.h"

Upgrade::Upgrade(JsonParse *jsonParse, QQmlContext *context, File *file, Settings *settings)
{
    Q_ASSERT(jsonParse);
    Q_ASSERT(context);
    Q_ASSERT(file);
    Q_ASSERT(settings);
    context->setContextProperty("software_upgrade", this);
    mJsonParse = jsonParse;

    mProcessPersent = 0;
    mError << "";
    mFile = file;
    mSettings = settings;
}

int Upgrade::findPersent(QByteArray output)
{
    bool f = false;
    QString p = "";
    for(int i = 0; i < output.size(); i++)
    {
        char a = output[i];
        if(a == '@') {
            f = true;
            p = "";
        } else if(f) {
            if(a == '%') {
                f = false;
            } else {
                p += a;
            }
        }
    }

    if(p == "" || f == true) {
        p = "0";
    }

    return p.toInt();
}

QStringList Upgrade::findError(QByteArray output)
{
    bool f = false;
    QString str = "";
    QStringList result;
    bool end = false; // true - end
    int size = output.size();
    for(int i = 0; i < size; i++)
    {
        char a = output[i];
        if(a == '<') {
            f = true;  //found start token '<'
            str = "";
            /*if(size > i) {
                if(output[i+1] == '!') { //found upgrade end flag
                    end = true;
                }
            }*/
        } else if(f) {
            if(a == '>') {  //found end token '>'
                f = false;
                break;
            } else {
                if(a != '!') {
                    str += a;
                } else {
                    end = true;
                }
            }
        }
    }

    // No error found
    if(f) {
        str = "";
    } else {
        result << str;
        if(end == true) {
            result << "end";
        } else {
            result << "";
        }
    }

    return result;
}

void Upgrade::updateError(QString err, QString type)
{
    mError.clear();
    mError << err << type;
}

void Upgrade::updateError(QStringList err)
{
    mError.clear();
    mError << err;
}

void Upgrade::run()
{
    int ack;
    QStringList error;
    QProcess pprocess;
    QString exec = QGuiApplication::applicationDirPath().append("/entry.sh");
    QStringList args;
    QString mode;

    args << mFile->getDrivePath(); // arg1

    QString home = mSettings->getValueString("advance", "home", "/home/root");
    args << home; // arg2

    QString remote = mSettings->getValueString("advance", "remote", "localhost");
    args << remote; // arg3

    qDebug() << "Upgrade::run args: " << args;

    pprocess.start(exec, args);
    qDebug() << "Upgrade::run entry.sh";

    if(false == pprocess.waitForStarted())
    {
        qDebug() << "Upgrade::run entry.sh failed";
        updateError("run entry.sh failed");
        return;
    }

    standardOutput = "";
    mProcessPersent = 0;
    mError.clear();
    mState = E_Init;
    int persent;

    qDebug() << "Upgrade::run upgrade.sh";

    int flashTimeCount = 0;

    queryFlashResult(ack);

    while(!pprocess.waitForFinished(500))
    {
        standardOutput += pprocess.readAllStandardOutput();
        standardError = pprocess.readAllStandardError();

        if(!standardError.isEmpty())
        {
            standardOutput += '\n';
            standardOutput += standardError;
            standardError.clear();
        }

        error = findError(standardOutput);
        if(error[0] != "")
        {
            updateError(error);
        }

        switch(mState)
        {
        case E_Init:
            if(standardOutput.contains("UPDATE_MCU")) {
                QString result;
                ack = startFlashMCU(result);
                standardOutput += result;
                if(ack != 0) {
                    updateError(result);
                    return;
                }
                flashTimeCount = 0;
                mState = E_WaitStart;
            }
            qDebug() << "Upgrade::run E_Init";
            break;
        case E_WaitStart:
            //flashTimeCount = 4 wait for flash thread in probe daemon start
            if(flashTimeCount == 10) {
                mState = E_FlashMCU;
                flashTimeCount = 0;
            } else {
                flashTimeCount ++;
            }
            break;
        case E_FlashMCU:
            persent = queryFlashProgress(ack);
            mProcessPersent = persent / 2+10;
            flashTimeCount ++;
            if(persent == 100)
            {
                //setFlashMCUCompleteFlag();
                mState = E_WaitBoot;
                flashTimeCount = 0;
            } else if(flashTimeCount == (5*60000/500)) { //wait for 5*60000/500 = 5min
                updateError("Flash MCU Timeout");
                return;
            }
            // crc = 0x100 && timeout = 0x104
            if(ack == 0x100 || ack == 0x104) {
                qDebug() << "Upgrade::run ack: " << ack;
                updateError("Flash MCU Failed: "+QString::number(ack));
                return;
            }
            qDebug() << "Upgrade::run E_FlashMCU";
            break;
        case E_WaitBoot:
            //flashTimeCount = 4 wait for mcu boot
            if(flashTimeCount == 15) {
                mState = E_QueryMCU;
                flashTimeCount = 0;
            } else {
                flashTimeCount ++;
            }
            break;
        case E_QueryMCU:
            mode = queryFlashResult(ack);
            qDebug() << "Upgrade::run mode: " + mode;
            if(mode == "application") {
                mState = E_UpdateApp;
                setFlashMCUCompleteFlag();
            } else {
                updateError("Flash MCU Failed, please retry.");
                return;
            }

            break;
        case E_UpdateApp:
            qDebug() << "Upgrade::run E_UpdateApp";
            break;
        }

        // get persentage
        int persent = findPersent(standardOutput);
        if(persent > mProcessPersent)
        {
            mProcessPersent = persent;
        }
    }

    standardOutput = pprocess.readAllStandardOutput();
    qDebug() << "Upgrade::run standardOutput" << standardOutput;
    error = findError(standardOutput);
    if(error[0] != "")
    {
        updateError(error);
    }
}

bool Upgrade::createScript()
{
    /*QString temp;
    QFile source(":/resources/scripts/entry.sh");
    if (!source.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "Error Upgrade::createScript Open source error!";
        return false;
    }
    QTextStream in(&source);

    in >> temp;
    source.close();

    QFile target(QGuiApplication::applicationDirPath().append("/entry.sh"));
    if (!target.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qDebug() << "Error Upgrade::createScript Open target error!";
        return false;
    }

    QTextStream out(&target);
    out << temp;
    target.close();*/

    QString entryFilePath = QGuiApplication::applicationDirPath().append("/entry.sh");
    QFile::remove(entryFilePath);

    QFile::copy(":/resources/scripts/entry.sh", entryFilePath);
    QFile::setPermissions(entryFilePath, QFileDevice::ExeOther | QFileDevice::ReadOwner
                          | QFileDevice::ExeOwner | QFileDevice::ExeUser);

    return true;
}

bool Upgrade::startProcess()
{
    // create entry.sh script
    createScript();
    //te
    QFile file(QGuiApplication::applicationDirPath().append("/entry.sh"));
    if (!file.exists()) {
        qDebug() << "Error Upgrade::startProcess Open file error!";
        return false;
    }
    this->start();
    //this->setFlashMCUCompleteFlag();
    return true;
}

QString Upgrade::getStandardOutput()
{
    QByteArray bk = standardOutput;
    standardOutput.clear();
    return QString(bk);
}

float Upgrade::processPersent()
{
    return (float)mProcessPersent/100;
}

QString Upgrade::error()
{
    if(!mError.isEmpty())
    {
        return mError[0];
    } else {
        return "";
    }
}

QString Upgrade::errorFlag()
{
    if(mError.length() > 1)
    {
        return mError[1];
    } else {
        return "";
    }
}

bool Upgrade::getStatus()
{
    return this->isRunning();
}

void Upgrade::readStandardOutput()
{

}

void Upgrade::readStandardError()
{

}

void Upgrade::finishProcess(int exitCode, QProcess::ExitStatus exitStatus)
{
    Q_UNUSED(exitCode);
    Q_UNUSED(exitStatus);
}

int Upgrade::startFlashMCU(QString &result)
{
    QJsonObject param;
    param.insert("hex", "/home/root/update/mcu/firmware.bin");
    QJsonValue jVal = mJsonParse->execJson("flash", param);
    result = jVal.toString();
    qDebug() << "Upgrade::startFlashMCU";
    return mJsonParse->ack();
}

int Upgrade::queryFlashProgress(int & ack)
{
    QJsonObject param;
    QJsonValue result = mJsonParse->execJson("flash_progress", param);
    if(result.isNull()) {
        ack = 0x104;
        return 0;
    }
    double dValue = result.toString().toDouble() * 100;
    int persent = (int)(dValue);
    qDebug() << "Upgrade::queryFlashProgress: " << result << persent << dValue;
    ack = mJsonParse->ack();
    return persent;
}

QString Upgrade::queryFlashResult(int & ack)
{
    QJsonObject param;
    QJsonValue result = mJsonParse->execJson("flash_result", param);
    QString resultStr = result.toString();
    qDebug() << "Upgrade::queryFlashResult: " << result << resultStr;
    ack = mJsonParse->ack();
    return resultStr;
}

bool Upgrade::setFlashMCUCompleteFlag()
{
    QString home = mSettings->getValueString("advance", "home", "/home/root");

    QFile pipe(home+"/update/mcu_update.p");

    if(pipe.exists())
    {
        if(pipe.open(QIODevice::ReadWrite))
        {
            QTextStream out(&pipe);
            out << "100";
        } else {
            qDebug() << "Upgrade::setFlashMCUCompleteFlag pipe open fail";
            return false;
        }

        pipe.close();
    }
    else
    {
        qDebug() << "Upgrade::setFlashMCUCompleteFlag pipe not exist";
        return false;
    }

    return true;
}
