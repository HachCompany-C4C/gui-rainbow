/****************************************************************************
** main.cpp - main entry
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

#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlEngine>
#include <QQmlContext>
#include <QFile>
#include <qglobal.h>
#include <QJsonObject>
#include <QJsonDocument>
#include <QTextCodec>
#include "probemanager.h"
#include "application.h"

#include "utilities/common.h"
#include "utilities/translator.h"
#include "utilities/networkinterface.h"
#include "utilities/mouseevent.h"
#include "utilities/backlight.h"
#include "utilities/settings.h"
#include "utilities/fb2bmp.h"
#include "utilities/udiskdectect.h"
#include "utilities/commterminal.h"
#include "utilities/execscript.h"
#include "utilities/terminalserver.h"
#include "utilities/messageoutput.h"
#include "utilities/watchdog.h"
#include "utilities/systime.h"
#include "utilities/upgrade.h"
#include "utilities/logstring.h"
#include "utilities/logexport.h"
#include "utilities/backlight.h"
#include "utilities/panelleds.h"
#include "utilities/file.h"
#include "utilities/settings.h"
#include "utilities/execscript.h"
#include "utilities/udiskdectect.h"
#include "utilities/rtcdetect.h"
#include "utilities/password.h"
#include "utilities/socversion.h"

#ifdef __arm__
#include "ts_cali/ts_tool.h"
#endif
#include "ts_cali/calibration.h"

#if 0
//#include <QtQuickTest/quicktest.h>
//QUICK_TEST_MAIN(MeasureRange)

#include <QtTest>
#include <probe/interface/ifprobe.h>

int main(int argc, char *argv[])
{
    //IfProbe ifprobe;
    //QTest::qExec(&ifprobe)

}

#else

int main(int argc, char *argv[])
{
    Application app(argc, argv);

#if 1
    //app.setOverrideCursor(Qt::ArrowCursor);
    //FB2Bmp::showPicture(); //remove it for core dump in imx7
    bool isLocal = false;

    Q_INIT_RESOURCE(qml);
    QThread::currentThread()->setPriority(QThread::NormalPriority);
    //system("cat /home/root/screensnap > /dev/fb0");

    qInstallMessageHandler(Common::messageOutputStd);

    QStringList ignoredList;
    ignoredList << "IfProbe1::"
                << "IfProbe::readEx"
                << "IfProbe1::write"
                << "IfProbe::readLimit"
                //<< "JsonParse::"
                << "ProbePage::"
                << "ProbeObject::"
                << "ProbeClass::"
                << "IfModbus::"
                << "ProbeWorker::startWork"
                << "QML::UpdatePage"
                << "Settings::"
                << "Application::"
                << "Gpio::";

    Common::addIgnoredString(ignoredList);

    QStringList args = app.arguments();
    for (int i = 1; i < args.size(); ++i) {
        const QByteArray arg = args.at(i).toUtf8();
        if (arg.startsWith('-')) {
            if ("-version" == arg) {
                qInfo() << Common::appVersion();
                return 0;
            } else if("-help" == arg) {
                qInfo() << "-tcp 192.168.1.10 # connect to remote server by tcp dbus";
                qInfo() << "-version          # get application version";
                qInfo() << "-debug            # use debug interface";
                qInfo() << "-mask IfProbe::   # mask and don't print message about IfProbe::";
                qInfo() << "-unmask IfProbe:: # unmask and print message about IfProbe::";
                return 0;
            } else if ("-outfile" == arg) {
                qInstallMessageHandler(Common::messageOutputFile);
            } else if ("-outipc" == arg) {
                qInstallMessageHandler(Common::messageOutputIPC);
            } else if ("-outipcfile" == arg) {
                qInstallMessageHandler(Common::messageOutputIPCFile);
            } else if ("-local" == arg) {
                isLocal = true;
            } else if(arg == "-umask") {
                if(args.size()-1 >= (i+1))
                {
                    const QByteArray temp = args.at(i+1).toUtf8();
                    Common::delIgnoredString(temp);
                }
            }
            else if(arg == "-mask")
            {
                if(args.size()-1 >= (i+1))
                {
                    const QByteArray temp = args.at(i+1).toUtf8();
                    Common::addIgnoredString(temp);
                }
            }
        }
    }

    //QWindowSystemInterface::handleMouseEvent(0, QPoint(0, 0), QPoint(0, 0), Qt::LeftButton);

    QQmlApplicationEngine engine;


    app.setOrganizationName("danaher");
    app.setOrganizationDomain("danaher.com");
    app.setApplicationName("hach application");

    QTextCodec *codec = QTextCodec::codecForName("UTF-8");
    //QTextCodec *codec = QTextCodec::codecForName("GB2312");
    //QTextCodec *codec = QTextCodec::codecForName("GB18030");
    QTextCodec::setCodecForLocale(codec);

    QQmlContext *context = engine.rootContext();

    MouseEvent mouseEvent(&engine, &app);
    Q_UNUSED(mouseEvent);

    CaliThread calThread(context);
    Q_UNUSED(calThread);

    TerminalServer termServer(context);
    termServer.createAdapter();

    Watchdog watchdog(context);
    Q_UNUSED(watchdog);

    Settings localSettings(context);
    QString lang = localSettings.getValueString("system", "language", "ZH");

    ProbeManager probeManager(context);
    probeManager.setAppVersion(APP_VERSION);

    probeManager.init(args);
    JsonParse *jsonParse = probeManager.jsonParse();

    /* create utilities */
    File fileTool(&localSettings, context);
    fileTool.findFile("/sys/class/scsi_disk/");

    SysTime sysTime(context);
    sysTime.setSync(isLocal);

    Password password(context, &localSettings);

    Upgrade upgrade(jsonParse, context, &fileTool, &localSettings);

    PanelLeds panelLeds(context);

    LogString logString(context);

    LogExport logExport(&logString, jsonParse, context, &fileTool);

    ExecScript execScript(context, &fileTool);

    UDiskDectect uDiskDectect(context, &fileTool);

    SocVersion socVersion(context);

    RtcDetect rtcDetect(context);

    Translator translator(&app, context);
    translator.translate(lang);

    NetworkInterface networkInterface(context);
    Q_UNUSED(networkInterface);

    FB2Bmp fb2Bmp(context);
    Q_UNUSED(fb2Bmp);

    CommTerminal commTerminal(context);
    Q_UNUSED(commTerminal);

    MessageOutput messageOutput(context);
    Q_UNUSED(messageOutput);

    Backlight backLight(&app, context);
    QObject::connect(&app, SIGNAL(touchEventPressed()), &backLight, SLOT(setOn()));
    //QObject::connect(&app, SIGNAL(touchHoldTimeout()), &calThread, SIGNAL(calibrateTouch()));

#if QML_TEST
    engine.load(QUrl(QStringLiteral("qrc:/QmlTest.qml")));
#else
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
#endif

#endif

    return app.exec();
}
#endif

