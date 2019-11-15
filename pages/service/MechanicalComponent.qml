/****************************************************************************
** MechanicalComponent.qml - UI for showing mechanical component status in real time
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
    objectName: "mechanical page"

    Connections {
        target: status_page2
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            console.debug("QML::UpdatePage status.page2")
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

        ListModel {
            id: type1Model
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView", "Mixer"); value: "0"; }
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView", "Pump1~3"); value: "0"; }
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView", "Valve1~3"); value: "0"; }
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView", "Valve4~5"); value: "0"; }
        }

        ListModel {
            id: type2Model
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView", "Mixer"); value: "0"; }
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView", "Pump1~3"); value: "0"; }
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView", "Valve1~3"); value: "0"; }
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView", "Valve4~6"); value: "0"; }
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView", "Valve7~9"); value: "0"; }
        }

        /*rowDelegate: Rectangle {
            id: rowItem
            height: 32

            SystemPalette {
                id: myPalette;
                colorGroup: SystemPalette.Active
            }
            color: {
                var baseColor = styleData.row%2 == 0 ? myPalette.alternateBase : myPalette.base
                return styleData.selected ? myPalette.highlight : baseColor
            }
        }*/

        function updateModel()
        {
            var type = system_info.getObjInt("instr_type");
            if(tableView.model === undefined)
            {
                if(type === 0) {
                    tableView.model = type1Model;
                } else {
                    tableView.model = type2Model;
                }
            }

            // mixer
            //console.debug("QML::Mixer "+status_page2.getObjString("mixer"))
            model.setProperty(0, "value", status_page2.getObjString("mixer"));
            // pump1~3
            var pump = status_page2.getObjString("pump1") + " / "
                        + status_page2.getObjString("pump2") + " / "
                        + status_page2.getObjString("pump3");
            model.setProperty(1, "value", pump);

            // valve0~9
            var valve = status_page2.getObjInt("valve");
            //console.debug("QML::valve "+valve);
            /*for(var i = 15; i > 6; i--)
            {
                var status = (valve & (0x1 << i)) > 0 ? QT_TRANSLATE_NOOP("H2oTableView", "On") : QT_TRANSLATE_NOOP("H2oTableView", "Off");
                var row = (15-i) / 3;
                var role = "value"+((15-i)%3+1);
                model.setProperty(row, "value", status);
            }*/

            var row = type == 0 ? 2 : 3;
            for(var i = 0; i < row; i++) {
                var valveStat = "";
                var col = (type == 0) && (i == 1) ? 2 : 3;
                for(var j = 0; j < col; j++) {
                    var bitCnt = 15 - i*3 - j;
                    var status = (valve & (0x1 << bitCnt)) > 0 ? qsTr("On") : qsTr("Off");
                    valveStat += status;
                    if(j < (col - 1)) {
                        valveStat += " / ";
                    }
                }
                model.setProperty(2+i, "value", valveStat);
            }
        }
    }
}
