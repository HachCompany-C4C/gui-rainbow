/****************************************************************************
** ScreenCalibrate.qml - Screen calibration
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
import QtQuick.Window 2.2

//import QtQuick.Controls.Styles.Flat 1.0 as Flat
import "../components"


Item {

    id: scr_cali
    width: 800
    height: 480
    property bool startFlag: false
    property string display: qsTr("click screen, start calibrating this screen")+translator.tr
    property string caliTime

    Connections {
        target: ts_caliThread
        ignoreUnknownSignals: true
        onNextCalibrated: {
            p1.visible = ts_cali.ts_cali_p1
            p2.visible = ts_cali.ts_cali_p2
            p3.visible = ts_cali.ts_cali_p3
            p4.visible = ts_cali.ts_cali_p4
            p5.visible = ts_cali.ts_cali_p5

            if(ts_cali.ts_cali_p6 === true)
            {
                startFlag = false
                display = qsTr("click screen, start calibrating this screen")+translator.tr
                caliTime = Date()
                mainScreenCali.visible = false;
                //console.debug("QML::Screen Calibrated done")
                mainMessageDialogNoButton.openDialog("reminder", qsTr("Restart UI to apply the calibrated result, please wait for a minute"));
                //mainMessageDialogTwoButton.parentItem = scr_cali;

                local_settings.setValue("touchcalib", "testenabled", true);
                restartTimer.start();
            }
        }
    }

    Timer {
        id: restartTimer
        interval: 2000
        repeat: false
        running: false
        triggeredOnStart: false
        onTriggered: {
            scr_cali.accept();
        }
    }

    function accept()
    {
        exec_script.exec("reboot");
        //if(soc_version.getSocDesc() === "i.MX6DL")
        //{
        //    exec_script.exec("/etc/init.d/ui_qt.sh restart");
        //} else {
        //    exec_script.exec("systemctl restart systemd-ui");
        //}
    }

    function reject()
    {

    }

    Rectangle {
        id: rectangle

        x:-800
        y:-480
        height: 480*3
        width: 800*3
        color: "black"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(startFlag === false)
                {
                    //ts_caliThread.init();
                    ts_cali.startCali();
                    ts_caliThread.start();
                    startFlag = true
                    display = qsTr("click every red point to calibrate screen ")+translator.tr
                    ts_cali.ts_cali_p6 = false
                }
                /*if(ts_cali.ts_cali_p6===false)
                {
                    p1.visible = ts_cali.ts_cali_p1
                    p2.visible = ts_cali.ts_cali_p2
                    p3.visible = ts_cali.ts_cali_p3
                    p4.visible = ts_cali.ts_cali_p4
                    p5.visible = ts_cali.ts_cali_p5
                }*/

                /*if(ts_cali.ts_cali_p6 === true)
                {
                    startFlag = false
                    p1.visible = false
                    p2.visible = false
                    p3.visible = false
                    p4.visible = false
                    p5.visible = false
                    display = qsTr("click screen, start calibrating this screen")+translator.tr
                    caliTime = Date()
                    mainScreenCali.visible = false;
                }*/

            }
        }
    }

    Text {
        id: txt
        x: 125
        y: 150
        color: "white"
        font: mainTheme.bigFont
        text: display
        anchors.horizontalCenter: parent.horizontalCenter
    }

    CaliPoint {
        id: p1
        x: 20
        y: 20
        visible: false
        //visible: ts_cali.ts_cali_p1

    }

    CaliPoint {
        id: p2
        x: 720
        y: 20
        visible: false//ts_cali.ts_cali_p2
    }

    CaliPoint {
        id: p3
        x: 720
        y: 410
        visible: false//ts_cali.ts_cali_p3
    }
    CaliPoint {
        id: p4
        x: 20
        y: 410
        visible: false//ts_cali.ts_cali_p4
    }
    CaliPoint {
        id: p5
        x: 370
        y: 210
        visible: false//ts_cali.ts_cali_p5
    }


}
