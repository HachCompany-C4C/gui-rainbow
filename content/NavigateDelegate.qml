/****************************************************************************
** NavigateDelegate.qml - Navigate delegate
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

Item {

    Grid {
        spacing: 5
        rows: 1

        Button {
            id: setupButton
            width: 120
            height: 80
            text: qsTr("Setup")
            activeFocusOnPress: false
            transformOrigin: Item.Center
            style: ButtonStyle {
                label: Text {
                    renderType: Text.NativeRendering
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    //font.family: noto.name
                    font: mainTheme.mediumFont
                    color: "black"
                    text: control.text
                }
            }

        }

        Button {
            id: statusButton
            width: 120
            height: 80
            text: qsTr("Status")
            style: ButtonStyle {
                label: Text {
                    renderType: Text.NativeRendering
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    //font.family: noto.name
                    font: mainTheme.mediumFont
                    color: "black"
                    text: control.text
                }
            }
        }

        Button {
            id: serviceButton
            width: 120
            height: 80
            text: qsTr("Service")
            style: ButtonStyle {
                label: Text {
                    renderType: Text.NativeRendering
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    //font.family: noto.name
                    font: mainTheme.mediumFont
                    color: "black"
                    text: control.text
                }
            }
        }

        Button {
            id: historyButton
            width: 120
            height: 80
            text: qsTr("History")
            style: ButtonStyle {
                label: Text {
                    renderType: Text.NativeRendering
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    //font.family: noto.name
                    font: mainTheme.mediumFont
                    color: "black"
                    text: control.text
                }
            }
        }
    }
}

