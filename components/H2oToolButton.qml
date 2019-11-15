/****************************************************************************
** H2oToolButton.qml
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
    id: h2oButton
    opacity: enabled ? 1.0 : 0.4
    property color buttonColor: "#0098db"
    property color buttonPressColor: "#313131"
    property color buttonTextColor: "white"
    property int radius: 0
    property string imageSource: "qrc:///resources/icons/icons_new/Settings_32x32.gif"
    property string icon

    style: ButtonStyle {
        id: buttonStyle

        label: Component {
            Text {
                text: h2oButton.text
                clip: true  // truncate the text if overflow of button area
                wrapMode: Text.WordWrap // wrap the text on word boundary
                verticalAlignment: Text.AlignBottom
                horizontalAlignment: Text.AlignHCenter
                anchors.fill: parent
                //font.family:
                font: mainTheme.smallFont
                color: buttonTextColor
            }
        }
        background: Rectangle {
            id: background
            implicitWidth: 420
            implicitHeight: 50
            color: control.pressed ? buttonPressColor : buttonColor
            radius: h2oButton.radius
            Text {
                id: ico
                y: 10
                anchors.horizontalCenter: parent.horizontalCenter
                width: 32
                height: 32
                font: mainTheme.mediumIcon
                color: "#f2f2f2"
                text: h2oButton.icon
            }
        }
    }
}

