/****************************************************************************
** ScreenSaver.qml - Print screen and save as piture
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
import QtQuick.Window 2.2

//import QtQuick.Controls.Styles.Flat 1.0 as Flat
import "../components"


H2oButton {
    width: 80
    height: 80
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    text: "Print Screen"
    visible: false

    Connections {
        target: fb2bmp_tool
        ignoreUnknownSignals: true
        onGenerationDone: {
            mainMessageDialogOneButton.text = "Screen capture done: "+fb2bmp_tool.fileName();
            mainMessageDialogOneButton.open();
            visible = true;
        }
    }

    function init() {
        var value = local_settings.getValueBool("screensave", "visible", false);
        if(value === true) {
            var drive = file_tool.getDrivePath();
            if(drive !== "") {
                visible = true;
            }
        }
    }

    Timer {
        id: fTimer
        interval: 1000
        running: false
        repeat: false
        triggeredOnStart: false

        onTriggered: {
            var drive = file_tool.getDrivePath();
            if(drive !== "") {
                fb2bmp_tool.startGenerate(drive);
            } else {
                mainMessageDialogOneButton.type = "warning";
                mainMessageDialogOneButton.text = qsTr("Drive not exist.");
                mainMessageDialogOneButton.open();
                visible = true;
            }
        }
    }

    onClicked: {
        visible = false;
        fTimer.start();
    }
}
