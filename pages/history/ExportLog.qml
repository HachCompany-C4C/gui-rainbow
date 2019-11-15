/****************************************************************************
** ExportLog.qml - Export log
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
    objectName: "export_log"
    property string title: qsTr("Export Log")+translator.tr
    width: 800
    height: 420

    property string exportDrive: ""

    property var errDesc: [
        QT_TR_NOOP("Export logs failed."),
        QT_TR_NOOP("No enough disk space.")
    ]

    FilterSettings {
        id: filterSettings
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        opType: 1
        z: 1
    }

    Connections {
        target: log_filter2
        ignoreUnknownSignals: true
        onProbeSetObjsDone: {
            //console.debug("QML::QueryLog log_filter2")
            /*var title = ["*.time", "ID"];

            //console.debug("QML::QueryLog setFilterTypeList: "+filterSettings.setFilterTypeList)
            var param = {"title": title, "start": -1, "count": 20000, "type": filterSettings.setFilterTypeList, "orderby": "lambda x: datetime.datetime.strptime(x[1],'%Y-%m-%d %H:%M:%S')", "desc": true }; // x[0] - type; x[1] - time
            log_export.setObj("read_data", param);*/

            export_log.setSNBuff(system_info.getObjString("sn"));
            export_log.setTypeList(filterSettings.setFilterTypeList);
            export_log.startProcess();
        }
    }

    Connections {
        target: export_log
        ignoreUnknownSignals: true
        onFinished: {
            //console.debug("QML::LogView SetObjDone export_log onFinished")
            var err = export_log.error();
            if(err === "")
            {
                mainMessageDialogOneButton.text = qsTr("Export log done.");
            }
            else
            {
                mainMessageDialogOneButton.text = qsTr(err);
            }

            mainBusyDialog.close();
            mainMessageDialogOneButton.type = "reminder";
            mainMessageDialogOneButton.open();
            page_manager.setTimerRunning(true);
        }
    }

//    function updateLogModel()
//    {
//        var result = log_export.getObjJsonValue("read_data");

//        if(result !== null) {
//            var logMatrix = result["table"];

//            if(logMatrix.length > 0) {
//                var titleKey = ["type", "time", "summary"];

//                for (var i = 0; i < logMatrix.length; i++) {
//                    var row = logMatrix[i];
//                    var array;
//                    var summary;
//                    var temp = row[2];
//                    var logId = Number.fromLocaleString(Qt.locale(), temp);
//                    var logType = row[0];
//                    var j;
//                    switch(logType)
//                    {
//                    case "mcuevent":
//                        var title = mainLogDefinition.title(logType);
//                        var param = {"title": title, "start": logId, "count": 1, "type": [logType], "orderby": "lambda x: (datetime.datetime.strptime(x[1],'%Y-%m-%d %H:%M:%S'),x[3])", "desc": true };
//                        var detail = json_parse.execJson("read_data", param);

//                        /*for(var k = 0; k < row_2.length; k++)
//                        {
//                            if(row_2[k] === '|') {
//                                break;
//                            }
//                        }

//                        if(k === row_2.length) {
//                            summary = qsTr(row_2);
//                        } else {
//                            array = row_2.split('|')
//                            summary = "";
//                            for(j = 0; j < array.length; j++)
//                                summary += qsTr(array[j])+"; ";
//                        }*/
//                        break;
//                    case "mcudiag":
//                        array = row_2.split(' ');
//                        summary = "";
//                        for(j = 0; j < array.length; j++)
//                            summary += qsTr(array[j])+" ";
//                        break;
//                    case "mculog.measure":
//                    case "mcucalib":
//                        summary = row_2;
//                        break;

//                    }

//                }
//            }
//        }

//        mainBusyDialog.close();
//    }

