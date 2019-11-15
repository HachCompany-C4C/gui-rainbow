/****************************************************************************
** calibration.cpp
**
** Created on: 2017-10-31
**
** Author: Mandy
**
** Copyright (C) 2016 Hach DDC
**              All Rights Reserved
**
**
** Notes:
**
****************************************************************************/

#ifndef CALIBRATION_H
#define CALIBRATION_H

#include <QObject>
#include <QThread>
#include <QQmlApplicationEngine>
#include <QQmlEngine>
#include <QQmlContext>

#ifdef __arm__
#include "config.h"

#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <string.h>
#include <unistd.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#include "tslib.h"

#include "fbutils.h"
#include "testutils.h"
#include "ts_tool.h"


#define TS_POINTERCAL "/etc/pointercal"

#endif

typedef struct {
    int x[5], xfb[5];
    int y[5], yfb[5];
    int a[7];
} calibration;

class Calibration : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool ts_cali_p1 READ get_p1 WRITE set_p1 NOTIFY p1_changed)
    Q_PROPERTY(bool ts_cali_p2 READ get_p2 WRITE set_p2 NOTIFY p2_changed)
    Q_PROPERTY(bool ts_cali_p3 READ get_p3 WRITE set_p3 NOTIFY p3_changed)
    Q_PROPERTY(bool ts_cali_p4 READ get_p4 WRITE set_p4 NOTIFY p4_changed)
    Q_PROPERTY(bool ts_cali_p5 READ get_p5 WRITE set_p5 NOTIFY p5_changed)
    Q_PROPERTY(bool ts_cali_p6 READ get_p6 WRITE set_p6 NOTIFY p6_changed)
public:
    explicit Calibration(QQmlContext *context, QObject *parent = 0);

//#ifdef __arm__
    int performCalibration(calibration *cal);
    void getSample(struct tsdev *ts, calibration *cal,
                   int index, int x, int y, char *name);
    void clearbuf(struct tsdev *ts);
#ifdef __arm__
    void openTsDevice();
    void closeTsDevice();
#endif
    void writeCali();
    //Q_INVOKABLE int tsCalibrate();
    void caliSample(int index);
//#endif
    Q_INVOKABLE void startCali();

    bool touch();

    void set_p1(bool display);
    void set_p2(bool display);
    void set_p3(bool display);
    void set_p4(bool display);
    void set_p5(bool display);
    void set_p6(bool display);

    bool get_p1();
    bool get_p2();
    bool get_p3();
    bool get_p4();
    bool get_p5();
    bool get_p6();

signals:
    void p1_changed();
    void p2_changed();
    void p3_changed();
    void p4_changed();
    void p5_changed();
    void p6_changed();

public slots:
private:
    bool display_p1;
    bool display_p2;
    bool display_p3;
    bool display_p4;
    bool display_p5;
    bool display_p6;

    struct tsdev *ts;
    calibration cal;
    int pointx[5];
    int pointy[5];
    char *location[5];

    QQmlContext *mContext;
};

class CaliThread: public QThread
{
    Q_OBJECT
public:
    CaliThread(QQmlContext *context);
    ~CaliThread();
    void init();
    void detectTouch();
signals:
    void gotoCalibrateTouch();
    void nextCalibrated();

protected:
    void run();
private:
    Calibration *calib;
    int pressIndex;

    bool mMode;

    QQmlContext *mContext;
};

#endif // CALIBRATION_H
