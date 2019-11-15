/****************************************************************************
** translator.cpp - Language translator
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

#include "translator.h"
#include <QQmlContext>
#include <QDebug>

Translator::Translator(QApplication *app, QQmlContext *context, QObject *parent) :
    QObject(parent),
    mApp(app)
{
    Q_ASSERT(context);
    context->setContextProperty("translator", this);
    mSource = ":/language/";
    addTranslation("EN", "rainbow_en.qm");
    addTranslation("ZH", "rainbow_zh.qm");
}

void Translator::addTranslation(const QString &name, const QString &file)
{
    if (!mTranslations.contains(name))
        mTranslations.insert(name, file);
}

QString Translator::currentLanguage()
{
    return mCurrentLanguage;
}

int Translator::currentIndex()
{
    int ii = 0;

    QVariantMap::iterator i;
    for(i = mTranslations.begin(); i != mTranslations.end(); ++i)
    {
        if(i.key() == mCurrentLanguage) {
            break;
        }
        ++i;
        ++ii;
    }

    return ii;
}

QString Translator::tr()
{
    return "";
}

void Translator::setSource(const QString &source)
{
    mSource = source;
}

void Translator::translate(const QString &language)
{
    if (language == "DEFAULT")
        removeTranslation();
    if (mTranslations.contains(language)) {
        if (mTranslator.load(mTranslations.value(language).toString(), mSource)) {
            removeTranslation();
            mApp->installTranslator(&mTranslator);
            qDebug() << "Translator::translate" << mTranslations.value(language).toString();
            mCurrentLanguage = language;
            emit languageChanged();
        }
    }
}

void Translator::removeTranslation()
{
    mApp->removeTranslator(&mTranslator);
    emit languageChanged();
}
