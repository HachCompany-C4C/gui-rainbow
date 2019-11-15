/****************************************************************************
** AnalogOutput.qml - Interface for AO module setting
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
    objectName: "ao setup"
    property string title: qsTr("IO Setup")+translator.tr
    width: 800
    height: 420
    enabled: mainPermisMgr.editabled

    Connections {
        target: io_ao
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            aoStatus.updateIOStatus();
            ch1RangeList.updateCh1Range();
            ch1ModeList.updateCh1Mode();
            ch1Mapup.updateMapup();
            ch1Mapdown.updateMapdown();
            chTransfer.updateTransfer();
            ch2RangeList.updateCh2Range();
            ch2ModeList.updateCh2Mode();
            ch2Mapup.updateMapup();
            ch2Mapdown.updateMapdown();
            //ch2Transfer.updateTransfer();
            mainStackView.push({item: root, immediate: true})
            console.debug("QML::UpdatePage io.ao");
            page_manager.updatePageDone();
        }
    }


    Rectangle {
        id: title
        x: 25
        y: 0
        width: 498
        height: 45

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("O: AO")+translator.tr
            font: mainTheme.mediumFont
        }

        H2oSwitch {
            id: aoStatus
            x: 675
            anchors.verticalCenterOffset: 0
            anchors.rightMargin: -248
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right

            function updateIOStatus(){
                checked = io_ao.getObjBool("enabled");
                console.debug("QML::AO checked: "+checked)
            }

            onClicked: {
                io_ao.setObj("enabled", checked);
            }
        }
    }

    ListModel {
        id: modeList
        ListElement { name: qsTr("Active"); check: false; index: 0 }
        ListElement { name: qsTr("Hold"); check: false; index: 1 }
        ListElement { name: qsTr("Transfer"); check: false; index: 2 }
    }

    ListModel {
        id: rangeList
        ListElement { name: qsTr("0~20"); check: false; index: 0 }
        ListElement { name: qsTr("4~20"); check: false; index: 1 }
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
        height: 300
        width: Flat.FlatStyle.onePixel
        color: Flat.FlatStyle.lightFrameColor
    }

    Rectangle {
        width: 800-20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: title.bottom
        anchors.topMargin: 300
        height: Flat.FlatStyle.onePixel
        color: Flat.FlatStyle.lightFrameColor
    }

    GroupBox {
        id: groupBox
        enabled: aoStatus.checked
        x: 0
        y: 49
        width: 734
        height: 347
        flat: true
        Text {
            id: textCH1
            x: 117
            y: 0
            text: qsTr("CH1")+translator.tr
            font: mainTheme.titleFont
        }

        Text {
            id: textRange1
            x: 1
            y: 39
            font: mainTheme.titleFont
        }

        H2oExclusiveGroup {
            id: tabCh1RangeGroup
        }

        ListView {
            id: ch1RangeList
            x: 117
            y: 34
            width: 263
            height: 38
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
            orientation: Qt.Horizontal
            property int range: 0

            model: ListModel {
                id: ch1RangeListModel
                ListElement { name: "0~20 mA"; check: false; index: 0 }
                ListElement { name: "4~20 mA"; check: false; index: 1 }
            }

            delegate: H2oLineRadioButton {
                text: name
                checked: check
                exclusiveGroup: tabCh1RangeGroup
                width: 120
                onValueChanged: {
                    /*"range=0
                    1: AO_MEASURE0_ACTIVE,
                    2: AO_MEASURE0_HOLD,
                    3: AO_MEASURE0_TRANSFER,
                    range=1
                    4: AO_MEASURE1_ACTIVE,
                    5: AO_MEASURE1_HOLD,
                    6: AO_MEASURE1_TRANSFER,"*/
                    var range = index;
                    var idx = (range === 0) ? (ch1ModeList.currentIndex  + 1) : (ch1ModeList.currentIndex  + 4);
                    io_ao.setObjs(["ch1range","ch1mode"], [index, idx]);
                }
            }

            function updateCh1Range()
            {
                var mode = io_ao.getObjInt("ch1mode");
                //ch1RangeListModel.setProperty(i, "check", true);
                /*"range=0
                1: AO_MEASURE0_ACTIVE,
                2: AO_MEASURE0_HOLD,
                3: AO_MEASURE0_TRANSFER,
                range=1
                4: AO_MEASURE1_ACTIVE,
                5: AO_MEASURE1_HOLD,
                6: AO_MEASURE1_TRANSFER,"*/
                ch1RangeList.range = mode <= 3 ? 0 : 1;
                ch1RangeList.contentItem.children[ch1RangeList.range].checked = true;
            }
        }

        Text {
            id: textMappingUp1
            x: 0
            y: 129
            text: qsTr("Mapping High")+translator.tr
            font: mainTheme.smallFont
        }

        H2oTextField {
            id: ch1Mapup
            x: 117
            y: 117
            width: 213
            height: 40
            plaintext: text+" "+"mg/L"

            onEditDone: {
                var numOrg = Number.fromLocaleString(Qt.locale(), inputStr);
                var num = numOrg.toFixed(3);

                if(io_ao.isInRange("ch1mapup", num))
                {
                    text = num;
                    io_ao.setObj("ch1mapup", num);
                } else {
                    var range = io_ao.rangeString("ch1mapup");
                    mainMessageDialog.text = qsTr("Your input ")+numOrg+qsTr(" out of range")+translator.tr+range;
                    mainMessageDialog.open();
                    text = preText;
                }
            }

            function updateMapup() {
                var textTime = io_ao.getObjFloat("ch1mapup")
                text = Number(textTime).toFixed(3)
            }

        }

        H2oTextField {
            id: ch1Mapdown
            x: 117
            y: 75
            width: 213
            height: 40
            plaintext: text+" "+"mg/L"

            onEditDone: {
                var numOrg = Number.fromLocaleString(Qt.locale(), inputStr);
                var num = numOrg.toFixed(3);

                if(io_ao.isInRange("ch1mapdown", num))
                {
                    text = num;
                    io_ao.setObj("ch1mapdown", num);
                } else {
                    var range = io_ao.rangeString("ch1mapdown");
                    mainMessageDialog.text = qsTr("Your input ")+numOrg+qsTr(" out of range")+translator.tr+range;
                    mainMessageDialog.open();
                    text = preText;
                }
            }

            function updateMapdown() {
                var textTime = io_ao.getObjFloat("ch1mapdown")
                text = Number(textTime).toFixed(3)
            }

        }

        Text {
            id: textMode1
            x: 0
            y: 171
            text: qsTr("Mode")+translator.tr
            font: mainTheme.smallFont
        }

        H2oExclusiveGroup {
            id: tabCh1ModeGroup
        }

        ListView {
            id: ch1ModeList
            x: 117
            y: 166
            width: 213
            height: 125
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
            property int currentIndex
            property var nameList: [
                qsTr("Active")+translator.tr,
                qsTr("Hold")+translator.tr,
                qsTr("Transfer")+translator.tr
            ]

            model: ListModel {
                id: ch1ModeListModel
                ListElement { name: qsTr("Active"); check: false; index: 0 }
                ListElement { name: qsTr("Hold"); check: false; index: 1 }
                ListElement { name: qsTr("Transfer"); check: false; index: 2 }
            }

            delegate: H2oLineRadioButton {
                text: ch1ModeList.nameList[index]
                checked: check
                exclusiveGroup: tabCh1ModeGroup
                width: 200
                onValueChanged: {
                    /*"range=0
                    1: AO_MEASURE0_ACTIVE,
                    2: AO_MEASURE0_HOLD,
                    3: AO_MEASURE0_TRANSFER,
                    range=1
                    4: AO_MEASURE1_ACTIVE,
                    5: AO_MEASURE1_HOLD,
                    6: AO_MEASURE1_TRANSFER,"*/
                    var range = ch1RangeList.range; //io_ao.getObjInt("ch1range");
                    var idx = (range === 0) ? (index + 1) : (index + 4);
                    io_ao.setObj("ch1mode", idx);
                    ch1ModeList.currentIndex = index;
                }
            }

            function setMode() {

            }

            function updateCh1Mode()
            {
                var i = io_ao.getObjInt("ch1mode");
                console.debug("QML::AO i="+i)
                if(i > 0) {
                    i = (i - 1)%3;
                }
                //ch1ModeListModel.setProperty(i, "check", true);
                ch1ModeList.contentItem.children[i].checked = true;
                ch1ModeList.currentIndex = i;
            }
        }


        /*Text {
            id: textmA
            anchors.left: chTransfer.right
            anchors.leftMargin: 10
            anchors.verticalCenter: chTransfer.verticalCenter
            text: qsTr("mA")
            font.pixelSize: 16
        }*/

        Text {
            id: textCH2
            x: 513
            y: 0
            text: qsTr("CH2")+translator.tr
            font: mainTheme.titleFont
        }

        Text {
            id: textRange
            x: 403
            y: 39
            text: qsTr("Range")+translator.tr
            font: mainTheme.smallFont
        }

        H2oExclusiveGroup {
            id: tabCh2RangeGroup
        }

        ListView {
            id: ch2RangeList
            x: 513
            y: 34
            width: 213
            height: 38
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
            orientation: Qt.Horizontal
            property int range: 0

            model: ListModel {
                id: ch2RangeListModel
                ListElement { name: "0~20 mA"; check: false; index: 0 }
                ListElement { name: "4~20 mA"; check: false; index: 1 }
            }

            delegate: H2oLineRadioButton {
                text: name
                checked: check
                exclusiveGroup: tabCh2RangeGroup
                width: 120
                onValueChanged: {
                    /*"range=0
                    1: AO_MEASURE0_ACTIVE,
                    2: AO_MEASURE0_HOLD,
                    3: AO_MEASURE0_TRANSFER,
                    range=1
                    4: AO_MEASURE1_ACTIVE,
                    5: AO_MEASURE1_HOLD,
                    6: AO_MEASURE1_TRANSFER,"*/
                    var range = index;
                    var idx = (range === 0) ? (ch2ModeList.currentIndex  + 1) : (ch2ModeList.currentIndex  + 4);
                    io_ao.setObjs(["ch2range","ch2mode"], [index, idx]);
                }
            }

            function updateCh2Range()
            {
                var mode = io_ao.getObjInt("ch2mode");
                //ch2RangeListModel.setProperty(i, "check", true);
                /*"range=0
                1: AO_MEASURE0_ACTIVE,
                2: AO_MEASURE0_HOLD,
                3: AO_MEASURE0_TRANSFER,
                range=1
                4: AO_MEASURE1_ACTIVE,
                5: AO_MEASURE1_HOLD,
                6: AO_MEASURE1_TRANSFER,"*/
                ch2RangeList.range = mode <= 3 ? 0 : 1;
                ch2RangeList.contentItem.children[ch2RangeList.range].checked = true;
            }
        }

        Text {
            id: textMappingup2
            x: 403
            y: 126
            text: qsTr("Mapping High")+translator.tr
            font: mainTheme.smallFont
        }

        H2oTextField {
            id: ch2Mapup
            x: 513
            y: 116
            width: 213
            height: 40
            plaintext: text+" "+"mg/L"

            onEditDone: {
                var numOrg = Number.fromLocaleString(Qt.locale(), inputStr);
                var num = numOrg.toFixed(3);

                if(io_ao.isInRange("ch2mapup", num))
                {
                    text = num;
                    io_ao.setObj("ch2mapup", num);
                } else {
                    var range = io_ao.rangeString("ch2mapup");
                    mainMessageDialog.text = qsTr("Your input ")+numOrg+qsTr(" out of range")+translator.tr+range;
                    mainMessageDialog.open();
                    text = preText;
                }
            }

            function updateMapup() {
                var textTime = io_ao.getObjFloat("ch2mapup")
                text = Number(textTime).toFixed(3)
            }

        }

        H2oTextField {
            id: ch2Mapdown
            x: 513
            y: 75
            width: 213
            height: 40
            plaintext: text+" "+"mg/L"

            onEditDone: {
                var numOrg = Number.fromLocaleString(Qt.locale(), inputStr);
                var num = numOrg.toFixed(3);

                if(io_ao.isInRange("ch2mapdown", num))
                {
                    text = num;
                    io_ao.setObj("ch2mapdown", num);
                } else {
                    var range = io_ao.rangeString("ch2mapdown");
                    mainMessageDialog.text = qsTr("Your input ")+numOrg+qsTr(" out of range")+translator.tr+range;
                    mainMessageDialog.open();
                    text = preText;
                }
            }

            function updateMapdown() {
                var textTime = io_ao.getObjFloat("ch2mapdown")
                text = Number(textTime).toFixed(3)
            }
        }

        Text {
            id: textMode2
            x: 403
            y: 171
            text: qsTr("Mode")+translator.tr
            font: mainTheme.smallFont
        }

        H2oExclusiveGroup {
            id: tabCh2ModeGroup
        }

        ListView {
            id: ch2ModeList
            x: 513
            y: 166
            width: 213
            height: 125
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
            property int currentIndex
            property var nameList: [
                qsTr("Active")+translator.tr,
                qsTr("Hold")+translator.tr,
                qsTr("Transfer")+translator.tr
            ]

            model: ListModel {
                id: ch2ModeListModel
                ListElement { name: qsTr("Active"); check: false; index: 0 }
                ListElement { name: qsTr("Hold"); check: false; index: 1 }
                ListElement { name: qsTr("Transfer"); check: false; index: 2 }
            }

            delegate: H2oLineRadioButton {
                text: ch2ModeList.nameList[index]
                checked: check
                exclusiveGroup: tabCh2ModeGroup
                width: 200
                onValueChanged: {
                    /*"range=0
                    1: AO_MEASURE0_ACTIVE,
                    2: AO_MEASURE0_HOLD,
                    3: AO_MEASURE0_TRANSFER,
                    range=1
                    4: AO_MEASURE1_ACTIVE,
                    5: AO_MEASURE1_HOLD,
                    6: AO_MEASURE1_TRANSFER,"*/
                    var range = ch2RangeList.range; //io_ao.getObjInt("ch2range");
                    var idx = (range === 0) ? (index + 1) : (index + 4);
                    io_ao.setObj("ch2mode", idx);
                    ch2ModeList.currentIndex = index;
                }
            }

            function updateCh2Mode()
            {
                var i = io_ao.getObjInt("ch2mode");
                console.debug("QML::AO i="+i)
                if(i > 0) {
                    i = (i - 1)%3;
                }
                //ch2ModeListModel.setProperty(i, "check", true);
                ch2ModeList.contentItem.children[i].checked = true;
                ch2ModeList.currentIndex = i;
            }

        }

        /*Text {
            id: text11
            x: 334
            y: 86
            text: qsTr("mg/L")
            font.pixelSize: 16
        }

        Text {
            id: text12
            x: 336
            y: 128
            text: qsTr("mg/L")
            font.pixelSize: 16
        }

        Text {
            id: text13
            x: 732
            y: 86
            text: qsTr("mg/L")
            font.pixelSize: 16
        }

        Text {
            id: text14
            x: 732
            y: 128
            text: qsTr("mg/L")
            font.pixelSize: 16
        }*/

        Text {
            id: text15
            x: 1
            y: 44
            text: qsTr("Range")+translator.tr
            font: mainTheme.smallFont
        }

        Text {
            id: textMappingDown1
            x: 0
            y: 86
            text: qsTr("Mapping Low")+translator.tr
            font: mainTheme.smallFont
        }

        Text {
            id: textMappingLow2
            x: 403
            y: 84
            text: qsTr("Mapping Low")+translator.tr
            font: mainTheme.smallFont
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -15
            height: 40
            width: 200

            Text {
                id: transferCurrentText
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Transfer Current")+translator.tr
                font: mainTheme.smallFont
            }

            H2oTextField {
                id: chTransfer
                anchors.left: transferCurrentText.right
                anchors.leftMargin: 10
                anchors.verticalCenter: transferCurrentText.verticalCenter
                width: 213
                height: 40
                //enabled: ch1ModeList.currentIndex === 2 ? true:false
                plaintext: text+" "+"mA"

                onEditDone: {
                    var numOrg = Number.fromLocaleString(Qt.locale(), inputStr);
                    var num = numOrg.toFixed(1);

                    if(io_ao.isInRange("transfer", num))
                    {
                        text = num;
                        io_ao.setObj("transfer", num);
                    } else {
                        var range = io_ao.rangeString("transfer");
                        mainMessageDialog.text = qsTr("Your input ")+numOrg+qsTr(" out of range")+translator.tr+range;
                        mainMessageDialog.open();
                        text = preText;
                    }
                }

                function updateTransfer() {
                    var textTime = io_ao.getObjFloat("transfer") //mA
                    text = textTime.toFixed(1)
                }

            }
        }
    }
}
