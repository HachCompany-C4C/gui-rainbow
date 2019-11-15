/****************************************************************************
** CommSpdt.qml - Interface for spdt setting
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
    height: 420
    objectName: "commspdt"
    property string title: qsTr("IO Setup")+translator.tr
    enabled: mainPermisMgr.editabled

    Connections {
        target: io_spdt
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            console.debug("QML::UpdatePage io.spdt");
            spdtStatus.updateIOStatus();
            ch1Output.updateCh1Output();
            //ch1Pretreat.updateCh1Pretreat();
            ch2Output.updateCh2Output();
            mainStackView.push({item: root, immediate: true})

            //ch2Pretreat.updateCh2Pretreat();
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
            text: qsTr("O: SPDT")+translator.tr
            font: mainTheme.mediumFont
        }

        H2oSwitch {
            id: spdtStatus
            x: 675
            anchors.verticalCenterOffset: 0
            anchors.rightMargin: -244
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right

            function updateIOStatus(){
                checked = io_spdt.getObjBool("enabled");
            }

            onValueChanged: {
                io_spdt.setObj("enabled", checked);
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

    /*Rectangle {
        width: 800-20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: title.bottom
        anchors.topMargin: 300
        height: Flat.FlatStyle.onePixel
        color: Flat.FlatStyle.lightFrameColor
    }*/

    GroupBox {
        id: groupBox
        x: 0
        y: 52
        width: 773
        height: 330
        flat: true
        enabled: spdtStatus.checked
        Text {
            id: text1
            x: 107
            y: 0
            text: qsTr("CH1")+translator.tr
            font: mainTheme.titleFont
        }

        Text {
            id: text6
            x: 21
            y: 53
            text: qsTr("Output")+translator.tr
            font: mainTheme.smallFont
        }

        H2oExclusiveGroup {
            id: ch1OutputGroup
        }

        ListView {
            id: ch1Output
            x: 107
            y: 47
            width: 213
            height: 168
            boundsBehavior: Flickable.StopAtBounds
            anchors.bottomMargin: 3
            anchors.topMargin: 0
            scale: 1
            anchors.rightMargin: 3
            cacheBuffer: 200
            contentHeight: 30
            snapMode: ListView.SnapToItem
            flickableDirection: Flickable.VerticalFlick
            spacing: 3
            orientation: Qt.Vertical
            property int currentIndex
            property var nameList: [
                qsTr("Low Alarm")+translator.tr,
                qsTr("High Alarm")+translator.tr,
                qsTr("Warning")+translator.tr,
                qsTr("Pretreatment")+translator.tr
            ]

            model: ListModel {
                id: ch1OutputList
                ListElement { name: qsTr("Low Alarm"); check: true; index: 1 }
                ListElement { name: qsTr("High Alarm"); check: false; index: 2 }
                ListElement { name: qsTr("Warning"); check: false; index: 3 }
                ListElement { name: qsTr("Pretreatment"); check: false; index: 4 }
            }

            delegate: H2oLineRadioButton {
                width: 230
                text: ch1Output.nameList[index-1]
                checked: check
                exclusiveGroup: ch1OutputGroup
                onValueChanged: {
                    ch1Output.currentIndex = index;
                    io_spdt.setObj("ch1output", index);
                }
            }

            function updateCh1Output()
            {
                var i = io_spdt.getObjInt("ch1output");
                //ch1OutputList.setProperty(i, "check", true);
                if(i > 0) {
                    ch1Output.currentIndex = i-1;
                    ch1Output.contentItem.children[ch1Output.currentIndex].checked = true;
                }
            }

            Component.onCompleted: {
                updateCh1Output();
            }
        }

        /*Text {
            id: pretrementText
            anchors.left: parent.left
            anchors.leftMargin: 50
            y: 313
            text: qsTr("Pretrement Delay Time")+translator.tr
            font.pixelSize: 16
        }

        H2oTextField {
            id: ch1Pretreat
            anchors.left: pretrementText.right
            anchors.leftMargin: 10
            anchors.verticalCenter: pretrementText.verticalCenter
            width: 200
            height: 40
            //enabled: ch1Output.currentIndex === 3 ? true:false
            plaintext: text+" "+qsTr("seconds")+translator.tr

            onEditDone: {
                var numOrg = Number.fromLocaleString(Qt.locale(), inputStr);
                var num = numOrg.toFixed(0);

                if(io_spdt.isInRange("ch1pretreat", num))
                {
                    text = num;
                    io_spdt.setObj("ch1pretreat", num);
                } else {
                    var range = io_spdt.rangeString("ch1pretreat");
                    mainMessageDialogOneButton.text = qsTr("Your input ")+numOrg+qsTr(" out of range")+translator.tr+range;
                    mainMessageDialogOneButton.open();
                    text = preText;
                }
            }

            function updateCh1Pretreat() {
                var textTime = io_spdt.getObjInt("ch1pretreat")
                text = Number(textTime).toString()
            }

            Component.onCompleted: {
                updateCh1Pretreat();
            }
        }*/

        /*Text {
            id: text2
            anchors.left: ch1Pretreat.right
            anchors.leftMargin: 10
            anchors.verticalCenter: ch1Pretreat.verticalCenter
            text: qsTr("seconds")+translator.tr
            font.pixelSize: 20
        }*/

        Text {
            id: text3
            x: 507
            y: 0
            text: qsTr("CH2")+translator.tr
            font: mainTheme.titleFont
        }

        Text {
            id: text7
            x: 421
            y: 53
            text: qsTr("Output")+translator.tr
            font: mainTheme.smallFont
        }

        H2oExclusiveGroup {
            id: ch2OutputGroup
        }

        ListView {
            id: ch2Output
            x: 507
            y: 47
            width: 213
            height: 168
            boundsBehavior: Flickable.StopAtBounds
            anchors.bottomMargin: 3
            anchors.topMargin: 0
            scale: 1
            anchors.rightMargin: 3
            cacheBuffer: 200
            contentHeight: 30
            snapMode: ListView.SnapToItem
            flickableDirection: Flickable.VerticalFlick
            spacing: 3
            orientation: Qt.Vertical
            property int currentIndex
            property var nameList: [
                qsTr("Low Alarm")+translator.tr,
                qsTr("High Alarm")+translator.tr,
                qsTr("Warning")+translator.tr,
                qsTr("Pretreatment")+translator.tr
            ]

            model: ListModel {
                id: ch2OutputList
                ListElement { name: qsTr("Low Alarm"); check: true; index: 1 }
                ListElement { name: qsTr("High Alarm"); check: false; index: 2 }
                ListElement { name: qsTr("Warning"); check: false; index: 3 }
                ListElement { name: qsTr("Pretreatment"); check: false; index: 4 }
            }

            delegate: H2oLineRadioButton {
                width: 230
                text: ch2Output.nameList[index-1]
                checked: check
                exclusiveGroup: ch2OutputGroup
                onValueChanged: {
                    ch2Output.currentIndex = index;
                    io_spdt.setObj("ch2output", index);
                }
            }

            function updateCh2Output()
            {
                var i = io_spdt.getObjInt("ch2output");
                //ch2OutputList.setProperty(i, "check", true);
                if(i > 0) {
                    ch2Output.currentIndex = i-1;
                    ch2Output.contentItem.children[ch2Output.currentIndex].checked = true;
                }
            }

            Component.onCompleted: {
                updateCh2Output();
            }
        }
    }
}
