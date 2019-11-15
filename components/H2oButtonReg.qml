/****************************************************************************
** H2oButtonReg.qml - Square button
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
import QtQuick.Controls.Styles.Flat 1.0 as Flat

Rectangle {
    id: root
    width: 64
    height: 40
    radius: 4
    opacity: enabled ? 1.0 : 0.4
    border.color: "#0098db"; //Flat.FlatStyle.lightFrameColor
    border.width: Flat.FlatStyle.onePixel
    color: "#0098db" //mouseArea.pressed ? "#0098db" : "white"
    signal accepted();

    Text {
        font: mainTheme.smallFont
        anchors.centerIn: parent
        text: qsTr("APPLY") + translator.tr //"\ue602"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: "white"
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            accepted()
        }
    }
}

