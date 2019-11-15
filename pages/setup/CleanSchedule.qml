/****************************************************************************
** CleanSchedule.qml - Interface for clean schedule setting
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
        target: cleaning_schedule
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            console.debug("QML::UpdatePage cleaning.schedule")
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
        property var listName: [
            qsTr("Trigger")+translator.tr,
            qsTr("Customize")+translator.tr,
            qsTr("Interval")+translator.tr
        ]

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
                    cleaning_schedule.setObj("index", index + intervalTimeList.currentIndex);
                }
                else if(index == 1) //custom
                {
                    var name = ["index", "customize"];
                    var value = [index, customizeTime.text.valueOf()]; //minutes
                    cleaning_schedule.setObjs(name, value);
                }
                else if(index == 0) // trigger
                {
                    cleaning_schedule.setObj("index", index);
                }
            }
        }

        function updateIndex() {
            var i = cleaning_schedule.getObjInt("index");
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
        anchors.left: customizeTime.left
        anchors.top: customizeTime.bottom
        anchors.topMargin: 2
        enabled: listView.currentIndex === 2 ? true:false

        listName: [
            qsTr("6 hours")+translator.tr,
            qsTr("12 hours")+translator.tr,
            qsTr("24 hours")+translator.tr
        ]

        model: ListModel {
            id: intervalTimeItem
            ListElement { name: qsTr("6 hours") }
            ListElement { name: qsTr("12 hours") }
            ListElement { name: qsTr("24 hours") }
        }

        onIndexChanged: {
            cleaning_schedule.setObj("index", intervalTimeList.currentIndex+2)
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
        plaintext: text+" "+qsTr("minutes")+translator.tr

        onEditDone: {
            var numOrg = Number.fromLocaleString(Qt.locale(), inputStr);
            var num = numOrg.toFixed();//minutes

            if(cleaning_schedule.isInRange("customize", numOrg))
            {
                text = numOrg;
                cleaning_schedule.setObj("customize", num);
            } else {
                var range = cleaning_schedule.rangeString("customize");
                mainMessageDialogOneButton.text = qsTr("Your input ")+numOrg+qsTr(" out of range")+translator.tr+range;
                mainMessageDialogOneButton.open();
                text = preText;
            }
        }

        function updateCustomTime() {
            var textTime = cleaning_schedule.getObjInt("customize")
            var hour = Number(textTime); //minutes
            text = hour.toFixed().toString()
        }
    }

    /*Text {
        x: 555
        y: 80
        text: qsTr("hours")+translator.tr
        font.pixelSize: 20
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

    /*H2oDateTime1 {
        id: startTime
        x: 0
        y: 240

        function updateStartTime() {
            dtYear = cleaning_schedule.getObjInt("year");
            dtMonth = cleaning_schedule.getObjInt("month");
            dtDay = cleaning_schedule.getObjInt("day");
            dtHour = cleaning_schedule.getObjInt("hour");
            dtMinute = cleaning_schedule.getObjInt("minute");
        }

        onTimeSetting: {
            var items = ["year", "month", "day", "hour", "minute"];
            var values = [year, month, day, hour, minute];
            cleaning_schedule.setObjs(items, values);
        }
    }*/

    H2oTimeSetting {
        id: timeSetting
        anchors.left: startTimeText.left
        anchors.leftMargin: 10
        anchors.top: startTimeText.bottom
        anchors.topMargin: 10
        function updateTime() {
            if(!button.enabled)
            {
                //var hour = cleaning_schedule.getObjInt("hour");
                //var minute = cleaning_schedule.getObjInt("minute");

                var starttime = cleaning_schedule.getObjInt("starttime");
                var datetime = TimeScript.convertU32Date(starttime);

                var hour = datetime.getHours();
                var minute = datetime.getMinutes();
                var seconds = datetime.getSeconds();

                init(hour, minute);
            }
        }

        onHourSetting: {
            //cleaning_schedule.setObj("hour", hour);
            button.enabled = true;
        }

        onMinuteSetting: {
            //cleaning_schedule.setObj("minute", minute);
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
                //var year = cleaning_schedule.getObjInt("year");
                //var month = cleaning_schedule.getObjInt("month");
                //var day = cleaning_schedule.getObjInt("day");

                var starttime = cleaning_schedule.getObjInt("starttime");
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
            //cleaning_schedule.setObjs(items, values);
            //console.debug("QML::CalibSchedule onDateSetting")
            button.enabled = true;
        }
    }

    function setDateTime() {
        //cleaning_schedule.clearObjTList();
        //cleaning_schedule.addObjToTList("year", dateSetting.dtYear);
        //cleaning_schedule.addObjToTList("month", dateSetting.dtMonth);
        //cleaning_schedule.addObjToTList("day", dateSetting.dtDay);
        //cleaning_schedule.addObjToTList("hour", timeSetting.value[0]);
        //cleaning_schedule.addObjToTList("minute", timeSetting.value[1]);
        //cleaning_schedule.setObjTList();

        var timeT32 = TimeScript.convertTimeU32(dateSetting.dtYear, dateSetting.dtMonth, dateSetting.dtDay,
                                                timeSetting.value[0], timeSetting.value[1], 0);
        cleaning_schedule.setObj("starttime", "0x"+timeT32.toString(16));
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



