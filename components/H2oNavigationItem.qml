/****************************************************************************
** H2oNavigationItem.qml
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
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles.Flat 1.0 as Flat

Rectangle {
    id: root
    width: parent.width
    height: 60
    property string imageSource: ""
    property bool checked
    property alias text: textitem.text
    opacity: enabled ? 1.0 : 0.4
    property var imageFont: 0

    signal clicked

    /*Rectangle {
        anchors.fill: parent
        color: "#9e9e9e"
        visible: mouse.pressed
    }*/

    /*Image {
        id: icon
        anchors.verticalCenter: parent.verticalCenter
        source: imageSource
    }*/

    Text {
        id: image
        x: 14
        width: 24
        height: 24
        font: imageFont ? mainTheme.bigIcon2 : mainTheme.bigIcon //Fix icon can not show issue in windows
        color: "#0098db"
        text: imageSource
        anchors.verticalCenterOffset: -10
        anchors.verticalCenter: parent.verticalCenter
    }

    Text {
        id: textitem
        color: "black"
        text: modelData
        anchors.verticalCenterOffset: 0
        font: mainTheme.mediumFont
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 66
    }

    Rectangle {
        width: parent.width
        height: Flat.FlatStyle.onePixel
        anchors.bottom: parent.bottom
        //anchors.left: parent.left
        //anchors.right: parent.right
        //anchors.margins: 15
        color: Flat.FlatStyle.lightFrameColor
    }

    Text {
        id: arrow
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.verticalCenter: parent.verticalCenter
        font: mainTheme.mediumIcon
        color: "#9e9e9e"
        text: "\uf054"
        verticalAlignment: Text.AlignVCenter
        visible: root.checked ? false : true
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked: root.clicked()

    }
}
