/****************************************************************************
** SystemInfo.qml - UI to show system information
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

import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.1
import "../../components"
import "../../content/time.js" as Time
import "../../content/Strconvert.js" as StringConv

Rectangle {
    Connections {
        target: system_info
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            // console.debug("QML::PageUpdate system_info")
            /*mcuVersion.updateMcuVersion();
            mcuSN.updateMcuSN();
            daemonVersion.updateDaemonVersion();
            modbusVer.updateModbusVer();*/
            tableView.updateModel2();
            page_manager.updatePageDone();
        }
    }

    property var instrType: [
        QT_TRANSLATE_NOOP("H2oTableView", "Standard"),
        QT_TRANSLATE_NOOP("H2oTableView", "Extended")
    ]

    H2oTableView {
        id: tableView
        anchors.top: parent.top
        anchors.topMargin: 0
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
            width: tableView.width / 2
            resizable: false
            movable: false
            //delegate: textDelegate

        }
        TableViewColumn {
            role: "value"
            title: qsTr("Value")+translator.tr
            width: tableView.width / 2
            resizable: false
            movable: false
            //delegate: textDelegate
        }

        model: ListModel {
            id: page1Model

            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView", "Software Version"); value: "0"; }

            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView", "UI Software Version"); value: "0"; }
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView", "MCU Software Version"); value: "0"; }

            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView", "Probe Daemon Version"); value: "0"; }
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView", "Modbus Daemon Version"); value: "0"; }

            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView", "Instrument Type"); value: "0"; }
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView", "MCU SN"); value: "0"; }
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView", "IP Address"); value: "0"; }
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView", "MAC Address"); value: "0"; }
        }

        function updateModel() {
            model.setProperty(0, "value", page_manager.mainVersion());

            model.setProperty(1, "value", page_manager.appVersion());

            model.setProperty(2, "value", system_info.getObjString("fw"));

            model.setProperty(3, "value", system_info.getObjString("version"));

            model.setProperty(4, "value", io_modbus.getObjString("sw_version"));

            var value = system_info.getObjInt("instr_type");
            if(value > 1) value = 0;
            model.setProperty(5, "value", instrType[value]);

            model.setProperty(6, "value", system_info.getObjString("sn"));

            model.setProperty(7, "value", network_interface.getHostIpAddress());

            model.setProperty(8, "value", network_interface.getHostMacAddress());
        }

        function updateModel2()
        {
            model.clear();

            var aliasStr = system_info.getObjString("alias");
            var strText = StringConv.codeToString32(aliasStr);

            model.append({ "item": qsTr("Alias")+translator.tr, "value": strText });

            var type = system_info.getObjInt("instr_type");
            if(type > 1) type = 0;
            model.append({ "item": qsTr("Instrument Type")+translator.tr, "value": instrType[type] });
            model.append({ "item": qsTr("MCU SN")+translator.tr, "value": system_info.getObjString("sn") });
            model.append({ "item": qsTr("Software Version")+translator.tr, "value": page_manager.mainVersion() });

            var activeTime;
            var mcuTime = system_info.getObjInt("active_time");
            var hmiTime = local_settings.getValueInt("startup", "activetime", 0);
            //var hmiTime = Number.fromLocaleString(Qt.locale(), temp);
            // console.debug("QML::SystemInfo mcutime: "+mcuTime+" hmiTime: "+hmiTime);
            if(mcuTime === hmiTime) {
                activeTime = Time.convertU32Time(mcuTime);
            } else {
                activeTime = Time.convertU32Time(mcuTime)+" ( "+Time.convertU32Time(hmiTime)+" )";
            }

            model.append({ "item": qsTr("Active Time")+translator.tr, "value": activeTime });

            model.append({ "item": qsTr("HMI hardware version")+translator.tr, "value": soc_version.getSocDesc() });

            //var advInfoEn = local_settings.getValue("advance", "advanceinfo", false);
            //if(advInfoEn === "true") {
            var advInfoEn = mainPermisMgr.superperms;
            if(advInfoEn === true) {
                model.append({ "item": qsTr("UI Software Version")+translator.tr, "value": page_manager.appVersion() });
                model.append({ "item": qsTr("MCU Software Version")+translator.tr, "value": system_info.getObjString("fw") });
                model.append({ "item": qsTr("Probe Daemon Version")+translator.tr, "value": system_info.getObjString("version") });
                model.append({ "item": qsTr("Modbus Daemon Version")+translator.tr, "value": io_modbus.getObjString("sw_version") });
                model.append({ "item": qsTr("IP Address")+translator.tr, "value": network_interface.getHostIpAddress() });
                model.append({ "item": qsTr("MAC Address")+translator.tr, "value": network_interface.getHostMacAddress() });
            }
        }
    }

    /*Text {
        id: text1
        x: 45
        y: 69
        text: qsTr("HMI Software Version:")+translator.tr
        font.pixelSize: 16
    }

    Text {
        id: text2
        x: 234
        y: 69
        text: page_manager.appVersion();
        font.pixelSize: 16
    }

    Text {
        id: text3
        x: 45
        y: 115
        text: qsTr("MCU Software Version:")+translator.tr
        font.pixelSize: 16
    }

    Text {
        id: mcuVersion
        x: 234
        y: 115
        font.pixelSize: 16
        text: "1.0.0"

        function updateMcuVersion() {
            text = system_info.getObjString("fw");
        }
    }

    Text {
        id: text6
        x: 45
        y: 162
        text: qsTr("Probe Daemon Version:")+translator.tr
        font.pixelSize: 16
    }

    Text {
        id: daemonVersion
        x: 234
        y: 162
        font.pixelSize: 16
        text: "1.0.0"

        function updateDaemonVersion() {
            var param;
            //text = json_parse.execJson("version", param);
            text = system_info.getObjString("version");
        }
    }

    Text {
        id: text5
        x: 45
        y: 243
        text: qsTr("MCU SN:")+translator.tr
        font.pixelSize: 16
    }

    Text {
        id: mcuSN
        x: 234
        y: 243
        font.pixelSize: 16
        text: "123456"

        function updateMcuSN() {
            text = system_info.getObjString("sn");
        }
    }

    Text {
        id: text7
        x: 45
        y: 285
        text: qsTr("Instrument Type:")+translator.tr
        font.pixelSize: 16
    }

    Text {
        id: instrType
        x: 234
        y: 285
        text: "1"
        font.pixelSize: 16

        function updateInstrType() {
            //text = system_info.getObjInt("instr_type");
        }
    }

    Text {
        id: text8
        x: 45
        y: 204
        text: qsTr("Modbus Daemon Version:")+translator.tr
        font.pixelSize: 16
    }

    Text {
        id: modbusVer
        x: 271
        y: 204
        text: "1"
        font.pixelSize: 16

        function updateModbusVer() {
            text = io_modbus.getObjString("sw_version")
        }
    }*/


    /*H2oTableView {
        id: tableView
        width: 800
        height: 360

        verticalScrollBarPolicy: 0
        highlightOnFocus: false
        headerVisible: true
        alternatingRowColors: true
        //backgroundVisible: false
        frameVisible: false

        TableViewColumn {
            role: "item"
            title: "Item"
            width: tableView.width / 2
            resizable: false
            movable: false
            //delegate: textDelegate

        }
        TableViewColumn {
            role: "value"
            title: "Value"
            width: tableView.width / 2
            resizable: false
            movable: false
            //delegate: textDelegate
        }



        model: ListModel {
            id: page1Model

            ListElement { item: qsTr("HMI Software Version")+translator.tr; value: "0" }
            ListElement { item: qsTr("MCU Software Version"); value: "0" }
            ListElement { item: qsTr("Probe Daemon Version"); value: "0" }
            ListElement { item: qsTr("MCU SN"); value: "0" }
            ListElement { item: qsTr("Instrument Type"); value: "0" }
        }

        function updateModel() {
            model.append("item": qsTr("HMI Software Version")+translator.tr, "value": )
            //model.setProperty(0, "value1", status_page1.getObjString("l660")+"/"+status_page1.getObjString("s660"));
            //model.setProperty(0, "value2", status_page1.getObjString("s660"));


        }
    }*/
}
