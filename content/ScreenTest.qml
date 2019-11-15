/****************************************************************************
** ScreenTest.qml - Touch screen test
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

import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.2

//import QtQuick.Controls.Styles.Flat 1.0 as Flat
import "../components"

Rectangle {

    id: root
    width: 800
    height: 480
    color: "black"

//    Text {
//        id: curseText
//        text: "+"
//        color: "white"
//        font: mainTheme.bigIcon
//        width: 20
//        height: width

//    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
//        onPositionChanged: {
//            curseText.x = mouse.x - 10
//            curseText.y = mouse.y - 10
//            //console.debug("QML::ScreenTest curse.x="+mouse.x
//            //              +"  curse.y="+mouse.y)
//        }
    }

    Repeater {
        id: testPointRep
        model: ListModel {
            id: testPointModel
            ListElement { ex: 20; ey: 20; etext: "1"; echeck: false }
            ListElement { ex: 750; ey: 20; etext: "2"; echeck: false }
            ListElement { ex: 750; ey: 430; etext: "3"; echeck: false }
            ListElement { ex: 20; ey: 430; etext: "4"; echeck: false }
            ListElement { ex: 390; ey: 230; etext: "5"; echeck: false }
        }

        delegate: Rectangle {
            x: ex
            y: ey
            width: 32
            height: width
            radius: width/2
            color: echeck ? "red" : "white"
            Text {
                anchors.centerIn: parent
                text: etext
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(!echeck)
                        echeck = ! echeck;
                }
            }
        }
    }

//    H2oButton {
//        id: recalibButton
//        anchors.left: parent.left
//        anchors.bottom: parent.bottom
//        width: parent.width/2
//        height: 60
//        text: qsTr("RECALIBRATE")+translator.tr
//        anchors.horizontalCenterOffset: 0
//        buttonRadius: 0
//        buttonTextColor: theme.mainTextColor
//        buttonColor: theme.mediumBackgroundColor
//        buttonBorderColor: theme.mediumBackgroundColor
//        visible: false
//        onClicked: {
//            naviPage.navigate(2, 4, 2);
//            var page = naviPage.currentPage();
//            if(page !== undefined) {
//                page.calibrateTouch();
//            }
//            root.visible = false;
//        }
//    }

//    H2oButton {
//        id: exitButton
//        anchors.right: parent.right
//        anchors.bottom: parent.bottom
//        width: parent.width/2
//        height: 60
//        text: qsTr("EXIT")+translator.tr
//        anchors.horizontalCenterOffset: 0
//        buttonRadius: 0
//        visible: false
//        onClicked: {
//            root.visible = false;
//        }
//    }

    function showTest(b)
    {
        //var enb = local_settings.getValueBool("touchcalib", "testenabled", false);
        //var shown = local_settings.getValueBool("touchcalib", "testshown", false);
        if(mainScreenCali.visible) {
            root.visible = false;
        } else {
            root.visible = b;
        }

        for(var i = 0; i < testPointModel.rowCount(); i++)
        {
            testPointModel.get(i).echeck = false;
        }

        //local_settings.setValue("touchcalib", "testenabled", false);
    }

    function getCheckNum()
    {
        var num = 0;

        for(var i = 0; i < testPointModel.rowCount(); i++)
        {
            if(testPointModel.get(i).echeck)
            {
                num ++;
            }
        }

        return num;
    }
}
