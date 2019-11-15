/****************************************************************************
** Communication.qml - Interface for modbus setting
**
** Created on: 2017-10-31
**
** Author:
**
** Copyright (C) 2016 Hach DDC
**              All Rights Reserved
**
**
** Notes:
**
****************************************************************************/

import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.0
import "../../components"


Rectangle {
    width: 800
    height: 360

    enabled: mainPermisMgr.editabled

    Connections {
        target: io_modbus
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            console.debug("QML::UpdatePage io.modbus")
            modbusDeviceID.updateDeviceID();
            baudrateList.updateBaudrate();
	    startAddrList.updateStartAddr();
            page_manager.updatePageDone();
        }
    }

    Connections {
        target: latest2_measure
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            hj212Format.updateHj212Format();
            page_manager.updatePageDone();
        }
    }

    Text {
        id: devidText
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.top: parent.top
        anchors.topMargin: 10
        text: qsTr("Device id")+translator.tr
        font: mainTheme.titleFont
    }


    H2oTextField {
        id: modbusDeviceID
        anchors.left: devidText.left
        anchors.leftMargin: 10
        anchors.top: devidText.bottom
        anchors.topMargin: 10

        width: 240
        //text: io_modbus.getObjString("deviceid")//get device id used now
        plaintext: text

        onEditDone: {
            var numOrg = Number.fromLocaleString(Qt.locale(), inputStr)

            if(numOrg > 0 && numOrg <= 247)
            {
                text = Number(numOrg).toFixed()
                io_modbus.setObj("deviceid", text.valueOf())   //set device id to modbus deamon by session bus-by mandy
            } else {
                mainMessageDialogOneButton.text = qsTr("Your input ")+numOrg+qsTr(" out of range")+translator.tr+"[1, 247]";
                mainMessageDialogOneButton.open();
                text = preText;
            }
        }

        function updateDeviceID() {
            text = io_modbus.getObjString("deviceid");
        }
    }

    Text {
        id: baudrateText
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.top: modbusDeviceID.bottom
        anchors.topMargin: 18

        text: qsTr("Baud rate")+translator.tr
        font: mainTheme.titleFont
    }

    H2oDropBox {
        id: baudrateList

        anchors.left: baudrateText.left
        anchors.leftMargin: 10
        anchors.top: baudrateText.bottom
        anchors.topMargin: 10
        width: 240
        height: 40
        //currentIndex: Number(io_modbus.getObjString("baudrate")).toLocaleString(Qt.locale(), 'd', 0)  //get from modbus deamon-by mandy
        property bool operated: false

        listName: [
            "1200",
            "2400",
            "4800",
            "9600",
            "14400",
            "19200",
            "38400",
            "57600",
            "115200"
        ]

        model: ListModel {
            id: baudrateItem
            ListElement { name: "1200" }
            ListElement { name: "2400" }
            ListElement { name: "4800" }
            ListElement { name: "9600" }
            ListElement { name: "14400" }
            ListElement { name: "19200" }
            ListElement { name: "38400" }
            ListElement { name: "57600" }
            ListElement { name: "115200" }
        }

        onIndexChanged: {
            console.debug("Modbus baudrate: " )
            io_modbus.setObj("baudrate", currentIndex.valueOf())
        }

        function updateBaudrate() {
            currentIndex= Number(io_modbus.getObjString("baudrate")).toLocaleString(Qt.locale(), 'd', 0);
        }
    }

    Text {
        id: startAddrText
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.top: baudrateList.bottom
        anchors.topMargin: 18

        text: qsTr("Object start address")+translator.tr
        font: mainTheme.titleFont
    }

    H2oDropBox {
        id: startAddrList

        anchors.left: startAddrText.left
        anchors.leftMargin: 10
        anchors.top: startAddrText.bottom
        anchors.topMargin: 10
        width: 240
        height: 40
        property bool operated: false

        listName: [
            "0",
            "1",
        ]

        model: ListModel {
            id: startAddrItem
            ListElement { name: "0" }
            ListElement { name: "1" }
        }

        onIndexChanged: {
            io_modbus.setObj("startaddr", currentIndex.valueOf())
        }

        function updateStartAddr() {
            currentIndex= Number(io_modbus.getObjString("startaddr")).toLocaleString(Qt.locale(), 'd', 0);
        }
    }

    Text {
        id:  hj212FormatText
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.top: startAddrList.bottom
        anchors.topMargin: 18
        text: qsTr("HJ212 format")+translator.tr
        font: mainTheme.titleFont
        visible: false //hide in this version
    }

    H2oSwitch {
        id: hj212Format
        anchors.left: hj212FormatText.right
        anchors.leftMargin: 10
        anchors.verticalCenter: hj212FormatText.verticalCenter
        visible: false //hide in this version
        onValueChanged: {
            latest2_measure.setObj("hj212_format", checked)
        }

        function updateHj212Format() {
            checked = latest2_measure.getObjInt("hj212_format");
        }
    }
}



