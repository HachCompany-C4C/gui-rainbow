/****************************************************************************
** H2oTimeSetting.qml
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

Rectangle {
    id: root
    height: 40
    width: height * 4 + 30


    property var value: [1, 0] // hour, minute
    property var min: [0, 0] // mim hour, min minute
    property var max: [23, 59] // max hour, max minute
    property int currentIndex: 0
    opacity: enabled ? 1.0 : 0.4

    signal hourSetting(var hour)
    signal minuteSetting(var minute)

    function init(hour, minute) {
        root.value[0] = hour;
        root.value[1] = minute;
        tabItems.itemAt(0).value = hour;
        tabItems.itemAt(1).value = minute;
    }

    Rectangle {
        id: decrementControl
        width: parent.height
        height: parent.height
        radius: 4
        border.color: "#0098db"; //Flat.FlatStyle.lightFrameColor
        border.width: Flat.FlatStyle.onePixel
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        color: decrMouseArea.pressed ? "#0098db" : "white"

        Text {
            font: mainTheme.mediumFont
            anchors.centerIn: parent
            text: "-"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        Timer {
            id: dectimer
            interval: 200
            repeat: true
            running: false
            triggeredOnStart: true
            onTriggered: {
                decrementControl.valueDecrease();
            }
        }

        function valueDecrease()
        {
            if(root.value[root.currentIndex] > root.min[root.currentIndex]) {
                root.value[root.currentIndex] --;
            } else {
                root.value[root.currentIndex] = root.max[root.currentIndex]
            }

            tabItems.itemAt(root.currentIndex).value = root.value[root.currentIndex];
            if(root.currentIndex == 0) //hour setting
            {
                hourSetting(root.value[0]);
            }
            else if(root.currentIndex == 1) //minute setting
            {
                minuteSetting(root.value[1]);
            }
        }

        MouseArea {
            id: decrMouseArea
            anchors.fill: parent
            onClicked: {
                decrementControl.valueDecrease();
            }

            onPressAndHold: {
                dectimer.start();
            }

            onReleased: {
                dectimer.stop();
            }
        }
    }

    H2oExclusiveGroup {
        id: tabGroup
    }

    // tab Item
    Row {
        id: row
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: decrementControl.right
        anchors.leftMargin: 10
        width: parent.width
        height: parent.height
        spacing: 15

        Repeater {
            id: tabItems
            model: ListModel {
                ListElement { value: 10; check: true; index: 0 }
                ListElement { value: 20; check: false; index: 1 }
            }

            delegate: RadioButton {
                id: radioButton
                exclusiveGroup: tabGroup
                checked: check
                property int value: root.value[index]
                onCheckedChanged: {
                    //console.debug("QML::H2oTabView index "+index+" "+check)
                }

                style: RadioButtonStyle {
                    indicator: Rectangle {
                        implicitWidth: 0
                        implicitHeight: parent.height
                    }
                    label: Component {
                        Rectangle {
                            implicitWidth: 40
                            implicitHeight: 40

                            Rectangle {
                                anchors.centerIn: parent
                                implicitWidth: 32
                                implicitHeight: parent.height
                                visible: true
                                color: radioButton.checked ? "#0098db" : "white"
                                anchors.margins: 0
                                Text {
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    anchors.centerIn: parent
                                    text: radioButton.value < 10 ? "0"+radioButton.value : radioButton.value
                                    font: mainTheme.smallFont
                                    color: radioButton.checked ? "white" : "black"
                                }
                            }
                        }
                    }
                }
                onClicked: {
                    root.currentIndex = index;
                }
            }
        }
    }

    Text {
        font: mainTheme.mediumFont
        anchors.centerIn: parent
        anchors.verticalCenter: parent.verticalCenter
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: ":"
    }

    Rectangle {
        id: incrementControl
        width: parent.height
        height: parent.height
        radius: 4
        border.color: "#0098db"; //Flat.FlatStyle.lightFrameColor
        border.width: Flat.FlatStyle.onePixel
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        color: incrMouseArea.pressed ? "#0098db" : "white"
        Text {
            font: mainTheme.mediumFont
            anchors.centerIn: parent
            text: "+"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        Timer {
            id: inctimer
            interval: 200
            repeat: true
            running: false
            triggeredOnStart: true
            onTriggered: {
                incrementControl.valueIncrease();
            }
        }

        function valueIncrease()
        {
            if(root.value[root.currentIndex] < root.max[root.currentIndex]) {
                //console.debug("QML::H2oTimeSetting incrMouseArea")
                root.value[root.currentIndex] ++;
            } else {
                root.value[root.currentIndex] = root.min[root.currentIndex]
            }

            tabItems.itemAt(root.currentIndex).value = root.value[root.currentIndex];
            if(root.currentIndex == 0) //hour setting
            {
                hourSetting(root.value[0]);
            }
            else if(root.currentIndex == 1) //minute setting
            {
                minuteSetting(root.value[1]);
            }
        }

        MouseArea {
            id: incrMouseArea
            anchors.fill: parent
            onClicked: {
                incrementControl.valueIncrease();
            }

            onPressAndHold: {
                inctimer.start();
            }

            onReleased: {
                inctimer.stop();
            }
        }
    }
}

