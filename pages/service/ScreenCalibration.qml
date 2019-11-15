/****************************************************************************
** ScreenCalibration.qml - UI to calibrate touch screen
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
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.0
import "../../components"
import "../../content"
Rectangle {
    id: root
    objectName: "Screen_Calibration"
    property string title: qsTr("Screen Calibration")+translator.tr

    //property bool toratex_ts: true
    enabled: mainPermisMgr.editabled

    width: 800
    height: 370

    Connections {
        target: ts_caliThread
        ignoreUnknownSignals: true
        onGotoCalibrateTouch: {
            console.debug("QML::ScreenCalibration onCalibrateTouch");
            mainNaviPage.navigate(2, 4, 2);
            calibrateTouch();
        }
    }

    function calibrateTouch()
    {
        mainScreenCali.visible = true;
        mainScreenTest.visible = false;
    }

    /*Text {
        id: titleText
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -30
        font: mainTheme.bigFont
        text: qsTr("Calibrate Screen?")+translator.tr
    }

    Text {
        anchors.horizontalCenter: titleText.horizontalCenter
        anchors.verticalCenter: titleText.verticalCenter
        anchors.verticalCenterOffset: 50
        font: mainTheme.smallFont
        text: qsTr("Note: please calibrate screen touch by a touchpen not finger.")+translator.tr
    }



    Text {
        id: caliDate
        x: 89
        y: 233
        font.pixelSize: 18
        visible: ts_cali.ts_cali_p6
        text: qsTr("A screen calibration has been done at ") + mainScreenCali.caliTime+"\n"+qsTr("it will take effect after next device restart")+translator.tr
    }*/

    Text {
        id: title
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 40
        font: mainTheme.mediumFont
        text: qsTr("Calibrate Screen")+translator.tr
    }

    Text {
        id: note
        width: 600
        anchors.top: title.bottom
        anchors.left: title.left
        anchors.leftMargin: 20
        font: mainTheme.smallFont
        text: note.getText() + translator.tr
        wrapMode: Text.WordWrap

        property var detail: [
            QT_TR_NOOP("calibrate_screen_desc0"),
            QT_TR_NOOP("calibrate_screen_desc1"),
            QT_TR_NOOP("calibrate_screen_desc2"),
            QT_TR_NOOP("calibrate_screen_desc3")
        ]

        function getText()
        {
            var temp = "";
            for(var i = 0; i < detail.length; i++) {
                temp += qsTr(detail[i]) + "\n";
            }

            return temp;
        }
    }

    H2oButton {
        id: caliBtn
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        height: 60
        width: parent.width
        text: qsTr("START CALIBRATE") + translator.tr
        buttonRadius: 0

        onClicked: {
            //if(toratex_ts)
            mainMessageDialogTwoButton.openDialog("reminder", qsTr("UI will be restarted after screen touch calibration is finished.  Do you want to continue ?"));
            mainMessageDialogTwoButton.parentItem = root;


            //loader.source = "../../content/ScreenCalibrate.qml"
            //caliStackView.push({item: tabList[0], immediate: true, replace: true})
            /*var component
            component=Qt.createComponent("../../content/ScreenCalibrate.qml");
            if(component.status === Component.Ready)
                component.createObject(rectangle, {"x": 800, "y": 480});
            else
                console.debug(component.errorString)
            //ts_cali.tsCalibrate();*/
        }
    }

    function accept()
    {
        root.calibrateTouch();;
    }

    function reject()
    {

    }
}
