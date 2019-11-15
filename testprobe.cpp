#include <QQmlApplicationEngine>
#include <QQmlEngine>
#include <QQmlContext>
#include "probe/probemanager.h"
#include <QtTest/QtTest>
#include <QtTest>
#include "testprobe.h"
#include "probe/probepage.h"
#include "probe/probeclass.h"

class TestProbe: public QObject
{
    Q_OBJECT
public:
    TestProbe()
    {
        mEngine = new QQmlApplicationEngine();
        mContext = mEngine->rootContext();
        mIfProbe = new IfProbe;

        mContext->setContextProperty("ifprobe", mIfProbe);

        mProbeClass = new ProbeClass(mIfProbe, mContext);

        mProbeClass->createPages(QCoreApplication::applicationDirPath()+"/probe_pages");
    }

private slots:
    void testProbeObject();
    void testPages();

private:
    IfProbe *mIfProbe;
    QQmlApplicationEngine *mEngine;
    QQmlContext *mContext;
    ProbeClass *mProbeClass;
};

void TestProbe::testProbeObject()
{
    ProbeObject *obj = new ProbeObject("auto", mIfProbe, mContext);
    bool b = obj->getBool();
    //QCOMPARE(b, 0);
}

void TestProbe::testPages()
{
    mProbeClass->exportAllPages();
}

QTEST_MAIN(TestProbe)
#include "testprobe.moc"
