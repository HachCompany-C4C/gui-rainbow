/****************************************************************************
** H2oRadioButton.qml
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

RadioButton {
    id: radioButton
    text: "Radio Button"
    property bool preChecked: false
    signal valueChanged
    opacity: enabled ? 1.0 : 0.4

    style: RadioButtonStyle {
        indicator: Rectangle {
            implicitWidth: 40
            implicitHeight: 40
            //radius: 15
            border.color: control.activeFocus ? "blue" : "black"
            border.width: 1
            Text {
                anchors.fill: parent
                visible: control.checked
                color: "black"
                //radius: 20
                //anchors.margins: 4
                text: "\ue602"
                font: mainTheme.bigIcon
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }

        label: Component {
            Text {
                text: radioButton.text
                font: mainTheme.smallFont
            }
        }
    }
    onCheckedChanged: {
        if(pressed == true) {
            valueChanged();
        }
    }
}
