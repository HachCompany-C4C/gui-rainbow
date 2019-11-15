/****************************************************************************
** QueryLog.qml - UI for querying log
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
    objectName: "query_log"
    property string title: qsTr("Filter Settings")+translator.tr
    property Item logView: LogList {}
    width: 800
    height: 420

    FilterSettings {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        id: filterSettings
        opType: 0
        z: 1
    }

    Connections {
        target: log_filter
        ignoreUnknownSignals: true
        onProbeSetObjsDone: {
            /*console.debug("QML::QueryLog log_filter ")
            //updateLogDetail();
            mainStackView.push({item: logView, immediate: true})
            var title = ["*.time", "*.summary", "ID"];

            console.debug("QML::QueryLog setFilterTypeList: "+filterSettings.setFilterTypeList)
            var param = {"title": title, "start": -1, "count": 20000, "type": filterSettings.setFilterTypeList, "orderby": "lambda x: (datetime.datetime.strptime(x[1],'%Y-%m-%d %H:%M:%S'),x[3])", "desc": true }; // x[0] - type; x[1] - time
            log_view.setObj("read_data", param);*/

            startReadTimer.start();
        }
    }

    Timer {
        id: startReadTimer
        interval: 1000
        repeat: false
        running: false
        triggeredOnStart: false

        onTriggered: {
            //console.debug("QML::QueryLog log_filter ")
            //updateLogDetail();
            mainStackView.push({item: logView, immediate: true})
            var title = ["*.time", "*.summary", "ID"];

            //console.debug("QML::QueryLog setFilterTypeList: "+filterSettings.setFilterTypeList)
            var param = {"title": title, "start": -1, "count": 10001, "type": filterSettings.setFilterTypeList, "orderby": "lambda x: (datetime.datetime.strptime(x[1],'%Y-%m-%d %H:%M:%S'),x[3])", "desc": true }; // x[0] - type; x[1] - time
            log_view.setObj("read_data", param);
        }
    }

    /*property var periodList: [0, 6, 30, 90, -1]  //one day, one week, one month, three months, custom
    property var typeList: ["mculog.measure", "mcucalib", "mcudiag", "mcuevent"]
    property var setFilterTypeList: []
    property alias mainSetFilterTypeList: root.setFilterTypeList

    Text {
        id: timeRangeTitle
        x: 36
        y: 14
        text: qsTr("Period")+translator.tr
        font.pointSize: 16
    }

    ListView {
        id: periodListView
        x: 36
        y: 44
        width: 300
        height: 195
        boundsBehavior: Flickable.StopAtBounds
        anchors.bottomMargin: 3
        anchors.topMargin: 0
        scale: 1
        anchors.rightMargin: 3
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
        x: 36
        y: 258
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
        x: 36
        y: 304
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
        x: 433
        y: 8
        width: 300
        height: 30
        text: qsTr("Type")+translator.tr
        font.pointSize: 16
    }

    ListView {
        id: typeListView
        x: 433
        y: 44
        width: 300
        height: 195
        boundsBehavior: Flickable.StopAtBounds
        anchors.bottomMargin: 3
        anchors.topMargin: 0
        scale: 1
        anchors.rightMargin: 3
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
        ]

        model: ListModel {
            id: typeModel
            ListElement { name: "Measurement"; check: false; index: 0 }
            ListElement { name: "Calibration"; check: false; index: 1 }
            ListElement { name: "Diagnosis"; check: false; index: 2 }
            ListElement { name: "Event"; check: false; index: 3 }
        }

        delegate: H2oLineCheckBox {
            text: typeListView.listName[index]
            checked: check
        }

        function updateIndex() {
            //listView.contentItem.children[modelIndex].checked = true;
        }
    }

    Connections {
        target: log_filter
        ignoreUnknownSignals: true
        onProbeSetObjsDone: {
            console.debug("QML::QueryLog log_filter ")
            //updateLogDetail();
            mainStackView.push({item: logView, immediate: true})
            var title = ["*.time", "*.summary", "ID"];
            // get type list
            var setTypeList = [];
            for(var i = 0; i < 4; i++) {
                var chck = typeListView.contentItem.children[i].checked
                if(chck) {
                     setTypeList.push(root.typeList[i]);
                }
                //console.debug("QML::QueryLog check: "+chck)
            }

            setFilterTypeList = setTypeList;
            console.debug("QML::QueryLog setFilterTypeList: "+setFilterTypeList)
            var param = {"title": title, "start": -1, "count": 20000, "type": setFilterTypeList, "orderby": "lambda x: datetime.datetime.strptime(x[1],'%Y-%m-%d %H:%M:%S')", "desc": true }; // x[0] - type; x[1] - time
            log_view.setObj("read_data", param);
        }
    }

    function setFilter() {
        var timeUTC;
        var nameList = ["clear_data_filters"];
        var valueList = [{}];
        // "start" - start time; "delta" - period
        var deltaDay = root.periodList[periodListView.currentIndex];
        if(deltaDay === -1) {
            var end = Math.floor(endDay.currentDate.getTime()/(3600 * 24 * 1000));
            var start = Math.floor(startDay.currentDate.getTime()/(3600 * 24 * 1000));
            deltaDay = end - start;
            //console.debug("QML::QueryLog end:"+endDay.currentDate+" start:"+startDay.currentDate);
            //console.debug("QML::QueryLog deltaDay: "+deltaDay+"end:"+end+"start:"+start);
            timeUTC = endDay.dtYear+"-"+endDay.dtMonth+"-"+endDay.dtDay;
            console.debug("QML::QueryLog timeUTC: "+timeUTC+" delta: "+deltaDay);
        } else {
            // get current time
            var datetime = new Date();
            var year = datetime.getFullYear();
            var month = datetime.getMonth()+1;
            var day = datetime.getDate();
            timeUTC = year+"-"+month+"-"+day;
        }

        var isFilter = false;
        if(deltaDay >= 0) {
            deltaDay = 0-deltaDay;
            if(typeListView.contentItem.children[0].checked) {
                var mculogParam = {"title": "mculog.measure.time", "start": timeUTC, "delta": deltaDay, "type": root.typeList[0]};
                nameList.push("mculog/set_data_range");
                valueList.push(mculogParam);
                mculogParam = {"title": "mculog.measure.update_flag", "value": "1", "type": root.typeList[0]};
                nameList.push("mculog/set_data_keyword");
                valueList.push(mculogParam);
                isFilter = true;
            }

            if(typeListView.contentItem.children[1].checked) {
                var mcucalibParam = {"title": "mcucalib.time", "start": timeUTC, "delta": deltaDay, "type": root.typeList[1]};
                nameList.push("mcucalib/set_data_range");
                valueList.push(mcucalibParam);
                mcucalibParam = {"title": "mcucalib.update_flag", "value": "1", "type": root.typeList[1]};
                nameList.push("mcucalib/set_data_keyword");
                valueList.push(mcucalibParam);
                isFilter = true;
            }

            if(typeListView.contentItem.children[2].checked) {
                var mcudiagParam = {"title": "mcudiag.time", "start": timeUTC, "delta": deltaDay, "type": root.typeList[2]};
                nameList.push("mcudiag/set_data_range");
                valueList.push(mcudiagParam);
                isFilter = true;
            }

            if(typeListView.contentItem.children[3].checked) {
                var mcueventParam = {"title": "mcuevent.time", "start": timeUTC, "delta": deltaDay, "type": root.typeList[3]};
                nameList.push("mcuevent/set_data_range");
                valueList.push(mcueventParam);
                isFilter = true;
            }

            // set filter
            if(isFilter) {
                log_filter.setObjsJson(nameList, valueList);
                mainBusyDialog.open(qsTr("Log Filtering..."));
            }
        }
    }*/

    H2oButton {
        id: applyButton

        width: parent.width
        height: 60
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        text: qsTr("APPLY CHANGES")+translator.tr
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        buttonRadius: 0

        onClicked: {
            // set filter range
            //root.setFilter();
            if(filterSettings.setFilter(log_filter)) {
                page_manager.setTimerRunning(false);
                mainBusyDialog.open(qsTr("Log Filtering..."));
            }
       }
    }
}


