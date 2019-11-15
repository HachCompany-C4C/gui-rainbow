/****************************************************************************
** H2oArrowsPannel.qml - Arrow button pannel
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
    width: 120
    height: 120
    opacity: enabled ? 1.0 : 0.4

    property alias vValue: vArrows.value
    property alias vDelta: vArrows.delta
    property alias hValue: hArrows.value
    property alias hDelta: hArrows.delta
    property alias upArrowText: vArrows.increaseText
    property alias downArrowText: vArrows.decreaseText
    property alias leftArrowText: hArrows.decreaseText
    property alias rightArrowText: hArrows.increaseText
    property bool resetButtonVisable: true

    signal vValueIncreased(var value)
    signal vValueDecreased(var value)
    signal hValueIncreased(var value)
    signal hValueDecreased(var value)
    signal valueReset()

    H2oSpinBox {
        id: vArrows
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        textWidth: 40
        value: 0
        delta: 10
        increaseText: upArrowText
        decreaseText: downArrowText

        onValueChanged: {

        }

        onValueIncreased: {
            vValueIncreased(value);
        }

        onValueDecreased: {
            vValueDecreased(value)
        }
    }

    H2oSpinBox {
        id: hArrows
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        value: 0
        delta: 10
        orientation: Qt.Horizontal
        textWidth: 40
        increaseText: rightArrowText
        decreaseText: leftArrowText
        onValueChanged: {

        }

        onValueIncreased: {
            hValueIncreased(value)
        }

        onValueDecreased: {
            hValueDecreased(value)
        }
    }

    Rectangle {
        id: resetControl
        width: 40
        height: resetControl.width
        radius: 4
        border.color: "#0098db"; //Flat.FlatStyle.lightFrameColor
        border.width: Flat.FlatStyle.onePixel
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        color: resetMouseArea.pressed ? "#0098db" : "white"
        visible: resetButtonVisable

        Text {
            font: mainTheme.mediumFont
            anchors.centerIn: parent
            text: "R"
            color: resetMouseArea.pressed ? "white" : "#0098db"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        MouseArea {
            id: resetMouseArea
            anchors.fill: parent
            onClicked: {
                vArrows.value = 0;
                hArrows.value = 0;
                valueReset();
            }
        }
    }
}
