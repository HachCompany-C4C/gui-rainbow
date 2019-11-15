/****************************************************************************
** MeasureSchedule.qml - Interface for measure schedule setting
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
import "../../content/time.js" as TimeScript
import "../../components"

Rectangle {
    enabled: mainPermisMgr.editabled
    property alias timeBtnEnabled: button.enabled

    Connections {
        target: measure_schedule
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            console.debug("QML::UpdatePage measure.schedule")
            listView.updateIndex();
            customizeTime.updateCustomTime();
            //startTime.updateStartTime();
            timeSetting.updateTime();
            dateSetting.updateDate();

            page_manager.updatePageDone();
        }
    }

    signal debugMessage(string message, string operate)
    width: 800
    height: 400

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
        height: 178
        boundsBehavior: Flickable.StopAtBounds
        scale: 1
        cacheBuffer: 200
        contentHeight: 1144
        snapMode: ListView.SnapToItem
        flickableDirection: Flickable.VerticalFlick
        spacing: 5
        property var listName: [qsTr("Trigger")+translator.tr,
                            qsTr("Continuous")+translator.tr,
                            qsTr("Customize")+translator.tr,
                            qsTr("Interval")+translator.tr]

        model: ListModel {
            ListElement { name: qsTr("Trigger"); check: false; index: 0 }
            ListElement { name: qsTr("Continuous"); check: false; index: 1 }
            ListElement { name: qsTr("Customize"); check: false; index: 2 }
            ListElement { name: qsTr("Interval"); check: false; index: 3 }
        }

        delegate: H2oLineRadioButton {
            text: listView.listName[index]
            checked: check
            exclusiveGroup: tabGroup
            onValueChanged: {
                listView.currentIndex = index
                if(index == 2) //Customize
                {
                    var name = ["index", "customize"];
                    var value = [index, customizeTime.text.valueOf()];
                    measure_schedule.setObjs(name, value);
                }
                else if(index == 3) //Interval
                {
                    measure_schedule.setObj("index", index + intervalTimeList.currentIndex)
                } else { // Trigger/Contineous (index == 0/1)
                    measure_schedule.setObj("index", index);
                }
            }
        }

        function updateIndex() {
            var i = measure_schedule.getObjInt("index");
            var index = i > 3 ? 3 : i;
            //listView.model.setProperty(index, "check", true);
            listView.contentItem.children[index].checked = true;
            listView.currentIndex = index;
            if(i >= 3) {
                intervalTimeList.currentIndex = i-3;
            }
        }

        //onCurrentIndexChanged: {
        //    console.debug("QML::MeasureSchedule currentIndex: "+currentIndex)
        //}
    }

    H2oTextField {
        id: customizeTime
        anchors.left: listView.right
        anchors.leftMargin: 5
        anchors.top: listView.top
        anchors.topMargin: 73
        width: 200
        height: 40
        enabled: listView.currentIndex === 2 ? true:false
        plaintext: text+" "+qsTr("minutes")+translator.tr

        onEditDone: {
            var numOrg = Number.fromLocaleString(Qt.locale(), inputStr);
            var num = numOrg.toFixed();

            if(measure_schedule.isInRange("customize", numOrg))
            {
                text = num;
                measure_schedule.setObj("customize", num);
            } else {
                var range = measure_schedule.rangeString("customize");
                mainMessageDialogOneButton.text = qsTr("Your input ")+numOrg+qsTr(" out of range")+translator.tr+range;
                mainMessageDialogOneButton.open();
                text = preText;
            }
        }

        function updateCustomTime() {
            var textTime = measure_schedule.getObjInt("customize");
            var hour = Number(textTime);
            text = hour.toFixed().toString();
            // console.debug("QML::MeasureSchedule customize: "+text)
        }
    }

    /*Text {
        x: 541
        y: 103
        text: qsTr("minutes")+translator.tr
        font.pixelSize: 20
    }*/

    H2oDropBox {
        id: intervalTimeList
        width: 200
        height: 40
        anchors.left: customizeTime.left
        anchors.top: customizeTime.bottom
        anchors.topMargin: 2
        enabled: listView.currentIndex === 3 ? true:false

        listName: [
            qsTr("30 minites")+translator.tr,
            qsTr("1 hour")+translator.tr,
            qsTr("2 hours")+translator.tr,
            qsTr("4 hours")+translator.tr,
        ]

        model: ListModel {
            id: intervalTimeItem
            ListElement { name: "30 minites" }
            ListElement { name: "1 hour" }
            ListElement { name: "2 hours" }
            ListElement { name: "4 hours" }
        }

        onIndexChanged: {
            measure_schedule.setObj("index", 3+intervalTimeList.currentIndex)
        }
    }

    /*H2oDateTime1 {
        id: startTime
        x: 0
        y: 240

        function updateStartTime() {
            dtYear = measure_schedule.getObjInt("year");
            dtMonth = measure_schedule.getObjInt("month");
            dtDay = measure_schedule.getObjInt("day");
            dtHour = measure_schedule.getObjInt("hour");
            dtMinute = measure_schedule.getObjInt("minute");
        }

        onTimeSetting: {
            var items = ["year", "month", "day", "hour", "minute"];
            var values = [year, month, day, hour, minute];
            measure_schedule.setObjs(items, values);
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
            if(!button.enabled)
            {
                //var hour = measure_schedule.getObjInt("hour");
                //var minute = measure_schedule.getObjInt("minute");

                var starttime = measure_schedule.getObjInt("starttime");
                var datetime = TimeScript.convertU32Date(starttime);

                var hour = datetime.getHours();
                var minute = datetime.getMinutes();
                var seconds = datetime.getSeconds();

                init(hour, minute);
            }
        }

        onHourSetting: {
            //measure_schedule.setObj("hour", hour);
            button.enabled = true;
        }

        onMinuteSetting: {
            //measure_schedule.setObj("minute", minute);
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
            if(!button.enabled)
            {
                //var year = measure_schedule.getObjInt("year");
                //var month = measure_schedule.getObjInt("month");
                //var day = measure_schedule.getObjInt("day");

                var starttime = measure_schedule.getObjInt("starttime");
                var datetime = TimeScript.convertU32Date(starttime);

                var year = datetime.getFullYear();
                var month = datetime.getMonth()+1; // Date start from 0
                var day = datetime.getDate();

                dateSetting.init(year, month, day);
                //console.debug("QML::MeasureSchedule Date: "+year+"/"+month+"/"+day);
                button.enabled = false;
            }
        }

        onDateSetting: {
            //var items = ["year", "month", "day"];
            //var values = [year, month, day];
            //measure_schedule.setObjs(items, values);
            //console.debug("QML::MeasureSchedule onDateSetting")
            button.enabled = true;
        }
    }

    function setDateTime() {
        //measure_schedule.clearObjTList();
        //measure_schedule.addObjToTList("year", dateSetting.dtYear);
        //measure_schedule.addObjToTList("month", dateSetting.dtMonth);
        //measure_schedule.addObjToTList("day", dateSetting.dtDay);
        //measure_schedule.addObjToTList("hour", timeSetting.value[0]);
        //measure_schedule.addObjToTList("minute", timeSetting.value[1]);
        //measure_schedule.setObjTList();

        var timeT32 = TimeScript.convertTimeU32(dateSetting.dtYear, dateSetting.dtMonth, dateSetting.dtDay,
                                                timeSetting.value[0], timeSetting.value[1], 0);
        measure_schedule.setObj("starttime", "0x"+timeT32.toString(16));
    }

    H2oButtonReg {
        id: button
        anchors.verticalCenter: dateSetting.verticalCenter
        anchors.left: dateSetting.right
        anchors.leftMargin: 20
        enabled: false

        onAccepted: {

            // time set by user > 8 hours current time
            var msecsSet = TimeScript.toMsecsSinceEpoch(new Date(dateSetting.dtYear, dateSetting.dtMonth-1,
                                                      dateSetting.dtDay, timeSetting.value[0],
                                                      timeSetting.value[1], 0));
            var msecsNow = TimeScript.toMsecsSinceEpoch(new Date());

            var delta = (msecsSet-msecsNow)/1000/3600;
            if(delta <= 8) {
                button.enabled = false;
                setDateTime();
            } else {
                mainMessageDialogOneButton.openDialog("reminder", qsTr("The start time shouldn't be 8 hours later than present time."))
            }
        }
    }

}


