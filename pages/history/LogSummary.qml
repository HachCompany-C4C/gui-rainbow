/****************************************************************************
** LogSummary.qml - Log summary view
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

import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.1
import "../../components"

Rectangle {
    objectName: "log_detail"
    property string title: qsTr("Log Detail")+translator.tr
    width: 800
    height: 420

    Connections {
        target: log_detail
        ignoreUnknownSignals: true
        onProbeSetObjDone: {
            //console.debug("QML::LogSummary SetObjDone log_detail")
            updateLogDetail();
        }
    }

    function updateLogDetail() {
        tableView.positionViewAtRow(0, ListView.Beginning)
//        var title = [];
//        switch(mainDetailLogType) {
//        case "mculog.measure":
//            title = mainLogDefinition.mcuLogTitle;
//            break;
//        case "mcucalib":
//            title = mainLogDefinition.mcuCalibTitle;
//            break;
//        case "mcudiag":
//            title = mainLogDefinition.mcuDiagTitle;
//            break;
//        case "mcuevent":
//            title = mainLogDefinition.mcuEventTitle;
//            break;
//        }

        var title = mainLogDefinition.title(mainDetailLogType);
        console.debug("log title: "+title);
        logSummaryModel.clear();
        var result = log_detail.getObjJsonValue("read_data");
        var table = result["table"];

        if(table !== null && table.length > 0) {
            var rowData = table[0]; //this table only contains one log detail
            //console.debug("QML::LogSummary rowData: "+rowData);
            var array;
            var j;
            if(rowData !== null && rowData.length > 0) {
                for (var i = 0; i < title.length; i++)
                {
                    var type = rowData[0];
                    var row_i = rowData[i+1];
                    var summary;
                    switch(type)
                    {

                    case "mcuevent":
                    case "mculog.measure":
                    case "mcucalib":
                    case "appop":
                        summary = mainLogDefinition.translate(row_i);
                        logSummaryModel.append({"item": mainLogDefinition.translate(title[i]), "value": summary});
                        break;
                    case "mcudiag":
                        if(i == (title.length-1)) //detail
                        {
                            var bkList = row_i.split(' ');
                            for(var j = 0; j<(bkList.length/6+1); j++) {
                                summary = mainLogDefinition.translate(row_i, j*6, (j+1)*6);
                                var ttl = j == 0 ? mainLogDefinition.translate(title[i]) : "";
                                if(summary !== "") {
                                    logSummaryModel.append({"item": ttl, "value": summary});
                                }
                            }
                        } else {
                            summary = mainLogDefinition.translate(row_i);
                            logSummaryModel.append({"item": mainLogDefinition.translate(title[i]), "value": summary});
                        }
                        break;
                    }
                }
            }
        }
    }

//    function viewLogDetail(row) {
//        // goto detail veiw and read detail data
//        var rowArray = logMatrix[row];
//        var len = rowArray.length;
//        if(len > 0) {
//            // get log Id
//            var temp = rowArray[len-1];
//            var logId = Number.fromLocaleString(Qt.locale(), temp);
//            // get log type
//            var logType = rowArray[0];
//            // send signal
//            updateLogSummary(logId, logType);
//            //console.debug("QML::LogView id:"+logId+" type:"+logType)

//            var title = [];
//            switch(logType){
//            case "mculog.measure":
//                title = mainLogDefinition.mcuLogTitle;
//                break;
//            case "mcucalib":
//                title = mainLogDefinition.mcuCalibTitle;
//                break;
//            case "mcudiag":
//                title = mainLogDefinition.mcuDiagTitle;
//                break;
//            case "mcuevent":
//                title = mainLogDefinition.mcuEventTitle;
//                break;
//            case "appop":
//                title = mainLogDefinition.mcuEventTitle;
//                break;
//            }

//            console.debug("QML::Summery:"+title)

//            if(title.length > 0) {
//                mainDetailLogType = logType;
//                var param = {"title": title, "start": logId, "count": 1, "type": [logType], "orderby": "lambda x: x[1]", "desc": true };
//                log_detail.setObj("read_data", param)
//            }
//        }
//    }

    H2oTableView {
        id: tableView
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        width: parent.width - 40

        verticalScrollBarPolicy: 0
        highlightOnFocus: false
        headerVisible: true
        alternatingRowColors: false
        //backgroundVisible: false
        frameVisible: false

        TableViewColumn {
            role: "item"
            title: qsTr("Item")+translator.tr
            width: tableView.width/3
            resizable: false
            movable: false
            //delegate: textDelegate

        }
        TableViewColumn {
            role: "value"
            title: qsTr("Value")+translator.tr
            width: tableView.width*2/3
            resizable: false
            movable: false
            //delegate: textDelegate
        }

        model: ListModel {
            id: logSummaryModel
        }
    }
}

