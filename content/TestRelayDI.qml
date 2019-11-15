/****************************************************************************
** TestRelayDI.qml - test relay di
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

import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../components"
Rectangle{
    id: relayTestDelegate
    property bool  rCheck: true
    property string name: qsTr("Ralay")+translator.tr
    property string addr: "0"
    property bool testRelay: true
    signal statusChanged
    Text {
        id: relay_text
        x: 0
        y: 40
        text: name
        font.pixelSize: 30
    }
    Text {
        id: rAddr
        x: 100
        y: 40
        text: addr+ ": "
        font.pixelSize: 30
    }
    Text {
        id: ch1
        x: 160
        y: 0
        text: "ch1"
        font: mainTheme.mediumFont
    }
    Text {
        id: ch2
        x: 160
        y: 47
        text: "ch2"
        font: mainTheme.mediumFont
    }

    H2oSwitch {
        id: ch1Swith
        checked: rCheck
        //anchors.left: relay_text.right
        anchors.top: ch1.top
        x: 630
        width: 75
        height: 40
        visible: testRelay?true:false

        onValueChanged: {
            statusChanged()
        }
    }
    H2oSwitch {
        id: ch2Swith
        checked: rCheck
        //anchors.left: relay_text.right
        anchors.top: ch2.top
        x: 630
        width: 75
        height: 40
        visible: testRelay?true:false

        onValueChanged: {
            statusChanged()
        }
    }
    H2oOnOff {
        id: ch1OnOFF
        anchors.top: ch1.top
        x: 630
        dioameter: 35
        onOff: rCheck
        visible: testRelay?false:true
    }
    H2oOnOff {
        id: ch2OnOFF
        anchors.top: ch2.top
        x: 630
        dioameter: 35
        onOff: rCheck
        visible: testRelay?false:true
    }
}

