/****************************************************************************
** ServiceTool.qml - UI for service tool
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
    property bool isKeyAction: false

    Connections {
        target: exec_script
        ignoreUnknownSignals: true
        onExecScriptDone: {
            mainBusyDialog.close();

            if(!isKeyAction)
            {
                mainMessageDialogOneButton.openDialog("reminder", msg);
            } else {
                isKeyAction = false;
            }
        }
    }

    /*Text {
        x: 23
        y: 8

        font: mainTheme.titleFont
        text: qsTr("Execute script")+translator.tr
    }*/

    TextArea {
        id: progressText
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width - 20
        height: 240

        activeFocusOnPress: true
        frameVisible: true
        font.pointSize: 14

        Connections {
            target: exec_script
            ignoreUnknownSignals: true
            onStdOutput: {
                if(msg != "") {
                    progressText.text = msg;
                    console.debug("QML::ServiceTool "+msg);
                }
            }
        }
    }

    TextField {
        id: cmdText
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: progressText.bottom
        anchors.topMargin: 10
        width: parent.width - 20
        height: 40
        //keyBoard: mainVKeyBoard
        //plaintext: text
        focus: true
        signal editDone(var inputStr)
        placeholderText: "Execute commands from script package if text is empty."

        onEditDone: {
            cmdText.text = inputStr;
            console.debug("QML::ServiceTool cmd: "+cmdText.text);
            exec_script.preSetCmd(inputStr);
        }

        Connections {
            target: exec_script
            ignoreUnknownSignals: true
            onLineCmdCleared: {
                cmdText.text = "";
                console.debug("QML::ServiceTool clear");
            }
        }

        Keys.enabled: true
        Keys.onPressed: {
            if(event.key === (Qt.Key_Enter-1)) {
                execScript();
                event.accepted = true;
                isKeyAction = true;
            }
        }

        H2oButton {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height
            width: 60
            text: "Key board"
            textFont: Qt.font({family: icomoon.name, pixelSize: 12})

            onClicked: {
                mainVKeyBoard.textField = cmdText;
                mainVKeyBoard.openDialog();
            }
        }
    }

    function execScript()
    {
        exec_script.preSetCmd(cmdText.text);
        exec_script.start();
    }

    H2oButton {
        id:updateStart
        x: 0
        y: 300
        width: 800
        height: 60
        text: qsTr("EXECUTE")+translator.tr
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        enabled: true
        buttonRadius: 0

        onClicked: {
            mainBusyDialog.open(qsTr("Executing script..."));
            execScript();
        }
    }
}
