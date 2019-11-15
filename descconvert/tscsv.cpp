#include "tscsv.h"
#include <QCoreApplication>

TsCsv::TsCsv(QObject *parent) : QObject(parent)
{
    mLang = "zh";
}

void TsCsv::csv2ts()
{
    QFile inputFile(QCoreApplication::applicationDirPath()+"/rainbow_"+mLang+".csv");
    if(!inputFile.open(QIODevice::ReadOnly | QFile::Text)) {
        qDebug() << "open zh_hans.csv failed";
        return;
    }

    QFile file(QCoreApplication::applicationDirPath()+"/rainbow_"+mLang+".ts");

    if(!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qDebug() << "open zh_hans.ts failed";
        return;
    }

    QTextStream out(&file);

    qDebug() << "rainbow_zh.csv";

    if(!inputFile.atEnd())
        inputFile.readLine();

    QString preDesc = "";

    while (!inputFile.atEnd())
    {
        QByteArray lineBa = inputFile.readLine();
        QList<QByteArray> listBa = lineBa.split(';');

        if(listBa.length() > 3) {
            QString code = QString(listBa[0]);
            QString desc = QString(listBa[1]);
            QString id = QString(listBa[2]);

            qDebug() << code << desc << id;

            if(code != "") {
                out << " ], //"+preDesc+"\n";
                out << "[ qsTr(\""+id+"\")+translator.tr";
                preDesc = desc;
            } else {
                out << ", qsTr(\""+id+"\")+translator.tr";
            }
        }
    }

    out << " ]";

    inputFile.close();
    file.close();

    qDebug() << "convert done";
}

void TsCsv::ts2csv()
{
    QFile outputFile(QCoreApplication::applicationDirPath()+"/rainbow_"+mLang+".csv");

    if(!outputFile.open(QIODevice::ReadWrite)) {
        qDebug() << "create file error";
        return;
    }
    // add BOM
    QByteArray ba;
    ba.append(0xEF);
    ba.append(0xBB);
    ba.append(0xBF);
    outputFile.write(ba);
    outputFile.close();

    outputFile.open(QIODevice::WriteOnly | QIODevice::Text);
    QTextStream out(&outputFile);
    out << "page name;" << "source;" << "translation;" << "comment;" << "mark;" << "\n";

    QString path = QCoreApplication::applicationDirPath()+"/rainbow_"+mLang+".ts";
    QFile inputFile(path);
    QDomDocument doc;
    doc.setContent(&inputFile);
    inputFile.close();
    QDomElement root = doc.documentElement();
    QDomNode n = root.firstChild();
    QString pagename;
    while (!n.isNull()) {
        QDomElement e = n.toElement();
        if(!e.isNull()) {
            QDomNode n1 = e.firstChild();
            if(!n1.isNull()) {
                QDomElement e1 = n1.toElement(); // name
                pagename = e1.text();
            }
            n1 = n1.nextSibling();
            while(!n1.isNull()) {
                QDomElement e1 = n1.toElement(); // message
                if(!e1.isNull()) {
                    QDomNode n2 = e1.firstChild();
                    QStringList attrList;

                    QString comment = "";
                    QString mark = "";
                    QString source = "";
                    QString translation = "";

                    while(!n2.isNull())
                    {
                        QDomElement e3 = n2.toElement();

                        if(e3.tagName() == "location") {
                            if(e3.hasAttribute("line")) {
                                attrList << e3.attributeNode("line").value();
                            }
                        } else if(e3.tagName() == "translatorcomment") {
                            comment = e3.text();
                        } else if(e3.tagName() == "source") {
                            source = e3.text();
                        } else if(e3.tagName() == "translation") {
                            if(e3.tagName() == "translation") {
                                translation = e3.text();
                                if(e3.hasAttribute("type")) {
                                    mark = e3.attribute("type", "");
                                }
                            }
                        }
                        n2 = n2.nextSibling();
                    }

                    if(checkFilter(mark)) {

                        out << pagename << ";";

                        out << source << ";";

                        out << translation << ";";

                        out << comment << ";";

                        out << mark << ";";

                        for(int i =0; i < attrList.length(); i++) {
                            out << attrList[i] << ";";
                        }

                        out << "\n";
                    }
                }
                n1 = n1.nextSibling();
            }
            n = n.nextSibling();
        }
    }

    outputFile.close();

    qDebug() << "convert done";
}

void TsCsv::setLang(QString lang)
{
    mLang = lang;
}

void TsCsv::setFilter(QString str)
{
    mFilterList << str;
}

void TsCsv::delFilter(QString str)
{
    for(int i = 0; i < mFilterList.length(); i++) {
        if(mFilterList[i] == str) {
            mFilterList.removeAt(i);
        }
    }
}

