/****************************************************************************
** FactoryReset.qml - UI for reset data to default value
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
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.0
import "../../components"


Rectangle {
    id: rectangle
    objectName: "Factory_Reset"
    property string title: qsTr("Factory Reset")+translator.tr
    property string setAck
    width: 800
    height: 360

    enabled: mainPermisMgr.editabled

    Connections {
        target: factory_reset
        ignoreUnknownSignals: true
        onProbeSetObjsDone: {
            //mainCircleProgressDialog.text = qsTr("Reset...")
            //mainCircleProgressDialog.visible = true
            //console.debug("QML::Factory reset done flag:"+mainFactoryResetData.initial)

            mainBusyDialog.close();
            mainMessageDialogOneButton.type = "reminder";
            mainMessageDialogOneButton.text = qsTr("Factory reset done.");
            mainMessageDialogOneButton.open();
        }
    }

    Text {
        id: title
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 40
        font: mainTheme.mediumFont
        text: qsTr("Reset to FACTORY SETTING")+translator.tr

    }

    Text {
        id: note
        anchors.top: title.bottom
        anchors.left: title.left
        anchors.leftMargin: 20
        font: mainTheme.smallFont
        text: note.getText() + translator.tr
        visible: true
        property var detail: [
            QT_TR_NOOP("factory_reset_desc0"),
            QT_TR_NOOP("factory_reset_desc1"),
            //QT_TR_NOOP("factory_reset_desc2")
        ]

        function getText()
        {
            var temp = "";
            for(var i = 0; i < detail.length; i++) {
                temp += qsTr(detail[i]) + "\n";
            }

            return temp;
        }
    }

    H2oButton {
        id: resetBtn
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        height: 60
        width: parent.width
        text: qsTr("RESET") + translator.tr
        buttonRadius: 0
        onClicked: {
            messageDialog.text = qsTr("Do you want reset to factory setting?")+translator.tr;
            messageDialog.open();
        }
    }

    H2oMessageDialog {
        id: messageDialog

        onAccepted: {
            //factory_reset.setObj("hmi", 1)
            mainBusyDialog.open(qsTr("Factory reset, please wait."))
            //translator.translate("ZH");
            //local_settings.setValue("system", "language", "ZH");
            //local_settings.setValue("system", "backlight", false);
            //local_settings.setValue("system", "backlighttime", 2);
            mainFactoryResetData.reset();
        }

        onRejected: {

        }
    }

}
