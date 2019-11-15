/****************************************************************************
** settings.cpp - Local settings
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
#include "settings.h"

Settings::Settings(QQmlContext *context)
{
    Q_ASSERT(context);
    context->setContextProperty("local_settings", this);
    mSettings = new QSettings("/home/root/.config/rainbow/local.conf", QSettings::NativeFormat);
#if UNIT_TEST
    test();
#endif
}

void Settings::setValue(const QString & group, const QString & key, const QVariant & value) const
{
    mSettings->beginGroup(group);
    mSettings->setValue(key, value);
    mSettings->endGroup();
    qDebug() << "Settings::setValue key: " << key << " value: " << value;
}

QVariant Settings::getValue(const QString & group, const QString & key, const QVariant & def)
{
    QVariant value;
    mSettings->beginGroup(group);
    value = mSettings->value(key);
    mSettings->endGroup();
    qDebug() << "Settings::getValue key: " << key << " value: " << value;
    if(value.isNull() || !value.isValid())
    {
        setValue(group, key, def);
        value = def;
    }
    return value;
}

bool Settings::getValueBool(const QString &group, const QString &key, const bool &def)
{
    QVariant var = getValue(group, key, QVariant(def));
    return var.toBool();
}

int Settings::getValueInt(const QString &group, const QString &key, const int &def)
{
    QVariant var = getValue(group, key, QVariant(def));
    return var.toInt();
}

float Settings::getValueFloat(const QString &group, const QString &key, const float &def)
{
    QVariant var = getValue(group, key, QVariant(def));
    return var.toFloat();
}

QString Settings::getValueString(const QString &group, const QString &key, const QString &def)
{
    QVariant var = getValue(group, key, QVariant(def));
    return var.toString();
}

#if UNIT_TEST
bool Settings::compare(const QVariant &var1, const QVariant &var2)
{
    bool ret = true;
    if(var1 != var2)
    {
        qDebug() << "Unit Test" << var1 << var2;
        ret = false;
    }

    return ret;
}

void Settings::test()
{
    bool b = getValueBool("test", "typebool", true);
    compare(b, true);

    setValue("test", "typebool", false);
    b = getValueBool("test", "typebool", false);
    compare(b, false);
    setValue("test", "typebool", true);
    b = getValueBool("test", "typebool", false);
    compare(b, true);
}
#endif
