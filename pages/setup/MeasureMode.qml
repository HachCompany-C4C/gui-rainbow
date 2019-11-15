/****************************************************************************
** MeasureMode.qml - Interface for measure mode setting
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
import "../../components"

Rectangle {
    width: 800
    height: 420
    visible: true
    enabled: mainPermisMgr.editabled

    Connections {
        target: measure_mode
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            console.debug("QML::UpdatePage measure.mode")
            listView.updateModeIndex();
            averageTimes.updateAverageTimes();
            retest.updateRetest();
            highLimit.updateHighLimit();
            lowLimit.updateLowLimit();
            pretreatDelay.updatePretreat();
            page_manager.updatePageDone();
        }
    }

    H2oExclusiveGroup {
        id: tabGroup
    }

    Text {
        id: modeText
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.top: parent.top
        anchors.topMargin: 10
        text: qsTr("Mode")+translator.tr
        font: mainTheme.titleFont
    }

    ListView {
        id: listView
        anchors.left: modeText.left
        anchors.leftMargin: 10
        anchors.top: modeText.bottom
        anchors.topMargin: 5
        width: 280
        height: 76
        boundsBehavior: Flickable.StopAtBounds
        scale: 1
        cacheBuffer: 200
        contentHeight: 1144
        snapMode: ListView.SnapToItem
        flickableDirection: Flickable.VerticalFlick
        spacing: 5
        property int currentIndex
        property var listName: [
            qsTr("Standard Mode")+translator.tr,
            qsTr("Average Mode")+translator.tr
        ]

        model: ListModel {
            ListElement { name: qsTr("Standard Mode"); check: false; index: 0 }
            ListElement { name: qsTr("Average Mode"); check: false; index: 1 }
        }

        delegate: H2oLineRadioButton {
            text: listView.listName[index]
            checked: check
            exclusiveGroup: tabGroup
            width: parent.width
            onValueChanged: {
                listView.currentIndex = index;
                measure_mode.setObj("index", index);
            }
        }

        function updateModeIndex() {
            var i = measure_mode.getObjInt("index");
            //listView.model.setProperty(i, "check", true);
            listView.contentItem.children[i].checked = true;
            listView.currentIndex = i;
        }
    }


    H2oDropBox {
        id: averageTimes
        anchors.left: listView.right
        anchors.leftMargin: 5
        anchors.top: listView.top
        anchors.topMargin: 35
        width: 146
        height: 41
        enabled: listView.currentIndex === 1 ? true:false
        currentIndex: 0

        listName: [
            "2",
            "3",
            "4",
            "5"
        ]

        model: ListModel {
            id: intervalTimeItem
            ListElement { name: "2"; value: 2 }
            ListElement { name: "3"; value: 3 }
            ListElement { name: "4"; value: 4 }
            ListElement { name: "5"; value: 5 }
        }

        onIndexChanged: {
            measure_mode.setObj("average", listName[currentIndex]);
        }

        function updateAverageTimes() {
            var average = measure_mode.getObjInt("average");
            for(var i = 0; i < intervalTimeItem.rowCount(); i++) {
                if(intervalTimeItem.get(i).value === average) {
                    currentIndex = i;
                    break;
                }
            }
        }
    }

    Rectangle {
        id: rectangle
        width: 500
        height: 121
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.top: listView.bottom
        anchors.topMargin: 15
        enabled: listView.currentIndex === 0 ? true:false
        Text {
            id: retestText
            text: qsTr("Retest")+translator.tr
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
            font: mainTheme.titleFont
        }

        H2oSwitch {
            id: retest
            anchors.left: retestText.right
            anchors.leftMargin: 10
            anchors.verticalCenter: retestText.verticalCenter
            onValueChanged: {
                measure_mode.setObj("retest", checked)
            }

            function updateRetest() {
                checked = measure_mode.getObjInt("retest");
            }
        }

        GridLayout {
            anchors.left: retestText.left
            anchors.leftMargin: 10
            anchors.top: retestText.bottom
            anchors.topMargin: 20
            columns: 2
            columnSpacing: 10

            Text {

                text: qsTr("Low: ")+translator.tr
                font: mainTheme.smallFont
            }

            H2oTextField {
                id: lowLimit

                width: 207
                height: 40
                enabled: retest.checked ? true:false
                plaintext: text+" "+qsTr("mg/L")+translator.tr

                onEditDone: {
                    var numOrg = Number.fromLocaleString(Qt.locale(), inputStr);
                    var num = numOrg.toFixed(3);

                    if(measure_mode.isInRange("low", num))
                    {
                        text = num;
                        measure_mode.setObj("low", num);
                    } else {
                        var range = measure_mode.rangeString("low");
                        mainMessageDialogOneButton.text = qsTr("Your input ")+numOrg+qsTr(" out of range")+translator.tr+range;
                        mainMessageDialogOneButton.open();
                        text = preText;
                    }
                }

                function updateLowLimit()
                {
                    var num = measure_mode.getObjFloat("low");
                    text = Number(num).toFixed(3);
                }
            }

            /*Text {
                id: text1
                x: 316
                y: 211
                text: qsTr("mg/L")
                font.pixelSize: 18
            }*/
            Text {
                text: qsTr("High:")+translator.tr
                font: mainTheme.smallFont
            }

            H2oTextField {
                id: highLimit

                width: 207
                height: 40
                enabled: retest.checked ? true:false
                plaintext: text+" "+qsTr("mg/L")+translator.tr

                onEditDone: {
                    var numOrg = Number.fromLocaleString(Qt.locale(), inputStr);
                    var num = numOrg.toFixed(3);

                    if(measure_mode.isInRange("high", num))
                    {
                        text = num;
                        measure_mode.setObj("high", num);
                    } else {
                        var range = measure_mode.rangeString("high");
                        mainMessageDialogOneButton.text = qsTr("Your input ")+numOrg+qsTr(" out of range")+translator.tr+range;
                        mainMessageDialogOneButton.open();
                        text = preText;
                    }
                }

                function updateHighLimit() {
                    var num = measure_mode.getObjFloat("high");
                    text = Number(num).toFixed(3);
                }
            }

            /*Text {
                id: text2
                x: 316
                y: 256
                text: qsTr("mg/L")
                font.pixelSize: 18
            }*/
        }
    }

    Text {
        id: pretrementText
        anchors.left: rectangle.left
        anchors.leftMargin: 0
        anchors.top: rectangle.bottom
        anchors.topMargin: 20
        text: qsTr("Pretrement delay")+translator.tr
        font: mainTheme.titleFont
    }

    H2oTextField {
        id: pretreatDelay
        anchors.left: pretrementText.left
        anchors.leftMargin: 10
        anchors.top: pretrementText.bottom
        anchors.topMargin: 5
        width: 280
        height: 40
        plaintext: text+" "+qsTr("seconds")+translator.tr
        text: "0"

        onEditDone: {
            var numOrg = Number.fromLocaleString(Qt.locale(), inputStr);
            var num = numOrg.toFixed(0);

            if(measure_mode.isInRange("pretreat_delay", num))
            {
                text = num;
                measure_mode.setObj("pretreat_delay", num);
            } else {
                var range = measure_mode.rangeString("pretreat_delay");
                mainMessageDialogOneButton.text = qsTr("Your input ")+numOrg+qsTr(" out of range")+translator.tr+range;
                mainMessageDialogOneButton.open();
                text = preText;
            }
        }

        function updatePretreat() {
            var textTime = measure_mode.getObjInt("pretreat_delay")
            text = Number(textTime).toString()
        }
    }
}



