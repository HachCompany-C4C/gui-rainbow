/****************************************************************************
** LimitSettings.qml - Limit setting for alarm concentraction
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
import QtQuick.Layouts 1.0
import "../../components"

Rectangle {
    width: 800
    height: 420
    visible: true
    opacity: 1
    objectName: "limit settings"
    property string title: qsTr("Limit Settings")+translator.tr

    enabled: mainPermisMgr.editabled

    Connections {
        target: notification_concentration
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            console.debug("QML::UpdatePage notification.concentration")
            highLimit.updateHighLimit();
            lowLimit.updateLowLimit();

            page_manager.updatePageDone();
        }
    }

    Text {
        id: lowLimitText
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.top: parent.top
        anchors.topMargin: 10
        font: mainTheme.titleFont

        text: qsTr("Low Limit:")+translator.tr
    }

    H2oTextField {
        id: lowLimit
        anchors.left: lowLimitText.left
        anchors.leftMargin: 10
        anchors.top: lowLimitText.bottom
        anchors.topMargin: 10
        width: 207
        height: 40
        plaintext: text+" "+"mg/L"

        onEditDone: {
            var numOrg = Number.fromLocaleString(Qt.locale(), inputStr);
            var num = numOrg.toFixed(3);

            if(notification_concentration.isInRange("low", num))
            {
                text = num;
                notification_concentration.setObj("low", num);
            } else {
                var range = notification_concentration.rangeString("low");
                mainMessageDialogOneButton.text = qsTr("Your input ")+numOrg+qsTr(" out of range")+translator.tr+range;
                mainMessageDialogOneButton.open();
                text = preText;
            }
        }

        function updateLowLimit()
        {
            var num = notification_concentration.getObjFloat("low");
            text = Number(num).toFixed(3);
        }
    }

    /*Text {
            id: text1
            x: 316
            y: 211
            text: qsTr("mg/L")
            font: mainTheme.smallFont
        }*/
    Text {
        id: highLimitText
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.top: lowLimit.bottom
        anchors.topMargin: 10
        font: mainTheme.titleFont

        text: qsTr("High Limit:")+translator.tr
    }

    H2oTextField {
        id: highLimit
        anchors.left: highLimitText.left
        anchors.leftMargin: 10
        anchors.top: highLimitText.bottom
        anchors.topMargin: 10
        width: 207
        height: 40
        plaintext: text+" "+"mg/L"

        onEditDone: {
            var numOrg = Number.fromLocaleString(Qt.locale(), inputStr);
            var num = numOrg.toFixed(3);

            if(notification_concentration.isInRange("high", num))
            {
                text = num;
                notification_concentration.setObj("high", num);
            } else {
                var range = notification_concentration.rangeString("high");
                mainMessageDialogOneButton.text = qsTr("Your input ")+numOrg+qsTr(" out of range")+translator.tr+range;
                mainMessageDialogOneButton.open();
                text = preText;
            }
        }

        function updateHighLimit() {
            var num = notification_concentration.getObjFloat("high");
            text = Number(num).toFixed(3);
        }
    }

    /*Text {
            id: text2
            x: 316
            y: 256
            text: qsTr("mg/L")
            font: mainTheme.smallFont
        }*/

}



