/****************************************************************************
** SysDateTime.qml - Interface for date time setting
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
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import "../../content/time.js" as TimeScript
import "../../components"

Item {
    width: 800
    height: 360
    enabled: mainPermisMgr.editabled
    property alias timeBtnEnabled: button.enabled

    Connections {
        target: system_info
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            console.debug("QML::UpdatePage system_info")
            timeSetting.updateTime();
            dateSetting.updateDate();
            //page_manager.updatePageDone();
        }
    }

    Text {
        id: datetimeText
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.top: parent.top
        anchors.topMargin: 10
        text: qsTr("Date & time setting")+translator.tr
        font: mainTheme.titleFont
        visible: false
    }

    H2oTimeSetting {
        id: timeSetting
        anchors.left: datetimeText.left
        anchors.leftMargin: 10
        anchors.top: datetimeText.bottom
        anchors.topMargin: 10
        function updateTime() {
            if(!button.enabled)
            {
                var datetime = new Date();
                var hour = datetime.getHours();
                var minute = datetime.getMinutes();
                init(hour, minute);
            }
        }

        onHourSetting: {
            //system_info.setObj("hour", hour);
            //system_time.setHour(hour)
            //setTime();
            button.enabled = true;
        }

        onMinuteSetting: {
            //system_info.setObj("minute", minute);
            //system_time.setMin(minute);
            //setTime();
            button.enabled = true;
        }

        Component.onCompleted: {
            timeSetting.updateTime();
        }
    }

    H2oDateSetting {
        id: dateSetting
        anchors.verticalCenter: timeSetting.verticalCenter
        anchors.left: timeSetting.right
        anchors.leftMargin: 10
        width: 300
        isOnBottom: true

        function updateDate() {
            if(!button.enabled)
            {
                var datetime = new Date();
                var year = datetime.getFullYear();
                var month = datetime.getMonth()+1;
                var day = datetime.getDate();
                dateSetting.init(year, month, day);
                //console.debug("QML::MeasureSchedule Date: "+year+"/"+month+"/"+day);
                button.enabled = false;
            }
        }

        onDateSetting: {
            //setDate();
            button.enabled = true;
        }

        Component.onCompleted: {
            dateSetting.updateDate();
        }
    }

    H2oButtonReg {
        id: button
        anchors.verticalCenter: dateSetting.verticalCenter
        anchors.left: dateSetting.right
        anchors.leftMargin: 20
        enabled: false

        onAccepted: {
            var busy = false; //current_measure.getObjBool("busy");
            if(!busy) {
                button.enabled = false;
                setDateTimeU32();
            } else {
                mainMessageDialogOneButton.openDialog("reminder",
                                                      qsTr("The system time can't be changed during device is busy."))
            }
        }
    }

    function setDate()
    {
        // set dosing board rtc and HMI board rtc
        var datetime = new Date();
        var seconds = datetime.getSeconds();
        system_info.clearObjTList();
        system_info.addObjToTList("year", dateSetting.dtYear);
        system_info.addObjToTList("month", dateSetting.dtMonth);
        system_info.addObjToTList("day", dateSetting.dtDay);
        system_info.addObjToTList("time_set", {"datetime": [dateSetting.dtYear, dateSetting.dtMonth, dateSetting.dtDay, timeSetting.value[0], timeSetting.value[1], seconds]});
        system_info.setObjTList();
    }

    function setTime()
    {
        // set dosing board rtc and HMI board rtc
        var datetime = new Date();
        var seconds = datetime.getSeconds();
        // console.debug("QML::SysDateTime: "+timeSetting.value[0])
        system_info.clearObjTList();
        system_info.addObjToTList("hour", timeSetting.value[0]);
        system_info.addObjToTList("minute", timeSetting.value[1]);
        system_info.addObjToTList("time_set", {"datetime": [dateSetting.dtYear, dateSetting.dtMonth, dateSetting.dtDay, timeSetting.value[0], timeSetting.value[1], seconds]});
        system_info.setObjTList();
    }

    function setDateTime()
    {
        // set dosing board rtc and HMI board rtc
        var datetime = new Date();
        var seconds = datetime.getSeconds();
        system_info.clearObjTList();
        system_info.addObjToTList("year", dateSetting.dtYear);
        system_info.addObjToTList("month", dateSetting.dtMonth);
        system_info.addObjToTList("day", dateSetting.dtDay);
        system_info.addObjToTList("hour", timeSetting.value[0]);
        system_info.addObjToTList("minute", timeSetting.value[1]);
        system_info.addObjToTList("time_set", {"datetime": [dateSetting.dtYear, dateSetting.dtMonth, dateSetting.dtDay, timeSetting.value[0], timeSetting.value[1], seconds]});
        system_info.setObjTList();
    }

    /*function setDateTimeU32()
    {
        // set dosing board rtc and HMI board rtc
        var datetime = new Date();
        var seconds = datetime.getSeconds();
        system_info.clearObjTList();
        system_info.addObjToTList("year", dateSetting.dtYear);
        system_info.addObjToTList("month", dateSetting.dtMonth);
        system_info.addObjToTList("day", dateSetting.dtDay);
        system_info.addObjToTList("hour", timeSetting.value[0]);
        system_info.addObjToTList("minute", timeSetting.value[1]);
        system_info.addObjToTList("time_set", {"datetime": [dateSetting.dtYear, dateSetting.dtMonth, dateSetting.dtDay, timeSetting.value[0], timeSetting.value[1], seconds]});
        system_info.setObjTList();
    }*/

    function setDateTimeU32()
    {
        // set dosing board rtc and HMI board rtc
        var datetime = new Date();
        var seconds = datetime.getSeconds();
        system_info.clearObjTList();
        var rtc = TimeScript.convertTimeU32(dateSetting.dtYear, dateSetting.dtMonth, dateSetting.dtDay,
                                  timeSetting.value[0], timeSetting.value[1], seconds);
        system_info.addObjToTList("rtc", "0x"+rtc.toString(16));
        system_info.addObjToTList("time_set", {"datetime": [dateSetting.dtYear, dateSetting.dtMonth, dateSetting.dtDay, timeSetting.value[0], timeSetting.value[1], seconds]});
        system_info.setObjTList();
    }

    /*Timer {
        id: syncTimer
        repeat: true
        interval: 3600000 // 1*3600*1000=1day
        triggeredOnStart: false
        running: true
        onTriggered: {
            // sync HMI board rtc to dosing board
            var datetime = new Date();
            var year = datetime.getFullYear();
            var month = datetime.getMonth()+1; // Date start from 0
            var day = datetime.getDate();
            var hour = datetime.getHours();
            var minute = datetime.getMinutes();
            var seconds = datetime.getSeconds();
            system_info.clearObjTList();
            system_info.addObjToTList("year", year);
            system_info.addObjToTList("month", month);
            system_info.addObjToTList("day", day);
            system_info.addObjToTList("hour", hour);
            system_info.addObjToTList("minute", minute);
            system_info.addObjToTList("seconds", seconds);
            system_info.setObjTList();
        }
    }*/
}
