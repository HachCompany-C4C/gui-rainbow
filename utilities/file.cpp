/****************************************************************************
** file.cpp - File tool
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

#include <QStorageInfo>
#include <QDir>
#include <QDirIterator>
#include <QFileInfoList>
#include <QFileInfo>
#include <QDebug>
#include "file.h"
#include <stdio.h>
#include <time.h>
#include <fcntl.h>

#include <sys/stat.h>
#ifndef Q_OS_WIN
#include <unistd.h>
#include <utime.h>
#endif

File::File(Settings *settings, QQmlContext *context, QObject *parent) : QObject(parent)
{
    Q_ASSERT(context);
    Q_ASSERT(settings);
    context->setContextProperty("file_tool", this);

    mSettings = settings;
}

/*QString File::getDrivePath()
{
    QDir dir;
    dir.setPath("/media/");
    dir.setFilter(QDir::Dirs | QDir::NoDotAndDotDot);
    dir.setSorting(QDir::Name);
    QFileInfoList list = dir.entryInfoList();
    QFileInfo fileInfo;
    QString name;
    QString path = "";
    for (int i = (list.size() - 1); i > 0; i--) {
        fileInfo = list.at(i);
        name = fileInfo.fileName();

        if(name.contains("sd")) {
            QString tempPath = fileInfo.absolutePath()+ "/" +name;
            qDebug() << "File::getDrivePath drive: " << tempPath;

            QDir dir(tempPath);
            if(dir.exists()) {
                path = tempPath;
                qDebug() << "File::getDrivePath " << path;
                break;
            }
        }
    }

    return path;
}*/

bool File::isDriveValid(QString path)
{
    QString filePath = path+"/drive_test";
    QFile test(filePath);

    if(test.open(QIODevice::ReadWrite|QIODevice::Text))
    {
        QTextStream out(&test);
        out << "100";
    } else {
        qDebug() << "File::isDriveValid open fail" << path;
        test.close();
        return false;
    }

    test.close();

    if(test.exists()) {
        QFile::remove(filePath);
    }

    return true;
}

QString File::getDrivePathW()
{
    QString drivePath = "";
    QString filterPath = mSettings->getValueString("advance", "drivepath", "/media/sd");

    foreach(const QStorageInfo &storage, QStorageInfo::mountedVolumes()) {
        QString temp;
        temp = storage.rootPath();
        /*qDebug() << storage.rootPath();
        qDebug() << "name:" << storage.name();
        qDebug() << "fileSystemType:" << storage.fileSystemType();
        qDebug() << "size:" << storage.bytesTotal()/1000/1000 << "MB";
        qDebug() << "availableSize:" << storage.bytesAvailable()/1000/1000 << "MB";
        qDebug() << "isValid:" << storage.isValid();
        qDebug() << "isReadOnly:" << storage.isReadOnly();
        qDebug() << "isReady:" << storage.isReady();*/


        if(temp.contains(filterPath))
        {
            //if(storage.isReady() && storage.isValid())
            //{
            //    if(storage.isReadOnly()) {
            //        qDebug() << "isReadOnly:" << storage.isReadOnly();
             //   } else {
            if(isDriveValid(temp)) {
                drivePath = temp;
                break;
            }
            //   }
            //}
        }
    }

    //qDebug() << "File::getDrivePath drivePath: " << drivePath;
    return drivePath;
}

QString File::getDrivePath()
{

//    Device names of flash drives
//    A flash drive can be connected
//    via USB (typically a USB stick or a memory card via a USB adapter)
//    the device name is the same as for SATA drives, /dev/sdx
//    and partitions are named /dev/sdxn
//    where x is the device letter and n the partition number, for example /dev/sda1
//    via PCI (typically a memory card in a built-in slot in a laptop)
//    the device name is /dev/mmcblkm
//    and partitions are named /dev/mmcblkmpn
//    where m is the device number and n the partition number, for example /dev/mmcblk0p1
//    Example with an SSD, HDD, USB pendrive and an SD card


    QDir dir;

    dir.setPath("/dev/disk/by-id");

    QFileInfoList list = dir.entryInfoList();
    QString drive = "";

    for(int i = 0; i < list.size(); i++) {
        QFileInfo fileInfo = list.at(i);
        QString link = fileInfo.readLink();
        // qDebug() << "File::getDrivePath " << link;
        if(link.contains("/dev/sd"))
        {
            QStringList list = link.split("/");
            drive = "/media/" + list.at(2);
            //qDebug() << "File::getDriver: " << drive;
            //break;
        }
    }

    return drive;
}

bool File::openFile(QString name)
{
    Q_UNUSED(name);
    return true;
}

bool File::closeFile(QString name)
{
    Q_UNUSED(name);
    return true;
}

bool File::writeFile(QString filePath, QString data)
{
    QFile file(filePath);

    if(file.open(QIODevice::ReadWrite|QIODevice::Text))
    {
        QTextStream out(&file);
        out << data;

    } else {
        qDebug() << "File::isDriveValid open fail";
    }

    file.close();

    return true;
}

