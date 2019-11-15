/****************************************************************************
** H2oNumKeyBoard.qml
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
    id: h2oKeyBoard
    Label {
        text: "Input"
    }

    //width: content.implicitWidth+20
    //height: content.implicitHeight
    property alias text:  inputText.text
    signal h2oKeyBoardOk(var inputStr)
    property var textField

    function openDialog()
    {
        open();
    }

    contentItem: Rectangle {
        id: content
        implicitWidth: keypad.implicitWidth+25
        implicitHeight: keypad.implicitHeight + inputText.height+30

        ColumnLayout {
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter

            TextField {
                id: inputText
                font: mainTheme.mediumFont
                style: TextFieldStyle {
                    textColor: "black"

                    background: Rectangle {
                        radius: 4
                        border.color: "black"
                        border.width: 1
                        implicitHeight: 40
                        implicitWidth: keypad.cellWidth*4
                    }
                }
            }

            GridView {
                id: keypad
                implicitWidth: cellWidth * 4
                implicitHeight: cellHeight *4
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
                        name: QT_TR_NOOP("Exit")
                        operator: true
                        enable: true
                    }
                    ListElement {
                        name: "±"
                        operator: true
                        enable: true
                    }
                    ListElement {
                        name: "0"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "."
                        operator: true
                        enable: true
                    }
                    ListElement {
                        name: QT_TR_NOOP("OK")
                        operator: true
                        enable: true
                    }
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
                                    h2oKeyBoard.close()
                                    if(inputText.text != "") {
                                        textField.editDone(inputText.text.toString())
                                    } else {
                                        textField.editDone("0")
                                    }

                                    inputText.text = "";
                                    break
                                case "Exit":
                                    h2oKeyBoard.close();
                                    inputText.text = "";
                                    break;
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    //Component.onCompleted: h2oKeyBoard.open()
}
