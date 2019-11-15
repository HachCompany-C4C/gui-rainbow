/****************************************************************************
** FirmwareUpdate.qml - UI for updating firmware
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
    width: 800
    height: 380

    property var updateMessage: [
        QT_TR_NOOP("Restart UI, please wait for a minutes"),
        QT_TR_NOOP("Error: Can't find firmware.bin"),
    ]

    H2oProgressCircle {
        id: processCircle
        x: 76
        y: 64
        width: 180
        height: 180
        lineWidth: 12
    }

    Text {
        id: version
        anchors.top: processCircle.top
        anchors.left: processCircle.right
        anchors.leftMargin: 70
        text: qsTr("Current version: ")+translator.tr + page_manager.mainVersion()
        font: mainTheme.mediumFont
    }

    TextArea {
        id: progressText
        x: 262
        y: 230
        width: 530
        height: 84
        //height: mouseArea.containsMouse ? (25 * getLineCount()) : 50

        function getLineCount() {
            var n = 0;
            for(var i = 0; i < text.length; i++) {
                if(text.charAt(i) == '\n') {
                    n++;
                }
            }

            if(n > 10) n = 10;

            return n;
        }

        text: ""
        visible: false
        activeFocusOnPress: true
        frameVisible: true
        font.pointSize: 14
        verticalScrollBarPolicy: 25 * getLineCount() > height ? Qt.ScrollBarAsNeeded : Qt.ScrollBarAlwaysOff
    }

    H2oButton {
        id:updateStart
        x: 0
        y: 300
        width: 800
        height: 60
        text: qsTr("START UPDATE")+translator.tr
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        enabled: true
        buttonRadius: 0

        onClicked: {
            confirmDialog.text = qsTr("The update will restart the application, do you want to continue ?")+translator.tr
            confirmDialog.open();
        }
    }

    Timer {
        id: upgradeMsgUpdateTimer
        interval: 200
        running: false
        repeat: true
        onTriggered: {
            progressText.text += software_upgrade.getStandardOutput()
            processCircle.value = software_upgrade.processPersent();
            var error = software_upgrade.error();
            var flag = software_upgrade.errorFlag();
            if(error !== "") {
                if(flag === "end") {
                    local_settings.setValue("upgrade", "default", true);
                    mainMessageDialogNoButton.text = qsTr(error);
                    mainMessageDialogNoButton.open();
                } else {
                    mainMessageDialogOneButton.type = "error";
                    mainMessageDialogOneButton.text = qsTr(error);
                    mainMessageDialogOneButton.open();

                    upgradeMsgUpdateTimer.running = false;
                    updateStart.enabled = true;
                    mainMessage.buttonEnabled = true;
                    page_manager.setTimerRunning(true);

                    /* restart log when if error */
                    var items = ["log_rawdata", "log_result", "log_auto"];
                    var values = ["enable", "enable", "enable"];
                    latest_measure.setObjs(items, values);
                }
            }
        }
    }

    function startMCUFirmware()
    {
        var param = { "hex": "/home/root/probe/python/1710131131.bin" };
        var result = json_parse.execJson("flash", param);
        queryProcessTimer.start();
    }

    function queryFlashProgress()
    {
        var param = {};
        var result = json_parse.execJson("flash_progress", param);

        console.debug("Flash Progress: "+result);
        return result;
    }

    /* Start Update MCU Firmware */
    Connections {
        target: software_upgrade
        ignoreUnknownSignals: true
        onStartUpdateMCU: {
            startMCUFirmware();
        }
    }

    Timer {
        id: queryProcessTimer
        interval: 2000
        running: false
        repeat: true
        onTriggered: {
            queryFlashProgress();
        }
    }

    function startUpdateSoftware()
    {
        /* Start upgrade process */
        var bStart = software_upgrade.startProcess();
        if(bStart) {
            upgradeMsgUpdateTimer.start();
            progressText.text = "";
            updateStart.enabled = false;
            mainMessage.buttonEnabled = false;
            /* Disable refreshing data */
            page_manager.setTimerRunning(false);

            /* Stop measure and stop log when upgrade */
            var items = ["log_rawdata", "log_result", "log_auto", "startgo"];
            var values = ["disable", "disable", "disable", "1"]; //1-stop
            latest_measure.setObjs(items, values);
        } else {
            mainMessageDialogOneButton.type = "warning";
            mainMessageDialogOneButton.text = qsTr("Can't find entry script.")+translator.tr;
            mainMessageDialogOneButton.open();
        }
    }

    H2oMessageDialog {
        id: confirmDialog

        onAccepted: {
            startUpdateSoftware();
        }

        onRejected: {

        }
    }

    Text {
        id: noteText
        width: 411
        height: 64
        text: qsTr("Note: Please don't shut down the power during updating software")+translator.tr
        anchors.top: version.bottom
        anchors.topMargin: 30
        anchors.left: version.left
        anchors.leftMargin: 0
        wrapMode: Text.WordWrap
        font: mainTheme.titleFont
    }
}
