/****************************************************************************
** TestIo.qml - Test io
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
import QtQuick.Controls.Styles.Flat 1.0 as Flat
import "../components"
Rectangle{
    id: aoTestDelegate

    width: parent.width
    height: 90

    property int mType
    property int mIndex
    property string mName: typeName(mType)
    //property string mPageName: pageName(mType)
    property bool  ch1Check: true
    property bool  ch2Check: true
    property string ch1Value
    property string ch2Value

    signal aoCh1Clicked
    signal aoCh2Clicked
    signal doCh1StatusChanged
    signal doCh2StatusChanged

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

    Text {
        id: textitem
        color: "black"
        text: mIndex+": "+typeName(mType)
        font: theme.titleFont
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 30
    }

    Text {
        id: ch1
        text: qsTr("CH") + translator.tr + "1"
        anchors.left: parent.left
        anchors.leftMargin: 230
        anchors.verticalCenter: ch1SimButton.verticalCenter
    }

    Text {
        id: ch2
        text: qsTr("CH") + translator.tr + "2"
        anchors.left: parent.left
        anchors.leftMargin: 230
        anchors.verticalCenter: ch2SimButton.verticalCenter
    }

    H2oButton {
        id: ch1SimButton
        x: 630
        anchors.top: parent.top
        anchors.topMargin: 3
        height: 40
        width: 75
        text: qsTr("Simu")+translator.tr
        buttonRadius: 5
        visible: mType===4?true:false
        onClicked: {
            aoCh1Clicked()
        }
    }
    H2oButton {
        id: ch2SimButton
        x: 630
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 3
        height: 40
        width: 75
        text: qsTr("Simu")+translator.tr
        buttonRadius: 5
        visible: mType===4?true:false
        onClicked: {
            aoCh2Clicked()
        }
    }

    Text {
        id: out1CurrentText
        anchors.right: ch1SimButton.left
        anchors.rightMargin: 50
        anchors.verticalCenter: ch1SimButton.verticalCenter
        font: mainTheme.smallFont
        visible: false //mType===4?true:false
        text: "mA"
    }
    Text {
        id: out2CurrentText
        anchors.right: ch2SimButton.left
        anchors.rightMargin: 50
        anchors.verticalCenter: ch2SimButton.verticalCenter
        font: mainTheme.smallFont
        visible: false //mType===4?true:false
        text: "mA"
    }
    H2oTextField {
        id: out1Current
        anchors.right: out1CurrentText.left
        anchors.rightMargin: 5
        anchors.verticalCenter: ch1SimButton.verticalCenter
        width: 160
        height: 40
        visible: mType===4?true:false
        //plaintext: ch1Value
        plaintext: ch1Value+" "+qsTr("mA")+translator.tr

        onEditDone: {
            var numOrg = Number.fromLocaleString(Qt.locale(), inputStr);
            var num = numOrg.toFixed(2);

            /*if(test_io.isInRange("simu_ao_ch1", numOrg))
            {
                ch1Value = num;
                test_io.setObj("simu_ao_ch1", num);
            } else {
                var range = test_io.rangeString("simu_ao_ch1");
                mainMessageDialogOneButton.text = qsTr("Your input ")+numOrg+qsTr(" out of range")+translator.tr+range;
                mainMessageDialogOneButton.open();
                ch1Value = preText;
            }*/

            ch1Value = num;
            test_io.setObj("simu_ao_ch1", num);
        }
        /*
        onEditDone: {
            var num = Number.fromLocaleString(Qt.locale(), inputStr)
            ch1Value = Number(num).toFixed(2)
        }*/
    }
    H2oTextField {
        id: out2Current
        anchors.right: out2CurrentText.left
        anchors.rightMargin: 5
        anchors.verticalCenter: ch2SimButton.verticalCenter
        width: 160
        height: 40
        visible: mType===4?true:false
        //plaintext: ch2Value

        plaintext: ch2Value+" "+qsTr("mA")+translator.tr

        onEditDone: {
            var numOrg = Number.fromLocaleString(Qt.locale(), inputStr);
            var num = numOrg.toFixed(2);

            ch2Value = num;
            test_io.setObj("simu_ao_ch2", num);

            /*if(test_io.isInRange("simu_ao_ch2", numOrg))
            {
                ch2Value = num;
                test_io.setObj("simu_ao_ch2", num);
            } else {
                var range = test_io.rangeString("simu_ao_ch2");
                mainMessageDialogOneButton.text = qsTr("Your input ")+numOrg+qsTr(" out of range")+translator.tr+range;
                mainMessageDialogOneButton.open();
                ch2Value = preText;
            }*/
        }

        /*onEditDone: {
            var num = Number.fromLocaleString(Qt.locale(), inputStr)
            ch2Value = Number(num).toFixed(2)
        }*/
    }
    H2oSwitch {
        id: ch1Swith
        checked: ch1Check
        anchors.verticalCenter: ch1SimButton.verticalCenter
        x: 630
        width: 75
        height: 40
        visible: mType===2?true:false
        onValueChanged: {
            doCh1StatusChanged()
        }
    }
    H2oSwitch {
        id: ch2Swith
        checked: ch2Check
        anchors.verticalCenter: ch2SimButton.verticalCenter
        x: 630
        width: 75
        height: 40
        visible: mType===2?true:false

        onValueChanged: {
            doCh2StatusChanged()
        }
    }
    TestOnOff {
        id: ch1OnOFF
        anchors.verticalCenter: ch1SimButton.verticalCenter
        x: 630
        dioameter: 35
        onOff: ch1Check
        visible: mType===1?true:false
    }
    TestOnOff {
        id: ch2OnOFF
        anchors.verticalCenter: ch2SimButton.verticalCenter
        x: 630
        dioameter: 35
        onOff: ch2Check
        visible: mType===1?true:false
    }

    Rectangle {
        id: sp1
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        height: Flat.FlatStyle.onePixel
        width: parent.width - 40
        color: Flat.FlatStyle.lightFrameColor
    }
}

