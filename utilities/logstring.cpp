/****************************************************************************
** logstring.cpp - Log string definition
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

#include "logstring.h"

static const char* sn = QT_TRANSLATE_NOOP("LogString", "SN");

static const char* logTypeListLogList[] = {
    QT_TRANSLATE_NOOP("LogString", "mculog.measure"),
    QT_TRANSLATE_NOOP("LogString", "mcucalib"),
    QT_TRANSLATE_NOOP("LogString", "mcudiag"),
    QT_TRANSLATE_NOOP("LogString", "mcuevent"),
    QT_TRANSLATE_NOOP("LogString", "appop")
};

static const char* eventLogDesc[] = {
    QT_TRANSLATE_NOOP("LogString", "EV_SCH_STOP"),
    QT_TRANSLATE_NOOP("LogString", "EV_FLUSH"),
    QT_TRANSLATE_NOOP("LogString", "EV_PRIME"),
    QT_TRANSLATE_NOOP("LogString", "EV_DRAIN"),
    QT_TRANSLATE_NOOP("LogString", "EV_FLOWSTEP"),
    QT_TRANSLATE_NOOP("LogString", "EV_SCH_START"),
    QT_TRANSLATE_NOOP("LogString", "EV_DIA_CLR"),
    QT_TRANSLATE_NOOP("LogString", "EV_DIA_SET"),
    QT_TRANSLATE_NOOP("LogString", "EV_RESET"),
    QT_TRANSLATE_NOOP("LogString", "EV_DIAG_INFO"),
    QT_TRANSLATE_NOOP("LogString", "EV_DIAG_WARN"),
    QT_TRANSLATE_NOOP("LogString", "EV_DIAG_ERR"),
    QT_TRANSLATE_NOOP("LogString", "EV_CALIBRATION"),
    QT_TRANSLATE_NOOP("LogString", "EV_CLEANING"),
    QT_TRANSLATE_NOOP("LogString", "EV_MEASURE"),
    QT_TRANSLATE_NOOP("LogString", "EV_CALC_GAIN"),
    QT_TRANSLATE_NOOP("LogString", "EV_CMD_PUT_OBJ"),
    QT_TRANSLATE_NOOP("LogString", "EV_CMD_PUT_MEM"),
    QT_TRANSLATE_NOOP("LogString", "EV_FAKE_TEST"),
    QT_TRANSLATE_NOOP("LogString", "EV_CFG_RESET"),
    QT_TRANSLATE_NOOP("LogString", "EV_SW_UPGRADE"),
    QT_TRANSLATE_NOOP("LogString", "EV_RTC_UPDATE"),
    QT_TRANSLATE_NOOP("LogString", "EV_INIT01"),
    QT_TRANSLATE_NOOP("LogString", "EV_INIT02"),
    QT_TRANSLATE_NOOP("LogString", "EV_AUTO_RANGE_REQ"),
    QT_TRANSLATE_NOOP("LogString", "EV_ACT_STOP"),
    QT_TRANSLATE_NOOP("LogString", "EV_ACT_START"),
    QT_TRANSLATE_NOOP("LogString", "EV_FACTORY_RESET"),
    QT_TRANSLATE_NOOP("LogString", "EV_POWERDRAIN")
};

static const char* diagLogDesc[] = {
    QT_TRANSLATE_NOOP("LogString", "USB_WRITE_FAILURE"),
    QT_TRANSLATE_NOOP("LogString", "LOCAL_COMMUNICATION_ERR"),
    QT_TRANSLATE_NOOP("LogString", "LED_OUTPUT_LOW"),
    QT_TRANSLATE_NOOP("LogString", "NO_SAMPLE_FLOW"),
    QT_TRANSLATE_NOOP("LogString", "HEAT_OUT_CTRL"),
    QT_TRANSLATE_NOOP("LogString", "DOOR_OPEN"),
    QT_TRANSLATE_NOOP("LogString", "AD_SPI_FAILURE"),
    QT_TRANSLATE_NOOP("LogString", "FLASH_FAILURE"),
    QT_TRANSLATE_NOOP("LogString", "EEPROM_ERROR"),
    QT_TRANSLATE_NOOP("LogString", "MEASURE_OUT_WORK_RANGE"),
    QT_TRANSLATE_NOOP("LogString", "POWER_FAILURE"),
    QT_TRANSLATE_NOOP("LogString", "VOLT_OUT_RANGE"),
    QT_TRANSLATE_NOOP("LogString", "HEATER_SENSOR_FAILURE"),
    QT_TRANSLATE_NOOP("LogString", "CASE_TEMP_WARNING"),
    QT_TRANSLATE_NOOP("LogString", "FAILED_CALIBRATION"),
    QT_TRANSLATE_NOOP("LogString", "LEAKAGE_WARNING"),
    QT_TRANSLATE_NOOP("LogString", "CHECK_OPTICS"),
    QT_TRANSLATE_NOOP("LogString", "SAMPLE_IN_EXECPTION"),
    QT_TRANSLATE_NOOP("LogString", "CURRENT_ERROR"),
    QT_TRANSLATE_NOOP("LogString", "ALARM_LOW"),
    QT_TRANSLATE_NOOP("LogString", "ALARM_HIGH"),
    QT_TRANSLATE_NOOP("LogString", "REAGNET_EMPTY_A"),
    QT_TRANSLATE_NOOP("LogString", "REAGNET_EMPTY_B"),
    QT_TRANSLATE_NOOP("LogString", "REAGNET_EMPTY_C"),
    QT_TRANSLATE_NOOP("LogString", "STD_EMPTY_0"),
    QT_TRANSLATE_NOOP("LogString", "STD_EMPTY_1"),
    QT_TRANSLATE_NOOP("LogString", "STD_EMPTY_2"),
    QT_TRANSLATE_NOOP("LogString", "CLEANING_EMPTY"),
    QT_TRANSLATE_NOOP("LogString", "REAGNET_LOW_A"),
    QT_TRANSLATE_NOOP("LogString", "REAGNET_LOW_B"),
    QT_TRANSLATE_NOOP("LogString", "REAGNET_LOW_C"),
    QT_TRANSLATE_NOOP("LogString", "STD_LOW_0"),
    QT_TRANSLATE_NOOP("LogString", "STD_LOW_1"),
    QT_TRANSLATE_NOOP("LogString", "STD_LOW_2"),
    QT_TRANSLATE_NOOP("LogString", "CLEANING_LOW"),
    QT_TRANSLATE_NOOP("LogString", "LIFESPAN_TUBING_VALVE"),
    QT_TRANSLATE_NOOP("LogString", "LIFESPAN_TUBING_PUMP"),
    QT_TRANSLATE_NOOP("LogString", "LIFESPAN_MOTOR_PUMP1"),
    QT_TRANSLATE_NOOP("LogString", "LIFESPAN_MOTOR_PUMP2"),
    QT_TRANSLATE_NOOP("LogString", "LIFESPAN_MOTOR_PUMP3"),
    QT_TRANSLATE_NOOP("LogString", "LIFESPAN_MOTOR_MIX"),
    QT_TRANSLATE_NOOP("LogString", "RTC_ALARM"),
    QT_TRANSLATE_NOOP("LogString", "LED_ERROR"),
    QT_TRANSLATE_NOOP("LogString", "CANOPEN_WARNING"),
    QT_TRANSLATE_NOOP("LogString", "CANOPEN_ERROR"),
    QT_TRANSLATE_NOOP("LogString", "CANOPEN_ER_CONNECT"),
    QT_TRANSLATE_NOOP("LogString", "CANOPEN_ER_CONFIG"),
    QT_TRANSLATE_NOOP("LogString", "FIX_RANGE_WARNING")
};

static const char* diagLogDetail[] = {
    QT_TRANSLATE_NOOP("LogString", "LED_OUT_LOW"),
    QT_TRANSLATE_NOOP("LogString", "LED_ERROR"),
    QT_TRANSLATE_NOOP("LogString", "CABLE_FAIL")
    QT_TRANSLATE_NOOP("LogString", "LOW_POWER"),
    QT_TRANSLATE_NOOP("LogString", "HIGH_POWER"),
    QT_TRANSLATE_NOOP("LogString", "HEAT_SENS_HIGH"),
    QT_TRANSLATE_NOOP("LogString", "HEAT_SENS_LOW"),
    QT_TRANSLATE_NOOP("LogString", "PEEK_SENS_HIGH"),
    QT_TRANSLATE_NOOP("LogString", "PEEK_SENS_LOW"),
    QT_TRANSLATE_NOOP("LogString", "ENV_SENS_HIGH"),
    QT_TRANSLATE_NOOP("LogString", "ENV_SENS_LOW"),
    QT_TRANSLATE_NOOP("LogString", "CASE_TEMP_HIGH"),
    QT_TRANSLATE_NOOP("LogString", "CASE_TEMP_LOW"),
    QT_TRANSLATE_NOOP("LogString", "HEAT_OUT_HIGH"),
    QT_TRANSLATE_NOOP("LogString", "HEAT_OUT_LOW"),
    QT_TRANSLATE_NOOP("LogString", "LOPTICS_OUT_LMT"),
    QT_TRANSLATE_NOOP("LogString", "SOPTICS_OUT_LMT"),
    QT_TRANSLATE_NOOP("LogString", "LOPTICS_INVALID"),
    QT_TRANSLATE_NOOP("LogString", "SOPTICS_INVALID"),
    QT_TRANSLATE_NOOP("LogString", "P1TUB_LIFESPAN"),
    QT_TRANSLATE_NOOP("LogString", "P2TUB_LIFESPAN"),
    QT_TRANSLATE_NOOP("LogString", "P3TUB_LIFESPAN"),
    QT_TRANSLATE_NOOP("LogString", "P4TUB_LIFESPAN"),
    QT_TRANSLATE_NOOP("LogString", "MCU_RTC"),
    QT_TRANSLATE_NOOP("LogString", "HMI_RTC"),
    QT_TRANSLATE_NOOP("LogString", "LOW_BAT"),
    QT_TRANSLATE_NOOP("LogString", "NO_BAT")
};

static const char* measLogFlag[] = {
    QT_TRANSLATE_NOOP("LogString", "FLAG_MEA_MEAS"),
    QT_TRANSLATE_NOOP("LogString", "FLAG_MEA_TRIG"),
    QT_TRANSLATE_NOOP("LogString", "FLAG_MEA_OFFLINE"),
    QT_TRANSLATE_NOOP("LogString", "FLAG_MEA_ONLINE"),
    QT_TRANSLATE_NOOP("LogString", "FLAG_MEA_STD0"),
    QT_TRANSLATE_NOOP("LogString", "FLAG_MEA_STD1"),
    QT_TRANSLATE_NOOP("LogString", "FLAG_CALI_STD0"),
    QT_TRANSLATE_NOOP("LogString", "FLAG_CALI_STD1"),
    QT_TRANSLATE_NOOP("LogString", "FLAG_CALI_STATUS_ER"),
    QT_TRANSLATE_NOOP("LogString", "FLAG_CALI_STATUS_OK"),
    QT_TRANSLATE_NOOP("LogString", "FLAG_MEA_AUTORANGE_REQ"),
    QT_TRANSLATE_NOOP("LogString", "FLAG_RETRY_MAX")
};

static const char* calibLogFlag[] = {
    QT_TRANSLATE_NOOP("LogString", "VALID_CALIBRATION"),
    QT_TRANSLATE_NOOP("LogString", "INVALID_CALIBRATION"),
    QT_TRANSLATE_NOOP("LogString", "SCHEDULE_CALIBRATION"),
    QT_TRANSLATE_NOOP("LogString", "TRIGGER_CALIBRAION"),
    QT_TRANSLATE_NOOP("LogString", "AUTORANGE_CALIBRATION")
};

static const char* mcuLogTitle[] = {
    QT_TRANSLATE_NOOP("LogString", "ID"),
    QT_TRANSLATE_NOOP("LogString", "mculog.measure.time"),
    QT_TRANSLATE_NOOP("LogString", "mculog.measure.range_index"),
    QT_TRANSLATE_NOOP("LogString", "mculog.measure.concentration"),
    QT_TRANSLATE_NOOP("LogString", "mculog.measure.s660"),
    QT_TRANSLATE_NOOP("LogString", "mculog.measure.l660"),
    QT_TRANSLATE_NOOP("LogString", "mculog.measure.s880"),
    QT_TRANSLATE_NOOP("LogString", "mculog.measure.l880"),
    QT_TRANSLATE_NOOP("LogString", "mculog.measure.calibtime"),
    QT_TRANSLATE_NOOP("LogString", "mculog.measure.calibslop"),
    QT_TRANSLATE_NOOP("LogString", "mculog.measure.caliboffs"),
    QT_TRANSLATE_NOOP("LogString", "mculog.measure.temperature1"),
    QT_TRANSLATE_NOOP("LogString", "mculog.measure.temperature2"),
    QT_TRANSLATE_NOOP("LogString", "mculog.measure.temperature3"),
    QT_TRANSLATE_NOOP("LogString", "mculog.measure.temperature4"),
    QT_TRANSLATE_NOOP("LogString", "mculog.measure.measure_flag")
};

static const char* mcuLogTitleExp[] = {
    QT_TRANSLATE_NOOP("LogString", "ID"),
    QT_TRANSLATE_NOOP("LogString", "mculog.measure.time"),
    QT_TRANSLATE_NOOP("LogString", "mculog.measure.range_index"),
    QT_TRANSLATE_NOOP("LogString", "mculog.measure.concentration"),
    QT_TRANSLATE_NOOP("LogString", "mculog.measure.adapter_factor"),
    QT_TRANSLATE_NOOP("LogString", "mculog.measure.adapter_offset"),
    QT_TRANSLATE_NOOP("LogString", "mculog.measure.l660"),
    QT_TRANSLATE_NOOP("LogString", "mculog.measure.l880"),
    QT_TRANSLATE_NOOP("LogString", "mculog.measure.s660"),
    QT_TRANSLATE_NOOP("LogString", "mculog.measure.s880"),
    QT_TRANSLATE_NOOP("LogString", "mculog.measure.calibtime"),
    QT_TRANSLATE_NOOP("LogString", "mculog.measure.temperature1"),
    QT_TRANSLATE_NOOP("LogString", "mculog.measure.temperature2"),
    QT_TRANSLATE_NOOP("LogString", "mculog.measure.temperature3"),
    QT_TRANSLATE_NOOP("LogString", "mculog.measure.temperature4"),
    QT_TRANSLATE_NOOP("LogString", "mculog.measure.calibslop"),
    QT_TRANSLATE_NOOP("LogString", "mculog.measure.caliboffs"),
    QT_TRANSLATE_NOOP("LogString", "mculog.measure.measure_flag"),
    QT_TRANSLATE_NOOP("LogString", "mculog.measure.blank_s"),
    QT_TRANSLATE_NOOP("LogString", "mculog.measure.blank_l"),
};

static const char* mcuCalibTitle[] = {
    QT_TRANSLATE_NOOP("LogString", "ID"),
    QT_TRANSLATE_NOOP("LogString", "mcucalib.time"),
    QT_TRANSLATE_NOOP("LogString", "mcucalib.range_index"),
    QT_TRANSLATE_NOOP("LogString", "mcucalib.slope0"),
    QT_TRANSLATE_NOOP("LogString", "mcucalib.offset0"),
    QT_TRANSLATE_NOOP("LogString", "mcucalib.slope1"),
    QT_TRANSLATE_NOOP("LogString", "mcucalib.offset1"),
    QT_TRANSLATE_NOOP("LogString", "mcucalib.calib_status"),
    QT_TRANSLATE_NOOP("LogString", "mcucalib.time2"),
    QT_TRANSLATE_NOOP("LogString", "mcucalib.calibtimes0"),
    QT_TRANSLATE_NOOP("LogString", "mcucalib.l660"),
    QT_TRANSLATE_NOOP("LogString", "mcucalib.l880"),
    QT_TRANSLATE_NOOP("LogString", "mcucalib.s660"),
    QT_TRANSLATE_NOOP("LogString", "mcucalib.s880"),
    QT_TRANSLATE_NOOP("LogString", "mcucalib.temperature1"),
    QT_TRANSLATE_NOOP("LogString", "mcucalib.temperature2"),
    QT_TRANSLATE_NOOP("LogString", "mcucalib.temperature3"),
    QT_TRANSLATE_NOOP("LogString", "mcucalib.temperature4"),
    QT_TRANSLATE_NOOP("LogString", "mcucalib.time3"),
    QT_TRANSLATE_NOOP("LogString", "mcucalib.calibtimes1"),
    QT_TRANSLATE_NOOP("LogString", "mcucalib.l660_2"),
    QT_TRANSLATE_NOOP("LogString", "mcucalib.l880_2"),
    QT_TRANSLATE_NOOP("LogString", "mcucalib.s660_2"),
    QT_TRANSLATE_NOOP("LogString", "mcucalib.s880_2"),
    QT_TRANSLATE_NOOP("LogString", "mcucalib.temperature1_2"),
    QT_TRANSLATE_NOOP("LogString", "mcucalib.temperature2_2"),
    QT_TRANSLATE_NOOP("LogString", "mcucalib.temperature3_2"),
    QT_TRANSLATE_NOOP("LogString", "mcucalib.temperature4_2"),
};

static const char* mcuDiagTitle[] = {
    QT_TRANSLATE_NOOP("LogString", "ID"),
    QT_TRANSLATE_NOOP("LogString", "mcudiag.time"),
    QT_TRANSLATE_NOOP("LogString", "mcudiag.type"),
    QT_TRANSLATE_NOOP("LogString", "mcudiag.summary"),
    QT_TRANSLATE_NOOP("LogString", "mcudiag.detail")
};

static const char* mcuEventTitle[] = {
    QT_TRANSLATE_NOOP("LogString", "ID"),
    QT_TRANSLATE_NOOP("LogString", "mcuevent.time"),
    QT_TRANSLATE_NOOP("LogString", "mcuevent.summary")
};

static const char* appopTitle[] = {
    QT_TRANSLATE_NOOP("LogString", "ID"),
    QT_TRANSLATE_NOOP("LogString", "appop.time"),
    //QT_TRANSLATE_NOOP("LogString", "appop.summary"),
    QT_TRANSLATE_NOOP("LogString", "appop.detail"),
    QT_TRANSLATE_NOOP("LogString", "appop.user"),
    QT_TRANSLATE_NOOP("LogString", "appop.previous"),
    QT_TRANSLATE_NOOP("LogString", "appop.post"),
};

static const char*  mcuEventSubStep[] = {
    QT_TRANSLATE_NOOP("LogString", "MAINSTEP"),
    QT_TRANSLATE_NOOP("LogString", "SUBSTEP")
};

static const char*  appopLogDetail[] = {
    QT_TRANSLATE_NOOP("LogString", "SET"),
    QT_TRANSLATE_NOOP("LogString", "RANGE"),
    QT_TRANSLATE_NOOP("LogString", "FACTOR"),
    QT_TRANSLATE_NOOP("LogString", "OFFSET"),
    QT_TRANSLATE_NOOP("LogString", "user:"),
    QT_TRANSLATE_NOOP("LogString", "pre:"),
    QT_TRANSLATE_NOOP("LogString", "post:"),
    QT_TRANSLATE_NOOP("LogString", "usr1"),
    QT_TRANSLATE_NOOP("LogString", "usr2"),
    QT_TRANSLATE_NOOP("LogString", "usr3"),
    QT_TRANSLATE_NOOP("LogString", "usr4"),
    QT_TRANSLATE_NOOP("LogString", "usr5"),
    QT_TRANSLATE_NOOP("LogString", "auto"),
    QT_TRANSLATE_NOOP("LogString", "ULR"),
    QT_TRANSLATE_NOOP("LogString", "LR"),
    QT_TRANSLATE_NOOP("LogString", "MR"),
    QT_TRANSLATE_NOOP("LogString", "HR")
};

LogString::LogString(QQmlContext *context, QObject *parent) : QObject (parent)
{
    Q_UNUSED(sn);
    Q_UNUSED(logTypeListLogList);
    Q_UNUSED(eventLogDesc);
    Q_UNUSED(diagLogDesc);
    Q_UNUSED(measLogFlag);
    Q_UNUSED(calibLogFlag);
    Q_UNUSED(mcuEventSubStep);
    Q_UNUSED(diagLogDetail);
    Q_UNUSED(appopLogDetail);

    Q_ASSERT(context);
    context->setContextProperty("log_string", this);
}

QStringList LogString::title(const QString &type)
{
    QStringList titleList;
    if(type == "mculog.measure")
    {
        for(unsigned int i = 0; i < sizeof(mcuLogTitle)/sizeof(mcuLogTitle[0]); i++) {
            titleList << mcuLogTitle[i];
        }
    } else if(type == "mcucalib") {
        for(unsigned int i = 0; i < sizeof(mcuCalibTitle)/sizeof(mcuCalibTitle[0]); i++) {
            titleList << mcuCalibTitle[i];
        }
    } else if(type == "mcudiag") {
        for(unsigned int i = 0; i < sizeof(mcuDiagTitle)/sizeof(mcuDiagTitle[0]); i++) {
            titleList << mcuDiagTitle[i];
        }
    } else if(type == "mcuevent") {
        for(unsigned int i = 0; i < sizeof(mcuEventTitle)/sizeof(mcuEventTitle[0]); i++) {
            titleList << mcuEventTitle[i];
        }
    } else if(type == "appop") {
        for(unsigned int i = 0; i < sizeof(appopTitle)/sizeof(appopTitle[0]); i++) {
            titleList << appopTitle[i];
        }
    }

    return titleList;
}

QStringList LogString::titleExp(const QString &type)
{
    QStringList titleList;
    if(type == "mculog.measure")
    {
        for(unsigned int i = 0; i < sizeof(mcuLogTitleExp)/sizeof(mcuLogTitleExp[0]); i++) {
            titleList << mcuLogTitleExp[i];
        }
    } else if(type == "mcucalib") {
        for(unsigned int i = 0; i < sizeof(mcuCalibTitle)/sizeof(mcuCalibTitle[0]); i++) {
            titleList << mcuCalibTitle[i];
        }
    } else if(type == "mcudiag") {
        for(unsigned int i = 0; i < sizeof(mcuDiagTitle)/sizeof(mcuDiagTitle[0]); i++) {
            titleList << mcuDiagTitle[i];
        }
    } else if(type == "mcuevent") {
        for(unsigned int i = 0; i < sizeof(mcuEventTitle)/sizeof(mcuEventTitle[0]); i++) {
            titleList << mcuEventTitle[i];
        }
    } else if(type == "appop") {
        for(unsigned int i = 0; i < sizeof(appopTitle)/sizeof(appopTitle[0]); i++) {
            titleList << appopTitle[i];
        }
    }

    return titleList;
}

QString LogString::translate(const QString &string)
{
    QByteArray ba;
    const char *str;
    QString trStr = "";

    if(string != "")
    {
        QStringList bkList = string.split(" ");
        foreach (const QString & j, bkList)
        {
            ba = j.toLatin1();
            str = ba.data();
            trStr += tr(str)+" ";
        }
    }

    return trStr;
}

QString LogString::trs(const QString &string)
{
    QByteArray ba;
    const char *str;
    ba = string.toLatin1();
    str = ba.data();

    return tr(str);
}

QString LogString::translateEx(const QString &string, int begin, int end)
{
    QByteArray ba;
    const char *str;
    QString trStr = "";

    if(string != "") {
        QStringList bklist = string.split(" ");

        int len = bklist.length();
        if(begin > end)
            return "";
        if(end > (len - 1))
            end = len - 1;

        for(int j = begin; j < end; j++)
        {
            QString tmpStr = bklist[j];
            ba = tmpStr.toLatin1();
            str = ba.data();
            trStr += tr(str)+" ";
        }
    }

    return trStr;
}

LogString::~LogString()
{

}
