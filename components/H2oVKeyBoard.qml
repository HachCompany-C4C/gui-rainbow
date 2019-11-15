/****************************************************************************
** H2oVKeyBoard.qml
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
    id: root
    Label {
        text: "Input"
    }

    //width: content.implicitWidth+20
    //height: content.implicitHeight
    property alias text:  inputText.text
    signal h2oKeyBoardOk(var inputStr)
    property var textField

    property int cellWidth: 48
    property int cellHeight: 48
    property int keypadWidth: root.cellWidth * 10
    property int keypadHeight: cellHeight

    onVisibleChanged: {
        if(root.visible) {
            keypad2.model = keyModel21;
            keypad3.model = keyModel31;
            keypad4.model = keyModel41;
            keypad5.model = keyModel51;
        }
    }

    function openDialog()
    {
        open();
    }

    function keyFunction(name, operator, enabled)
    {
        inputText.focus = true;
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
                case "Space":
                    inputText.text += " "
                    break
                case "OK":
                    root.close()
                    if(inputText.text != "") {
                        textField.editDone(inputText.text.toString())
                    } else {
                        textField.editDone("0")
                    }

                    inputText.text = "";
                    break
                case "Exit":
                    root.close();
                    inputText.text = "";
                    break;
                case "\ue901":
                    keypad2.model = keyModel22;
                    keypad3.model = keyModel32;
                    keypad4.model = keyModel42;
                    break;
                case "\ue905":
                    keypad2.model = keyModel21;
                    keypad3.model = keyModel31;
                    keypad4.model = keyModel41;
                    break;
                case "123@":
                    keypad2.model = keyModel23;
                    keypad3.model = keyModel33;
                    keypad4.model = keyModel43;
                    keypad5.model = keyModel52;
                    break;
                case "abc":
                    keypad2.model = keyModel21;
                    keypad3.model = keyModel31;
                    keypad4.model = keyModel41;
                    keypad5.model = keyModel51;
                    break;
                case " \ue901 ":
                    keypad3.model = keyModel34;
                    keypad4.model = keyModel44;
                    break;
                case " \ue905 ":
                    keypad3.model = keyModel33;
                    keypad4.model = keyModel43;
                    break;
                }
            }
        }
    }

    contentItem: Rectangle {
        id: content
        implicitWidth: keypadWidth+24
        implicitHeight: keypadHeight*4 + inputText.height+30

        ColumnLayout {
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 0

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
                        implicitWidth: keypadWidth
                    }
                }
            }

            Rectangle {
                width: inputText.width
                height: 10
            }

            /*ListView {
                id: keypad
                implicitWidth: root.cellWidth * 10
                implicitHeight: root.cellHeight *1
                boundsBehavior: Flickable.StopAtBounds
                orientation: ListView.Horizontal
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
                }

                model: keyModel

                delegate: Button {
                    id: itemButton
                    text: name
                    width: 48
                    height: 48

                    onClicked: {
                        keyFunction(name, operator, enabled);
                    }
                }
            }*/

            ListView {
                id: keypad2
                implicitWidth: root.cellWidth * 10
                implicitHeight: root.cellHeight *1
                boundsBehavior: Flickable.StopAtBounds
                orientation: ListView.Horizontal
                Component.onCompleted: currentIndex = -1

                ListModel {
                    id: keyModel21
                    ListElement {
                        name: "q";
                        operator: false
                        enable: true
                    }

                    ListElement {
                        name: "w"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "e"
                        operator: false
                        enable: true
                    }

                    ListElement {
                        name: "r"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "t"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "y"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "u"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "i"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "o"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "p"
                        operator: false
                        enable: true
                    }
                }

                ListModel {
                    id: keyModel22
                    ListElement {
                        name: "Q"
                        operator: false
                        enable: true
                    }

                    ListElement {
                        name: "W"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "E"
                        operator: false
                        enable: true
                    }

                    ListElement {
                        name: "R"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "T"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "Y"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "U"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "I"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "O"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "P"
                        operator: false
                        enable: true
                    }
                }

                ListModel {
                    id: keyModel23
                    ListElement {
                        name: "1"
                        operator: false
                        enable: true
                    }

                    ListElement {
                        name: "2"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "3"
                        operator: false
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
                }

                model: keyModel21

                delegate: H2oKeyButton {
                    id: itemButton2
                    text: name
                    width: 48
                    height: 48

                    onClicked: {
                        keyFunction(name, operator, enabled);
                    }
                }
            }
            ListView {
                id: keypad3
                implicitWidth: root.cellWidth * 9
                implicitHeight: root.cellHeight *1
                boundsBehavior: Flickable.StopAtBounds
                orientation: ListView.Horizontal
                Layout.alignment: Qt.AlignCenter
                Component.onCompleted: currentIndex = -1

                ListModel {
                    id: keyModel31
                    ListElement {
                        name: "a"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "s"
                        operator: false
                        enable: true
                    }

                    ListElement {
                        name: "d"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "f"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "g"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "h"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "j"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "k"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "l"
                        operator: false
                        enable: true
                    }
                }

                ListModel {
                    id: keyModel32
                    ListElement {
                        name: "A"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "S"
                        operator: false
                        enable: true
                    }

                    ListElement {
                        name: "D"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "F"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "G"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "H"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "J"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "K"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "L"
                        operator: false
                        enable: true
                    }
                }
                ListModel {
                    id: keyModel33
                    ListElement {
                        name: "!"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "@"
                        operator: false
                        enable: true
                    }

                    ListElement {
                        name: "#"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "$"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "%"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "&"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "*"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "("
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: ")"
                        operator: false
                        enable: true
                    }
                }

                ListModel {
                    id: keyModel34
                    ListElement {
                        name: "~"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "`"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "^"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "<"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: ">"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "["
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "]"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "{"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "}"
                        operator: false
                        enable: true
                    }
                }

                model: keyModel31

                delegate: H2oKeyButton {
                    id: itemButton3
                    text: name
                    width: 48
                    height: 48

                    onClicked: {
                        keyFunction(name, operator, enabled);
                    }
                }
            }

            ListView {
                id: keypad4
                implicitWidth: root.cellWidth * 9 + 42
                implicitHeight: root.cellHeight *1
                boundsBehavior: Flickable.StopAtBounds
                orientation: ListView.Horizontal
                Layout.alignment: Qt.AlignCenter
                Component.onCompleted: currentIndex = -1

                ListModel {
                    id: keyModel41
                    ListElement {
                        name: "\ue901"
                        operator: true
                        enable: true
                        ewidth: 64
                    }
                    ListElement {
                        name: "z"
                        operator: false
                        enable: true
                        ewidth: 48
                    }

                    ListElement {
                        name: "x"
                        operator: false
                        enable: true
                        ewidth: 48
                    }
                    ListElement {
                        name: "c"
                        operator: false
                        enable: true
                        ewidth: 48
                    }
                    ListElement {
                        name: "v"
                        operator: false
                        enable: true
                        ewidth: 48
                    }
                    ListElement {
                        name: "b"
                        operator: false
                        enable: true
                        ewidth: 48
                    }
                    ListElement {
                        name: "n"
                        operator: false
                        enable: true
                        ewidth: 48
                    }
                    ListElement {
                        name: "m"
                        operator: false
                        enable: true
                        ewidth: 48
                    }
                    ListElement {
                        name: "\ue902"
                        operator: true
                        enable: true
                        ewidth: 64
                    }
                }

                ListModel {
                    id: keyModel42
                    ListElement {
                        name: "\ue905"
                        operator: true
                        enable: true
                        ewidth: 64
                    }
                    ListElement {
                        name: "Z"
                        operator: false
                        enable: true
                        ewidth: 48
                    }

                    ListElement {
                        name: "X"
                        operator: false
                        enable: true
                        ewidth: 48
                    }
                    ListElement {
                        name: "C"
                        operator: false
                        enable: true
                        ewidth: 48
                    }
                    ListElement {
                        name: "V"
                        operator: false
                        enable: true
                        ewidth: 48
                    }
                    ListElement {
                        name: "B"
                        operator: false
                        enable: true
                        ewidth: 48
                    }
                    ListElement {
                        name: "N"
                        operator: false
                        enable: true
                        ewidth: 48
                    }
                    ListElement {
                        name: "M"
                        operator: false
                        enable: true
                        ewidth: 48
                    }
                    ListElement {
                        name: "\ue902"
                        operator: true
                        enable: true
                        ewidth: 64
                    }
                }
                ListModel {
                    id: keyModel43
                    ListElement {
                        name: " \ue901 "
                        operator: true
                        enable: true
                        ewidth: 64
                    }
                    ListElement {
                        name: "'"
                        operator: false
                        enable: true
                        ewidth: 48
                    }

                    ListElement {
                        name: "/"
                        operator: false
                        enable: true
                        ewidth: 48
                    }
                    ListElement {
                        name: "-"
                        operator: false
                        enable: true
                        ewidth: 48
                    }
                    ListElement {
                        name: "_"
                        operator: false
                        enable: true
                        ewidth: 48
                    }
                    ListElement {
                        name: "?"
                        operator: false
                        enable: true
                        ewidth: 48
                    }
                    ListElement {
                        name: ":"
                        operator: false
                        enable: true
                        ewidth: 48
                    }
                    ListElement {
                        name: "."
                        operator: false
                        enable: true
                        ewidth: 48
                    }
                    ListElement {
                        name: "\ue902"
                        operator: true
                        enable: true
                        ewidth: 64
                    }
                }

                ListModel {
                    id: keyModel44
                    ListElement {
                        name: " \ue905 "
                        operator: true
                        enable: true
                        ewidth: 64
                    }
                    ListElement {
                        name: "\""
                        operator: false
                        enable: true
                        ewidth: 48
                    }

                    ListElement {
                        name: "\\"
                        operator: false
                        enable: true
                        ewidth: 48
                    }
                    ListElement {
                        name: "+"
                        operator: false
                        enable: true
                        ewidth: 48
                    }
                    ListElement {
                        name: "="
                        operator: false
                        enable: true
                        ewidth: 48
                    }
                    ListElement {
                        name: "|"
                        operator: false
                        enable: true
                        ewidth: 48
                    }
                    ListElement {
                        name: ";"
                        operator: false
                        enable: true
                        ewidth: 48
                    }
                    ListElement {
                        name: ","
                        operator: false
                        enable: true
                        ewidth: 48
                    }
                    ListElement {
                        name: "\ue902"
                        operator: true
                        enable: true
                        ewidth: 64
                    }
                }

                model: keyModel41

                delegate: H2oKeyButton {
                    id: itemButton4
                    text: name
                    width: ewidth
                    height: 48

                    onClicked: {
                        keyFunction(name, operator, enabled);
                    }
                }
            }

            ListView {
                id: keypad5
                implicitWidth: 488
                implicitHeight: root.cellHeight *1
                boundsBehavior: Flickable.StopAtBounds
                orientation: ListView.Horizontal
                Layout.alignment: Qt.AlignCenter
                Component.onCompleted: currentIndex = -1

                ListModel {
                    id: keyModel51
                    ListElement {
                        name: "123@"
                        operator: true
                        enable: true
                        ewidth: 64
                    }
                    ListElement {
                        name: QT_TR_NOOP("CE")
                        operator: true
                        enable: true
                        ewidth: 64
                    }
                    ListElement {
                        name: "Space"
                        operator: true
                        enable: true
                        ewidth: 224
                    }
                    ListElement {
                        name: QT_TR_NOOP("Exit")
                        operator: true
                        enable: true
                        ewidth: 64
                    }
                    ListElement {
                        name: QT_TR_NOOP("OK")
                        operator: true
                        enable: true
                        ewidth: 64
                    }
                }

                ListModel {
                    id: keyModel52
                    ListElement {
                        name: "abc"
                        operator: true
                        enable: true
                        ewidth: 64
                    }
                    ListElement {
                        name: QT_TR_NOOP("CE")
                        operator: true
                        enable: true
                        ewidth: 64
                    }
                    ListElement {
                        name: "Space"
                        operator: true
                        enable: true
                        ewidth: 224
                    }
                    ListElement {
                        name: QT_TR_NOOP("Exit")
                        operator: true
                        enable: true
                        ewidth: 64
                    }
                    ListElement {
                        name: QT_TR_NOOP("OK")
                        operator: true
                        enable: true
                        ewidth: 64
                    }
                }

                model: keyModel51

                delegate: H2oKeyButton {
                    id: itemButton5
                    text: qsTr(name)+translator.tr
                    width: ewidth
                    height: 48
                    enabled: enable

                    onClicked: {
                        keyFunction(name, operator, enabled);
                    }
                }
            }

            /*GridView {
                id: keypad
                implicitWidth: root.cellWidth * 10
                implicitHeight: root.cellHeight *5
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
                    ListElement {
                        name: "a"
                        operator: false
                        enabled: true
                    }

                    ListElement {
                        name: "b"
                        operator: false
                        enabled: true
                    }
                    ListElement {
                        name: "c"
                        operator: false
                        enable: true
                    }

                    ListElement {
                        name: "d"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "e"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "f"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "g"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "h"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "i"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "j"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "k"
                        operator: false
                        enabled: true
                    }

                    ListElement {
                        name: "l"
                        operator: false
                        enabled: true
                    }
                    ListElement {
                        name: "m"
                        operator: false
                        enable: true
                    }

                    ListElement {
                        name: "n"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "o"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "p"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "q"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "r"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "s"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "t"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "u"
                        operator: false
                        enabled: true
                    }

                    ListElement {
                        name: "v"
                        operator: false
                        enabled: true
                    }
                    ListElement {
                        name: "w"
                        operator: false
                        enable: true
                    }

                    ListElement {
                        name: "x"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "y"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "z"
                        operator: false
                        enable: true
                    }
                    ListElement {
                        name: "⇦"
                        operator: true
                        enable: true
                    }
                    ListElement {
                        name: "CE"
                        operator: true
                        enable: true
                    }
                    ListElement {
                        name: "Exit"
                        operator: true
                        enable: true
                    }
                    ListElement {
                        name: "±"
                        operator: true
                        enable: true
                    }
                    ListElement {
                        name: "."
                        operator: true
                        enable: true
                    }
                    ListElement {
                        name: "OK"
                        operator: true
                        enable: true
                    }
                }

                model: keyModel
                root.cellHeight: 48
                root.cellWidth: 48

                delegate: Button {
                    id: itemButton
                    text: name
                    width: 48
                    height: 48

                    onClicked: {
                        //console.debug(name)
                        if(enabled) {
                            if(!operator) {
                                inputText.text += name
                            } else {
                                var digits = inputText.text
                                switch(name)
                                {
                                case "⇦":
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
                                    h2oKeyBoard.close()
                                    break;
                                }
                            }
                        }
                    }
                }
            }*/
        }
    }

    //Component.onCompleted: h2oKeyBoard.open()
}
