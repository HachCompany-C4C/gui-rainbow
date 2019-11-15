/****************************************************************************
** DigitalInput.qml - Interface for DI setting
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

import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles.Flat 1.0 as Flat
import "../../components"

Rectangle {
    id: root
    width: 800
    height: 400
    objectName: "digitalinput"
    property string title: qsTr("IO Setup")+translator.tr
    enabled: mainPermisMgr.editabled

    Connections {
        target: io_di
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            console.debug("QML::UpdatePage io.di")
            diStatus.updateIOStatus();
            ch1Mode.updateCh1Mode();
            ch2Mode.updateCh2Mode();

            mainStackView.push({item: root, immediate: true})
            page_manager.updatePageDone();
        }
    }

    Rectangle {
        id: title
        x: 25
        y: 0
        width: 500
        height: 46

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("I: DI")+translator.tr
            font: mainTheme.mediumFont
        }

        H2oSwitch {
            id: diStatus
            x: 675
            anchors.verticalCenterOffset: 0
            anchors.rightMargin: -249
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right

            function updateIOStatus(){
                checked = io_di.getObjBool("enabled");
            }

            onValueChanged: {
                io_di.setObj("enabled", checked);
            }
        }
    }

    Rectangle {
        width: 800-20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: title.bottom
        height: Flat.FlatStyle.onePixel
        color: Flat.FlatStyle.lightFrameColor
    }

    Rectangle {
        anchors.top: title.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        width: Flat.FlatStyle.onePixel
        color: Flat.FlatStyle.lightFrameColor
    }

    GroupBox {
        id: groupBox
        x: 0
        y: 52
        width: 732
        height: 340
        flat: true
        enabled: diStatus.checked
        Text {
            id: text1
            x: 105
            y: 0
            text: qsTr("CH1")+translator.tr
            font: mainTheme.titleFont
        }

        Text {
            id: text6
            x: 8
            y: 42
            text: qsTr("Mode")+translator.tr
            font: mainTheme.smallFont
        }

        H2oExclusiveGroup {
            id: tabCh1ModeGroup
        }

        ListView {
            id: ch1Mode
            x: 105
            y: 37
            width: 218
            height: 296
            boundsBehavior: Flickable.StopAtBounds
            anchors.bottomMargin: 3
            anchors.topMargin: 0
            scale: 1
            anchors.rightMargin: 3
            cacheBuffer: 200
            contentHeight: 1144
            snapMode: ListView.SnapToItem
            flickableDirection: Flickable.VerticalFlick
            spacing: 3
            property var listName: [
                qsTr("Clean")+translator.tr,
                qsTr("Calibrate")+translator.tr,
                qsTr("Measure")+translator.tr,
                qsTr("Drain")+translator.tr,
                qsTr("Flush")+translator.tr,
                qsTr("Prime")+translator.tr,
                qsTr("Stop Schedule")+translator.tr
            ]

            model: ListModel {
                id: ch1ModeModel
                ListElement { name: qsTr("Clean"); check: true; index: 1 }
                ListElement { name: qsTr("Calibrate"); check: false; index: 2 }
                ListElement { name: qsTr("Measure"); check: false; index: 3 }
                ListElement { name: qsTr("Drain"); check: false; index: 4 }
                ListElement { name: qsTr("Flush"); check: false; index: 5 }
                ListElement { name: qsTr("Prime"); check: false; index: 6 }
                ListElement { name: qsTr("Stop Schedule"); check: false; index: 7 }
            }

            delegate: H2oLineRadioButton {
                text: ch1Mode.listName[index-1]
                checked: check
                width: 200
                exclusiveGroup: tabCh1ModeGroup
                onValueChanged: {
                    io_di.setObj("ch1mode", index);
                }
            }

            function updateCh1Mode()
            {
                var i = io_di.getObjInt("ch1mode");
                //ch1ModeModel.setProperty(i, "check", true);
                if(i > 0) {
                    ch1Mode.contentItem.children[i-1].checked = true;
                }
                console.debug("QML::DI ch1mode: "+i)
            }
        }

        Text {
            id: text2
            x: 506
            y: 0
            text: qsTr("CH2")+translator.tr
            font: mainTheme.titleFont
        }

        Text {
            id: text7
            x: 406
            y: 42
            text: qsTr("Mode")+translator.tr
            font: mainTheme.smallFont
        }


        H2oExclusiveGroup {
            id: tabCh2ModeGroup
        }

        ListView {
            id: ch2Mode
            x: 506
            y: 37
            width: 218
            height: 296
            boundsBehavior: Flickable.StopAtBounds
            anchors.bottomMargin: 3
            anchors.topMargin: 0
            scale: 1
            anchors.rightMargin: 3
            cacheBuffer: 200
            contentHeight: 1144
            snapMode: ListView.SnapToItem
            flickableDirection: Flickable.VerticalFlick
            spacing: 3
            property var listName: [
                qsTr("Clean")+translator.tr,
                qsTr("Calibrate")+translator.tr,
                qsTr("Measure")+translator.tr,
                qsTr("Drain")+translator.tr,
                qsTr("Flush")+translator.tr,
                qsTr("Prime")+translator.tr,
                qsTr("Stop Schedule")+translator.tr
            ]

            model: ListModel {
                id: ch2ModeModel
                ListElement { name: qsTr("Clean"); check: true; index: 1 }
                ListElement { name: qsTr("Calibrate"); check: false; index: 2 }
                ListElement { name: qsTr("Measure"); check: false; index: 3 }
                ListElement { name: qsTr("Drain"); check: false; index: 4 }
                ListElement { name: qsTr("Flush"); check: false; index: 5 }
                ListElement { name: qsTr("Prime"); check: false; index: 6 }
                ListElement { name: qsTr("Stop Schedule"); check: false; index: 7 }
            }

            delegate: H2oLineRadioButton {
                text: ch2Mode.listName[index-1]
                checked: check
                exclusiveGroup: tabCh2ModeGroup
                width: 200
                onValueChanged: {
                    io_di.setObj("ch2mode", index);
                }
            }

            function updateCh2Mode()
            {
                var i = io_di.getObjInt("ch2mode");
                //ch2ModeModel.setProperty(i, "check", true);
                if(i > 0) {
                    ch2Mode.contentItem.children[i-1].checked = true;
                }
                console.debug("QML::DI ch2mode: "+i)
            }
        }
    }
}
