/****************************************************************************
** H2oButton.qml - Button
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
import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Button {
    id: root
    opacity: enabled ? 1.0 : 0.4
    property color buttonColor: "#0098db"
    property color buttonPressColor: "#313131"
    property color buttonBorderColor: "#0098db"
    property color buttonTextColor: "white"
    property color buttonTextPressColor: "white"
    property int buttonRadius: 4
    property var textFont: mainTheme.smallFont

    property bool mpressed

    signal released()

    style: ButtonStyle {
        id: buttonStyle

        label: Component {
            Text {
                text: root.text
                clip: true  // truncate the text if overflow of button area
                wrapMode: Text.WordWrap // wrap the text on word boundary
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.fill: parent
                font: textFont
                color: mouseArea.pressed ? buttonTextPressColor : buttonTextColor
            }
        }
        background: Rectangle {
            id: background
            implicitWidth: 420
            implicitHeight: 50
            color: mouseArea.pressed ? buttonPressColor : buttonColor
            border.color: buttonBorderColor
            border.width: 1
            radius: buttonRadius
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onPressed: {
            if(!timer.running)
                mpressed = pressed;
        }
        onReleased: {
            if(mpressed) {
                root.clicked();
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

