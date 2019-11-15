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

#include <QDebug>
#include "calibration.h"
#include <math.h>
#include <unistd.h>

#ifdef __arm__
__u32 xres, yres;

//static int palette[] = {
//    0x000000, 0xffe080, 0xffffff, 0xe0c0a0
//};
#define NR_COLORS (sizeof(palette) / sizeof(palette[0]))
#endif

Calibration::Calibration(QQmlContext *context, QObject *parent) : QObject(parent)
{
    Q_ASSERT(context);
    mContext = context;
    mContext->setContextProperty("ts_cali", this);
    set_p1(false);
    set_p2(false);
    set_p3(false);
    set_p4(false);
    set_p5(false);
    set_p6(false);
}
bool Calibration::get_p1()
{
    return display_p1;
}

void Calibration::set_p1(bool display)
{
    display_p1 = display;
    emit p1_changed();
}
bool Calibration::get_p2()
{
    return display_p2;
}

void Calibration::set_p2(bool display)
{
    display_p2 = display;
    emit p2_changed();
}
bool Calibration::get_p3()
{
    return display_p3;
}

void Calibration::set_p3(bool display)
{
    display_p3 = display;
    emit p3_changed();
}
bool Calibration::get_p4()
{
    return display_p4;
}

void Calibration::set_p4(bool display)
{
    display_p4 = display;
    emit p4_changed();
}
bool Calibration::get_p5()
{
    return display_p5;
}

void Calibration::set_p5(bool display)
{
    display_p5 = display;
    emit p5_changed();
}
bool Calibration::get_p6()
{
    return display_p6;
}

void Calibration::set_p6(bool display)
{
    display_p6 = display;
    emit p6_changed();
}

#ifdef __arm__
static void sig(int sig)
{
    //close_framebuffer();
    fflush(stderr);
    fprintf(stderr,"signal %d caught\n", sig);
    fflush(stdout);
    exit(1);
}

int Calibration::performCalibration(calibration *cal)
{
    int j;
    float n, x, y, x2, y2, xy, z, zx, zy;
    float det, a, b, c, e, f, i;
    float scaling = 65536.0;

    fprintf(stderr, "physical: x: %d %d %d %d %d, y: %d %d %d %d %d\n", cal->x[0], cal->x[1], cal->x[2], cal->x[3],
            cal->x[4], cal->y[0], cal->y[1], cal->y[2], cal->y[3], cal->y[4]);
    fprintf(stderr, "screen: x: %d %d %d %d %d, y: %d %d %d %d %d\n", cal->xfb[0], cal->xfb[1], cal->xfb[2], cal->xfb[3],
            cal->xfb[4], cal->yfb[0], cal->yfb[1], cal->yfb[2], cal->yfb[3], cal->yfb[4]);

    /* Get sums for matrix */
    n = x = y = x2 = y2 = xy = 0;
    for (j = 0; j < 5; j++) {
        n += 1.0;
        x += (float)cal->x[j];
        y += (float)cal->y[j];
        x2 += (float)(cal->x[j]*cal->x[j]);
        y2 += (float)(cal->y[j]*cal->y[j]);
        xy += (float)(cal->x[j]*cal->y[j]);
    }

    /* Get determinant of matrix -- check if determinant is too small */
    det = n*(x2*y2 - xy*xy) + x*(xy*y - x*y2) + y*(x*xy - y*x2);
    if (det < 0.1 && det > -0.1) {
        fprintf(stderr,"ts_calibrate: determinant is too small -- %f\n", det);
        return 0;
    }

    /* Get elements of inverse matrix */
    a = (x2*y2 - xy*xy)/det;
    b = (xy*y - x*y2)/det;
    c = (x*xy - y*x2)/det;
    e = (n*y2 - y*y)/det;
    f = (x*y - n*xy)/det;
    i = (n*x2 - x*x)/det;

    /* Get sums for x calibration */
    z = zx = zy = 0;
    for (j = 0; j < 5; j++) {
        z += (float)cal->xfb[j];
        zx += (float)(cal->xfb[j]*cal->x[j]);
        zy += (float)(cal->xfb[j]*cal->y[j]);
    }

    /* Now multiply out to get the calibration for framebuffer x coord */
    cal->a[0] = (int)((a*z + b*zx + c*zy)*(scaling));
    cal->a[1] = (int)((b*z + e*zx + f*zy)*(scaling));
    cal->a[2] = (int)((c*z + f*zx + i*zy)*(scaling));

    fprintf(stderr,"%f %f %f\n", (a*z + b*zx + c*zy),
                 (b*z + e*zx + f*zy),
                 (c*z + f*zx + i*zy));

    /* Get sums for y calibration */
    z = zx = zy = 0;
    for (j = 0; j < 5; j++) {
        z += (float)cal->yfb[j];
        zx += (float)(cal->yfb[j]*cal->x[j]);
        zy += (float)(cal->yfb[j]*cal->y[j]);
    }

    /* Now multiply out to get the calibration for framebuffer y coord */
    cal->a[3] = (int)((a*z + b*zx + c*zy)*(scaling));
    cal->a[4] = (int)((b*z + e*zx + f*zy)*(scaling));
    cal->a[5] = (int)((c*z + f*zx + i*zy)*(scaling));

    fprintf(stderr,"%f %f %f\n", (a*z + b*zx + c*zy),
                 (b*z + e*zx + f*zy),
                 (c*z + f*zx + i*zy));

    /* If we got here, we're OK, so assign scaling to a[6] and return */
    cal->a[6] = (int)scaling;

    return 1;
}

