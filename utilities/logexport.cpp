/****************************************************************************
** logexport.cpp - Export log
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

#include <QDir>
#include <QJsonArray>
#include <QDateTime>
#include <QObject>
#include "logexport.h"
#include <unistd.h>
#include <math.h>
#include <QStorageInfo>

//static const char* logTypeListLogList[] = {
//    QT_TRANSLATE_NOOP("LogExport", "mculog.measure"),
//    QT_TRANSLATE_NOOP("LogExport", "mcucalib"),
//    QT_TRANSLATE_NOOP("LogExport", "mcudiag"),
//    QT_TRANSLATE_NOOP("LogExport", "mcuevent")
//};

//static const char* eventLogDesc[] = {
//    QT_TRANSLATE_NOOP("LogExport", "EV_SCH_STOP"),
//    QT_TRANSLATE_NOOP("LogExport", "EV_FLUSH"),
//    QT_TRANSLATE_NOOP("LogExport", "EV_PRIME"),
//    QT_TRANSLATE_NOOP("LogExport", "EV_DRAIN"),
//    QT_TRANSLATE_NOOP("LogExport", "EV_FLOWSTEP"),
//    QT_TRANSLATE_NOOP("LogExport", "EV_SCH_START"),
//    QT_TRANSLATE_NOOP("LogExport", "EV_DIA_CLR"),
//    QT_TRANSLATE_NOOP("LogExport", "EV_DIA_SET"),
//    QT_TRANSLATE_NOOP("LogExport", "EV_RESET"),
//    QT_TRANSLATE_NOOP("LogExport", "EV_DIAG_INFO"),
//    QT_TRANSLATE_NOOP("LogExport", "EV_DIAG_WARN"),
//    QT_TRANSLATE_NOOP("LogExport", "EV_DIAG_ERR"),
//    QT_TRANSLATE_NOOP("LogExport", "EV_CALIBRATION"),
//    QT_TRANSLATE_NOOP("LogExport", "EV_CLEANING"),
//    QT_TRANSLATE_NOOP("LogExport", "EV_MEASURE"),
//    QT_TRANSLATE_NOOP("LogExport", "EV_CALC_GAIN"),
//    QT_TRANSLATE_NOOP("LogExport", "EV_CMD_PUT_OBJ"),
//    QT_TRANSLATE_NOOP("LogExport", "EV_CMD_PUT_MEM"),
//    QT_TRANSLATE_NOOP("LogExport", "EV_FAKE_TEST"),
//    QT_TRANSLATE_NOOP("LogExport", "EV_CFG_RESET"),
//    QT_TRANSLATE_NOOP("LogExport", "EV_SW_UPGRADE"),
//    QT_TRANSLATE_NOOP("LogExport", "EV_RTC_UPDATE"),
//    QT_TRANSLATE_NOOP("LogExport", "EV_INIT01"),
//    QT_TRANSLATE_NOOP("LogExport", "EV_INIT02"),
//    QT_TRANSLATE_NOOP("LogExport", "EV_AUTO_RANGE_REQ"),
//    QT_TRANSLATE_NOOP("LogExport", "EV_ACT_STOP"),
//    QT_TRANSLATE_NOOP("LogExport", "EV_ACT_START")
//};

//static const char* diagLogDesc[] = {
//    QT_TRANSLATE_NOOP("LogExport", "USB_WRITE_FAILURE"),
//    QT_TRANSLATE_NOOP("LogExport", "LOCAL_COMMUNICATION_ERR"),
//    QT_TRANSLATE_NOOP("LogExport", "LED_OUTPUT_LOW"),
//    QT_TRANSLATE_NOOP("LogExport", "NO_SAMPLE_FLOW"),
//    QT_TRANSLATE_NOOP("LogExport", "HEAT_OUT_CTRL"),
//    QT_TRANSLATE_NOOP("LogExport", "DOOR_OPEN"),
//    QT_TRANSLATE_NOOP("LogExport", "AD_SPI_FAILURE"),
//    QT_TRANSLATE_NOOP("LogExport", "FLASH_FAILURE"),
//    QT_TRANSLATE_NOOP("LogExport", "EEPROM_ERROR"),
//    QT_TRANSLATE_NOOP("LogExport", "RAM_FAILURE"),
//    QT_TRANSLATE_NOOP("LogExport", "POWER_FAILURE"),
//    QT_TRANSLATE_NOOP("LogExport", "VOLT_OUT_RANGE"),
//    QT_TRANSLATE_NOOP("LogExport", "HEATER_SENSOR_FAILURE"),
//    QT_TRANSLATE_NOOP("LogExport", "CASE_TEMP_WARNING"),
//    QT_TRANSLATE_NOOP("LogExport", "FAILED_CALIBRATION"),
//    QT_TRANSLATE_NOOP("LogExport", "LEAKAGE_WARNING"),
//    QT_TRANSLATE_NOOP("LogExport", "CHECK_OPTICS"),
//    QT_TRANSLATE_NOOP("LogExport", "REAGENT_INVALID"),
//    QT_TRANSLATE_NOOP("LogExport", "CURRENT_ERROR"),
//    QT_TRANSLATE_NOOP("LogExport", "ALARM_LOW"),
//    QT_TRANSLATE_NOOP("LogExport", "ALARM_HIGH"),
//    QT_TRANSLATE_NOOP("LogExport", "REAGNET_EMPTY_A"),
//    QT_TRANSLATE_NOOP("LogExport", "REAGNET_EMPTY_B"),
//    QT_TRANSLATE_NOOP("LogExport", "REAGNET_EMPTY_C"),
//    QT_TRANSLATE_NOOP("LogExport", "STD_EMPTY_0"),
//    QT_TRANSLATE_NOOP("LogExport", "STD_EMPTY_1"),
//    QT_TRANSLATE_NOOP("LogExport", "STD_EMPTY_2"),
//    QT_TRANSLATE_NOOP("LogExport", "CLEANING_EMPTY"),
//    QT_TRANSLATE_NOOP("LogExport", "REAGNET_LOW_A"),
//    QT_TRANSLATE_NOOP("LogExport", "REAGNET_LOW_B"),
//    QT_TRANSLATE_NOOP("LogExport", "REAGNET_LOW_C"),
//    QT_TRANSLATE_NOOP("LogExport", "STD_LOW_0"),
//    QT_TRANSLATE_NOOP("LogExport", "STD_LOW_1"),
//    QT_TRANSLATE_NOOP("LogExport", "STD_LOW_2"),
//    QT_TRANSLATE_NOOP("LogExport", "CLEANING_LOW"),
//    QT_TRANSLATE_NOOP("LogExport", "LIFESPAN_TUBING_VALVE"),
//    QT_TRANSLATE_NOOP("LogExport", "LIFESPAN_TUBING_PUMP"),
//    QT_TRANSLATE_NOOP("LogExport", "LIFESPAN_MOTOR_PUMP1"),
//    QT_TRANSLATE_NOOP("LogExport", "LIFESPAN_MOTOR_PUMP2"),
//    QT_TRANSLATE_NOOP("LogExport", "LIFESPAN_MOTOR_PUMP3"),
//    QT_TRANSLATE_NOOP("LogExport", "LIFESPAN_MOTOR_MIX"),
//    QT_TRANSLATE_NOOP("LogExport", "RTC_ALARM"),
//    QT_TRANSLATE_NOOP("LogExport", "LED_ERROR"),
//    QT_TRANSLATE_NOOP("LogExport", "CANOPEN_WARNING"),
//    QT_TRANSLATE_NOOP("LogExport", "CANOPEN_ERROR"),
//    QT_TRANSLATE_NOOP("LogExport", "CANOPEN_ER_CONNECT"),
//    QT_TRANSLATE_NOOP("LogExport", "CANOPEN_ER_CONFIG"),
//    QT_TRANSLATE_NOOP("LogExport", "FIX_RANGE_WARNING")
//};

//static const char* diagLogDetail[] = {
//    QT_TRANSLATE_NOOP("LogExport", "LED_OUT_LOW"),
//    QT_TRANSLATE_NOOP("LogExport", "LED_ERROR"),
//    QT_TRANSLATE_NOOP("LogExport", "CABLE_FAIL")
//    QT_TRANSLATE_NOOP("LogExport", "LOW_POWER"),
//    QT_TRANSLATE_NOOP("LogExport", "HIGH_POWER"),
//    QT_TRANSLATE_NOOP("LogExport", "HEAT_SENS_HIGH"),
//    QT_TRANSLATE_NOOP("LogExport", "HEAT_SENS_LOW"),
//    QT_TRANSLATE_NOOP("LogExport", "PEEK_SENS_HIGH"),
//    QT_TRANSLATE_NOOP("LogExport", "PEEK_SENS_LOW"),
//    QT_TRANSLATE_NOOP("LogExport", "ENV_SENS_HIGH"),
//    QT_TRANSLATE_NOOP("LogExport", "ENV_SENS_LOW"),
//    QT_TRANSLATE_NOOP("LogExport", "CASE_TEMP_HIGH"),
//    QT_TRANSLATE_NOOP("LogExport", "CASE_TEMP_LOW"),
//    QT_TRANSLATE_NOOP("LogExport", "HEAT_OUT_HIGH"),
//    QT_TRANSLATE_NOOP("LogExport", "HEAT_OUT_LOW"),
//    QT_TRANSLATE_NOOP("LogExport", "LOPTICS_OUT_LMT"),
//    QT_TRANSLATE_NOOP("LogExport", "SOPTICS_OUT_LMT"),
//    QT_TRANSLATE_NOOP("LogExport", "LOPTICS_INVALID"),
//    QT_TRANSLATE_NOOP("LogExport", "SOPTICS_INVALID"),
//    QT_TRANSLATE_NOOP("LogExport", "P1TUB_LIFESPAN"),
//    QT_TRANSLATE_NOOP("LogExport", "P2TUB_LIFESPAN"),
//    QT_TRANSLATE_NOOP("LogExport", "P3TUB_LIFESPAN")
//};

//static const char* measLogFlag[] = {
//    QT_TRANSLATE_NOOP("LogExport", "FLAG_MEA_MEAS"),
//    QT_TRANSLATE_NOOP("LogExport", "FLAG_MEA_TRIG"),
//    QT_TRANSLATE_NOOP("LogExport", "FLAG_MEA_OFFLINE"),
//    QT_TRANSLATE_NOOP("LogExport", "FLAG_MEA_ONLINE"),
//    QT_TRANSLATE_NOOP("LogExport", "FLAG_MEA_STD0"),
//    QT_TRANSLATE_NOOP("LogExport", "FLAG_MEA_STD1"),
//    QT_TRANSLATE_NOOP("LogExport", "FLAG_CALI_STD0"),
//    QT_TRANSLATE_NOOP("LogExport", "FLAG_CALI_STD1"),
//    QT_TRANSLATE_NOOP("LogExport", "FLAG_CALI_STATUS_ER"),
//    QT_TRANSLATE_NOOP("LogExport", "FLAG_CALI_STATUS_OK"),
//    QT_TRANSLATE_NOOP("LogExport", "FLAG_MEA_AUTORANGE_REQ"),
//    QT_TRANSLATE_NOOP("LogExport", "FLAG_RETRY_MAX")
//};

//static const char* calibLogFlag[] = {
//    QT_TRANSLATE_NOOP("LogExport", "VALID_CALIBRATION"),
//    QT_TRANSLATE_NOOP("LogExport", "INVALID_CALIBRATION"),
//    QT_TRANSLATE_NOOP("LogExport", "SCHEDULE_CALIBRATION"),
//    QT_TRANSLATE_NOOP("LogExport", "TRIGGER_CALIBRAION"),
//    QT_TRANSLATE_NOOP("LogExport", "AUTORANGE_CALIBRATION")
//};

//static const char* mcuLogTitle[] = {
//    QT_TRANSLATE_NOOP("LogExport", "ID"),
//    QT_TRANSLATE_NOOP("LogExport", "mculog.measure.time"),
//    QT_TRANSLATE_NOOP("LogExport", "mculog.measure.range_index"),
//    QT_TRANSLATE_NOOP("LogExport", "mculog.measure.concentration"),
//    QT_TRANSLATE_NOOP("LogExport", "mculog.measure.adapter_factor"),
//    QT_TRANSLATE_NOOP("LogExport", "mculog.measure.adapter_offset"),
//    QT_TRANSLATE_NOOP("LogExport", "mculog.measure.l660"),
//    QT_TRANSLATE_NOOP("LogExport", "mculog.measure.l880"),
//    QT_TRANSLATE_NOOP("LogExport", "mculog.measure.s660"),
//    QT_TRANSLATE_NOOP("LogExport", "mculog.measure.s880"),
//    QT_TRANSLATE_NOOP("LogExport", "mculog.measure.calibtime"),
//    QT_TRANSLATE_NOOP("LogExport", "mculog.measure.temperature1"),
//    QT_TRANSLATE_NOOP("LogExport", "mculog.measure.temperature2"),
//    QT_TRANSLATE_NOOP("LogExport", "mculog.measure.temperature3"),
//    QT_TRANSLATE_NOOP("LogExport", "mculog.measure.temperature4"),
//    QT_TRANSLATE_NOOP("LogExport", "mculog.measure.calibslop"),
//    QT_TRANSLATE_NOOP("LogExport", "mculog.measure.caliboffs"),
//    QT_TRANSLATE_NOOP("LogExport", "mculog.measure.measure_flag"),
//    QT_TRANSLATE_NOOP("LogExport", "mculog.measure.blank_s"),
//    QT_TRANSLATE_NOOP("LogExport", "mculog.measure.blank_l"),
//};

//static const char* mcuCalibTitle[] = {
//    QT_TRANSLATE_NOOP("LogExport", "ID"),
//    QT_TRANSLATE_NOOP("LogExport", "mcucalib.time"),
//    QT_TRANSLATE_NOOP("LogExport", "mcucalib.range_index"),
//    QT_TRANSLATE_NOOP("LogExport", "mcucalib.slope0"),
//    QT_TRANSLATE_NOOP("LogExport", "mcucalib.offset0"),
//    QT_TRANSLATE_NOOP("LogExport", "mcucalib.slope1"),
//    QT_TRANSLATE_NOOP("LogExport", "mcucalib.offset1"),
//    QT_TRANSLATE_NOOP("LogExport", "mcucalib.calib_status"),
//    QT_TRANSLATE_NOOP("LogExport", "mcucalib.time2"),
//    QT_TRANSLATE_NOOP("LogExport", "mcucalib.calibtimes0"),
//    QT_TRANSLATE_NOOP("LogExport", "mcucalib.l660"),
//    QT_TRANSLATE_NOOP("LogExport", "mcucalib.l880"),
//    QT_TRANSLATE_NOOP("LogExport", "mcucalib.s660"),
//    QT_TRANSLATE_NOOP("LogExport", "mcucalib.s880"),
//    QT_TRANSLATE_NOOP("LogExport", "mcucalib.temperature1"),
//    QT_TRANSLATE_NOOP("LogExport", "mcucalib.temperature2"),
//    QT_TRANSLATE_NOOP("LogExport", "mcucalib.temperature3"),
//    QT_TRANSLATE_NOOP("LogExport", "mcucalib.temperature4"),
//    QT_TRANSLATE_NOOP("LogExport", "mcucalib.time3"),
//    QT_TRANSLATE_NOOP("LogExport", "mcucalib.calibtimes1"),
//    QT_TRANSLATE_NOOP("LogExport", "mcucalib.l660_2"),
//    QT_TRANSLATE_NOOP("LogExport", "mcucalib.l880_2"),
//    QT_TRANSLATE_NOOP("LogExport", "mcucalib.s660_2"),
//    QT_TRANSLATE_NOOP("LogExport", "mcucalib.s880_2"),
//    QT_TRANSLATE_NOOP("LogExport", "mcucalib.temperature1_2"),
//    QT_TRANSLATE_NOOP("LogExport", "mcucalib.temperature2_2"),
//    QT_TRANSLATE_NOOP("LogExport", "mcucalib.temperature3_2"),
//    QT_TRANSLATE_NOOP("LogExport", "mcucalib.temperature4_2"),
//};

//static const char* mcuDiagTitle[] = {
//    QT_TRANSLATE_NOOP("LogExport", "ID"),
//    QT_TRANSLATE_NOOP("LogExport", "mcudiag.time"),
//    QT_TRANSLATE_NOOP("LogExport", "mcudiag.type"),
//    QT_TRANSLATE_NOOP("LogExport", "mcudiag.summary"),
//    QT_TRANSLATE_NOOP("LogExport", "mcudiag.detail")
//};

//static const char* mcuEventTitle[] = {
//    QT_TRANSLATE_NOOP("LogExport", "ID"),
//    QT_TRANSLATE_NOOP("LogExport", "mcuevent.time"),
//    QT_TRANSLATE_NOOP("LogExport", "mcuevent.summary")
//};

//static const char*  mcuEventSubStep[] = {
//    QT_TRANSLATE_NOOP("LogExport", "MAINSTEP"),
//    QT_TRANSLATE_NOOP("LogExport", "SUBSTEP")
//};

LogExport::LogExport(LogString *logString, JsonParse *jsonParse, QQmlContext *context, File *file)
{
    Q_ASSERT(context);
    Q_ASSERT(jsonParse);
    Q_ASSERT(file);
    Q_ASSERT(logString);
    context->setContextProperty("export_log", this);
    mJsonParse = jsonParse;
    mFile = file;
    mSNBuff = "";
}

void LogExport::setSNBuff(QString sn)
{
    mSNBuff = sn;
}

void LogExport::setTypeList(const QStringList &list)
{
    mExportLogTypeList = list;
}

QString LogExport::getDrivePath()
{
    if(mFile) {
        return mFile->getDrivePath();
    } else {
        return "";
    }
}

int LogExport::countData(QString type)
{
    QJsonObject jobjParam;
    jobjParam.insert("target", "all");
    jobjParam.insert("type", type);
    QJsonValue jvalue = mJsonParse->execJson("count_data", jobjParam);
    QJsonObject valObj = jvalue.toObject();
    int count = valObj.value("row").toInt();

    return count;
}

QString LogExport::translate(const QString &str)
{
    return mLogString->translate(str);
}

QString LogExport::trs(const QString &str)
{
    return mLogString->trs(str);
}

QString LogExport::exportLog2File(QString type, QString time)
{

    QString err = "Export logs failed.";
    QString typeName;
    if(type == "mculog.measure") {
        typeName = "measure";
    } else if(type == "mcucalib") {
        typeName = "calibration";
    } else if(type == "mcudiag") {
        typeName = "diagnosis";
    } else if(type == "mcuevent") {
        typeName = "event";
    } else if(type == "appop") {
        typeName = "appop";
    }

    QString filePath = mFile->getDrivePath()+"/AmtaxNA8000_"+typeName+"_"+time+".csv";
    QFile file(filePath);
    QString temp;
    QJsonArray jTypeArray;
    QJsonArray jTitleArray;
    QJsonArray jResultArray;

    qDebug() << "LogExport::exportMeasLogFile path: "+filePath;

    if(!file.open(QIODevice::ReadWrite)) {
        qDebug() << "LogExport::exportMeasLogFile create file error";
        file.close();
        return err;
    }

    // add BOM
    QByteArray ba;
    ba.append(0xEF);
    ba.append(0xBB);
    ba.append(0xBF);
    if(0 == file.write(ba))
    {
        qDebug() << "LogExport::exportMeasLogFile write file error";
        file.close();
        return err;
    }

    if(false == file.flush())
    {
        qDebug() << "LogExport::exportMeasLogFile flush file error";
        file.close();
        return err;
    }

    file.close();

    if(!file.open(QIODevice::ReadWrite | QIODevice::Append)) {
        qDebug() << "LogExport::exportMeasLogFile create file error";
        file.close();
        return err;
    }

    QTextStream out(&file);
    QStringList titleList;

#if 0
    if(type == "mculog.measure")
    {
        for(unsigned int i = 0; i < sizeof(mcuLogTitle)/sizeof(mcuLogTitle[0]); i++) {
            jTitleArray.append(mcuLogTitle[i]);
            titleList << tr(mcuLogTitle[i]);
        }
    } else if(type == "mcucalib") {
        for(unsigned int i = 0; i < sizeof(mcuCalibTitle)/sizeof(mcuCalibTitle[0]); i++) {
            jTitleArray.append(mcuCalibTitle[i]);
            titleList << tr(mcuCalibTitle[i]);
        }
    } else if(type == "mcudiag") {
        for(unsigned int i = 0; i < sizeof(mcuDiagTitle)/sizeof(mcuDiagTitle[0]); i++) {
            jTitleArray.append(mcuDiagTitle[i]);
            titleList << tr(mcuDiagTitle[i]);
        }
    } else if(type == "mcuevent") {
        for(unsigned int i = 0; i < sizeof(mcuEventTitle)/sizeof(mcuEventTitle[0]); i++) {
            jTitleArray.append(mcuEventTitle[i]);
            titleList << tr(mcuEventTitle[i]);
        }
    }
#endif

    QStringList tempList = mLogString->titleExp(type);

    foreach(const QString &str, tempList)
    {
        jTitleArray.append(str);
        titleList << trs(str);
    }

    if(titleList.length() == 0) {
        return err;
    }

    // output sn to file
    out << trs("SN")+ ", " + mSNBuff << "\n";

    // output title list to file
    QStringListIterator i(titleList);
    while(i.hasNext()) {
        temp = i.next();
        out << temp << ", ";
        if(QTextStream::WriteFailed == out.status())
        {
            qDebug() << "LogExport::exportMeasLogFile write file error";
            file.close();
            return err;
        }
    }
    out << "\n";

    QJsonObject jobjParam;
    jobjParam.insert("title", jTitleArray);
    jobjParam.insert("start", -1);
    jobjParam.insert("count", 20000);
    jTypeArray.append(type);
    jobjParam.insert("type", jTypeArray);
    jobjParam.insert("orderby", "lambda x: (datetime.datetime.strptime(x[2],'%Y-%m-%d %H:%M:%S'),x[1])");
    jobjParam.insert("desc", false);

    QJsonValue jResult = mJsonParse->execJson("read_data", jobjParam);

    QJsonObject valObj = jResult.toObject();
    jResultArray = valObj.value("table").toArray();

    foreach(const QJsonValue & ivalue, jResultArray) {
        //qDebug() << "LogExport::exportMeasLogFile" << ivalue;
        bool first = true;
        int count = 0;
        QString type;
        foreach (const QJsonValue & jvalue, ivalue.toArray()) {
            //qDebug() << "LogExport::exportMeasLogFile" << jvalue.toString();
            // ignore type
            if(first == true) {
                first = false;
                count = 0;
                type = jvalue.toString();
                continue;
            }

            if(type == "mculog.measure") {
                QString trStr = jvalue.toString();
                if(count == 17) { //measure_flag
                    trStr = translate(trStr);
                }
                out << trStr << ", ";
                if(QTextStream::WriteFailed == out.status())
                {
                    qDebug() << "LogExport::exportMeasLogFile write file error";
                    file.close();
                    return err;
                }
            } else if(type == "mcucalib") {
                QString trStr = jvalue.toString();
                if(count == 7) { //flag
                    trStr = translate(trStr);
                }
                out << trStr << ", ";
                if(QTextStream::WriteFailed == out.status())
                {
                    qDebug() << "LogExport::exportMeasLogFile write file error";
                    file.close();
                    return err;
                }
            } else if(type == "mcudiag") {
                QString trStr = jvalue.toString();
                if(count == 3 || count == 2 || count == 4) { //summery || type || detail
                    trStr = translate(trStr);
                }
                out << trStr << ", ";
                if(QTextStream::WriteFailed == out.status())
                {
                    qDebug() << "LogExport::exportMeasLogFile write file error";
                    file.close();
                    return err;
                }
            } else if(type == "mcuevent") {
                QString trStr = jvalue.toString();
                if(count == 2 ) { //summery
                    trStr = translate(trStr);
                }
                out << trStr << ", ";
                if(QTextStream::WriteFailed == out.status())
                {
                    qDebug() << "LogExport::exportMeasLogFile write file error";
                    file.close();
                    return err;
                }
            } else if(type == "appop") {
                QString trStr = jvalue.toString();
                if(count == 2 ) { //summery
                    trStr = translate(trStr);
                }
                out << trStr << ", ";
                if(QTextStream::WriteFailed == out.status())
                {
                    qDebug() << "LogExport::exportMeasLogFile write file error";
                    file.close();
                    return err;
                }
            }

            count++;
        }
        out << "\n";
        if(QTextStream::WriteFailed == out.status())
        {
            qDebug() << "LogExport::exportMeasLogFile write file error";
            file.close();
            return err;
        }
    }

    if(!file.flush()) {
        qDebug() << "LogExport::exportLog2File flush failed.";
        file.close();
        return err;
    }

    file.close();

    mFile->updateTime(filePath);

    sync();

    return QString("");
}

int LogExport::getDriveAvailableSize()
{
    int size;
    QString drive = mFile->getDrivePath();
    QStorageInfo storage(drive);

    if(storage.isReadOnly())
    {
        size = 0;
    } else {
        size = (int)storage.bytesAvailable(); //type of size is qint64, use the low 32 bits
        if(size == -1) { // QStorageInfo is not valid
            return size;
        }
        else if(size < -1) // exceed number of low 32 bits set
        {
            size = -size;
        }
    }

    return size;
}

void LogExport::run()
{
    int driveSize = getDriveAvailableSize();
    qDebug() << "LogExort::run drive avail size = " << driveSize;
    if(driveSize > 2000) // 2k
    {
        QDateTime currentDateTime = QDateTime::currentDateTime();
        QString currentDate = currentDateTime.toString("yyyy-MM-dd_hhmmss");
        mError = "";
        foreach (const QString & value, mExportLogTypeList) {
            mError = exportLog2File(value, currentDate);
            if(mError != "")
            {
                break;
            }
        }
    } else {
        mError = "No enough disk space.";
    }
}

QString LogExport::error()
{
    return mError;
}

bool LogExport::isIdle()
{
    return !this->isRunning();
}

bool LogExport::startProcess()
{
    if(!this->isRunning()) {
        this->start();
    } else {
        return false;
    }

    return true;
}