//    function exportLogDetail() {
////        var title = [];
////        switch(mainDetailLogType) {
////        case "mculog.measure":
////            title = mainLogDefinition.mcuLogTitle;
////            break;
////        case "mcucalib":
////            title = mainLogDefinition.mcuCalibTitle;
////            break;
////        case "mcudiag":
////            title = mainLogDefinition.mcuDiagTitle;
////            break;
////        case "mcuevent":
////            title = mainLogDefinition.mcuEventTitle;
////            break;
////        }

//        var title = mainLogDefinition.title(mainDetailLogType);

//        var result = log_detail.getObjJsonValue("read_data");
//        var table = result["table"];

//        if(table !== null && table.length > 0) {
//            var rowData = table[0]; //this table only contains one log detail
//            //console.debug("QML::LogSummary rowData: "+rowData);
//            var array;
//            var j;
//            if(rowData !== null && rowData.length > 0) {
//                for (var i = 0; i < title.length; i++)
//                {
//                    var type = rowData[0];
//                    var row_i = rowData[i+1];
//                    var summary;
//                    switch(type)
//                    {
//                    case "mcudiag":
//                        if(title[i] === "mcudiag.summary" || title[i] === "mcudiag.type")
//                        {
//                            array = row_i.split(' ');
//                            summary = "";
//                            for(j = 0; j < array.length; j++)
//                                summary += qsTr(array[j])+" ";
//                        } else {
//                            summary = row_i;
//                        }

//                        break;
//                    case "mcuevent":
//                        if(title[i] === "mcuevent.summary" || title[i] === "mcucalib.summary") {

//                            for(var k = 0; k < row_i.length; k++)
//                            {
//                                if(row_i[k] === '|') {
//                                    break;
//                                }
//                            }

//                            if(k === row_i.length) {
//                                summary = qsTr(row_i);
//                            } else {
//                                array = row_i.split('|')
//                                summary = "";
//                                for(j = 0; j < array.length; j++)
//                                    summary += qsTr(array[j])+"; ";
//                            }
//                        } else {
//                            summary = row_i;
//                        }

//                        break;
//                    case "mculog.measure":
//                    case "mcucalib":
//                        summary = qsTr(row_i);
//                        break;
//                    }