void Calibration::getSample(struct tsdev *ts, calibration *cal,
               int index, int x, int y, char *name)
{
    //static int last_x = -1, last_y;

    /*if (last_x != -1) {
#define NR_STEPS 10
        int dx = ((x - last_x) << 16) / NR_STEPS;
        int dy = ((y - last_y) << 16) / NR_STEPS;
        int i;

        last_x <<= 16;
        last_y <<= 16;
        for (i = 0; i < NR_STEPS; i++) {
            //put_cross(last_x >> 16, last_y >> 16, 2 | XORMODE);
            usleep(1000);
            //put_cross(last_x >> 16, last_y >> 16, 2 | XORMODE);
            last_x += dx;
            last_y += dy;
        }
    }*/

    //put_cross(x, y, 2 | XORMODE);
    getxy(ts, &cal->x[index], &cal->y[index]);
    //put_cross(x, y, 2 | XORMODE);

    //last_x = cal->xfb[index] = x;
    //last_y = cal->yfb[index] = y;
    cal->xfb[index] = x;
    cal->yfb[index] = y;

    fprintf(stderr, "point %d-%s : X = %4d Y = %4d, Xfb = %d Yfb= %d\n", index, name, cal->x[index], cal->y[index], cal->xfb[index], cal->yfb[index]);
    //fprintf(stderr, "%s : X = %4d Y = %4d\n", name, cal->x[index], cal->y[index]);
    //fprintf(stderr, "point %d is clicked\n", index);
}

void Calibration::clearbuf(struct tsdev *ts)
{
    int fd = ts_fd(ts);
    fd_set fdset;
    struct timeval tv;
    int nfds;
    struct ts_sample sample;

    while (1) {
        FD_ZERO(&fdset);
        FD_SET(fd, &fdset);

        tv.tv_sec = 0;
        tv.tv_usec = 0;

        nfds = select(fd + 1, &fdset, NULL, NULL, &tv);
        if (nfds == 0)
            break;

        if (ts_read_raw(ts, &sample, 1) < 0) {
            perror("ts_read");
            exit(1);
        }
    }
}

