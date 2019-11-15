/****************************************************************************
** H2oCheckBox.qml - Check box
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

CheckBox {
    id: root
    width: 20
    height: 20
    opacity: enabled ? 1.0 : 0.4
    property color backgroundColor: "transparent"

    style: CheckBoxStyle {

        label: Component {
            Text {
                anchors.verticalCenter: parent.verticalCenter
                font: mainTheme.smallFont
                text: root.text
            }
        }

        indicator: Rectangle {
        }

        background: Rectangle {
            implicitWidth: 20
            implicitHeight: 20
            color: backgroundColor

            Rectangle {
                width: 20
                height: 20
                radius: 4
                border.width: Flat.FlatStyle.onePixel
                border.color: Flat.FlatStyle.lightFrameColor

                Text {
                    anchors.centerIn: parent
                    visible: root.checked
                    color: "#0098db"
                    text: "\ue602"
                    font: mainTheme.smallFont
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
    }
}
