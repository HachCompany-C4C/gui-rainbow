/****************************************************************************
** TestDelegate.qml - Test delegate
**
** Created on: 2017-10-31
**
** Author:
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
import QtQuick.Controls.Styles.Flat 1.0 as Flat

Rectangle {
    id: root
    width: parent.width
    height: 64

    property int mType
    property bool mEnabled
    property int mIndex
    property string mName: typeName(mType)
    property string mPageName: pageName(mType)

    signal clicked

    function typeName(type) {
        var testName
        switch(type)
        {
        case 1:
            testName = "IO";
            break;
        case 2:
            testName = "Pump & Valve";
            break;
        case 3:
            testName = "Mixer & Heating";
            break;
        case 4:
            testName = "AD Adjust";
            break;
        case 5:
            testName = "Substep";
            break;
        default:
            testName = "Undefined";
            break;
        }

        return testName;
    }

    function pageName(type) {
        var testName
        switch(type)
        {
        case 1:
            testName = "test.io";
            break;
        case 2:
            testName = "test.pv";
            break;
        case 3:
            testName = "test.mh";
            break;
        case 4:
            testName = "test.ad";
            break;
        case 5:
            testName = "test.substep";
            break;
        default:
            testName = "Undefined";
            break;
        }

        return testName;
    }



    Rectangle {
        anchors.fill: parent
        color: "#9e9e9e"
        visible: mouse.pressed
    }

    Text {
        id: textitem
        color: "black"
        text: mIndex+": "+typeName(mType)
        font: theme.mediumFont
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 15
    }

    // line
    Rectangle {
        width: parent.width
        height: Flat.FlatStyle.onePixel
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        //anchors.margins: 15
        color: Flat.FlatStyle.lightFrameColor
    }

    Image {
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:///resources/images/navigation_next_item-hach.png"
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked: root.clicked()

    }
}
