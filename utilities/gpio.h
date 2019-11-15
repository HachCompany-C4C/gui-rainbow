#ifndef GPIO_H
#define GPIO_H

#include <QObject>

class Gpio : public QObject
{
    Q_OBJECT
public:
    Gpio(QObject *parent = 0);
    Gpio(int pin = 0, QString direct = "in", QObject *parent = 0);
    static bool exportFd(int pin);
    static bool setDirection(int pin, QString direct);
    static bool setValue(int pin, int val);
    static QString direction(int pin);
    static int getValue(int pin);

    int getValueDebounde();
signals:

public slots:

private:
    int mLevel;
    int mPreLevel;
    int mPin;
    int mDeboundeTimes;
};

#endif // GPIO_H
