#ifndef RTCDETECT_H
#define RTCDETECT_H

#include <QObject>
#include <QQmlContext>
#include "gpio.h"

class RtcDetect : public QObject
{
    Q_OBJECT
public:
    explicit RtcDetect(QQmlContext *context, QObject *parent = 0);
    Q_INVOKABLE int rtcStatus();
    Q_INVOKABLE bool isRtcStatusChanged();
signals:

public slots:

private:
    int mErr;
    int mPreErr;
    Gpio *mRtcLowPin;
    Gpio *mRtcFailPin;
    QString mSocDesc;
};

#endif // RTCDETECT_H
