/****************************************************************************
** MessageDelegate.qml - Title bar for message
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
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Styles.Flat 1.0 as Flat
import "../components"

Item {
    width: 800
    height: 60
    property alias sUDiskIcon: udiskIcon
    property string titleMessage
    property alias timeMessage: timeStamp
    property bool buttonEnabled: true
    signal refreshTimerTimeOut();
    signal mainWindowPopped(var objName);
    signal loginWindowPopped();

    Connections {
        target: current_measure
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            //if(mainStackView.depth > 1) {
            //console.debug("QML::UpdatePage Message Delegate current.measure")
            process.updateProcess();
            subProcess.updateSubProcess();
            progressBar.updateProgress();
            remainTime.updateRemainTime();
            refreshTimerTimeOut();
            //}

        }
    }

    Connections {
        target: mainStackView
        ignoreUnknownSignals: true
        onDepthChanged: {
            // console.debug("QML::MessageDelegate mainstackview depth="+mainStackView.depth)
            if(mainStackView.depth <= 1) {
                naviIcon.text = "\ue607";
                naviText.text = "Menu";
            } else if(mainStackView.depth == 2) {
                naviIcon.text = "\ue600";
                naviText.text = "Hide";
            } else if(mainStackView.depth > 2) {
                naviIcon.text = "\uf053";
                naviText.text = ""//"Back";
            }
        }
    }

    Rectangle {
        id: borderImage
        width: 800
        //border.bottom: 8
        //source: "qrc:///resources/images/toolbar-hach.png"
        height: parent.height
        color: "#d4d4d4"

        Rectangle {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            height: Flat.FlatStyle.twoPixels
            width: parent.width
            color: Flat.FlatStyle.mediumFrameColor
        }

        // menu or back Button
        Rectangle {
            id: menuIcon
            width: 60
            height: 60
            enabled: buttonEnabled
            opacity: enabled ? 1.0 : 0.4
            // TODO: screen touch cause the menuIcon color changed error
            color: "transparent"//menuMouseArea.pressed ? "#9e9e9e":"transparent"
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            Text {
                id: naviIcon
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: (mainStackView.depth > 2) ? 18 : 10
                //opacity: mainStackView.depth > 1 ? 0 : 1
                /*text: {
                    if(mainStackView.depth <= 1)
                        return "\ue607";
                    else if(mainStackView.depth == 2)
                        return "\ue600"
                    if(mainStackView.depth > 2)
                        return "\uf053"
                }*/
                color: theme.hachBlueColor
                font: theme.mediumIcon
            }
            Text {
                id: naviText
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: naviIcon.bottom
                //opacity: mainStackView.depth > 1 ? 0 : 1
                /*text: {
                    if(mainStackView.depth <= 1)
                        return "Menu";
                    else if(mainStackView.depth == 2)
                        return "Hide"
                    if(mainStackView.depth > 2)
                        return ""//"Back"
                }*/
                color: theme.hachBlueColor
                font.pixelSize: 12
            }

            MouseArea {
                id: menuMouseArea
                anchors.fill: parent
                property bool mpressed
                onPressed: {
                    if(!timer.running)
                        mpressed = pressed;
                }
                onReleased: {
                    if(mpressed) {
                        if(mainStackView.depth > 1) {
                            var objName = mainStackView.currentItem.objectName
                            //console.debug("QML::MessageDelegate: "+objName)
                            mainWindowPopped(objName);
                            // if in repeater page, clear the repeater page
                            if(mainStackView.depth > 2) {
                                page_manager.startUpdate("");
                            }
                            mainStackView.pop({immediate: true})
                        } else {
                            //if(mainPermisMgr.checkPermission()) {
                            mainStackView.push({item: mainNaviPage, immediate: true})
                            //}
                        }

                        mpressed = pressed;
                        timer.start();
                    }
                }
            }
            Timer {
                id: timer
                interval: 20
                repeat: false
                triggeredOnStart: false
                running: false
            }
        }

        Rectangle {
            id: sp
            width: Flat.FlatStyle.onePixel
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: menuIcon.right

            color: Flat.FlatStyle.lightFrameColor
        }

        // login Button
        Rectangle {
            id: lockIcon
            width: mainPermisMgr.permsenabled ? 48 : 0
            height: parent.height
            //radius: 8
            anchors.verticalCenterOffset: 0
            color: lockMouseArea.pressed ? "#9e9e9e":"transparent"
            anchors.left: sp.left
            anchors.verticalCenter: parent.verticalCenter
            visible: true // mainStackView.depth > 1 ? true : false
            clip: true
            opacity: enabled ? 1.0 : 0.4
            enabled: buttonEnabled
            Text {
                anchors.centerIn: parent
                //opacity: mainStackView.depth > 1 ? 0 : 1
                property var textList: ["\ue90a", "\ue90a", "\ue90b"]
                property var colorList: [mainTheme.mediumGrayColor, mainTheme.hachBlueColor, mainTheme.hachBlueColor]
                text: textList[mainPermisMgr.permslevel]
                color: colorList[mainPermisMgr.permslevel]
                font: mainTheme.bigIcon
            }
            MouseArea {
                id: lockMouseArea
                anchors.rightMargin: 1
                anchors.bottomMargin: 0
                anchors.leftMargin: -1
                anchors.topMargin: 0
                anchors.fill: parent
                onClicked: {
                    if(mainStackView.depth > 1) {
                        var objName = mainStackView.currentItem.objectName
                        //loginWindowPopped();
                    } else {
                    }
                    if(mainPermisMgr.permission == 0) {
                        mainLoginDialog.openDialog();
                    } else {
                        mainLogoutDialog.openDialog();
                    }
                }
            }
        }

        Rectangle {
            id: sp2
            width: Flat.FlatStyle.onePixel
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: lockIcon.right

            color: Flat.FlatStyle.lightFrameColor
        }

        // title message
        Text {
            id: title
            //opacity: mainStackView.depth > 1 ? 1 : 0
            Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
            anchors.left: sp2.right
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            color: theme.mainTextColor
            text: {
                var title = "";
                if(mainStackView.currentItem != null) {
                    if(mainStackView.currentItem.title !== null) {
                        title = mainStackView.currentItem.title;
                    }
                }

                return title;
            }

            font: theme.mediumFont
        }

        H2oTimeStamp {
            id: timeStamp
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            //anchors.horizontalCenterOffset: mainStackView.depth > 1 ? -50 : 300
            anchors.horizontalCenterOffset: mainStackView.depth > 1 ? 0 : (300-udiskIcon.width)
            oriention: mainStackView.depth > 1 ? Qt.Vertical : Qt.Horizontal
        }

        Text {
            id: udiskIcon
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            text: "\ue909"
            font.pixelSize: 16
            color: mainTheme.mainTextColor
            visible: udisk_dectect.isExist()
            width: udiskIcon.visible ? 16 : 0
            Connections {
                target: udisk_dectect
                ignoreUnknownSignals: true
                onSigUDiskDectect: {
                    udiskIcon.visible = exist;
                }
            }
        }

        // progress bar
        H2oProgressBar {
            id: progressBar
            anchors.left: udiskIcon.left
            anchors.leftMargin: -130
            anchors.top: parent.top
            anchors.topMargin: 10
            width: 120
            height: 19
            value: 0.0
            visible: mainStackView.depth > 1 ? 1 : 0

            function updateProgress() {
                var rem = current_measure.getObjInt("remain_time");
                var total = current_measure.getObjInt("total_time");
                var val;
                if(total > 0) {
                    val = rem/total;
                    if(val < 1.0) {
                        val = val;
                    } else {
                        val = 1.0;
                    }
                } else {
                    val = 1.0;
                }

                progressBar.value = 1.0 - val;
                //console.debug("QML::updateProgress rem "+rem+" total "+total);
            }
        }

        // remain time
        Text {
            id: remainTime
            anchors.left: progressBar.left
            anchors.leftMargin: 0
            anchors.top: progressBar.bottom
            anchors.topMargin: 5
            text: qsTr("Remain")+": "+minute+" "+qsTr("min")+" "+second+" "+qsTr("s")+translator.tr
            font.pixelSize: 16
            color: theme.secondaryTextColor
            visible: mainStackView.depth > 1 ? 1 : 0
            property int minute: 0
            property int second: 0

            function updateRemainTime() {
                var time = current_measure.getObjInt("remain_time");
                minute = parseInt(time/60);
                second = time-minute*60;
                //console.debug("QML::updateRemainTime "+time);
            }
        }

        // process description
        ProcessDescription {
            id: processDescription
        }

        // process
        Text {
            id: process
            anchors.right: progressBar.left
            anchors.rightMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 5
            text: processDescription.mainProcessDesc(mainIndex, rangeIndex, subIndex)
            font: mainTheme.smallboldFont
            color: theme.secondaryTextColor
            visible: mainStackView.depth > 1 ? 1 : 0
            property int mainIndex: 0
            property int rangeIndex: rangeIndex = processDescription.rangeLength -1;
            property int subIndex: processDescription.subDescLength -1;

            function updateProcess()
            {
                var i = current_measure.getObjInt("main");
                var detail = current_measure.getObjInt("detail");
                if(i >= 0 && i < processDescription.mainDescLength)
                {
                    mainIndex = i;
                } else {
                    mainIndex = processDescription.mainDescLength-1;
                }

                if(detail >= 0x00FF && detail <= 0x03FF)
                {
                    rangeIndex = (detail >> 8) & 0xFF;
                } else {
                    rangeIndex = processDescription.rangeLength -1;
                }

                if(detail >= 0x0001 && detail <= 0x00E0)
                {
                    subIndex = detail;
                } else {
                    subIndex = processDescription.subDescLength -1;
                }
            }
        }

        // sub process
        Text {
            id: subProcess
            anchors.right: progressBar.left
            anchors.rightMargin: 10
            anchors.top: remainTime.top
            anchors.topMargin: 0
            text: processDescription.description(index);
            font.bold: true
            font.pixelSize: 16
            color: theme.secondaryTextColor
            visible: mainStackView.depth > 1 ? 1 : 0
            property int index: processDescription.length-1

            function updateSubProcess()
            {
                var i = current_measure.getObjInt("action");

                if(i >= 0 && i < processDescription.length)
                {
                    if(process.index == 0)
                    {
                        index = processDescription.length-1;
                    } else {
                        index = i;
                    }
                }
            }
        }
    }
}
