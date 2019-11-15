import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
//import QtQuick.Controls.Styles.Flat 1.0 as Flat
import "../content"
import "history"
import "../components"

Item {
    id: historyPage
    property string title: qsTr("Logs")+translator.tr

    width: 800
    height: 420 //parent.height
    objectName: "history page"
    property Item logSummary: LogSummary {}
    signal updateLogSummary(var row)

    Connections {
        target: log_query
        ignoreUnknownSignals: true
        onProbeSetObjDone: {
            console.debug("QML::SetObjDone log_query")
            updateLogModel();
        }
    }

    GridView {
        id: gridView
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 10
        width: parent.width - 80
        height: 40
        cellWidth: gridView.width / 4
        cellHeight: gridView.height

        model: ListModel {
            ListElement {
                name: "Measurements"
                url: "LogSummary.qml"
                index: 0
            }
            ListElement {
                name: "Calibrations"
                url: "QueryLog.qml"
                index: 1
            }
            ListElement {
                name: "Diagnosis"
                url: "LogSummary.qml"
                index: 2
            }
            ListElement {
                name: "Activities"
                url: "LogSummary.qml"
                index: 3
            }
        }

        delegate: H2oButton {
            width: 160
            height: 40
            text: name
            buttonColor: theme.lightBackgroundColor
            buttonBorderColor: theme.hachBlueColor
            buttonPressColor: theme.hachBlueColor
            buttonTextColor: theme.mainTextColor
            buttonTextPressColor: "white"
            buttonTextFont: theme.smallFont
            buttonRadius: 3
            //anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                var title;
                var titleUI;
                if (index == 0) {
                    logTable.model = logTable.measureModel;
                    title = ["mcudata.rtc", "mcudata.abs.l880", "mcudata.abs.s600", "mcudata.abs.l660", "mcudata.monitor.concentration", "mcudata.temperature.pt0", "mcudata.step.main0"];
                    titleUI = ["t", "a1", "a2", "a3", "conc", "temp", "st"];
                    updateLogModel(title, titleUI, -100, 8, logTable.measureModel);
                }
                else if (index == 1)
                {
                    logTable.model = logTable.calibModel;
                    title = ["mcudata.rtc", "mcudata.abs.l880", "mcudata.abs.s600", "mcudata.abs.l660", "mcudata.monitor.concentration", "mcudata.temperature.pt0", "mcudata.step.main0"];
                    titleUI = ["t", "a1", "a2", "a3", "conc", "temp", "st"];
                    updateLogModel(title, titleUI, 8, 8, logTable.calibModel);
                }
                else if (index == 2)
                {
                    logTable.model = logTable.diagnosisModel;
                    title = ["mcudata.rtc", "mcudata.abs.l880", "mcudata.abs.s600", "mcudata.abs.l660", "mcudata.monitor.concentration", "mcudata.temperature.pt0", "mcudata.step.main0"];
                    titleUI = ["t", "a1", "a2", "a3", "conc", "temp", "st"];
                    updateLogModel(title, titleUI, 16, 8, logTable.diagnosisModel);
                }
                else
                {
                    logTable.model = logTable.eventModel;
                    title = ["mcudata.rtc", "mcudata.abs.l880", "mcudata.abs.s600", "mcudata.abs.l660", "mcudata.monitor.concentration", "mcudata.temperature.pt0", "mcudata.step.main0"];
                    titleUI = ["t", "a1", "a2", "a3", "conc", "temp", "st"];
                    updateLogModel(title, titleUI, 24, 8, logTable.eventModel);
                }
            }
        }
    }

    H2oTableView {
        id: logTable
        width: parent.width - 40
        height: parent.height - gridView.height - exportButton.height - 40
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: gridView.bottom
        anchors.topMargin: 10

        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        highlightOnFocus: false
        headerVisible: true
        alternatingRowColors: false
        //backgroundVisible: false
        frameVisible: false
        headerBackgroundColor: theme.lightBackgroundColor
        headerTextFont: theme.tinyFont
        headerTextColor: theme.mainTextColor

        property alias measureModel: measureListModel
        property alias calibModel: calibListModel
        property alias diagnosisModel: diagnosisListModel
        property alias eventModel: eventListModel
        property int colNum: 7

        TableViewColumn {
            role: "t"
            title: "time"
            resizable: false
            movable: false
            //delegate: textDelegate
        }

        TableViewColumn {
            role: "a1"
            title: "abs 660L"
            resizable: false
            movable: false
            //delegate: textDelegate
        }

        TableViewColumn {
            role: "a2"
            title: "abs 880L"
            resizable: false
            movable: false
            //delegate: textDelegate
        }

        TableViewColumn {
            role: "a3"
            title: "abs 880s"
            resizable: false
            movable: false
        }

        TableViewColumn {
            role: "conc"
            title: "concentration"
            resizable: false
            movable: false
        }
        TableViewColumn {
            role: "temp"
            title: "temperature"
            resizable: false
            movable: false
        }
        TableViewColumn {
            role: "st"
            title: "status"
            resizable: false
            movable: false
        }

        model: measureListModel

        ListModel {
            id: measureListModel
            }

        ListModel {
            id: calibListModel
            }
        ListModel {
            id: diagnosisListModel

        }
        ListModel {
            id: eventListModel
            }

        onClicked: {
            mainStackView.push({item: logSummary, immediate: true});
            updateLogSummary(row);
            var title = ["mcudata.rtc", "mcudata.abs.l880", "mcudata.abs.s600", "mcudata.abs.l660", "mcudata.monitor.concentration", "mcudata.calibration.slope0", "mcudata.calibration.offset0", "mcudata.temperature.pt0", "mcudata.step.main0"];
            var param = {"title": title, "start": row, "count": 1, "type": "mcudata"};
            log_detail.setObj("read_data", param)
        }
    }

    function updateLogModel()
    {
        var result = log_query.getObjJsonValue("read_data");
        var table = result["table"];
        var titleUI = ["t", "a1", "a2", "a3", "conc", "temp", "st"];
        logTable.model.clear();
        for (var i = 0; i < table.length; i++) {
            var row = table[i];
            var rowObj = json_parse.createObject(titleUI, row);
            logTable.model.append(rowObj);
        }
    }

    Connections {
        target: log_export
        ignoreUnknownSignals: true
        onFinished: {
            console.debug("QML::log_export onFinished")
            mainBusyDialog.close();
        }
    }


    H2oButton {
        id: exportButton
        width: parent.width/2
        height: 60
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        text: "Export"
        buttonTextFont: theme.mediumFont
        buttonTextColor: theme.mainTextColor
        buttonColor: theme.mediumBackgroundColor
        buttonBorderColor: theme.mediumBackgroundColor

        onClicked: {
            if(log_export.isIdle()) {
                log_export.startProcess();
                mainBusyDialog.open("Export Log..., Please wait.")
            }
        }
    }
    H2oButton {
        id: filterButton
        width: parent.width/2
        height: 60
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        text: "Graphic/List View"
        buttonTextFont: theme.mediumFont
        //onClicked: mainStackView.push({item: Qt.resolvedUrl("history/QueryLog.qml")})

    }
}

