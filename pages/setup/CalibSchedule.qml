/****************************************************************************
** CalibSchedule.qml - Interface for calibration schedule setting
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
import QtQuick.Layouts 1.0
import "../../components"
import "../../content/time.js" as TimeScript

Rectangle {
    width: 800
    height: 420
    enabled: mainPermisMgr.editabled
    property alias timeBtnEnabled: button.enabled

    Connections {
        target: calibration_schedule
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            console.debug("QML::UpdatePage calibration.schedule")
            listView.updateIndex();
            customizeTime.updateCustomTime();
            //startTime.updateStartTime();
            timeSetting.updateTime();
            dateSetting.updateDate();
            page_manager.updatePageDone();
        }
    }

    H2oExclusiveGroup {
        id: tabGroup
    }

    Text {
        id: intervalText
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.top: parent.top
        anchors.topMargin: 10
        text: qsTr("Interval")+translator.tr
        font: mainTheme.titleFont
    }

    ListView {
        id: listView
        anchors.left: intervalText.left
        anchors.leftMargin: 10
        anchors.top: intervalText.bottom
        anchors.topMargin: 10
        width: 300
        height: 131
        boundsBehavior: Flickable.StopAtBounds
        scale: 1
        cacheBuffer: 200
        contentHeight: 1144
        snapMode: ListView.SnapToItem
        flickableDirection: Flickable.VerticalFlick
        spacing: 5
        property var listName: [qsTr("Trigger")+translator.tr,
                            qsTr("Customize")+translator.tr,
                            qsTr("Interval")+translator.tr]

        model: ListModel {
            ListElement { name: qsTr("Trigger"); check: false; index: 0 }
            ListElement { name: qsTr("Customize"); check: false; index: 1 }
            ListElement { name: qsTr("Interval"); check: false; index: 2 }
        }

        delegate: H2oLineRadioButton {
            text: listView.listName[index]
            checked: check
            exclusiveGroup: tabGroup
            onValueChanged: {
                listView.currentIndex = index;
                if(index == 2) //interval
                {
                    calibration_schedule.setObj("index", index + intervalTimeList.currentIndex);
                }
                else if(index == 1) //custom
                {
                    var name = ["index", "customize"];
                    var value = [index, customizeTime.text.valueOf()]; //minutes
                    calibration_schedule.setObjs(name, value);
                }
                else if(index == 0) //trigger
                {
                    calibration_schedule.setObj("index", index); //add list number
                }
            }
        }

        function updateIndex() {
            var i = calibration_schedule.getObjInt("index");
            var modelIndex;

            if(i >= 2) {
                modelIndex = 2
                intervalTimeList.currentIndex = i - 2;
            } else {
                modelIndex = i;
            }

            //listView.model.setProperty(modelIndex, "check", true);
            listView.contentItem.children[modelIndex].checked = true;
            listView.currentIndex = modelIndex;
        }
    }

    H2oDropBox {
        id: intervalTimeList
        width: 197
        height: 43
        property bool operated: false
        anchors.left: customizeTime.left
        anchors.top: customizeTime.bottom
        anchors.topMargin: 2
        enabled: listView.currentIndex === 2 ? true:false

        listName: [qsTr("1 day")+translator.tr,
                   qsTr("3 days")+translator.tr,
                   qsTr("5 days")+translator.tr,
                   qsTr("7 days")+translator.tr
        ]

        model: ListModel {
            id: intervalTimeItem
            ListElement { name: qsTr("1 day") }
            ListElement { name: qsTr("3 days") }
            ListElement { name: qsTr("5 days") }
            ListElement { name: qsTr("7 days") }
        }

        onIndexChanged: {
            calibration_schedule.setObj("index", intervalTimeList.currentIndex+2);
        }
    }

    H2oTextField {
        id: customizeTime
        anchors.left: listView.right
        anchors.leftMargin: 5
        anchors.top: listView.top
        anchors.topMargin: 33
        width: 197
        height: 40
        enabled: listView.currentIndex === 1 ? true:false
        plaintext: text+" "+qsTr("minites")+translator.tr

        onEditDone: {
            var numOrg = Number.fromLocaleString(Qt.locale(), inputStr);
            var num = numOrg.toFixed();//minutes

            if(calibration_schedule.isInRange("customize", numOrg))
            {
                text = numOrg;
                calibration_schedule.setObj("customize", num);
            } else {
                var range = calibration_schedule.rangeString("customize");
                mainMessageDialogOneButton.text = qsTr("Your input ")+numOrg+qsTr(" out of range")+translator.tr+range;
                mainMessageDialogOneButton.open();
                text = preText;
            }
        }

        function updateCustomTime() {
            var textTime = calibration_schedule.getObjInt("customize")
            var day = Number(textTime); //minutes
            text = day.toFixed().toString()
            // console.debug("QML::MeasureSchedule customize: "+text)
        }
    }

    /*Text {
        x: 536
        y: 66
        text: qsTr("days")+translator.tr
        font.pixelSize: 20
    }*/

    /*H2oDateTime1 {
        id: startTime
        x: 0
        y: 240

        function updateStartTime() {
            dtYear = calibration_schedule.getObjInt("year");
            dtMonth = calibration_schedule.getObjInt("month");
            dtDay = calibration_schedule.getObjInt("day");
            dtHour = calibration_schedule.getObjInt("hour");
            dtMinute = calibration_schedule.getObjInt("minute");
        }

        onTimeSetting: {
            var items = ["year", "month", "day", "hour", "minute"];
            var values = [year, month, day, hour, minute];
            calibration_schedule.setObjs(items, values);
        }
    }*/

    Text {
        id: startTimeText
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.top: listView.bottom
        anchors.topMargin: 20
        text: qsTr("Start Time")+translator.tr
        font: mainTheme.titleFont
    }

    H2oTimeSetting {
        id: timeSetting
        anchors.left: startTimeText.left
        anchors.leftMargin: 10
        anchors.top: startTimeText.bottom
        anchors.topMargin: 10
        function updateTime() {
            if(!button.enabled) {
                //var hour = calibration_schedule.getObjInt("hour");
                //var minute = calibration_schedule.getObjInt("minute");

                var starttime = calibration_schedule.getObjInt("starttime");
                var datetime = TimeScript.convertU32Date(starttime);

                var hour = datetime.getHours();
                var minute = datetime.getMinutes();
                var seconds = datetime.getSeconds();

                init(hour, minute);
            }
        }

        onHourSetting: {
            //calibration_schedule.setObj("hour", hour);
            button.enabled = true;
        }

        onMinuteSetting: {
            //calibration_schedule.setObj("minute", minute);
            button.enabled = true;
        }
    }

    H2oDateSetting {
        id: dateSetting
        anchors.verticalCenter: timeSetting.verticalCenter
        anchors.left: timeSetting.right
        anchors.leftMargin: 10
        width: 300
        height: 40

        function updateDate() {
            if(!button.enabled) {
                //var year = calibration_schedule.getObjInt("year");
                //var month = calibration_schedule.getObjInt("month");
                //var day = calibration_schedule.getObjInt("day");
                var starttime = calibration_schedule.getObjInt("starttime");
                var datetime = TimeScript.convertU32Date(starttime);

                var year = datetime.getFullYear();
                var month = datetime.getMonth()+1; // Date start from 0
                var day = datetime.getDate();

                dateSetting.init(year, month, day);
                // console.debug("QML::CalibSchedule Date: "+year+"/"+month+"/"+day);
                button.enabled = false;
            }
        }

        onDateSetting: {
            //var items = ["year", "month", "day"];
            //var values = [year, month, day];
            //calibration_schedule.setObjs(items, values);
            //console.debug("QML::CalibSchedule onDateSetting")
            button.enabled = true;
        }
    }

    function setDateTime() {
        //calibration_schedule.clearObjTList();
        //calibration_schedule.addObjToTList("year", dateSetting.dtYear);
        //calibration_schedule.addObjToTList("month", dateSetting.dtMonth);
        //calibration_schedule.addObjToTList("day", dateSetting.dtDay);
        //calibration_schedule.addObjToTList("hour", timeSetting.value[0]);
        //calibration_schedule.addObjToTList("minute", timeSetting.value[1]);
        //calibration_schedule.setObjTList();
        var timeT32 = TimeScript.convertTimeU32(dateSetting.dtYear, dateSetting.dtMonth, dateSetting.dtDay,
                                                timeSetting.value[0], timeSetting.value[1], 0);
        calibration_schedule.setObj("starttime", "0x"+timeT32.toString(16));
    }

    H2oButtonReg {
        id: button
        anchors.verticalCenter: dateSetting.verticalCenter
        anchors.left: dateSetting.right
        anchors.leftMargin: 20
        enabled: false

        onAccepted: {
            button.enabled = false;
            setDateTime();
        }
    }
}



