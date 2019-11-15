/****************************************************************************
** DiagnosisBar.qml - Diagnosis bar
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
//import QtQuick.Controls.Styles.Flat 1.0 as Flat
import "../components"

Rectangle {
        id: notifiedLine
        x: 0
        y: 60
        width: 800
        height: 40
        color: "#ffb446"


        Rectangle {
            id: dropIcon
            x: 760
            y: 0
            width: 40
            height: 40

            color: notifMouseArea.pressed ? "#9e9e9e":"white"
            Text {
                anchors.centerIn: parent
                text: notifyDialog.visible ? "\ue644" : "\ue643"
                color: theme.hachBlueColor
                font: theme.mediumIcon
            }
            MouseArea {
                id: notifMouseArea
                anchors.rightMargin: 0
                anchors.bottomMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0
                anchors.fill: parent
                onClicked: {
                    if(!notifyDialog.visible)
                        notifyDialog.open("Hello");
                    else
                        notifyDialog.close();
                }
            }
        }
}

