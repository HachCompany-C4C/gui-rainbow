#include <QFile>
#include <QtDebug>
#include <QTextStream>
#include "socversion.h"

SocVersion::SocVersion(QQmlContext *context, QObject *parent) : QObject(parent)
{
    Q_ASSERT(context);
    context->setContextProperty("soc_version", this);
}

QString SocVersion::getSocDesc()
{
    return SocVersion::getSocDescStatic();
}

QString SocVersion::getSocDescStatic()
{
    QString socDesc = "i.MX6DL";
    QFile soc("/sys/devices/soc0/soc_id");
    if(soc.exists())
    {
        if(soc.open(QIODevice::ReadOnly))
        {
            QTextStream in(&soc);
            in >> socDesc;
            qDebug() << "SocVersion::getSocDesc" << socDesc;
        } else {
            qDebug() << "SocVersion::getSocDesc open fail";
        }

        soc.close();
    }

    return socDesc;
}
