/****************************************************************************
** H2oSpinBox.qml
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
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles.Flat 1.0 as Flat

Item {
    id: root

    width: orientation == Qt.Horizontal ? (80+textWidth) : 40
    height: orientation == Qt.Horizontal ? 40 : (80+textWidth)
    property int value: 0
    property int delta: 10
    property int max: delta
    property int min: -delta
    opacity: enabled ? 1.0 : 0.4
    property int orientation: Qt.Vertical
    property int textWidth: 40
    property bool textVisible: true
    property string increaseText: "+"
    property string decreaseText: "-"

    signal valueIncreased(var value)
    signal valueDecreased(var value)

    Timer {
        id: inctimer
        interval: 200
        repeat: true
        running: false
        triggeredOnStart: true
        onTriggered: {

            value ++;
            valueIncreased(value);
        }
    }

    Timer {
        id: dectimer
        interval: 200
        repeat: true
        running: false
        triggeredOnStart: true
        onTriggered: {
            value --;
            valueDecreased(value);
        }
    }

    Rectangle {
        id: label
        visible: textVisible
        height: orientation == Qt.Horizontal ? parent.height : parent.width
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        Text {
            id: txt
            font: mainTheme.smallFont
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: value
        }
    }

    Rectangle {
        id: decrementControl
        width: orientation == Qt.Horizontal ? parent.height : parent.width
        height: width
        radius: 4
        border.color: "#0098db"; //Flat.FlatStyle.lightFrameColor
        border.width: Flat.FlatStyle.onePixel
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        color: decrMouseArea.pressed ? "#0098db" : "white"

        Text {
            font: mainTheme.mediumFont
            anchors.centerIn: parent
            text: decreaseText
            color: decrMouseArea.pressed ? "white" : "#0098db"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        MouseArea {
            id: decrMouseArea
            anchors.fill: parent
            property bool mpressed
            onPressed: {
                if(!filterTimer.running)
                    mpressed = pressed;
            }
            onReleased: {
                if(mpressed) {
                    value --;
                    valueDecreased(value);
                    mpressed = pressed;
                    filterTimer.start();
                }
            }
        }
    }

    Rectangle {
        id: incrementControl
        width: orientation == Qt.Horizontal ? parent.height : parent.width
        height: incrementControl.width
        radius: 4
        border.color: "#0098db"; //Flat.FlatStyle.lightFrameColor
        border.width: Flat.FlatStyle.onePixel
        anchors.top: parent.top
        anchors.right: parent.right
        color: incrMouseArea.pressed ? "#0098db" : "white"
        Text {
            font: mainTheme.mediumFont
            anchors.centerIn: parent
            text: increaseText
            color: incrMouseArea.pressed ? "white" : "#0098db"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        MouseArea {
            id: incrMouseArea
            anchors.fill: parent
            property bool mpressed
            onPressed: {
                if(!filterTimer.running)
                    mpressed = pressed;
            }
            onReleased: {
                if(mpressed) {
                    value ++;
                    valueIncreased(value);
                    mpressed = pressed;
                    filterTimer.start();
                }
            }
        }

    }


    Timer {
        id: filterTimer
        interval: 20
        repeat: false
        triggeredOnStart: false
        running: false
    }
}
