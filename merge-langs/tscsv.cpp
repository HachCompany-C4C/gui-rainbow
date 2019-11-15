#include "tscsv.h"
#include <QCoreApplication>

TsCsv::TsCsv(QObject *parent) : QObject(parent)
{
    mLang = "zh";
}

QStringList TsCsv::findLengthInMerge(QFile &file, QString pageName, QString keyName)
{
    QStringList list;

    while (!file.atEnd()) {
        QByteArray lineBa = file.readLine();
        QList<QByteArray> listBa = lineBa.split(';');
        QByteArray page = listBa[0];
        QByteArray key = listBa[1];

        if(page == pageName && page != "") {
            if(key == keyName && key != "") {
                list << listBa[3] << listBa[5];
                break;
            }
        }
    }

    return list;
}

void TsCsv::mergeCsv()
{
    system("cp lang_merge.csv lang_merge_old.csv");

    QFile zhCsv(QCoreApplication::applicationDirPath()+"/rainbow_zh.csv");
    if(!zhCsv.open(QIODevice::ReadOnly | QFile::Text)) {
        qDebug() << "open rainbow_zh.csv failed";
        return;
    }
    QFile enCsv(QCoreApplication::applicationDirPath()+"/rainbow_en.csv");
    if(!enCsv.open(QIODevice::ReadOnly | QFile::Text)) {
        qDebug() << "open rainbow_en.csv failed";
        return;
    }
    QFile outCsv(QCoreApplication::applicationDirPath()+"/lang_merge.csv");
    if(!outCsv.open(QIODevice::WriteOnly | QFile::Text)) {
        qDebug() << "open out.csv failed";
        return;
    }
    QFile oldmergeCsv(QCoreApplication::applicationDirPath()+"/lang_merge_old.csv");
    if(!oldmergeCsv.open(QIODevice::ReadWrite | QFile::Text)) {
        qDebug() << "open oldmergeCsv.csv failed";
        return;
    }

    QTextStream out(&outCsv);

    zhCsv.readLine();
    out << "page name; source; zh translation; zh trans length; en translation; en trans length; comment; mark; \n";
    while(!zhCsv.atEnd()) {
        QByteArray zhlineBa = zhCsv.readLine();
        QList<QByteArray> zhlistBa = zhlineBa.split(';');
        QByteArray zhPage = zhlistBa[0];
        QByteArray zhKey = zhlistBa[1];

        enCsv.seek(0);
        while (!enCsv.atEnd()) {
            QByteArray enlineBa = enCsv.readLine();
            QList<QByteArray> enlistBa = enlineBa.split(';');
            QByteArray enPage = enlistBa[0];
            QByteArray enKey = enlistBa[1];

            if(zhPage == enPage && zhPage != "") {
                if(zhKey == enKey && zhKey != "") {
                    QStringList lenList = findLengthInMerge(oldmergeCsv, zhPage, zhKey);
                    QString zhLen = "100";
                    QString enLen = "100";
                    if(lenList.length() == 2) {
                        zhLen = lenList[0];
                        enLen = lenList[1];
                    }
                    QString outStr = zhPage + ";" + zhKey + ";" +zhlistBa[2] + ";"+ zhLen +";" +enlistBa[2] + ";" + enLen + ";";
                    for(int i = 3; i < zhlistBa.length(); i++)
                    {
                        if(i > 4 && zhlistBa[i] == "") {
                            break;
                        }
                        QString str = zhlistBa[i];
                        str = str.simplified();
                        outStr += str + ";";
                    }
                    outStr += "\n";
                    qDebug() << outStr;
                    out << outStr;
                    break;
                }
            }
        }
    }

    enCsv.close();
    zhCsv.close();
    outCsv.close();
    oldmergeCsv.close();
}

void TsCsv::updateCsv()
{
    QFile zhCsv(QCoreApplication::applicationDirPath()+"/rainbow_zh.csv");
    if(!zhCsv.open(QIODevice::WriteOnly | QFile::Text)) {
        qDebug() << "open rainbow_zh.csv failed";
        return;
    }
    QFile enCsv(QCoreApplication::applicationDirPath()+"/rainbow_en.csv");
    if(!enCsv.open(QIODevice::WriteOnly | QFile::Text)) {
        qDebug() << "open rainbow_en.csv failed";
        return;
    }
    QFile outCsv(QCoreApplication::applicationDirPath()+"/lang_merge.csv");
    if(!outCsv.open(QIODevice::ReadOnly | QFile::Text)) {
        qDebug() << "open out.csv failed";
        return;
    }
    QTextStream zhOut(&zhCsv);
    QTextStream enOut(&enCsv);

    outCsv.readLine();
    zhOut << "page name; source; translation; comment; mark; \n";
    enOut << "page name; source; translation; comment; mark; \n";
    while(!outCsv.atEnd()) {
        QByteArray lineBa = outCsv.readLine();

        QList<QByteArray> listBa = lineBa.split(';');
        QByteArray page = listBa[0];
        QByteArray key = listBa[1];
        QByteArray zhTrans = listBa[2];
        QByteArray enTrans = listBa[4];
        QString zhOutStr = page + ";" + key + ";" +zhTrans + ";";
        QString enOutStr = page + ";" + key + ";" +enTrans + ";";

        // start from comment
        for(int i = 6; i < listBa.length(); i++)
        {
            // line number
            if(i > 7 && listBa[i] == "") {
                break;
            }
            QString str = listBa[i];
            str = str.simplified();
            zhOutStr += str + ";";
            enOutStr += str + ";";
        }
        zhOutStr += "\n";
        enOutStr += "\n";
        zhOut << zhOutStr;
        enOut << enOutStr;
        qDebug() << zhOutStr;
    }

    enCsv.close();
    zhCsv.close();
    outCsv.close();
}

