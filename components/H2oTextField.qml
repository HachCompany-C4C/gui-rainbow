/****************************************************************************
** H2oTextField.qml
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
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles.Flat 1.0 as Flat

Rectangle {
    id: root
    property bool editTextHoldEnabled: false
    property string plaintext //: txt.text
    property var keyBoard: mainNumKeyBoard
    property string suffix: ""
    property string text: ""
    property string preText: ""
    height: 40
    //opacity: enabled ? 1.0 : 0.4
    property bool valid: true
    property int echoMode: TextInput.Normal

    signal editDone(var inputStr)

    Rectangle {
        radius: 4
        border.color: root.enabled ? mainTheme.mediumGrayColor : mainTheme.mediumBackgroundColor
        border.width: 1
        width: parent.width
        height: 40
        color: root.enabled ? "white": mainTheme.mediumBackgroundColor
        Text {
            id: txt
            font: mainTheme.smallFont
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 15
            horizontalAlignment: Text.AlignLeft
            color: root.enabled ? mainTheme.darkGrayColor : mainTheme.mediumGrayColor
            text: echoMode == TextInput.Password ? root.text.replace(/[0-9]/g, '•') : plaintext
        }

        Text {
            visible: !valid
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 4
            anchors.right: parent.right
            anchors.rightMargin: 10
            color: "#ee5353"
            text: "\ue631"
            font: mainTheme.mediumFont
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            mousePressed();
        }
    }

    function mousePressed()
    {
        keyBoard.openDialog();
        keyBoard.textField = root;
        root.preText = root.text;
    }

    //echoMode: TextInput.Password

    /*Button {
        id: button
        anchors.right: parent.right
        anchors.rightMargin: 2
        anchors.verticalCenter: parent.verticalCenter

        Label {
            width: 40
            height: 38
            text: "\ue637"
            color: "black"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: theme.mediumIcon
        }

        style: ButtonStyle {

            background: Rectangle {
                implicitWidth: 40
                implicitHeight: 38
                border.width: control.activeFocus ? 1 : 0
                //border.color: "#888"
                radius: 4
                gradient: Gradient {
                    GradientStop { position: 0 ; color: control.pressed ? "#ccc" : "#eee" }
                    GradientStop { position: 1 ; color: control.pressed ? "#aaa" : "#ccc" }
                }
            }
        }

        function keyboardOutput() {
            console.debug("QML::H2oTextField key board output")
        }

        onClicked: {
            //console.debug("H2o Virtual Key Board")
            mainNumKeyBoard.open();
            mainNumKeyBoard.textField = h2oTextField;
            //var compon = Qt.createComponent("H2oVKeyBoard.qml")
            //Incubators allow new component instances to be instantiated asynchronously and do not cause freezes in the UI.
            //var keyBoard = compon.incubateObject(h2oTextField, {"text": editTextHoldEnabled ? h2oTextField.text : ""});
            //keyBoard.open()
        }
    }*/
}

