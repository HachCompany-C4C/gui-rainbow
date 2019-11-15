#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlEngine>
#include <QQmlContext>
#include "probe/probemanager.h"
//#include "probe.h"
//#include <QWSServer>

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
    QApplication app(argc, argv);    
    bool dbus_tcp = false;
    for (int i = 0; i < argc; i++) {
        if (strcmp((const char*) "--tcp", argv[i]) == 0)
            dbus_tcp = true;
    }

    QQmlApplicationEngine engine;

    app.setOrganizationName("danaher");
    app.setOrganizationDomain("danaher.com");
    app.setApplicationName("hach Application");

    QScopedPointer<MouseMemory> mouse(new MouseMemory);
    engine.rootContext()->setContextProperty("mouse", mouse.data());

    //QScopedPointer<Probe> probe(new Probe);
    //Probe probe;
    //probe.set_connection(dbus_tcp);
    //engine.rootContext()->setContextProperty("probe", &probe);

    QQmlContext *context = engine.rootContext();
    ProbeManager probeManager(context);
    probeManager.init();

    engine.load(QUrl(QStringLiteral("qrc:/main_testcase.qml")));

    return app.exec();
}
#endif

