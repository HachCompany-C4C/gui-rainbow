/****************************************************************************
** LeakagePower.qml - UI for showing leak/power status in real time
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

import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.1
import "../../components"

Item {
    width: 800
    height: 360
    objectName: "leakage power page"

    Connections {
        target: status_page3
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            console.debug("QML::UpdatePage status.page3")
            tableView.updateModel();

            page_manager.updatePageDone();
        }
    }

    H2oTableView {
        id: tableView
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter
        width: 800-40
        height: 360

        verticalScrollBarPolicy: 0
        highlightOnFocus: false
        headerVisible: true
        alternatingRowColors: false
        //backgroundVisible: false
        frameVisible: false

        TableViewColumn {
            role: "item"
            title: qsTr("Item")+translator.tr
            width: tableView.width / 2 + 10
            resizable: false
            movable: false
            //delegate: textDelegate
        }
        TableViewColumn {
            role: "value"
            title: qsTr("Value")+translator.tr
            width: tableView.width / 2 - 10
            resizable: false
            movable: false
            //delegate: textDelegate
        }

        model: ListModel {
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView", "Leakage"); value: "0";}
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView", "Power"); value: "0";}
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView", "Humidity (%)"); value: "0";}
        }

        function updateModel() {
            var val;
            val = ""+status_page3.getObjInt("leakage");
            model.setProperty(0, "value", val);
            val = ""+status_page3.getObjInt("power")
            model.setProperty(1, "value", val);
            val = status_page3.getObjInt("humidity")/100;
            val = ""+val.toFixed(3);
            model.setProperty(2, "value", val);
         }
    }
}