//                    logSummaryModel.append({"item": qsTr(title[i]), "value": summary});
//                }
//            }
//        }
//    }

    H2oButton {
        id: exportButton

        width: parent.width
        height: 60
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        text: qsTr("EXPORT LOG")+translator.tr
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        buttonRadius: 0
        onClicked: {
            exportDrive = file_tool.getDrivePath();
            if(exportDrive !== "") {
                if(filterSettings.setFilter(log_filter2))
                {
                    mainBusyDialog.open(qsTr("Export..., this can take a few minutes.")+translator.tr)
                    page_manager.setTimerRunning(false);
                }
            } else {
                mainMessageDialogOneButton.type = "warning";
                mainMessageDialogOneButton.text = qsTr("Drive not exist.");
                mainMessageDialogOneButton.open();
            }
       }
    }

    /*Timer {
        id: exportTimer
        interval: 2000
        running: false
        repeat: true
        triggeredOnStart: false
        property bool inited: false
        onTriggered: {
            if(inited == false) {
                var param = {"type": filterSettings.setFilterTypeList, "folder": exportDrive};
                log_export.setObj("export_data", param);
                console.debug("QML::ExportLog onProbeSetObjsDone");
                inited = true;
            } else {
                log_export.setObj("export_progress", {});
            }
        }
    }

    Connections {
        target: log_export
        ignoreUnknownSignals: true
        onProbeSetObjsDone: {
            exportTimer.start();
        }

        onProbeSetObjDone: {
            var ack = log_export.getObjErr(objName);
            console.debug("QML::ExportLog objName: "+objName);

            if(ack !== 0) {
                mainBusyDialog.close();
                exportTimer.stop();
                if(objName == "export_data") {
                    var msg = log_export.getObjString("export_data");
                    mainMessageDialogOneButton.text = qsTr(msg);
                    mainMessageDialogOneButton.open();
                }
                console.debug("QML::ExportLog export_progress ack: "+ack);
            } else {
                if(objName == "export_progress") {
                    var progress = log_export.getObjInt("export_progress");
                    console.debug("QML::ExportLog export_progress progress: "+progress);
                    if(progress === 1) {
                        mainBusyDialog.close();
                        exportTimer.stop();
                        mainMessageDialogOneButton.text = qsTr("Export log done.");
                        mainMessageDialogOneButton.open();
                    }
                }
            }
        }
    }*/

    /*property var periodList: [0, 7, 30, 90, -1]  //one day, one week, one month, three months
    property var typeList: ["mculog.measure", "mcucalib", "mcudiag", "mcuevent"]
    property string exportDrive: ""

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
        target: log_export
        ignoreUnknownSignals: true
        onProbeSetObjsDone: {
            //console.debug("QML::Export start Export Logs")
            //log_export_worker.start();
            //var typeLst = [];
            //for(var i = 0; i < 4; i++) {
            //    if(typeListView.contentItem.children[i].checked) {
            //        typeLst.push(root.typeList[i]);
            //    }
            //}

            //var param = {"type": typeLst, "folder": exportDrive};
            //log_export.setObj("export_data", param);
            //mainBusyDialog.open(qsTr("Export..., this can take a few minutes.")+translator.tr)
            //exportTimer.start();
            exportTimer.start();
        }

        onProbeSetObjDone: {
            var ack = log_export.getObjErr(objName);
            console.debug("QML::ExportLog objName: "+objName);

            if(ack !== 0) {
                mainBusyDialog.close();
                exportTimer.stop();
                if(objName == "export_data") {
                    var msg = log_export.getObjString("export_data");
                    mainMessageDialogOneButton.text = qsTr(msg);
                    mainMessageDialogOneButton.open();
                } else {

                }

                console.debug("QML::ExportLog export_progress ack: "+ack);
            } else {
                if(objName == "export_progress") {
                    var progress = log_export.getObjInt("export_progress");
                    console.debug("QML::ExportLog export_progress progress: "+progress);
                    if(progress === 1) {
                        mainBusyDialog.close();
                        exportTimer.stop();
                        mainMessageDialogOneButton.text = qsTr("Export log done.");
                        mainMessageDialogOneButton.open();
                    }
                }
            }
        }
    }

    Timer {
        id: exportTimer
        interval: 2000
        running: false
        repeat: true
        triggeredOnStart: false
        onTriggered: {
            log_export.setObj("export_progress", {});
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

            //if(typeListView.contentItem.children[1].checked) {
            //    var mcucalibParam1 = {"title": "mcucalib.update_flag", "value": "1", "type": root.typeList[1]};
            //    nameList.push("mcucalib/set_data_keyword");
            //    valueList.push(mcucalibParam1);
            //    isFilter = true;
            //}

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

            console.debug("QML::Export start Export Logs")
            //log_export_worker.start();
            var typeLst = [];
            for(var i = 0; i < 4; i++) {
                if(typeListView.contentItem.children[i].checked) {
                    typeLst.push(root.typeList[i]);
                }
            }

            var param = {"type": typeLst, "folder": exportDrive};
            nameList.push("export_data");
            valueList.push(param);
            //log_export.setObj("export_data", param);
            //mainBusyDialog.open(qsTr("Export..., this can take a few minutes.")+translator.tr)
            //exportTimer.start();

            // set filter
            if(isFilter) {
                mainBusyDialog.open(qsTr("Export..., this can take a few minutes.")+translator.tr)
                //exportTimer.start();
                log_export.setObjsJson(nameList, valueList);
            }
        }
    }*/

    /*Connections {
        target: log_export_worker
        ignoreUnknownSignals: true
        onFinished: {
            console.debug("QML::log_export onFinished")
            mainBusyDialog.close();
        }
    }*/


}
