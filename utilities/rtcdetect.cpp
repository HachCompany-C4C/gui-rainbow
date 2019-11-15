#include <QDebug>
#include <QFile>
#include "rtcdetect.h"
#include "socversion.h"

#define RTC_BAT_LOW_PIN_IMX6     67
#define RTC_BAT_FAIL_PIN_IMX6    76

#define RTC_BAT_LOW_PIN_IMX7     35
#define RTC_BAT_FAIL_PIN_IMX7    50

RtcDetect::RtcDetect(QQmlContext *context, QObject *parent) : QObject(parent)
{
    Q_ASSERT(context);

    context->setContextProperty("rtc_dectect", this);

    QString socDesc = SocVersion::getSocDescStatic();

    if(socDesc == "i.MX6DL") {
        mRtcLowPin = new Gpio(RTC_BAT_LOW_PIN_IMX6, "in");
        mRtcFailPin = new Gpio(RTC_BAT_FAIL_PIN_IMX6, "in");
    } else { //i.MX7D
        mRtcLowPin = new Gpio(RTC_BAT_LOW_PIN_IMX7, "in");
        mRtcFailPin = new Gpio(RTC_BAT_FAIL_PIN_IMX7, "in");
    }

    mPreErr = 0;
    mErr = 0;
}

// Bit1-RTC_BAT_LOW; Bit0-RTC_BAT_FAIL
int RtcDetect::rtcStatus()
{
    int ret = 0;
    if(mRtcFailPin->getValueDebounde() == 0)
    {
        ret = 0x1;
    }
    else if(mRtcLowPin->getValueDebounde() == 0)
    {
        ret = 0x2;
    }

    mErr = ret;

    //qDebug() << "RtcDetect::rtcStatus=" << ret;

    return ret;
}

bool RtcDetect::isRtcStatusChanged()
{
    bool ret = false;
    if(mPreErr != mErr)
    {
        ret = true;
        mPreErr = mErr;
    }

    return ret;
}
