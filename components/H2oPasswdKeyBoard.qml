/****************************************************************************
** H2oPasswdKeyBoard.qml
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
import "../components"

Dialog
{
    id: root
    Label {
        text: "Input"
    }

    //width: content.implicitWidth+20
    //height: content.implicitHeight
    property alias text:  inputText.text
    signal h2oKeyBoardOk(var inputStr)
    property var textField

    function openDialog(title)
    {
        inputText.text = "";
        if(title !== undefined && title !== "") {
            pwText.text = title;
        } else {
            pwText.text = qsTr("Please enter password.") + translator.tr;
        }

        open();
    }

    contentItem: Rectangle {
        id: content

        implicitWidth: keypad.implicitWidth+25
        implicitHeight: pwText.height +keypad.implicitHeight
                       + inputText.height + loginButton.height + 40

        Text {
            id: pwText
            text: qsTr("Password") + translator.tr
            font: mainTheme.titleFont
            width: keypad.implicitWidth+5
            height: 30 * lineCount
            wrapMode: Text.WordWrap
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.left: parent.left
            anchors.leftMargin: 10
        }

        ColumnLayout {
            anchors.top: pwText.bottom
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter

            TextField {
                id: inputText
                font: mainTheme.mediumFont
                echoMode: TextInput.Password

                property bool valid: true

                style: TextFieldStyle {
                    textColor: "black"

                    background: Rectangle {
                        radius: 4
                        border.color: "black"
                        border.width: 1
                        implicitHeight: 40
                        implicitWidth: keypad.cellWidth*4

                        Text {
                            visible: !inputText.valid
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.verticalCenterOffset: 4
                            anchors.right: parent.right
                            anchors.rightMargin: 10
                            color: "#ee5353"
                            text: "\ue631"
                            font: mainTheme.mediumFont
                        }
                    }
                }
            }

            GridView {
                id: keypad
                implicitWidth: cellWidth * 4
                implicitHeight: cellHeight * 3
                boundsBehavior: Flickable.StopAtBounds

                Component.onCompleted: currentIndex = -1

                ListModel {
                    id: keyModel
                    ListElement {
                        name: "1"
                        operator: false
                        enabled: true
                    }

                    ListElement {
                        name: "2"
                        operator: false
                        enabled: true
                    }
                    ListElement {
                        name: "3"
                        operator: false
                        enable: true
                    }

                    ListElement {
                        name: "\ue902"
                        operator: true
                        enable: true
                    }
                    ListElement {
                        name: "4"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "5"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "6"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: QT_TR_NOOP("CE")
                        operator: true
                        enable: true
                    }
                    ListElement {
                        name: "7"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "8"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "9"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "0"
                        operator: false
                        enable: true
                    }
                    /*ListElement {
                        name: " "
                        operator: true
                        enable: true
                    }
                    ListElement {
                        name: "0"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: " "
                        operator: true
                        enable: true
                    }
                    ListElement {
                        name: "OK"
                        operator: true
                        enable: true
                    }*/
                }

                model: keyModel
                cellHeight: 64
                cellWidth: 64

                delegate: H2oKeyButton {
                    id: itemButton
                    text: qsTr(name)+translator.tr
                    width: 64
                    height: 64

                    onClicked: {
                        //console.debug(name)
                        if(enabled) {
                            if(!operator) {
                                inputText.text += name
                            } else {
                                var digits = inputText.text
                                switch(name)
                                {
                                case "\ue902":
                                    digits = digits.toString().slice(0, -1)
                                    inputText.text = digits
                                    break
                                case "±":
                                    if(digits[0] === '-') {
                                        digits = digits.toString().slice(1, digits.length)
                                    } else {
                                        digits = '-' + digits
                                    }
                                    inputText.text = digits
                                    break
                                case "CE":
                                    inputText.text = ""
                                    break
                                case ".":
                                    var f = digits.indexOf(".")
                                    if((f == -1)) {
                                        digits += "."
                                        inputText.text = digits
                                    }

                                    break
                                case "OK":
                                    root.close()
                                    if(inputText.text != "") {
                                        textField.editDone(inputText.text.toString())
                                    } else {
                                        textField.editDone("")
                                    }

                                    inputText.text = "";
                                    break
                                case "Exit":
                                    root.close()
                                    break;
                                }
                            }
                        }
                    }
                }
            }
        }

        H2oButton {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            width: parent.width/2
            buttonRadius: 0
            text: qsTr("CANCEL")+translator.tr
            buttonTextColor: theme.mainTextColor
            buttonColor: theme.mediumBackgroundColor
            buttonBorderColor: theme.mediumBackgroundColor
            onClicked: {
                //h2oKeyBoard.close()
                reject();
            }
        }

        H2oButton {
            id: loginButton
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            width: parent.width/2
            buttonRadius: 0
            text: qsTr("CONFIRM")+translator.tr
            onClicked: {
                //h2oKeyBoard.close()
                if(textField !== undefined) {
                    if(inputText.text != "") {
                        textField.editDone(inputText.text.toString())
                    } else {
                        textField.editDone("")
                    }
                }

                inputText.text = "";
                textField = undefined;
                accept();
            }
        }
    }
    //Component.onCompleted: root.open()
}
