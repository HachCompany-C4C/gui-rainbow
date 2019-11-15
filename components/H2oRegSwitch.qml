/****************************************************************************
** H2oRegSwitch.qml
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

Rectangle {
    id: root
    property bool status: false
    property alias text: txt.text
    property bool pressed: mouseArea.pressed
    signal clicked()

    width: 40
    height: root.width
    radius: 4
    border.color: "#0098db"; //Flat.FlatStyle.lightFrameColor
    border.width: Flat.FlatStyle.onePixel
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter
    color: mouseArea.pressed ? "#0098db" : "white"
    Text {
        id: txt
        font: mainTheme.mediumFont
        anchors.centerIn: parent
        text: root.status ? "o":"O"
        color: mouseArea.pressed ? "white" : "#0098db"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            root.clicked();
            root.status = !root.status;
        }
    }
}

