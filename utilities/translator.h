/****************************************************************************
** translator.h - Language translator
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

#ifndef TRANSLATOR_H
#define TRANSLATOR_H

#include <QObject>
#include <QVariantMap>
#include <QtWidgets/QApplication>
#include <QTranslator>
#include <QQmlContext>

class Translator : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString tr READ tr NOTIFY languageChanged)

public:
    explicit Translator(QApplication *app, QQmlContext *context, QObject *parent = 0);

    void addTranslation(const QString &name, const QString &file);
    void setSource(const QString &source);
    QString currentLanguage();
    Q_INVOKABLE void translate(const QString &language);
    Q_INVOKABLE int currentIndex();

    QString tr();

signals:
    void languageChanged();

private:
    QApplication *mApp;
    QString mSource;
    QVariantMap mTranslations;
    QTranslator mTranslator;
    void removeTranslation();
    QString mCurrentLanguage;
};

#endif // TRANSLATOR_H
