/****************************************************************************
** H2oKeyButton.qml
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
import QtQuick.Layouts 1.0

Button {
    id: root
    text: "A button"
    property var font: mainTheme.smallIcon2
    property bool mpressed

    style: ButtonStyle {
        label: Item {
            Text {
                id: txt
                text: root.text
                font: root.font
                anchors.centerIn: parent
            }
        }

        background: Rectangle {
            implicitWidth: 48
            implicitHeight: 48
            border.width: control.activeFocus ? 2 : 1
            border.color: "#888"
            radius: 4
            gradient: Gradient {
                GradientStop { position: 0 ; color: mouseArea.pressed ? "#ccc" : "#eee" }
                GradientStop { position: 1 ; color: mouseArea.pressed ? "#aaa" : "#ccc" }
            }
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
