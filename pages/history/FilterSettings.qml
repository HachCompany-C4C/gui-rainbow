/****************************************************************************
** FilterSettings.qml - Log filter setting
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
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Styles.Flat 1.0 as Flat
import "../../components"

Rectangle {
    id: root
    width: 800
    height: 360
    property var parent_obj
    property var nameList: ["clear_data_filters"]
    property var valueList: [{}]

    property var periodList: [1, 7, 30, 90, -1]  //one day, one week, one month, three months, custom
    property var typeList: ["mculog.measure", "mcucalib", "mcudiag", "mcuevent", "appop"]
    property var setFilterTypeList: []
    property alias mainSetFilterTypeList: root.setFilterTypeList
    property int opType: 0 //0 - view, 1 - export

    Text {
        id: timeRangeTitle
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.top: parent.top
        anchors.topMargin: 10
        font: mainTheme.titleFont
        text: qsTr("Period")+translator.tr
    }

    ListView {
        id: periodListView
        anchors.left: timeRangeTitle.left
        anchors.leftMargin: 10
        anchors.top: timeRangeTitle.bottom
        anchors.topMargin: 10
        width: 300
        height: 195
        boundsBehavior: Flickable.StopAtBounds
        scale: 1
        cacheBuffer: 200
        contentHeight: 1144
        snapMode: ListView.SnapToItem
        flickableDirection: Flickable.VerticalFlick
        spacing: 5
        property int currentIndex: 0
        property var listName: [   qsTr("1 Day")+translator.tr,
                                   qsTr("1 Week")+translator.tr,
                                   qsTr("1 Month")+translator.tr,
                                   qsTr("3 Months")+translator.tr,
                                   qsTr("Customize")+translator.tr]
        ExclusiveGroup {
            id: tabGroup
        }

        model: ListModel {
            ListElement { name: "1 Day"; check: true; index: 0 }
            ListElement { name: "1 Week"; check: false; index: 1 }
            ListElement { name: "1 Month"; check: false; index: 2 }
            ListElement { name: "3 Months"; check: false; index: 3 }
            ListElement { name: "Customize"; check: false; index: 4 }
        }

        delegate: H2oLineRadioButton {
            text: periodListView.listName[index]
            checked: check
            exclusiveGroup: tabGroup
            onValueChanged: {
                periodListView.currentIndex = index;
            }
        }

        function updateIndex() {
            //periodListView.contentItem.children[modelIndex].checked = true;
        }
    }

    H2oDateSetting {
        id: startDay
        anchors.left: periodListView.left
        anchors.leftMargin: 0
        anchors.top: periodListView.bottom
        anchors.topMargin: 10
        width: 300
        enabled: periodListView.currentIndex == 4 ? true: false
        Component.onCompleted: {
            var datetime = new Date();
            dtYear = datetime.getFullYear();
            dtMonth = datetime.getMonth()+1;
            dtDay = datetime.getDate();
            init(dtYear, dtMonth, dtDay);
        }
    }
    H2oDateSetting {
        id: endDay
        anchors.horizontalCenter: startDay.horizontalCenter
        anchors.top: startDay.bottom
        anchors.topMargin: 10
        width: 300
        enabled: periodListView.currentIndex == 4 ? true: false
        Component.onCompleted: {
            var datetime = new Date();
            dtYear = datetime.getFullYear();
            dtMonth = datetime.getMonth()+1;
            dtDay = datetime.getDate();
            init(dtYear, dtMonth, dtDay);
        }
    }

    Rectangle {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        width: Flat.FlatStyle.onePixel
        color: Flat.FlatStyle.lightFrameColor
    }

    Text {
        id: typeTitle
        anchors.left: parent.left
        anchors.leftMargin: 430
        anchors.top: parent.top
        anchors.topMargin: 10
        font: mainTheme.titleFont
        width: 300
        height: 30
        text: qsTr("Type")+translator.tr
    }

    ListView {
        id: typeListView
        anchors.left: typeTitle.left
        anchors.leftMargin: 10
        anchors.top: typeTitle.bottom
        anchors.topMargin: 10
        width: 300
        height: 195
        boundsBehavior: Flickable.StopAtBounds
        scale: 1
        cacheBuffer: 200
        contentHeight: 1144
        snapMode: ListView.SnapToItem
        flickableDirection: Flickable.VerticalFlick
        spacing: 5
        property var listName: [
            qsTr("Measurement")+translator.tr,
            qsTr("Calibration")+translator.tr,
            qsTr("Diagnosis")+translator.tr,
            qsTr("Event")+translator.tr,
            qsTr("Operation")+translator.tr
        ]

        model: ListModel {
            id: typeModel
            ListElement { name: "Measurement"; check: false; index: 0 }
            ListElement { name: "Calibration"; check: false; index: 1 }
            ListElement { name: "Diagnosis"; check: false; index: 2 }
            ListElement { name: "Event"; check: false; index: 3 }
            ListElement { name: "Operation"; check: false; index: 4 }
        }

        delegate: H2oLineCheckBox {
            text: typeListView.listName[index]
            checked: check
        }
    }

    function daysInMonths(date, num)
    {
        var year = date.getFullYear();
        var month = date.getMonth();

        var days = 0;
        var daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        if(((year%4 == 0) && (year%100 != 0)) || (year%400==0))
            daysInMonth[1] = 29;
        else
            daysInMonth[1] = 28;

        for(var m = month; m < (month+num); m++)
        {
            var idx = m;
            if(m > 11) {
                idx = m - 12;
            }

            days += daysInMonth[idx];
        }

        return days;
    }

    function setFilter(page_obj) {
        var timeUTC;
        nameList = ["clear_data_filters"];
        valueList = [{}];
        // "start" - start time; "delta" - period
        var deltaDay = root.periodList[periodListView.currentIndex];
        if(deltaDay === 90) {
            deltaDay = daysInMonths(new Date, 3);
        } else if(deltaDay === 30) {
            deltaDay = daysInMonths(new Date, 1);
        }

        if(deltaDay === -1) {
            var endDate = new Date(endDay.dtYear, endDay.dtMonth-1, endDay.dtDay);
            var end = Math.floor(endDate.getTime()/(3600 * 24 * 1000));
            var startDate = new Date(startDay.dtYear, startDay.dtMonth-1, startDay.dtDay);
            var start = Math.floor(startDate.getTime()/(3600 * 24 * 1000));

            if((end - start) < 0)
            {
                mainMessageDialogOneButton.openDialog("reminder",
                                                      qsTr("The start date can't be greater than the end date."))
                return;
            }

            deltaDay = end - start + 1;
            // the deltaDay less than 6 months when setting filter for view list(opType == 0),
//            else if(deltaDay > daysInMonths(startDate, 6) && opType == 0)
//            {
//                mainMessageDialogOneButton.openDialog("reminder",
//                                                      qsTr("The interval between start date and end date can't be greater than 6 months."));
//                return;
//            }

            //console.debug("QML::QueryLog end:"+endDay.currentDate+" start:"+startDay.currentDate);
            //console.debug("QML::QueryLog deltaDay: "+deltaDay+"end:"+end+"start:"+start);
            timeUTC = endDay.dtYear+"-"+endDay.dtMonth+"-"+endDay.dtDay;
            //console.debug("QML::QueryLog timeUTC: "+timeUTC+" delta: "+deltaDay);
        } else {
            // get current time
            var datetime = new Date();
            var year = datetime.getFullYear();
            var month = datetime.getMonth()+1;
            var day = datetime.getDate();
            timeUTC = year+"-"+month+"-"+day;
        }

        setFilterTypeList = [];

        var isFilter = false;
        if(deltaDay > 0) {
            deltaDay = 0-deltaDay;
            if(typeListView.contentItem.children[0].checked) {
                var mculogParam = {"title": "mculog.measure.time", "start": timeUTC, "delta": deltaDay, "type": root.typeList[0]};
                nameList.push("mculog/set_data_range");
                valueList.push(mculogParam);
                mculogParam = {"title": "mculog.measure.update_flag", "value": "1", "type": root.typeList[0]};
                nameList.push("mculog/set_data_keyword");
                valueList.push(mculogParam);
                setFilterTypeList.push(root.typeList[0]);
                isFilter = true;
            }

            if(typeListView.contentItem.children[1].checked) {
                var mcucalibParam = {"title": "mcucalib.time", "start": timeUTC, "delta": deltaDay, "type": root.typeList[1]};
                nameList.push("mcucalib/set_data_range");
                valueList.push(mcucalibParam);
                mcucalibParam = {"title": "mcucalib.update_flag", "value": "1", "type": root.typeList[1]};
                nameList.push("mcucalib/set_data_keyword");
                valueList.push(mcucalibParam);
                setFilterTypeList.push(root.typeList[1]);
                isFilter = true;
            }

            if(typeListView.contentItem.children[2].checked) {
                var mcudiagParam = {"title": "mcudiag.time", "start": timeUTC, "delta": deltaDay, "type": root.typeList[2]};
                nameList.push("mcudiag/set_data_range");
                valueList.push(mcudiagParam);
                setFilterTypeList.push(root.typeList[2]);
                isFilter = true;
            }

            if(typeListView.contentItem.children[3].checked) {
                var mcueventParam = {"title": "mcuevent.time", "start": timeUTC, "delta": deltaDay, "type": root.typeList[3]};
                nameList.push("mcuevent/set_data_range");
                valueList.push(mcueventParam);
                setFilterTypeList.push(root.typeList[3]);
                isFilter = true;
            }

            if(typeListView.contentItem.children[4].checked) {
                var appopParam = {"title": "appop.time", "start": timeUTC, "delta": deltaDay, "type": root.typeList[4]};
                nameList.push("appop/set_data_range");
                valueList.push(appopParam);
                setFilterTypeList.push(root.typeList[4]);
                isFilter = true;
            }

            // set filter
            if(isFilter) {
                //page_manager.setTimerRunning(false);
                //probe_worker.stopWork();
                //startFilterTimer.start();
                parent_obj = page_obj;

                parent_obj.setObjsJson(nameList, valueList);
            } else {
                mainMessageDialogOneButton.openDialog("reminder",
                                                      qsTr("Please select log types."));
            }

            return isFilter;
        }
    }

    Timer {
        id: startFilterTimer
        interval: 3000
        repeat: false
        running: false
        triggeredOnStart: false

        onTriggered: {
            parent_obj.setObjsJson(nameList, valueList);
        }
    }
}
