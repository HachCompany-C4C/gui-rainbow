#ifndef TSCSV_H
#define TSCSV_H

#include <QObject>
#include <QDomDocument>
#include <QFile>
#include <QDebug>

class TsCsv : public QObject
{
    Q_OBJECT
public:
    explicit TsCsv(QObject *parent = 0);
    Q_INVOKABLE void csv2ts();
    Q_INVOKABLE void ts2csv();
    Q_INVOKABLE void ts2csvAll();

    Q_INVOKABLE void setLang(QString lang);
    Q_INVOKABLE void setFilter(QString str);
    Q_INVOKABLE void delFilter(QString str);
    bool checkFilter(QString mark);

    QString findTransText(QString pageName, QString source);
signals:

public slots:

private:
    QStringList mFilterList;
    QString mLang;
};

#endif // TSCSV_H