bool TsCsv::checkFilter(QString mark)
{
    bool ret = true;
    for(int i = 0; i < mFilterList.length(); i++) {
        if(mFilterList[i] == mark) {
            ret = false;
        }
    }

    return ret;
}

QString TsCsv::findTransText(QString pageName, QString source)
{
    QString path = QCoreApplication::applicationDirPath()+"/rainbow_en.ts";
    QFile inputFile(path);
    QDomDocument doc;
    doc.setContent(&inputFile);
    inputFile.close();
    QDomElement root = doc.documentElement();
    QDomNode n = root.firstChild();
    QString name;
    QString mark;
    while (!n.isNull()) {
        QDomElement e = n.toElement();
        if(!e.isNull()) {
            QDomNode n1 = e.firstChild();
            if(!n1.isNull()) {
                QDomElement e1 = n1.toElement(); // name
                name = e1.text();
                if(name != pageName) {
                    continue;
                }
                qDebug() << "find name: "+name;
            }
            n1 = n1.nextSibling();
            while(!n1.isNull()) {
                QDomElement e1 = n1.toElement(); // message
                if(!e1.isNull()) {
                    QDomNode n2 = e1.firstChild();
                    QStringList attrList;
                    QString translationText;
                    bool findSource = false;
                    while(!n2.isNull()) {
                        QDomElement e3 = n2.toElement();
                        if(e3.hasAttribute("line")) {
                            attrList << e3.attributeNode("line").value();
                        } else if(e3.tagName() == "source") {
                            QString text = e3.text();
                            if(text == source) {
                                findSource = true;
                                qDebug() << "find source: " + source;
                            }

                        } else {
                            if(e3.tagName() == "translation") {
                                if(e3.hasAttribute("type")) {
                                    mark = e3.attribute("type", "");
                                }
                                if(findSource) {
                                    translationText = e.text();
                                    return translationText;
                                }
                            }
                        }
                        n2 = n2.nextSibling();
                    }
                }
                n1 = n1.nextSibling();
            }
            n = n.nextSibling();
        }
    }

    return "";
}

void TsCsv::ts2csvAll()
{
    QFile outputFile(QCoreApplication::applicationDirPath()+"/rainbow_zh.csv");

    if(!outputFile.open(QIODevice::ReadWrite)) {
        qDebug() << "create file error";
        return;
    }
    // add BOM
    QByteArray ba;
    ba.append(0xEF);
    ba.append(0xBB);
    ba.append(0xBF);
    outputFile.write(ba);
    outputFile.close();

    outputFile.open(QIODevice::WriteOnly | QIODevice::Text | QIODevice::Append);
    QTextStream out(&outputFile);
    out << "page name;" << "source;" << "translation;" << "comment;" << "mark;" << "\n";

    QString path = QCoreApplication::applicationDirPath()+"/rainbow_zh.ts";
    QFile inputFile(path);
    QDomDocument doc;
    doc.setContent(&inputFile);
    inputFile.close();
    QDomElement root = doc.documentElement();
    QDomNode n = root.firstChild();
    QString name;
    QString source;
    QString comment;
    QString mark;
    while (!n.isNull()) {
        QDomElement e = n.toElement();
        //qDebug() << e.nodeName() << e.text();
        if(!e.isNull()) {
            QDomNode n1 = e.firstChild();
            if(!n1.isNull()) {
                QDomElement e1 = n1.toElement(); // name
                qDebug() << e1.text();
                name = e1.text();
            }
            n1 = n1.nextSibling();
            while(!n1.isNull()) {
                QDomElement e1 = n1.toElement(); // message
                if(!e1.isNull()) {
                    QDomNode n2 = e1.firstChild();
                    QStringList attrList;
                    out << name << ";";

                    while(!n2.isNull()) {
                        QDomElement e3 = n2.toElement();
                        if(e3.hasAttribute("line")) {
                            attrList << e3.attributeNode("line").value();
                        } else if(e3.tagName() == "translatorcomment") {
                            comment = e3.text();
                        } else if(e3.tagName() == "source"){
                            source = e3.text();
                        } else {
                            qDebug() << "        " << e3.text();
                            out << e3.text() << ";";
                            if(e3.tagName() == "translation") {
                                if(e3.hasAttribute("type")) {
                                    mark = e3.attribute("type", "");
                                }
                            }
                        }
                        n2 = n2.nextSibling();
                    }
                    qDebug() << "name << " << name << source;
                    out << findTransText(name, source) << ";";

                    out << comment << ";";

                    out << mark << ";";

                    for(int i =0; i < attrList.length(); i++) {
                        qDebug() << "        " << attrList[i];
                        out << attrList[i] << ";";
                    }

                    out << "\n";
                }
                n1 = n1.nextSibling();
            }
            n = n.nextSibling();
        }
    }

    outputFile.close();
}
