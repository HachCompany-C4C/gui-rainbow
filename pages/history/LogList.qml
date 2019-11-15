/****************************************************************************
** LogList.qml - Log list view
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

import QtQuick 2.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.2
import QtQuick.Controls.Styles.Flat 1.0 as Flat
import "../../content"
import "../../components"

Rectangle {
    id: logList
    objectName: "history page"
    property string title: qsTr("Logs View")+translator.tr
    property var detailLogType
    property alias mainDetailLogType: logList.detailLogType
    property Item graphicView: LogGraphic{}

    width: 800
    height: 420 //parent.height

    property Item logSummary: LogSummary {}
    signal updateLogSummary(var logId, var logType)
    property var logMatrix
    property int logCount: 0

    signal switchToGraphic();

    Connections {
        target: log_view
        ignoreUnknownSignals: true
        onProbeSetObjDone: {
            console.debug("QML::LogView SetObjDone log_query "+objName)
            updateLogModel();
            page_manager.setTimerRunning(true);
            mainBusyDialog.close();
        }
    }

    function viewLogDetail(row) {
        // goto detail veiw and read detail data
        mainStackView.push({item: logSummary, immediate: true});
        var rowArray = logMatrix[row];
        var len = rowArray.length;
        if(len > 0) {
            // get log Id
            var temp = rowArray[len-1];
            var logId = Number.fromLocaleString(Qt.locale(), temp);
            // get log type
            var logType = rowArray[0];
            // send signal
            updateLogSummary(logId, logType);
            console.debug("QML::LogView id:"+logId+" type:"+logType)

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
//            }

            var title = mainLogDefinition.title(logType);

            if(title.length > 0) {
                mainDetailLogType = logType;
                var param = {"title": title, "start": logId, "count": 1, "type": [logType], "orderby": "lambda x: x[1]", "desc": true };
                log_detail.setObj("read_data", param)
            }
        }
    }

    function updateLogModel()
    {
        scrollArea.flickableItem.contentY = 0;
        logTable.focusIndex = 0;
        //logTable.positionViewAtRow(0, ListView.Beginning);
        logTable.model.clear();
        var result = log_view.getObjJsonValue("read_data");

        var readingStat = true;

        if(result !== null)
        {
            logMatrix = result["table"];
            if(logMatrix !== null)
            {
                logCount = logMatrix.length;

                if(logCount > 10000)
                    logCount = 10000;

                if(logCount > 0)
                {
                    var titleKey = ["type", "time", "summary"];

                    for (var i = 0; i < logCount; i++) {
                        var row = logMatrix[i];
                        var array;
                        var summary;
                        var row_2 = row[2];
                        var j;
                        switch(row[0])
                        {
                        case "mcuevent":
//                            for(var k = 0; k < row_2.length; k++)
//                            {
//                                if(row_2[k] === '|') {
//                                    break;
//                                }
//                            }

//                            if(k === row_2.length) {
//                                summary = mainLogDefinition.translate(row_2);
//                            } else {
//                                array = row_2.split('|')
//                                summary = "";
//                                for(j = 0; j < array.length; j++)
//                                    summary += mainLogDefinition.translate(array[j])+" ";
//                            }
//                            break;
                        case "mcudiag":
                        case "mculog.measure":
                        case "mcucalib":
                        case "appop":
                            summary = mainLogDefinition.translate(row_2);
                            break;
                        }

                        logTable.model.append({"time": row[1], "type": mainLogDefinition.translate(row[0]), "summary": summary});
                    }

                    // The max number of logs which list shows is 10000
                    if(logMatrix.length > 10000) {
                        mainMessageDialogOneButton.type = "reminder";
                        var row_last = logMatrix[10000];
                        var minDate = row_last[1];
                        var row_first = logMatrix[0];
                        var maxDate = row_first[1];
                        mainMessageDialogOneButton.text = qsTr("The number of logs is out of scope. Only logs with timestamp")+" ("
                                                               +minDate+" ~ "
                                                               +maxDate
                                                               +") "+qsTr("are shown in list.");
                        mainMessageDialogOneButton.open();
                    }

                } else {
                    mainMessageDialogOneButton.openDialog("reminder", qsTr("No log exist."))
                }
            } else {
                readingStat = false;
            }
        } else {
            readingStat = false;
        }

        if(readingStat == false) {
            mainMessageDialogOneButton.openDialog("reminder", qsTr("Reading logs failed."))
        }
    }

    /*H2oTableView {
        id: logTable
        width: parent.width - 20
        height: parent.height - 20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
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
        selectionMode: SelectionMode.SingleSelection
        property alias measureModel: measureListModel
        property int colNum: 7
        property int logViewIndex: 0

        TableViewColumn {
            role: "time"
            title: qsTr("Time")+translator.tr
            resizable: false
            movable: false
            width: 200
            //delegate: textDelegate
        }

        TableViewColumn {
            role: "type"
            title: qsTr("Type")+translator.tr
            resizable: false
            movable: false
            width: 100
            //delegate: textDelegate
        }

        TableViewColumn {
            role: "summary"
            title: qsTr("Summary")+translator.tr
            resizable: false
            movable: false
            width: logTable.width - 300
            //delegate: textDelegate
        }

        model: ListModel {
            id: measureListModel
        }

        onClicked: {
            viewLogDetail(row);
        }

        // ScrollBar
        /*Rectangle {
            id: scrollBar
            width: 50
            height: parent.height
            anchors.right: parent.right
            anchors.top: parent.top
            color: "#f2f2f2"

            // descrease control
            Rectangle {
                id: descreaseCtrl
                width: parent.width
                height: 50
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                color: descreaseMouseArea.pressed ? "#9e9e9e" : "#e4e4e4"
                Text {
                    font.family: theme.bigIcon
                    font.pixelSize: 24
                    color: "#3ebdf2"
                    text: "\ue644"
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                MouseArea {
                    id: descreaseMouseArea
                    anchors.fill: parent
                    onClicked: {
                        //console.debug("QML::descrease Ctrl")
                        if(handler.value > handler.minimumValue)
                            handler.value--;
                    }
                }
            }

            // handler control
            Slider {
                id: handler
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: descreaseCtrl.bottom
                anchors.bottom: inscreaseCtrl.top
                orientation: Qt.Vertical
                rotation: 180
                maximumValue: 10
                minimumValue: 1
                stepSize: 1.0
                value: 0.0
                property bool initted: false

                onValueChanged: {
                    if(initted) {
                        console.debug("QML::LogView slider value:"+value);
                        logTable.logViewIndex+=8;
                        var startNo = value.toFixed(0);

                        var title = ["*.time", "*.summary", "ID"];
                        var param = {"title": title, "start": startNo, "count": 8, "type": mainSetFilterTypeList};
                        log_view.setObj("read_data", param);
                    } else {
                        initted = true;
                    }
                }

                style: SliderStyle {
                    groove: Rectangle {
                        implicitWidth: 200
                        implicitHeight: 50
                        color: "#f2f2f2"
                        //radius: 8
                    }
                    handle: Rectangle {
                        anchors.centerIn: parent
                        color: control.pressed ? "white" : "#e4e4e4"
                        //border.color: "gray"
                        //border.width: 1
                        implicitWidth: ((scrollBar.height - 100)/handler.maximumValue < 20) ? 20: (scrollBar.height - 100)/handler.maximumValue
                        implicitHeight: 40
                        //radius: 12
                    }
                }
            }

            // inscrease control
            Rectangle {
                id: inscreaseCtrl
                width: parent.width
                height: 50
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                color: inscreaseMouseArea.pressed ? "#9e9e9e" : "#e4e4e4"
                Text {
                    font.family: theme.bigIcon
                    font.pixelSize: 24
                    color: "#3ebdf2"
                    text: "\ue643"
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                MouseArea {
                    id: inscreaseMouseArea
                    anchors.fill: parent
                    onClicked: {
                        //console.debug("QML::inscrease Ctrl")
                        if(handler.value < handler.maximumValue)
                            handler.value++;
                    }
                }
            }
        }*/
    //}

    Rectangle {
        id: titleText
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        height: 25
        width: parent.width
        color: "transparent"
        z: 1
        Text {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 30
            text: qsTr("Time")+translator.tr
            font.pixelSize: 20
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 280
            text: qsTr("Type")+translator.tr
            font.pixelSize: 20
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 400
            text: qsTr("Summary")+translator.tr
            font.pixelSize: 20
        }
    }

    // scroll area
    ScrollView {
        id: scrollArea
        anchors.top: titleText.bottom
        anchors.topMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        height: 320
        width: 800-40
        frameVisible: false
        highlightOnFocus: true
        verticalScrollBarPolicy: Qt.ScrollBarAsNeeded

        ListView {
            id: logTable
            /*anchors.top: parent.top
            anchors.topMargin: titleText.height
            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.height - titleText.height
            width: parent.width*/
            property int focusIndex: 0

            model: ListModel {
                //ListElement { time: "2012-11-11"; type: "mculog"; summary: "summary" }
            }

            delegate: Rectangle {
                color: {
                    var color = (index % 2 == 0) ? "#d3d3d3" : "white"
                    if(logTable.focusIndex == index) {
                        color = "#3ebdf2";
                    }
                    return color;
                }
                width: 800-40
                height: 40
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    text: time
                    font: mainTheme.textFont
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 260
                    text: type
                    font: mainTheme.textFont
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 380
                    text: summary
                    font: mainTheme.textFont
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        viewLogDetail(index);
                        logTable.focusIndex = index;
                    }
                }
            }
        }

        style: ScrollViewStyle {
            frame:Rectangle {
                border{
                    //color: Flat.FlatStyle.lightFrameColor
                    color: "white"
                }
                //color: Flat.FlatStyle.lightFrameColor
                color: "white"
            }

            handle: Rectangle {
                implicitWidth: 40
                implicitHeight: 30
                color: styleData.pressed ? "#9e9e9e" : "#f2f2f2"
                border.width: Flat.FlatStyle.onePixel
                border.color: Flat.FlatStyle.lightFrameColor
                /*Rectangle {
                    color: styleData.pressed ? "#9e9e9e" : "#e4e4e4"
                    anchors.fill: parent
                    anchors.topMargin: 6
                    anchors.leftMargin: 4
                    anchors.rightMargin: 4
                    anchors.bottomMargin: 6
                    //border.width: 1
                    //border.color: "black"
                }*/
            }
            incrementControl: Rectangle {
                id: incrControl
                implicitWidth: 40
                implicitHeight: 80
                border.width: Flat.FlatStyle.onePixel
                border.color: Flat.FlatStyle.lightFrameColor

                Rectangle {
                    implicitWidth: 40
                    implicitHeight: 40
                    border.width: Flat.FlatStyle.onePixel
                    border.color: Flat.FlatStyle.lightFrameColor
                    color: styleData.pressed ? "#9e9e9e" : "#f2f2f2"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    Text {
                        font: mainTheme.mediumIcon
                        color: "#3ebdf2"
                        text: "\ue643"
                        anchors.centerIn: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                /*Rectangle {
                    implicitWidth: 40
                    implicitHeight: 40
                    border.width: Flat.FlatStyle.onePixel
                    border.color: Flat.FlatStyle.lightFrameColor
                    color: styleData.pressed ? "#9e9e9e" : "#f2f2f2"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    Text {
                        font: mainTheme.mediumIcon
                        color: "#3ebdf2"
                        text: "\ue643"
                        anchors.centerIn: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }*/
            }

            decrementControl: Rectangle {
                implicitWidth: 40
                implicitHeight: 80
                border.width: Flat.FlatStyle.onePixel
                border.color: Flat.FlatStyle.lightFrameColor
                /*Rectangle {
                    implicitWidth: 40
                    implicitHeight: 40
                    border.width: Flat.FlatStyle.onePixel
                    border.color: Flat.FlatStyle.lightFrameColor
                    color: styleData.pressed ? "#9e9e9e" : "#f2f2f2"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    Text {
                        font: mainTheme.mediumIcon
                        color: "#3ebdf2"
                        text: "\ue644"
                        anchors.centerIn: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }*/

                Rectangle {
                    implicitWidth: 40
                    implicitHeight: 40
                    border.width: Flat.FlatStyle.onePixel
                    border.color: Flat.FlatStyle.lightFrameColor
                    color: styleData.pressed ? "#9e9e9e" : "#f2f2f2"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    Text {
                        font: mainTheme.mediumIcon
                        color: "#3ebdf2"
                        text: "\ue644"
                        anchors.centerIn: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }

            scrollBarBackground: Rectangle {
                implicitWidth: 40
                implicitHeight: 26
                color: "#f2f2f2"
            }
        }
    }

    Rectangle {
        id: repiterIncrControl
        width: 40
        height: 40
        border.width: Flat.FlatStyle.onePixel
        border.color: Flat.FlatStyle.lightFrameColor
        color: repiterIncrMouseArea.pressed ? "#9e9e9e" : "#f2f2f2"
        anchors.right: scrollArea.right
        anchors.rightMargin: 1
        anchors.bottom: scrollArea.bottom
        anchors.bottomMargin: 1
        visible: logCount > 8 ? true : false
        Text {
            //font: mainTheme.mediumIcon
            font: Qt.font({family: noto.name, pixelSize: 20, bold: false})
            color: "#3ebdf2"
            text: "\ue643\n\ue643"
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            lineHeightMode: Text.ProportionalHeight
            lineHeight : 0.3
        }

        Timer {
            id: inctimer
            interval: 200
            repeat: true
            running: false
            triggeredOnStart: true
            onTriggered: {
                repiterIncrControl.incrValue();
            }
        }

        function incrValue() {
            var contY = scrollArea.flickableItem.contentY + scrollArea.height;
            if(contY < (logTable.model.rowCount() * 40))
            {
                scrollArea.flickableItem.contentY += scrollArea.height
            }
        }

        MouseArea {
            id: repiterIncrMouseArea
            anchors.fill: parent
            onClicked: {
                repiterIncrControl.incrValue();
            }

            onPressAndHold: {
                inctimer.start();
            }

            onReleased: {
                inctimer.stop();
            }
        }
    }

    Rectangle {
        id: repiterDecrControl
        width: 40
        height: 40
        border.width: Flat.FlatStyle.onePixel
        border.color: Flat.FlatStyle.lightFrameColor
        color: repiterDecrMouseArea.pressed ? "#9e9e9e" : "#f2f2f2"
        anchors.right: scrollArea.right
        anchors.rightMargin: 1
        anchors.top: scrollArea.top
        anchors.topMargin: 1
        visible: logCount > 8 ? true : false
        Text {
            //font: mainTheme.mediumIcon
            font: Qt.font({family: noto.name, pixelSize: 20, bold: false})
            color: "#3ebdf2"
            text: "\ue644\n\ue644"
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            lineHeightMode: Text.ProportionalHeight
            lineHeight : 0.3
        }

        Timer {
            id: dectimer
            interval: 200
            repeat: true
            running: false
            triggeredOnStart: true
            onTriggered: {
                repiterDecrControl.decValue();
            }
        }

        function decValue()
        {
            var contY = scrollArea.flickableItem.contentY;
            if(contY > scrollArea.height) {
                scrollArea.flickableItem.contentY -= scrollArea.height;
            } else {
                scrollArea.flickableItem.contentY = 0;
            }
        }

        MouseArea {
            id: repiterDecrMouseArea
            anchors.fill: parent
            onClicked: {
                repiterDecrControl.decValue();
            }

            onPressAndHold: {
                dectimer.start();
            }

            onReleased: {
                dectimer.stop();
            }
        }
    }

    H2oButton {
        id: graphicButton

        width: parent.width
        height: 60
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        text: qsTr("GRAPHIC")+translator.tr
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        buttonRadius: 0
        onClicked: {
            mainBusyDialog.open(qsTr("Generate graphic, please wait."))
            graphicTimer.start();
       }
    }

    Timer {
        id: graphicTimer
        interval: 200
        repeat: false
        running: false
        triggeredOnStart: false
        //property real persent:control.parent
        //property real persent: control.persent
        onTriggered: {
            switchToGraphic();
        }
    }

    /*function updateLogModel()
    {
        logTable.positionViewAtRow(0, ListView.Beginning);
        logTable.model.clear();
        var result = log_view.getObjJsonValue("read_data");

        if(result !== null) {
            logMatrix = result["table"];

            if(logMatrix.length > 0) {
                var titleKey = ["type", "time", "summary"];

                for (var i = 0; i < logMatrix.length; i++) {
                    var row = logMatrix[i];
                    var array;
                    var summary;
                    var row_2 = row[2];
                    var j;
                    switch(row[0])
                    {
                    case "mcuevent":
                        for(var k = 0; k < row_2.length; k++)
                        {
                            if(row_2[k] === '|') {
                                break;
                            }
                        }

                        if(k === row_2.length) {
                            summary = qsTr(row_2);
                        } else {
                            array = row_2.split('|')
                            summary = "";
                            for(j = 0; j < array.length; j++)
                                summary += qsTr(array[j])+"; ";
                        }
                        break;
                    case "mcudiag":
                        array = row_2.split(' ');
                        summary = "";
                        for(j = 0; j < array.length; j++)
                            summary += qsTr(array[j])+" ";
                        break;
                    case "mculog.measure":
                    case "mcucalib":
                        summary = row_2;
                        break;

                    }

                    logTable.model.append({"time": row[1], "type": qsTr(row[0]), "summary": summary});
                }
            }
        }

        mainBusyDialog.close();
    }*/
}

