/****************************************************************************
** fb2bmp.cpp - Export framebuffer to bmp file
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

#include <QApplication>
#include <stdio.h>
#include <stdint.h>
#include <fcntl.h>
#include <QDebug>
#include <QDateTime>
#include <QFile>
#include "fb2bmp.h"

#ifndef Q_OS_WIN
#include <linux/fb.h>
#include <sys/mman.h>
#include <sys/ioctl.h>
#include <unistd.h>
#endif
typedef unsigned short WORD;
typedef unsigned int DWORD;
typedef unsigned long LONG;
typedef char BYTE;

#ifndef Q_OS_WIN
typedef struct tagBITMAPFILEHEADER
{
    WORD bfType;
    DWORD bfSize;
    WORD bfReserved1;
    WORD bfReserved2;
    DWORD bfOffBits;
} __attribute__((packed)) BITMAPFILEHEADER;


typedef struct tagBITMAPINFOHEADER
{
    DWORD biSize;
    LONG biWidth;
    LONG biHeight;
    WORD biPlanes;
    WORD biBitCount;
    DWORD biCompression;
    DWORD biSizeImage;
    LONG biXPelsPerMeter;
    LONG biYPelsPerMeter;
    DWORD biClrUsed;
    DWORD biClrImportant;
} __attribute__((packed)) BITMAPINFOHEADER;


#endif
typedef struct tagRGBQUAD {
    BYTE rgbBlue;
    BYTE rgbGreen;
    BYTE rgbRed;
    BYTE rgbReserved;
} RGBQUAD;

FB2Bmp::FB2Bmp(QQmlContext *context, QObject *parent) : QThread(parent)
{
    Q_ASSERT(context);
    context->setContextProperty("fb2bmp_tool", this);
}

int FB2Bmp::showPicture()
{
#ifndef Q_OS_WIN
    struct fb_fix_screeninfo finfo;
    struct fb_var_screeninfo vinfo;

    int fb_fd = open("/dev/fb0",O_RDWR);

    ioctl(fb_fd, FBIOGET_VSCREENINFO, &vinfo);
    ioctl(fb_fd, FBIOGET_FSCREENINFO, &finfo);

    long screensize = vinfo.yres_virtual * finfo.line_length;
    unsigned char *fbp = (unsigned char*)mmap(0, screensize, PROT_READ | PROT_WRITE, MAP_SHARED, fb_fd, (off_t)0);
    if(!fbp)
    {
        qDebug() << "mmap fails\n";
        return -1;
    }

    QFile pic(QApplication::applicationDirPath() + "/screensnap");
    pic.open(QIODevice::ReadOnly);
    QByteArray ba = pic.readAll();
    char *picData = ba.data();
    int length = ba.length();
    memcpy(fbp, picData, length);
    munmap(fbp, screensize);
#endif
    return 0;
}

int FB2Bmp::generate(QString path)
{
#ifndef Q_OS_WIN
    int res;
    struct fb_fix_screeninfo finfo;
    struct fb_var_screeninfo vinfo;

    int fb_fd = open("/dev/fb0",O_RDWR);

    ioctl(fb_fd, FBIOGET_VSCREENINFO, &vinfo);
    ioctl(fb_fd, FBIOGET_FSCREENINFO, &finfo);

    long screensize = vinfo.yres_virtual * finfo.line_length;
    unsigned char *fbp = (unsigned char*)mmap(0, screensize, PROT_READ | PROT_WRITE, MAP_SHARED, fb_fd, (off_t)0);
    if(!fbp)
    {
        qDebug() << "mmap fails\n";
        return -1;
    }

    BITMAPFILEHEADER    bmfh;
    BITMAPINFOHEADER    bmih;

    //create bitmap file header
    ((unsigned char *)&bmfh.bfType)[0] = 'B';
    ((unsigned char *)&bmfh.bfType)[1] = 'M';
    bmfh.bfSize = sizeof(BITMAPFILEHEADER) + sizeof(BITMAPINFOHEADER) + vinfo.xres * vinfo.yres * 4;
    bmfh.bfReserved1 = 0;
    bmfh.bfReserved2 = 0;
    bmfh.bfOffBits = sizeof(BITMAPFILEHEADER) + sizeof(BITMAPINFOHEADER);

    //create bitmap information header
    bmih.biSize = sizeof(BITMAPINFOHEADER);
    bmih.biWidth = vinfo.xres;
    bmih.biHeight = vinfo.yres;
    bmih.biPlanes = 1;
    bmih.biBitCount = 32;
    bmih.biCompression = 0;
    bmih.biSizeImage = 0;
    bmih.biXPelsPerMeter = 3800;
    bmih.biYPelsPerMeter = 3800;
    bmih.biClrUsed = 0;
    bmih.biClrImportant = 0;

    int second =  QTime::currentTime().msecsSinceStartOfDay();
    QString fileName = QString::number(second, 10)+".bmp";
    mFileName = fileName;
    //QString filePath = "/home/root/"+fileName;
    QString uFilePath = path+"/"+fileName;
    //QByteArray ba = filePath.toLatin1();
    //char *cfilePath = ba.data();
    //qDebug() << "FB2Bmp::generate" << cfilePath;
    //int image_file = open(cfilePath, O_RDWR|O_CREAT);
    QFile imageFile(uFilePath);

    if(!imageFile.open(QIODevice::ReadWrite))
    {
        qDebug() << "FB2Bmp::generateopen fail";
        imageFile.close();
        return -1;
    }

    if(res = imageFile.write((char*)&bmfh, sizeof(bmfh)) != sizeof(bmfh)) {
        qDebug() << "FB2Bmp::generate write failed.";
        imageFile.close();
        return -1;
    }

    if(res = imageFile.write((char*)&bmih, sizeof(bmih)) != sizeof(bmih)) {
        qDebug() << "FB2Bmp::generate write failed.";
        imageFile.close();
        return -1;
    }

    RGBQUAD rgb;
    rgb.rgbReserved = 0;
    qDebug("rgb xres: %d, yres: %d\n", vinfo.xres, vinfo.yres);

    int x, y;
    for(y = vinfo.yres - 1; y >= 0; y--)
    {
        for(x = 0; x < vinfo.xres; x++)
        {
            long location = (x + vinfo.xoffset) * (vinfo.bits_per_pixel/8) + (y + vinfo.yoffset) * finfo.line_length;
            unsigned char *rgbp = fbp + location;
            rgb.rgbRed = rgbp[1] & 0xf8;
            rgb.rgbGreen = (rgbp[1] << 5) | ((rgbp[0] & 0xe0) >> 3);
            rgb.rgbBlue = rgbp[0] << 3;

            rgb.rgbRed = rgb.rgbRed | ((rgb.rgbRed & 0x38) >> 3);
            rgb.rgbGreen = rgb.rgbGreen | ((rgb.rgbGreen & 0x0c) >> 2);
            rgb.rgbBlue = rgb.rgbBlue | ((rgb.rgbBlue & 0x38) >> 3);

            if(res = imageFile.write((char*)&rgb, sizeof(RGBQUAD)) != sizeof(RGBQUAD)) {
                qDebug() << "FB2Bmp::generate write failed.";
                imageFile.close();
                return -1;
            }
            //qDebug() << "FB2Bmp::generate convert: " << x << " " << y;
        }
    }
    munmap(fbp, screensize);
    if(!imageFile.flush()) {
        qDebug() << "FB2Bmp::generate flush failed.";
        imageFile.close();
        return -1;
    }

    imageFile.close();
    sync();
    close(fb_fd);

    if(!imageFile.exists()) {
        qDebug() << "FB2Bmp::generate create failed: " << fileName;
        return -1;
    }

    // test file saved sucessfully
    if(!imageFile.open(QIODevice::ReadWrite))
    {
        qDebug() << "FB2Bmp::generate open fail";
        imageFile.close();
        return -1;
    }

    imageFile.close();

    emit generationDone();
#endif
    return 0;
}

void FB2Bmp::startGenerate(QString path)
{
    mPath = path;
    this->start();
}

void FB2Bmp::run()
{
    sleep(1);
    generate(mPath);
}

QString FB2Bmp::fileName()
{
    return mFileName;
}
