#include <QFile>
#include <QApplication>
#include <QTextStream>
#include <QDateTime>
#include "common.h"
#include "messageoutput.h"

static QStringList ignoredList;

QString Common::mainVersion()
{
    QString version = "";

    return version;
}

QString Common::appVersion()
{
    return QString(APP_VERSION);
}

void Common::addIgnoredString(QString str)
{
    ignoredList << str;
}

void Common::addIgnoredString(QStringList list)
{
    ignoredList << list;
}

void Common::delIgnoredString(QString str)
{
    QString temp;
    for(int i = 0; i < ignoredList.length(); i++) {
        temp = ignoredList[i];
        if(temp == str) {
            ignoredList.removeAt(i);
        }
    }
}

QStringList Common::ignoredString()
{
    return ignoredList;
}

void Common::messageOutputNull(QtMsgType type, const QMessageLogContext &context, const QString &msg)
{
    Q_UNUSED(context);
    Q_UNUSED(msg);
    switch (type) {
    case QtDebugMsg:
        break;
    case QtInfoMsg:
        break;
    case QtWarningMsg:
        break;
    case QtCriticalMsg:
        break;
    case QtFatalMsg:
        abort();
    }
}

void Common::messageOutputStd(QtMsgType type, const QMessageLogContext &context, const QString &msg)
{
    Q_UNUSED(context);
    QByteArray localMsg = msg.toLocal8Bit();
#if 0
    switch (type) {
    case QtDebugMsg:
        fprintf(stderr, "Debug: %s (%s:%u, %s)\n", localMsg.constData(), context.file, context.line, context.function);
        break;
    case QtInfoMsg:
        fprintf(stderr, "Info: %s (%s:%u, %s)\n", localMsg.constData(), context.file, context.line, context.function);
        break;
    case QtWarningMsg:
        fprintf(stderr, "Warning: %s (%s:%u, %s)\n", localMsg.constData(), context.file, context.line, context.function);
        break;
    case QtCriticalMsg:
        fprintf(stderr, "Critical: %s (%s:%u, %s)\n", localMsg.constData(), context.file, context.line, context.function);
        break;
    case QtFatalMsg:
        fprintf(stderr, "Fatal: %s (%s:%u, %s)\n", localMsg.constData(), context.file, context.line, context.function);
        abort();
    }
#else
    QString data = localMsg.constData();

    for(int i = 0; i < ignoredList.length(); i++)
    {
        QString item = ignoredList[i];
        QString flag = data.mid(0, item.length());
        if(flag == item) {
            return;
        }
    }

    switch (type)
    {
    case QtDebugMsg:
        fprintf(stderr, "Debug: %s\n", localMsg.constData());
        break;
    case QtInfoMsg:
        fprintf(stderr, "Info: %s\n", localMsg.constData());
        break;
    case QtWarningMsg:
        fprintf(stderr, "Warning: %s\n", localMsg.constData());
        break;
    case QtCriticalMsg:
        fprintf(stderr, "Critical: %s\n", localMsg.constData());
        break;
    case QtFatalMsg:
        fprintf(stderr, "Fatal: %s\n", localMsg.constData());
        abort();
    }

#endif
}


