/****************************************************************************
** H2oLineRadioButton.qml
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
import QtQuick.Controls.Styles.Flat 1.0 as Flat

RadioButton {
    id: root
    text: "Radio Button"
    property bool preChecked: false
    signal valueChanged
    width: 300
    opacity: enabled ? 1.0 : 0.4

    style: RadioButtonStyle {
        label: Component {
            Text {
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.verticalCenter: parent.verticalCenter
                font: mainTheme.smallFont
                text: root.text
            }
        }

        indicator: Rectangle {
        }

        background: Rectangle {
            implicitWidth: root.width
            implicitHeight: 35
            Text {
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                visible: control.checked
                color: "#0098db"
                text: "\ue602"
                font: mainTheme.smallIcon
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            Rectangle {
                width: parent.width
                height: Flat.FlatStyle.onePixel
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                //anchors.left: parent.left
                //anchors.right: parent.right
                //anchors.margins: 15
                color: Flat.FlatStyle.lightFrameColor
            }
        }
    }

    onCheckedChanged: {
        if(pressed == true) {
            valueChanged();
        }
    }
}
