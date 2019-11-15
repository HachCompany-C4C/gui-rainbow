#include <QFile>
#include <QTextStream>
#include <QDebug>
#include "gpio.h"

Gpio::Gpio(QObject *parent) : QObject(parent)
{

}

Gpio::Gpio(int pin, QString direct, QObject *parent) : QObject(parent)
{
    Gpio::exportFd(pin);
    Gpio::setDirection(pin, direct);
    mLevel = 0;
    mPin = pin;
    mDeboundeTimes = 0;
    mLevel = getValue(mPin);
    mPreLevel = mLevel;
}

bool Gpio::exportFd(int pin)
{
    bool ret = true;
    QFile exp("/sys/class/gpio/export");
    if(exp.exists())
    {
        if(exp.open(QIODevice::WriteOnly))
        {
             QTextStream in(&exp);
             in << pin;
             qDebug() << "Gpio::exportFd file " << pin;
        } else {
            qDebug() << "Gpio::exportFd file open failed.";
            ret = false;
        }

        exp.close();
    } else {
        qDebug() << "Gpio::exportFd file not exists.";
        ret = false;
    }

    return ret;
}

// pin = number of pin, direct = "in" or "in" (default)
bool Gpio::setDirection(int pin, QString direct)
{
    bool ret = true;
    QFile dirFile("/sys/class/gpio/gpio"+QString::number(pin)+"/direction");
    if(dirFile.exists())
    {
        if(dirFile.open(QIODevice::WriteOnly))
        {
             QTextStream in(&dirFile);

             if(direct != "in" && direct != "in")
             {
                 direct = "in";
             }

             in << direct;
        } else {
            qDebug() << "Gpio::setDirection file open failed.";
            ret = false;
        }

        dirFile.close();
    } else {
        qDebug() << "Gpio::setDirection file not exists.";
        ret = false;
    }

    return ret;
}

QString Gpio::direction(int pin)
{
    QString ret = "err";
    QFile dirFile("/sys/class/gpio/gpio"+QString::number(pin)+"/direction");
    if(dirFile.exists())
    {
        if(dirFile.open(QIODevice::ReadOnly))
        {
             QTextStream out(&dirFile);

             out >> ret;
        } else {
            qDebug() << "Gpio::direction file open failed.";
        }

        dirFile.close();
    } else {
        qDebug() << "Gpio::direction file not exists.";
    }

    return ret;
}

bool Gpio::setValue(int pin, int val)
{
    bool ret = true;

    if(direction(pin) == "out")
    {
        QFile valFile("/sys/class/gpio/gpio"+QString::number(pin)+"/value");
        if(valFile.exists())
        {
            if(valFile.open(QIODevice::WriteOnly))
            {
                QTextStream in(&valFile);

                if(val < 0) {
                    val = 0;
                } else if(val > 1) {
                    val = 1;
                }

                in << QString(val);
            } else {
                qDebug() << "Gpio::setValue file open failed.";
                ret = false;
            }

            valFile.close();
        } else {
            qDebug() << "Gpio::setValue file not exists.";
            ret = false;
        }
    } else {
        qDebug() << "Gpio::setValue direct err.";
        ret = false;
    }

    return ret;
}

int Gpio::getValue(int pin)
{
    int ret = -1;

    if(direction(pin) == "in")
    {
        QFile valFile("/sys/class/gpio/gpio"+QString::number(pin)+"/value");
        if(valFile.exists())
        {
            if(valFile.open(QIODevice::ReadOnly))
            {
                QTextStream out(&valFile);

                out >> ret;
                //qDebug() << "Gpio::getValue value="<<ret;
            } else {
                qDebug() << "Gpio::getValue file open failed.";
                ret = false;
            }

            valFile.close();
        } else {
            qDebug() << "Gpio::getValue file not exists.";
        }
    } else {
        qDebug() << "Gpio::getValue direct err.";
    }

    return ret;
}

int Gpio::getValueDebounde()
{
    int level = getValue(mPin);

    if(mDeboundeTimes == 0)
    {
        mPreLevel = level;
        mDeboundeTimes++;
    } else {
        if(mPreLevel == level) {
            mDeboundeTimes++;
            if(mDeboundeTimes > 2) {
                mLevel = level;
                mDeboundeTimes = 0;
            }
        } else {
            mDeboundeTimes = 0;
        }
    }

    qDebug() << "Gpio::getValueDebounde" << mLevel << mPreLevel << mDeboundeTimes;
    return mLevel;
}