void Common::messageOutputFile(QtMsgType type, const QMessageLogContext &context, const QString &msg)
{
    Q_UNUSED(context);
    QString txt;
    QFile outFile(QApplication::applicationDirPath().append("/" + QString(PROJECT_NAME) + ".log"));
    if(!outFile.isOpen()) {
        outFile.open(QIODevice::WriteOnly|QIODevice::Append);
    }

    QByteArray localMsg = msg.toLocal8Bit();
    QString data = localMsg.constData();

    for(int i = 0; i < ignoredList.length(); i++)
    {
        QString item = ignoredList[i];
        QString flag = data.mid(0, item.length());
        if(flag == item) {
            outFile.close();
            return;
        }
    }

    QDateTime currentDateTime = QDateTime::currentDateTime();
    QString currentDate = currentDateTime.toString("yyyy-MM-dd_hhmmss");

    /*switch (type) {
    case QtDebugMsg:
        txt = QString("Debug: %1 (%2:%3, %4)").arg(localMsg.constData()).arg(context.file).arg(context.line).arg(context.function);
        break;
    case QtInfoMsg:
        txt = QString("Info: %1 (%2:%3, %4)").arg(localMsg.constData()).arg(context.file).arg(context.line).arg(context.function);
        break;
    case QtWarningMsg:
        txt = QString("Warning: %1 (%2:%3, %4)").arg(localMsg.constData()).arg(context.file).arg(context.line).arg(context.function);
        break;
    case QtCriticalMsg:
        txt = QString("Critical: %1 (%2:%3, %4)").arg(localMsg.constData()).arg(context.file).arg(context.line).arg(context.function);
        break;
    case QtFatalMsg:
        txt = QString("Fatal: %1 (%2:%3, %4)").arg(localMsg.constData()).arg(context.file).arg(context.line).arg(context.function);
        abort();
    }*/

    switch (type) {
    case QtDebugMsg:
        txt = QString("Debug[%1]: %2").arg(currentDate).arg(msg);
        break;
    case QtInfoMsg:
        txt = QString("Info[%1]: %2").arg(currentDate).arg(msg);
        break;
    case QtWarningMsg:
        txt = QString("Warning[%1]: %2").arg(currentDate).arg(msg);
        break;
    case QtCriticalMsg:
        txt = QString("Critical[%1]: %2").arg(currentDate).arg(msg);
        break;
    case QtFatalMsg:
        txt = QString("Fatal[%1]: %2").arg(currentDate).arg(msg);
        abort();
    }

    QTextStream ts(&outFile);
    ts << txt << endl;

    outFile.close();
}

void Common::messageOutputIPC(QtMsgType type, const QMessageLogContext &context, const QString &msg)
{
    Q_UNUSED(context);
    QString txt;

    QByteArray localMsg = msg.toLocal8Bit();
    QString data = localMsg.constData();

    for(int i = 0; i < ignoredList.length(); i++)
    {
        QString item = ignoredList[i];
        QString flag = data.mid(0, item.length());
        if(flag == item) {
            return;
        }
    }

    QDateTime currentDateTime = QDateTime::currentDateTime();
    QString currentDate = currentDateTime.toString("yyyy-MM-dd_hhmmss");

    switch (type) {
    case QtDebugMsg:
        txt = QString("Debug[%1]: %2").arg(currentDate).arg(msg);
        break;
    case QtInfoMsg:
        txt = QString("Info[%1]: %2").arg(currentDate).arg(msg);
        break;
    case QtWarningMsg:
        txt = QString("Warning[%1]: %2").arg(currentDate).arg(msg);
        break;
    case QtCriticalMsg:
        txt = QString("Critical[%1]: %2").arg(currentDate).arg(msg);
        break;
    case QtFatalMsg:
        txt = QString("Fatal[%1]: %2").arg(currentDate).arg(msg);
        abort();
    }

    MessageOutput::output(txt);
}

void Common::messageOutputIPCFile(QtMsgType type, const QMessageLogContext &context, const QString &msg)
{
    Q_UNUSED(context);
    QString txt;

    QByteArray localMsg = msg.toLocal8Bit();
    QString data = localMsg.constData();

    for(int i = 0; i < ignoredList.length(); i++)
    {
        QString item = ignoredList[i];
        QString flag = data.mid(0, item.length());
        if(flag == item) {
            return;
        }
    }

    QDateTime currentDateTime = QDateTime::currentDateTime();
    QString currentDate = currentDateTime.toString("yyyy-MM-dd_hhmmss");

    switch (type) {
    case QtDebugMsg:
        txt = QString("Debug[%1]: %2").arg(currentDate).arg(msg);
        break;
    case QtInfoMsg:
        txt = QString("Info[%1]: %2").arg(currentDate).arg(msg);
        break;
    case QtWarningMsg:
        txt = QString("Warning[%1]: %2").arg(currentDate).arg(msg);
        outputFile(txt);
        break;
    case QtCriticalMsg:
        txt = QString("Critical[%1]: %2").arg(currentDate).arg(msg);
        outputFile(txt);
        break;
    case QtFatalMsg:
        txt = QString("Fatal[%1]: %2").arg(currentDate).arg(msg);
        outputFile(txt);
        abort();
    }

    MessageOutput::output(txt);
}

void Common::outputFile(const QString &txt)
{
    QFile outFile(QApplication::applicationDirPath().append("/" + QString(PROJECT_NAME) + ".log"));
    if(!outFile.isOpen()) {
        outFile.open(QIODevice::WriteOnly|QIODevice::Append);
    }
    QTextStream ts(&outFile);

    ts << txt << endl;

    outFile.close();
}