/*
            // get type list
            for(var i = 0; i < typeList.length; i++) {
                var chck = typeModel.get(i).check;
                if(chck) {
                    var rangeParam = {"title": "*.time", "start": timeUTC, "delta": root.periodList[typeListView.currentIndex], "type": root.typeList[i]};
                    json_parse.execJson("set_data_range", rangeParam);
                }
            }

  //log_filter.setObjsJson(["clear_data_filters"], [{}]);

            // "set_data_keyword" parameter
            //var keywordParam = {"title": "ID", "value": keyword }

            //var countParam = {"target": "all", "type": root.typeList[0]}

json_parse.execJson("clear_data_filters", {});
json_parse.execJson("set_data_range", rangeParam);

for(var i = 0; i < 5; i++)
{
    var chck = typeCheckModel.get(i).check;
    if(chck) {
        var kwParam = {"title": "ID", "value": i}
        json_parse.execJson("set_data_keyword", kwParam);
    }
}

var kwParam = {"title": "ID", "value": ["1", "2"] }
json_parse.execJson("set_data_keyword", kwParam);

mainStackView.push({item: logView, immediate: true})
var title = ["mcudata.rtc", "mcudata.abs.l880", "mcudata.abs.s600", "mcudata.abs.l660", "mcudata.monitor.concentration", "mcudata.temperature.pt0", "mcudata.step.main0", "ID"];
var dataParam = {"title": title, "start": 0, "count": 8, "type": "mcudata"};
log_view.setObj("read_data", dataParam);*/
