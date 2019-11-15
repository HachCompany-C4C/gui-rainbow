/****************************************************************************
** H2oTriStatusBar.qml
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

Rectangle {
    id: root
    property int indictor: 50
    property int red: 20
    property int yellow: 20
    property int green: 100-red-yellow
    property bool dayEnabled: false
    property int range: 100
    property int display: indictor > range ? range : indictor

    color: "#f2f2f2"

    width: 200
    height: 40
    property int barHeight: 40

    //opacity: enabled ? 1.0 : 0.4

    signal clicked()

    Rectangle {
        id: indicator
        width: 20
        height: 20
        color: "#f2f2f2"
        anchors.top: redRect.bottom
        x: display/range*parent.width-10
        Text {
            id: symbol
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: -3
            text: "▲"
            font.pixelSize: 12
            color: root.enabled ? "black" :"#ba9797"
        }

        Text {
            anchors.horizontalCenter: symbol.horizontalCenter
            anchors.top: symbol.bottom
            anchors.topMargin: -3
            text: (indictor > range ? ">" : "") +display + " " + (dayEnabled ? qsTr("day") : "%")
            font.pixelSize: 16
            color: root.enabled ? "black" :"#ba9797"
        }
    }

    Rectangle {
        id: redRect
        width: red/range*parent.width
        height: barHeight-16
        color: root.enabled ? "red" : "#363636"

        anchors.bottom: parent.bottom
        anchors.left: parent.left
        /*gradient: Gradient {
            GradientStop { position: 0 ; color: redRect.color }
            GradientStop { position: 0.5 ; color: "#aaa" }
            GradientStop { position: 1 ; color: redRect.color }
        }*/
    }

    Rectangle {
        id: yelRect
        width: yellow/range*parent.width
        height: barHeight-16
        color: root.enabled ? "yellow" : "#bebebe"

        anchors.bottom: parent.bottom
        anchors.left: redRect.right

        /*gradient: Gradient {
            GradientStop { position: 0 ; color: yelRect.color }
            GradientStop { position: 0.5 ; color: "white" }
            GradientStop { position: 1 ; color: yelRect.color }
        }*/
    }

    Rectangle {
        id: greenRect
        width: parent.width - redRect.width - yelRect.width
        height: barHeight-16
        color: root.enabled ? "green" : "#9d9d9d"

        anchors.bottom: parent.bottom
        anchors.left: yelRect.right

        /*gradient: Gradient {
            GradientStop { position: 0 ; color: greenRect.color }
            GradientStop { position: 0.5 ; color: "#aaa" }
            GradientStop { position: 1 ; color: greenRect.color }
        }*/
    }

    Rectangle {
        id: indictorBar
        width: (display/range)*parent.width
        height: redRect.height
        color: "#0098db"
        opacity: 0.2
        anchors.bottom: redRect.bottom
        anchors.left: parent.left
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.clicked()
        }
    }
}