void Calibration::caliSample(int index)
{
    int sample_index = index -1;



    switch (index) {
    case 0:
        set_p1(true);
        break;
    case 1:
        clearbuf(ts);
        getSample(ts, &cal, sample_index, pointx[sample_index], pointy[sample_index], location[sample_index]);
        set_p1(false);
        //usleep(10000);
        set_p2(true);
        break;
    case 2:
        clearbuf(ts);
        getSample(ts, &cal, sample_index, pointx[sample_index], pointy[sample_index], location[sample_index]);
        while(fabs(cal.x[sample_index]-cal.x[sample_index-1]) < 1000 && fabs(cal.y[sample_index] - cal.y[sample_index-1]) < 1000)
        {
            clearbuf(ts);
            getSample(ts, &cal, sample_index, pointx[sample_index], pointy[sample_index], location[sample_index]);

        }
        set_p2(false);
        //usleep(10000);
        set_p3(true);
        break;
    case 3:
        clearbuf(ts);
        getSample(ts, &cal, sample_index, pointx[sample_index], pointy[sample_index], location[sample_index]);
        while(fabs(cal.x[sample_index]-cal.x[sample_index-1]) < 1000 && fabs(cal.y[sample_index] - cal.y[sample_index-1]) < 1000)
        {
            clearbuf(ts);
            getSample(ts, &cal, sample_index, pointx[sample_index], pointy[sample_index], location[sample_index]);

        }
        set_p3(false);
        //usleep(10000);
        set_p4(true);
        break;
    case 4:
        clearbuf(ts);
        getSample(ts, &cal, sample_index, pointx[sample_index], pointy[sample_index], location[sample_index]);
        while(fabs(cal.x[sample_index]-cal.x[sample_index-1]) < 1000 && fabs(cal.y[sample_index] - cal.y[sample_index-1]) < 1000)
        {
            clearbuf(ts);
            getSample(ts, &cal, sample_index, pointx[sample_index], pointy[sample_index], location[sample_index]);

        }
        set_p4(false);
        //usleep(10000);
        set_p5(true);
        break;
    case 5:
        clearbuf(ts);
        getSample(ts, &cal, sample_index, pointx[sample_index], pointy[sample_index], location[sample_index]);
        while(fabs(cal.x[sample_index]-cal.x[sample_index-1]) < 1000 && fabs(cal.y[sample_index] - cal.y[sample_index-1]) < 1000)
        {
            clearbuf(ts);
            getSample(ts, &cal, sample_index, pointx[sample_index], pointy[sample_index], location[sample_index]);

        }
        clearbuf(ts);
        set_p5(false);
        //usleep(10000);
        set_p6(true);
        break;
    default:
        break;
    }
}

void Calibration::openTsDevice()
{
    ts = ts_setup(NULL, 0);

    if (!ts) {
        perror("ts_setup");
        exit(1);
    }
}

void Calibration::closeTsDevice()
{
    ts_close(ts);
}

bool Calibration::touch()
{
    Q_ASSERT(ts);
    int fd = ts_fd(ts);
    fd_set fdset;
    struct timeval tv;
    int nfds;
    struct ts_sample sample;
    bool ret = false;

    while(1) {
        FD_ZERO(&fdset);
        FD_SET(fd, &fdset);

        tv.tv_sec = 0;
        tv.tv_usec = 0;

        nfds = select(fd + 1, &fdset, NULL, NULL, &tv);
        if (nfds == 0) //timeout
        {
            break;
        }

        if (ts_read_raw(ts, &sample, 1) > 0) {
            ret = true;
        }
    }

    return ret;
}

