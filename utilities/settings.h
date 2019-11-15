/****************************************************************************
** settings.h - Local settings
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

#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QSettings>
#include <QQmlContext>
#include "config.h"

class Settings : public QObject
{
    Q_OBJECT
public:
    Settings(QQmlContext *context);
    Q_INVOKABLE void setValue(const QString & group, const QString & key, const QVariant & value) const;
    Q_INVOKABLE QVariant getValue(const QString & group, const QString & key, const QVariant & def);
    Q_INVOKABLE bool getValueBool(const QString &group, const QString &key, const bool &def);
    Q_INVOKABLE int getValueInt(const QString &group, const QString &key, const int &def);
    Q_INVOKABLE float getValueFloat(const QString &group, const QString &key, const float &def);
    Q_INVOKABLE QString getValueString(const QString &group, const QString &key, const QString &def);

#if UNIT_TEST
    bool compare(const QVariant &var1, const QVariant &var2);
    void test();
#endif

private:
    QSettings *mSettings;
};

#endif // SETTINGS_H
