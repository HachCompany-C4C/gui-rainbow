/****************************************************************************
** IODelegate.qml - IO list item
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
import QtQuick.Controls.Styles.Flat 1.0 as Flat

Rectangle {
    id: root
    width: parent.width
    height: 64

    property int mType
    property string mCh1Value
    property string mCh2Value
    property string mEnabled
    property int mIndex
    property string mName: typeName(mType)
    property string mPageName: pageName(mType)

    signal clicked

    function typeName(type) {
        var ioName
        switch(type)
        {
        case 1:
            ioName = qsTr("DI")+translator.tr;
            break;
        case 2:
            ioName = qsTr("SPDT")+translator.tr;
            break;
        case 4:
            ioName = qsTr("AO")+translator.tr;
            break;
        default:
            ioName = qsTr("Undefined")+translator.tr;
            break;
        }

        return ioName;
    }

    function pageName(type) {
        var ioName
        switch(type)
        {
        case 1:
            ioName = "io.di";
            break;
        case 2:
            ioName = "io.spdt";
            break;
        case 4:
            ioName = "io.ao";
            break;
        default:
            ioName = "Undefined";
            break;
        }

        return ioName;
    }

    function typeChName(ch, type, value, enable)
    {
        var chName = qsTr("CH")+translator.tr+ch+": ";

        if(enable)
        {
            switch(type)
            {
            case 1:
                chName += value;
                break;
            case 2:
                chName += value;
                break;
            case 4:
                var num = value/1000;
                chName += num.toFixed(1)+" mA"; //uA->mA
                break;
            default:
                chName += "---";
            }
        } else {
            chName += "---";
        }

        return chName;
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
        font: mainTheme.smallFont
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 30
    }

    Text {
        id: ch1
        text: typeChName(1, mType, mCh1Value, mEnabled)
        anchors.left: parent.left
        anchors.leftMargin: 230
        anchors.top: parent.top
        anchors.topMargin: 10
    }

    Text {
        id: ch2
        text: typeChName(2, mType, mCh2Value, mEnabled)
        anchors.left: parent.left
        anchors.leftMargin: 230
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
    }

    Text {
        id: ioenb
        text: mEnabled === "1" ? qsTr("ON")+translator.tr : qsTr("OFF")+translator.tr

        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 160

        font: mainTheme.smallFont
    }

    // line
    Rectangle {
        width: parent.width - 40
        height: Flat.FlatStyle.onePixel
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        //anchors.margins: 15
        color: Flat.FlatStyle.lightFrameColor
    }

    /*Image {
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:///resources/images/navigation_next_item-hach.png"
    }*/

    Text {
        id: arrow
        anchors.right: parent.right
        anchors.rightMargin: 40
        anchors.verticalCenter: parent.verticalCenter
        font: mainTheme.mediumIcon
        color: "#9e9e9e"
        text: "\uf054"
        verticalAlignment: Text.AlignVCenter
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked: root.clicked()

    }
}