void Calibration::writeCali()
{
    int cal_fd;
    char cal_buffer[256];
    char *calfile = NULL;
    unsigned int i, len;
    if (performCalibration (&cal)) {
        fprintf(stderr,"Calibration constants: ");
        for (i = 0; i < 7; i++)
            fprintf(stderr,"%d ", cal.a[i]);
        fprintf(stderr,"\n");
        fprintf(stderr, "TSLIB_CALIBFILE = %s\n", getenv("TSLIB_CALIBFILE"));

        if ((calfile = getenv("TSLIB_CALIBFILE")) != NULL)
        {
            cal_fd = open(calfile, O_CREAT | O_TRUNC | O_RDWR,
                      S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
        }
        else
        {
            cal_fd = open(TS_POINTERCAL, O_CREAT | O_TRUNC | O_RDWR,
                      S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
        }
        if (cal_fd < 0) {
            perror("open");
            //close_framebuffer();
            ts_close(ts);
            //exit(1);
        }

        len = sprintf(cal_buffer, "%d %d %d %d %d %d %d %d %d",
                  cal.a[1], cal.a[2], cal.a[0],
                  cal.a[4], cal.a[5], cal.a[3], cal.a[6],
                  xres, yres);
        if (write(cal_fd, cal_buffer, len) == -1) {
            perror("write");
            //close_framebuffer();
            ts_close(ts);
            //exit(1);
        }
        close(cal_fd);
        i = 0;
    } else {
        fprintf(stderr,"Calibration failed.\n");
        i = -1;
    }

    ts_close(ts);
    //ts_close(ts);
    sync();
}
#endif

void Calibration::startCali()
{
#ifdef __arm__
    memset(&cal, 0, sizeof(cal));
    get_resolution(&xres, &yres);

    pointx[0] = 50;
    pointx[1] = xres-50;
    pointx[2] = xres-50;
    pointx[3] = 50;
    pointx[4] = xres/2;
    pointy[0] = 50;
    pointy[1] = 50;
    pointy[2] = yres-50;
    pointy[3] = yres-50;
    pointy[4] = yres/2;

    location[0] = "Top left";
    location[1] = "Top right";
    location[2] = "Bot right";
    location[3] = "Bot left";
    location[4] = "Center";


    signal(SIGSEGV, sig);
    signal(SIGINT, sig);
    signal(SIGTERM, sig);

    ts = ts_setup(NULL, 0);

    if (!ts) {
        perror("ts_setup");
        exit(1);
    }
    fprintf(stderr,"xres = %d, yres = %d\n", xres, yres);
    clearbuf(ts);
    set_p1(true);
#endif
}

CaliThread::CaliThread(QQmlContext *context)
{
    mContext = context;
    mContext->setContextProperty("ts_caliThread", this);
    calib = new Calibration(context);
    pressIndex = 0;
    mMode = false;

    // start to detect touch pressed after startup
    start();
}

CaliThread::~CaliThread()
{
    if(calib) {
        delete calib;
    }
}

void CaliThread::init()
{
#ifdef __arm__
    calib->startCali();
#endif
    start();
}


void CaliThread::detectTouch()
{
#ifdef __arm__
#define TIME_COUNT  15
#define PRESS_HOLD_TIMES 8
    int timeCount = 0;
    int count = 0;
    calib->openTsDevice();
    while (timeCount < TIME_COUNT) {
        if(calib->touch())
        {
            count ++;

            qDebug() << "CaliThread::detectTouch true" << count;
            if(count >= PRESS_HOLD_TIMES) break;
        }
        sleep(2);
        timeCount++;
    }

    calib->closeTsDevice();

    if(count >= PRESS_HOLD_TIMES) {
        emit gotoCalibrateTouch();
    }
#endif
    mMode = true;
}

void CaliThread::run()
{
#ifdef __arm__

    if(mMode)
    {
        usleep(5000);
        while(pressIndex<=5)
        {
            calib->caliSample(pressIndex);
            pressIndex++;
            emit nextCalibrated();
            //usleep(5000);
        }
        calib->writeCali();
        pressIndex = 0;
        calib->set_p1(false);
        calib->set_p2(false);
        calib->set_p3(false);
        calib->set_p4(false);
        calib->set_p5(false);
        //calib->set_p6(false);

        usleep(5000);
        struct tsdev *newts;
        newts = ts_setup(NULL, 0);
        ts_reconfig(newts);
        ts_close(newts);
    } else {
        detectTouch();
    }
#endif
    quit();
}
