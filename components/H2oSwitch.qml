/****************************************************************************
** H2oSwitch.qml
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

Rectangle {
    id: root
    property bool checked: false
    signal clicked()
    signal valueChanged()

    width: 74
    height: 40
    radius: 18
    //border.color: "#0098db"; //Flat.FlatStyle.lightFrameColor
    //border.width: Flat.FlatStyle.onePixel
    color: root.checked ? "#0098db" : "#9e9e9e"

    Rectangle {
        id: handleRect
        width: 40
        height: 40
        anchors.verticalCenter: parent.verticalCenter
        x: root.checked ? (parent.width - handleRect.width) : 0

        radius: 20
        color: "transparent"
        opacity: enabled ? 1.0 : 0.4

        Rectangle {
            width: 30
            height: 30
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            radius: 15
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            //console.debug("QML::H2oSwitch 1= "+root.checked)
            root.checked = !root.checked;
            //console.debug("QML::H2oSwitch 2= "+root.checked)
            root.clicked();
            root.valueChanged();
        }
    }
}

/*Switch {
	id: control
    checked: true
    property bool operated: false
    signal valueChanged
    opacity: enabled ? 1.0 : 0.4

    style: SwitchStyle {
        groove: Rectangle {
            id: grooveRect
            implicitWidth: 74
            implicitHeight: 40
            radius: 18
            color: checked ? "#0098db" : "#9e9e9e"
        }

        handle: Rectangle {
            id: handleRect
            implicitWidth: 40
            implicitHeight: 40

            radius: 20
            color: "transparent"

            Rectangle {
                implicitWidth: 30
                implicitHeight: 30
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                radius: 15
            }
        }
    }

    onCheckedChanged: {
        if(operated == true) {
            valueChanged();
        }
    }

    onPressedChanged: {
        operated = pressed;
    }
}*/