QString File::readFile(QString name)
{
    Q_UNUSED(name);
    return "";
}

QString File::findFile(QString strFilePath)
{
    QDir dir;

    dir.setPath(strFilePath);
    //dir.setNameFilters(filters);
    /*QDirIterator iter(dir, QDirIterator::NoIteratorFlags);

    while(iter.hasNext())
    {
        iter.next();
        QFileInfo info = iter.fileInfo();
        qDebug() << "File::findFile" << info.absolutePath();
        if(info.isFile()) {
            qDebug() << "File::findFile" << info.fileName();
        }

    }*/

    QFileInfoList list = dir.entryInfoList();
    QString findName = "";

    for(int i = 0; i < list.size(); i++) {
        QFileInfo fileInfo = list.at(i);
        QString baseName = fileInfo.baseName();
        if((baseName != "") && (baseName != "0:0:0:0"))
        {
            //qDebug() << "File::findFile" << baseName;
            findName = baseName;
        }
    }

    return findName;
}

bool File::findFileByName(QString strFilePath, QString strFileName)
{
    QDir dir;

    dir.setPath(strFilePath);

    QFileInfoList list = dir.entryInfoList();

    for(int i = 0; i < list.size(); i++) {
        QFileInfo fileInfo = list.at(i);
        QString fileName = fileInfo.fileName();
        //qDebug() << "File::findFile file:" << fileName;
        if(fileName == strFileName)
        {
            return true;
        }
    }

    return false;
}

void File::updateTime(QString path)
{
#ifndef    Q_OS_WIN
    unsigned int timezone = 0;
    Q_UNUSED(timezone);
    time_t t1, t2 ;
    struct tm *tm_local, *tm_utc;

    time(&t1);
    t2 = t1;
    //qDebug("File::utime t1=%1l,t2=%2l", t1, t2);

    // get localtime
    tm_local = localtime(&t1);
    //qDebug("File::utime localtime=%d:%d:%d", tm_local->tm_hour, tm_local->tm_min, tm_local->tm_sec);
    t1 = mktime(tm_local) ;

    // get utc time
    tm_utc = gmtime(&t2);
    //qDebug("File::utime utcutctime=%d:%d:%d", tm_utc->tm_hour, tm_utc->tm_min, tm_utc->tm_sec);
    t2 = mktime(tm_utc);

    //qDebug("File::utime t1=%1l\nt2=%2l", t1, t2);

    timezone = (t1 - t2) / 3600;
    //qDebug("File::utime timezone %d", timezone);

    QByteArray pathBa = path.toLatin1();
    qDebug() << "File::utime" << path;

    struct utimbuf timebuf;
    timebuf.actime = t1 + (t1-t2);
    timebuf.modtime = t1 + (t1-t2); //use local time + timezone
    if (utime(pathBa.data(), &timebuf) < 0) {
        qDebug("File::utime utime error");
    }
#endif
}

bool File::copyFileToPath(QString sourceDir ,QString toDir, bool coverFileIfExist)
{
    toDir.replace("\\","/");
    if (sourceDir == toDir){
        return true;
    }
    if (!QFile::exists(sourceDir)){
        return false;
    }
    QDir *createfile     = new QDir;
    bool exist = createfile->exists(toDir);
    if (exist){
        if(coverFileIfExist){
            createfile->remove(toDir);
        }
    }//end if

    if(!QFile::copy(sourceDir, toDir))
    {
        return false;
    }
    return true;
}

bool File::copyDirectoryFiles(const QString &fromDir, const QString &toDir, bool coverFileIfExist)
{
    QDir sourceDir(fromDir);
    QDir targetDir(toDir);
    if(!targetDir.exists()){    // if target dir not exist, create it
        if(!targetDir.mkdir(targetDir.absolutePath()))
            return false;
    }

    QFileInfoList fileInfoList = sourceDir.entryInfoList();
    foreach(QFileInfo fileInfo, fileInfoList){
        if(fileInfo.fileName() == "." || fileInfo.fileName() == "..")
            continue;

        if(fileInfo.isDir()){    // if dir, recursive copying
            if(!copyDirectoryFiles(fileInfo.filePath(),
                targetDir.filePath(fileInfo.fileName()),
                coverFileIfExist))
                return false;
        }
        else{            // if coverable, delete old file
            if(coverFileIfExist && targetDir.exists(fileInfo.fileName())){
                targetDir.remove(fileInfo.fileName());
            }

            /// copy file
            if(!QFile::copy(fileInfo.filePath(),
                targetDir.filePath(fileInfo.fileName()))){
                    return false;
            }
        }
    }
    return true;
}

bool File::exportLogFile()
{
    bool ret = true;
    QString fromDir = "/home/root/probe/python/daemon/logger/";
    QString toDir = getDrivePath();
    qDebug() << "LogExport::exprotLogFile toDir: " << toDir;
    if(toDir != "")
    {
        ret = copyDirectoryFiles(fromDir, toDir, true);
    }

    return ret;
}