void TsCsv::convertCsvToTs()
{
    mLang = "zh";
    csv2ts();
    mLang = "en";
    csv2ts();
}

void TsCsv::convertTsToCsv()
{
    mLang = "zh";
    ts2csv();
    mLang = "en";
    ts2csv();
}

void TsCsv::csv2ts()
{
    QFile inputFile(QCoreApplication::applicationDirPath()+"/rainbow_"+mLang+".csv");
    if(!inputFile.open(QIODevice::ReadOnly | QFile::Text)) {
        qDebug() << "open zh_hans.csv failed";
        return;
    }

    QFile file(QCoreApplication::applicationDirPath()+"/rainbow_"+mLang+".ts");

    if(!file.open(QIODevice::WriteOnly)) {
        qDebug() << "open zh_hans.ts failed";
        return;
    }

    QDomDocument doc;
    QDomProcessingInstruction instruction;

    instruction = doc.createProcessingInstruction("xml", "version = \'1.0\' encoding=\"utf-8\"");
    doc.appendChild(instruction);

    QDomComment comment = doc.createComment("DOCTYPE");
    doc.appendChild(comment);

    QDomAttr filename;
    QDomAttr line;
    QDomText text;
    QDomAttr type;
    if(!inputFile.atEnd())
        inputFile.readLine();

    QDomElement root = doc.createElement("TS");
    QDomAttr tmp = doc.createAttribute("version");
    tmp.setValue("2.1");
    root.setAttributeNode(tmp);

    tmp = doc.createAttribute("language");
    QString lang = (mLang == "zh") ? "zh_CN" : "en_US";
    tmp.setValue(lang);
    root.setAttributeNode(tmp);

    QString preNameText = "";
    QDomElement context;

    while (!inputFile.atEnd())
    {
        QByteArray lineBa = inputFile.readLine();
        QList<QByteArray> listBa = lineBa.split(';');
        QStringList lineList;
        for(int i = 0; i < listBa.length(); i++) {
            qDebug() << listBa[i];

            if(i > 4) {
                if(listBa[i] != "") {
                    lineList << listBa[i];
                } else {
                    break;
                }
            }
        }

        QString nameText = QString(listBa[0]);
        QString sourceText = QString(listBa[1]);
        QString translationText = QString(listBa[2]);
        QString commentText = QString(listBa[3]);
        QString markText = QString(listBa[4]);

        qDebug() << nameText << sourceText << translationText << commentText << markText;

        if(nameText != preNameText)
        {
            context = doc.createElement("context");

            QDomElement name = doc.createElement("name");
            text = doc.createTextNode(nameText);
            name.appendChild(text);
            context.appendChild(name);
        }

        QDomElement message = doc.createElement("message");

        for(int j = 0; j < lineList.length()-1 ; j++) {
            QDomElement location = doc.createElement("location");

            filename = doc.createAttribute("filename");
            filename.setValue(nameText+".qml");
            location.setAttributeNode(filename);

            line = doc.createAttribute("line");
            line.setValue(lineList[j]);
            location.setAttributeNode(line);
            message.appendChild(location);
        }

        QDomElement source = doc.createElement("source");
        text = doc.createTextNode(sourceText);
        source.appendChild(text);

        QDomElement comment = doc.createElement("translatorcomment");
        text = doc.createTextNode(commentText);
        comment.appendChild(text);

        QDomElement translation = doc.createElement("translation");
        if(markText != "") {
            type = doc.createAttribute("type");
            type.setValue(markText);
            translation.setAttributeNode(type);
        }
        text = doc.createTextNode(translationText);
        translation.appendChild(text);

        message.appendChild(source);
        message.appendChild(translation);
        message.appendChild(comment);
        context.appendChild(message);

        if(nameText != preNameText) {
            root.appendChild(context);
            preNameText = nameText;
        }
    }

    doc.appendChild(root);

    QTextStream out(&file);
    doc.save(out, 4);
    inputFile.close();
    file.close();
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
