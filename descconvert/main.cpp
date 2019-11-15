#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDomDocument>
#include <QQmlContext>
#include <QFile>
#include <QDebug>
#include <QTextCodec>
#include <tscsv.h>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QTextCodec *codec = QTextCodec::codecForName("UTF-8");
    QTextCodec::setCodecForLocale(codec);

    QQmlApplicationEngine engine;
    QQmlContext *qmlContext = engine.rootContext();

    TsCsv tsCsv;
    qmlContext->setContextProperty("ts_csv", &tsCsv);

    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    return app.exec();
}
