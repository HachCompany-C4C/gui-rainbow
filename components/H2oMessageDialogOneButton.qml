/****************************************************************************
** H2oMessageDialogOneButton.qml
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
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.0
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2

Dialog
{
    id: messageDialog
    //width: 400
    //height: (txt.contentHeight > 50) ? (txt.contentHeight + 100) : 150
    property alias text: txt.text
    property string type: "reminder"
    property int fontSize: 20

    function openDialog(type, message)
    {
        messageDialog.type = type;
        messageDialog.text = qsTr(message)+translator.tr;
        messageDialog.open();
    }

    contentItem: Rectangle {
        id: content
        implicitWidth: 400
        implicitHeight: (txt.contentHeight > 50) ? (txt.contentHeight + 100) : 150

        Text {
            id: icon
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -32
            anchors.left: parent.left
            anchors.leftMargin: 10
            width: 48
            height: 48
            font: mainTheme.bigFont
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            color: {
                if(messageDialog.type === "reminder") {
                    return "#0098db"
                } else if(messageDialog.type === "warning") {
                    return "#ffb446"
                } else if(messageDialog.type === "error") {
                    return "#ee5353"
                } else {
                    return "#0098db"
                }
            }
            text: {
                if(messageDialog.type === "reminder") {
                    return "\ue609"
                } else if(messageDialog.type === "warning") {
                    return "\ue627"
                } else if(messageDialog.type === "error") {
                    return "\ue631"
                } else {
                    return "\ue609"
                }
            }
        }

        Text {
            id: txt
            anchors.left: icon.right
            anchors.leftMargin: 20
            anchors.verticalCenter: icon.verticalCenter
            width: 300
            height: 70
            wrapMode: Text.WordWrap
            font: mainTheme.smallFont
            text: "Do you want to start the measurement?"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
        }

        H2oButton {
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            width: parent.width
            buttonRadius: 0
            text: qsTr("OK")+translator.tr
            onClicked: {
                accept();
            }
        }
    }
}
