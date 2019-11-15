/****************************************************************************
** fb2bmp.h - Export framebuffer to bmp file
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

#ifndef FB2BMP_H
#define FB2BMP_H

#include <QObject>
#include <QQmlContext>
#include <QThread>

class FB2Bmp : public QThread
{
    Q_OBJECT
public:
    explicit FB2Bmp(QQmlContext *context, QObject *parent = 0);
    Q_INVOKABLE int generate(QString path);
    Q_INVOKABLE void startGenerate(QString path);
    Q_INVOKABLE QString fileName();
    static int showPicture();
protected:
    void run();
signals:
    void generationDone();
public slots:
private:
    QString mPath;
    QString mFileName;
};

#endif // FB2BMP_H
