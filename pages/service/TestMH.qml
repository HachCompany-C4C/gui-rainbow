/****************************************************************************
** TestMH.qml - UI for Mixer and Heating test
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
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles.Flat 1.0 as Flat
import "../../components"

Rectangle{
    id: testroot
    objectName: "test_mh"
    property string title: qsTr("Mixer & Heating")+translator.tr
    width: 800
    height: 360

    Connections {
        target: test_mh
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            console.debug("QML::UpdatePage Test-PV")
            absTableView.updateAbs();
            tempTableView.updateTemp();

            page_manager.updatePageDone();
        }
    }

    Text{
        id:mixerText
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 5
        font: mainTheme.titleFont
        text:qsTr("Mixer Test") + translator.tr
    }

    H2oButton {
        id: buttonMixerRun
        anchors.top: mixerText.bottom
        anchors.topMargin: 5
        anchors.left: mixerText.left
        anchors.leftMargin: 65
        width: 120
        height: 40
        text: qsTr("RUN") + translator.tr
        onClicked: {
            test_mh.setObj("mixer", 0);   //6d, stop mixer, 0b, trigger a action
        }
    }
    H2oButton {
        id: buttonMixerStop
        anchors.verticalCenter: buttonMixerRun.verticalCenter
        anchors.left: buttonMixerRun.right
        anchors.leftMargin: (testroot.width-400)/3
        width: 120
        height: 40
        text: qsTr("STOP") + translator.tr
        onClicked: {
            test_mh.setObj("mixer", 1);   //6c, run mixer, 0b, trigger a action
        }
    }
    H2oButton {
        id: buttonMixerIdle
        anchors.verticalCenter: buttonMixerStop.verticalCenter
        anchors.left: buttonMixerStop.right
        anchors.leftMargin: (testroot.width-400)/3
        width: 120
        height: 40
        text: qsTr("IDLE") + translator.tr
        onClicked: {
            test_mh.setObj("mixer", 2);   //6e, idle mixer, 0b, trigger a action
        }
    }

    Rectangle {
        id: sp1
        anchors.top: mixerText.bottom
        anchors.topMargin: 65
        anchors.horizontalCenter: parent.horizontalCenter
        height: Flat.FlatStyle.onePixel
        width: parent.width - 40
        color: Flat.FlatStyle.lightFrameColor
    }

    Text {
        id: textHeating
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: sp1.top
        anchors.topMargin: 5
        font: mainTheme.titleFont
        text: qsTr("Heating Test") + translator.tr
    }

    H2oButton {
        id: buttonHeatingNormal
        anchors.left: textHeating.left
        anchors.leftMargin: 180
        anchors.top: textHeating.bottom
        anchors.topMargin: 5
        width: 120
        height: 40
        text: qsTr("START") + translator.tr
        onClicked: {
            test_mh.setObj("heat", 0);   //67, start heat, 0b, trigger a action
        }
    }
    H2oButton {
        id: buttonHeatingHigh
        x: 550
        anchors.top: textHeating.bottom
        anchors.topMargin: 5
        anchors.left: buttonHeatingNormal.left
        anchors.leftMargin: 300
        width: 120
        height: 40
        text: qsTr("STOP") + translator.tr
        onClicked: {
            test_mh.setObj("heat", 1);   //68, start heat, 0b, trigger a action
        }
    }

    Rectangle {
        id: sp2
        anchors.top: textHeating.bottom
        anchors.topMargin: 60
        anchors.horizontalCenter: parent.horizontalCenter
        height: Flat.FlatStyle.onePixel
        width: parent.width - 40
        color: Flat.FlatStyle.lightFrameColor
    }

    H2oTableView {
        id: tempTableView
        width: 800 - 40
        height: 60
        anchors.top: tempAbsText.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter

        verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        highlightOnFocus: false
        headerVisible: true
        alternatingRowColors: false
        //backgroundVisible: false
        frameVisible: false

        TableViewColumn {
            role: "item"
            title: " "
            width: tempTableView.width / 5
            resizable: false
            movable: false
            //delegate: textDelegate

        }
        TableViewColumn {
            role: "heating"
            title: qsTr("heating") + translator.tr
            width: tempTableView.width / 5
            resizable: false
            movable: false
            //delegate: textDelegate
        }
        TableViewColumn {
            role: "colorimeter"
            title: qsTr("colorimeter") + translator.tr
            width: tempTableView.width / 5
            resizable: false
            movable: false
            //delegate: textDelegate
        }
        TableViewColumn {
            role: "envirenment"
            title: qsTr("envirenment") + translator.tr
            width: tempTableView.width / 5
            resizable: false
            movable: false
            //delegate: textDelegate
        }
        TableViewColumn {
            role: "deviceCase"
            title: qsTr("case") + translator.tr
            width: tempTableView.width / 5
            resizable: false
            movable: false
            //delegate: textDelegate
        }

        model: ListModel {
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Temp"); heating: "0"; colorimeter: "0"; envirenment: "0"; deviceCase: "0"}
        }

        rowDelegate: Rectangle {
            id: tempRowItem
            height: 30

            SystemPalette {
                id: tempPalette;
                colorGroup: SystemPalette.Active
            }
            color: {
                var baseColor = styleData.row%2 == 0 ? tempPalette.alternateBase : tempPalette.base
                return styleData.selected ? tempPalette.highlight : baseColor
            }
        }
        function updateTemp()
        {
            var temp = "";
            temp = (test_mh.getObjInt("al_temp")/100).toFixed(1);
            model.setProperty(0, "heating", temp);
            temp = (test_mh.getObjInt("peek_temp")/100).toFixed(1);
            model.setProperty(0, "colorimeter", temp);
            temp = (test_mh.getObjInt("env_temp")/100).toFixed(1);
            model.setProperty(0, "envirenment", temp);
            temp = (test_mh.getObjInt("pcb_temp")/100).toFixed(1);
            model.setProperty(0, "deviceCase", temp);
        }
    }

    Text{
        id:tempAbsText
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: sp2.top
        anchors.topMargin: 5
        font: mainTheme.titleFont
        text:qsTr("Temperature & Abs") + translator.tr
    }

    H2oTableView {
        id: absTableView
        width: 800 - 40
        height: 60
        anchors.top: tempTableView.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        highlightOnFocus: false
        headerVisible: true
        alternatingRowColors: false
        //backgroundVisible: false
        frameVisible: false

        TableViewColumn {
            role: "item"
            title: " "
            width: absTableView.width / 5
            resizable: false
            movable: false
            //delegate: textDelegate

        }
        TableViewColumn {
            role: "L660"
            title: qsTr("L660")
            width: absTableView.width / 5
            resizable: false
            movable: false
            //delegate: textDelegate
        }
        TableViewColumn {
            role: "L880"
            title: qsTr("L880")
            width: absTableView.width / 5
            resizable: false
            movable: false
            //delegate: textDelegate
        }
        TableViewColumn {
            role: "S660"
            title: qsTr("S660")
            width: absTableView.width / 5
            resizable: false
            movable: false
            //delegate: textDelegate
        }
        TableViewColumn {
            role: "S880"
            title: qsTr("S880")
            width: absTableView.width / 5
            resizable: false
            movable: false
            //delegate: textDelegate
        }

        model: ListModel {
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Abs"); L660: "0"; L880: "0"; S660: "0"; S880: "0"}
        }

        rowDelegate: Rectangle {
            id: absrowItem
            height: 30

            SystemPalette {
                id: absPalette;
                colorGroup: SystemPalette.Active
            }
            color: {
                var baseColor = styleData.row%2 == 0 ? absPalette.alternateBase : absPalette.base
                return styleData.selected ? absPalette.highlight : baseColor
            }
        }
        function updateAbs()
        {
            var temp = "";
            temp = test_mh.getObjFloat("l660")
            model.setProperty(0, "L660", temp.toFixed(3))
            temp = test_mh.getObjFloat("l880")
            model.setProperty(0, "L880", temp.toFixed(3))
            temp = test_mh.getObjFloat("s660")
            model.setProperty(0, "S660", temp.toFixed(3))
            temp = test_mh.getObjFloat("s880")
            model.setProperty(0, "S880", temp.toFixed(3))
            //model.setProperty(0, "etext", test_substep.getObjString("l660"));
            //model.setProperty(1, "etext", test_substep.getObjString("l880"));
            //model.setProperty(2, "etext", test_substep.getObjString("s660"));
            //model.setProperty(3, "etext", test_substep.getObjString("s880"));
        }
    }

    /*Text {
        id: abs
        x: 5
        y: parent.height - 55
        font.pixelSize: 24
        text: qsTr("ABS") + translator.tr + " (l660/l880/s660/s880):"
    }
    Text {
        id: temp
        x: 5
        y: parent.height - 95
        font.pixelSize: 24
        text: qsTr("Temp") + translator.tr + (" (al/peek/env/pcb)             :")
    }
    ListModel {
        id: absModel
        ListElement {etext: "0.212121"}
        ListElement {etext: "0.212222"}
        ListElement {etext: "0.212323"}
        ListElement {etext: "0.212424"}
    }


    ListModel{
        id: tempModel
        ListElement {etext: "25.0"}
        ListElement {etext: "26.0"}
        ListElement {etext: "27.0"}
        ListElement {etext: "28.0"}
    }

    Row{
        id: tempRow
        //x: 285
        anchors.left: temp.right
        anchors.leftMargin: 5
        spacing: (testroot.width - 31*24)/3
        Repeater{
            id: tempRepeater
            model: tempModel
            function updateTemp()
            {
                var temp = "";
                temp = "" + (test_mh.getObjInt("al_temp")/100).toFixed(2);
                model.setProperty(0, "etext", temp);
                temp = "" + (test_mh.getObjInt("peek_temp")/100).toFixed(2);
                model.setProperty(1, "etext", temp);
                temp = (test_mh.getObjInt("env_temp")/100).toFixed(2);
                model.setProperty(2, "etext", temp);
                temp = (test_mh.getObjInt("pcb_temp")/100).toFixed(2);
                model.setProperty(3, "etext", temp);
            }
            delegate : Text {
                y: testroot.height-95
                font.pixelSize: 24
                text: etext
            }
        }
    }
    Row{
        id: absRow
        anchors.left: temp.right
        anchors.leftMargin: 5
        //x: 285
        spacing: (testroot.width - 30*24)/3
        Repeater{
            id: absRepeater
            model: absModel

            function updateAbs()
            {
                model.setProperty(0, "etext", test_mh.getObjString("l660"));
                model.setProperty(1, "etext", test_mh.getObjString("l880"));
                model.setProperty(2, "etext", test_mh.getObjString("s660"));
                model.setProperty(3, "etext", test_mh.getObjString("s880"));
            }

            delegate : Text {
                y: testroot.height-55
                font.pixelSize: 24
                text: etext
            }
        }
    }*/
}
