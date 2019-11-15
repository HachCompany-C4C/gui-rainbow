/****************************************************************************
** H2oComboBox.qml -
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

//import QtTest 1.0

ComboBox {
    id: control
    activeFocusOnPress: true

    property  int fontPixelSize: 16

    property bool operated: false

    //FontLoader {
    //    id: localfont
    //    source: "qrc:///resources/fonts/NotoSans/NotoSans-Regular.ttf"
    //}

    style: ComboBoxStyle {
        id: comboBox
        background: Rectangle {
            id: rectCategory
            radius: 4
            border.width: 1
            color: "#fff"
            implicitWidth: 160
            implicitHeight: 30

            /*Image {
                source: "pics/corner.png"
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.bottomMargin: 5
                anchors.rightMargin: 5
            }*/
        }
        label: Text {
            verticalAlignment: Text.AlignVCenter
            //horizontalAlignment: Text.AlignHCenter
            font.pointSize: fontPixelSize
            font.family: localfont.name
            //font.capitalization: Font.SmallCaps
            color: "black"
            text: control.currentText
        }
    }
/*
    TestCase {
        name: "H2oComboBox Testcase"
        when: windowShown
        function test_button_click() {
            mouseClick(control, Qt.LeftButton, Qt.NoModifier)
        }
    }*/
}
