/****************************************************************************
** H2oLineCheckBox.qml
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
    width: 300
    opacity: enabled ? 1.0 : 0.4

    style: CheckBoxStyle {

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

            Rectangle {
                width: 20
                height: 20
                radius: 4
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
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
}
