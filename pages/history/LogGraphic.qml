/****************************************************************************
** LogGraphic.qml - Log graphic
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
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.2
import QtQuick.Controls.Styles.Flat 1.0 as Flat
import "../../content"
import "../../components"
import "../../content/time.js" as TimeScript

//Item {}
import QtCharts 2.0

Rectangle {


    id: logGraphic
    objectName: "log graphic"
    property string title: qsTr("Log Graphic")+translator.tr
    width: 800
    height: 360
    property var maxTime
    property var minTime
    property var maxMeasValue
    property var minMeasValue

    property var maxAxisTime
    property var minAxisTime
    property var maxAxisMeasValue
    property var minAxisMeasValue

    property int markerSize: 8
    property color measSplineSeriesColor: measScatterSeriesColor
    property color measScatterSeriesColor: "#0098db"
    property color eventScatterSeriesColor: "#ffb446"
    property color calibScatterSeriesColor: "#71C671"
    property color diagScatterSeriesColor: "#ee5353"
    property color operationScatterSeriesColor: "#80b4ff"
    property color markerBorderColor: "#9e9e9e"
    property int markerBorderWidth: 1
    property int measLineWidth: 3
    property var logTable
    property real scrollStep: 20
    property real zoomStep: 0.2

    /*Connections {
        target: tabView
        ignoreUnknownSignals: true
        onTabToGraphicView: {
            console.debug("QML::LogGraphic update model")
            updateMeasSeries();
        }
    }*/

    /*onMarkerSizeChanged: {
        console.debug("QML::LogGraphic MarkerSize changed")
    }*/

    Connections {
        target: logList
        ignoreUnknownSignals: true
        onSwitchToGraphic: {
            //console.debug("QML::LogGraphic update model")
            updateMeasSeries();
        }
    }

    property int mx
    property int my
    property bool mpressed: false
    property int mmovestep: 10


    ChartView {
        id: chartView
        width: 820
        height: 390
        //title: "Ammonium NH3-N (Concentration-Time)"
        //anchors.verticalCenter: parent.verticalCenter
        anchors.top: parent.top
        anchors.topMargin: 30
        anchors.horizontalCenter: parent.horizontalCenter
        legend.visible: false
        legend.alignment: Qt.AlignBottom
        antialiasing: true
        theme: ChartView.ChartThemeLight

        /*MouseArea {
            id: mouseArea
            anchors.fill: chartView
            visible: logGraphic.markerSize == 8 ? true : false
            onPressed: {
                mx = mouseX
                my = mouseY
                mpressed = true
            }

            onReleased: {
                mpressed = false
            }

            onMouseXChanged: {
                if(mpressed) {
                    if(mouseX - mx > mmovestep) {
                        chartView.scrollLeft(mouseX-mx);
                        eventAxisY.max = 100
                        eventAxisY.min = 0
                        mx = mouseX
                    } else if(mx - mouseX > mmovestep) {
                        chartView.scrollRight(mx-mouseX);
                        eventAxisY.max = 100
                        eventAxisY.min = 0
                        mx = mouseX
                    }

                }
            }

            onMouseYChanged: {
                if(mpressed) {
                    if(mouseY - my > mmovestep) {
                        chartView.scrollUp(mouseY - my);
                        eventAxisY.max = 100
                        eventAxisY.min = 0
                        my = mouseY
                    } else if(my - mouseY > mmovestep) {
                        chartView.scrollDown(my - mouseY);
                        eventAxisY.max = 100
                        eventAxisY.min = 0
                        my = mouseY
                    }

                }
            }
        }*/

        DateTimeAxis {
            id: timeAxisX1
            format: "hh:mm:ss"
            tickCount: 7
            labelsAngle: 0
            color: "transparent"
            labelsFont.pixelSize: 12
        }

        DateTimeAxis {
            id: timeAxisX2
            format: "yyyy-MM-dd"
            tickCount: 7
            labelsAngle: 0
            //color: "#002366"
            color: "transparent"
            labelsFont.pixelSize: 12
        }

        ValueAxis {
            id: valueAxisY
            tickCount: 5
            labelsFont.pixelSize: 12
            labelFormat: "%.3f"
            titleText: "(mg/L)"
        }

        ValueAxis {
            id: eventAxisY
            tickCount: 5
            visible: false
            max: 100
            min: 0
        }

        // Event Data
        ScatterSeries {
            id: eventScatterSeries
            name: qsTr("event")+translator.tr
            axisX: timeAxisX1
            axisY: eventAxisY
            borderColor: markerBorderColor
            borderWidth: markerBorderWidth
            color: eventScatterSeriesColor
            markerShape: ScatterSeries.MarkerShapeRectangle
            markerSize: logGraphic.markerSize

            onClicked: {
                //console.debug("QML::Event Serials"+point.x+" "+point.y)

                chartView.updateScatterSummery(point.x, point.y, 87.5, qsTr("Event"));
            }
        }

        // Diag Data
        ScatterSeries {
            id: diagScatterSeries
            name: qsTr("diagnosis")+translator.tr
            axisX: timeAxisX1
            axisY: eventAxisY
            borderColor: markerBorderColor
            borderWidth: markerBorderWidth
            color: diagScatterSeriesColor
            markerShape: ScatterSeries.MarkerShapeRectangle
            markerSize: logGraphic.markerSize

            onClicked: {
                //console.debug("QML::Diag Serials"+point.x+" "+point.y)

                chartView.updateScatterSummery(point.x, point.y, 62.5, qsTr("Diagnosis"));
            }
        }

        // Calib Data
        ScatterSeries {
            id: calibScatterSeries
            name: qsTr("calibration")+translator.tr
            axisX: timeAxisX1
            axisY: eventAxisY
            borderColor: markerBorderColor
            borderWidth: markerBorderWidth
            color: calibScatterSeriesColor
            markerShape: ScatterSeries.MarkerShapeRectangle
            markerSize: logGraphic.markerSize

            onClicked: {
                //console.debug("QML::Calib Serials"+point.x+" "+point.y)

                chartView.updateScatterSummery(point.x, point.y, 37.5, qsTr("Calibration"));
            }
        }

        // Operation Data
        ScatterSeries {
            id: operationScatterSeries
            name: qsTr("operation")+translator.tr
            axisX: timeAxisX1
            axisY: eventAxisY
            borderColor: markerBorderColor
            borderWidth: markerBorderWidth
            color: operationScatterSeriesColor
            markerShape: ScatterSeries.MarkerShapeRectangle
            markerSize: logGraphic.markerSize

            onClicked: {
                console.debug("QML::operation Serials"+point.x+" "+point.y)

                chartView.updateScatterSummery(point.x, point.y, 12.5, qsTr("Operation"));
            }
        }

        //SplineSeries {
        LineSeries {
            id: measLineSeries
            axisX: timeAxisX2
            axisY: valueAxisY
            color: measSplineSeriesColor
            visible: true
            width: measLineWidth
        }

        // Measure Data
        ScatterSeries {
            id: measScatterSeries
            name: qsTr("Measure")+translator.tr
            axisX: timeAxisX1
            axisY: valueAxisY
            color: measScatterSeriesColor
            borderColor: markerBorderColor
            borderWidth: markerBorderWidth
            markerShape: ScatterSeries.MarkerShapeCircle
            markerSize: logGraphic.markerSize

            onClicked: {
                console.debug("QML::Measure Serials"+point.x+" "+point.y)
                var date = TimeScript.secsSinceEpochToDate(point.x/1000);
                var dateString = TimeScript.dateToTimeString(date);
                sumeryText.text = dateString + " " + qsTr("Measure ")+point.y + "mg/L";
            }
        }

        function updateScatterSummery(x, y, yaxis, typeStr) {
            var date = TimeScript.secsSinceEpochToDate(x/1000);
            var dateString = TimeScript.dateToTimeString(date);
            var rowCnt = (y - yaxis)*10000;
            var intCnt = rowCnt.toFixed(0);
            //console.debug("QML::LogGraphic intCnt="+intCnt)
            var rowContent = logTable[intCnt];
            var summeryText = rowContent[2];

            sumeryText.text = dateString+" "+typeStr+" "+mainLogDefinition.translate(summeryText);
        }
    }

    RangeSlider {
        id: timeSlider
        anchors.right: parent.right
        anchors.rightMargin: 45
        anchors.top: parent.top
        width: 685
        from: (minAxisTime == undefined) ? 0 : minAxisTime
        to: (maxAxisTime == undefined) ? 1000 : maxAxisTime
        first.value: (minAxisTime == undefined) ? 0 : minAxisTime
        second.value: (maxAxisTime == undefined) ? 0 : maxAxisTime
        stepSize: (second.value - first.value) / 20

        first.onValueChanged: {
            timeAxisX1.min = TimeScript.secsSinceEpochToDate(first.value);
            timeAxisX2.min = TimeScript.secsSinceEpochToDate(first.value);
            updateMeasValueAxis(first.value, second.value);
            arrowsPannel.enabled = true;
        }

        second.onValueChanged: {
            timeAxisX1.max = TimeScript.secsSinceEpochToDate(second.value);
            timeAxisX2.max = TimeScript.secsSinceEpochToDate(second.value);
            updateMeasValueAxis(first.value, second.value);
            arrowsPannel.enabled = true;
        }

        Repeater {
            model: 7
            delegate: Rectangle {
                x: 6+(timeSlider.width-12)/6*index
                anchors.verticalCenter: timeSlider.verticalCenter
                anchors.verticalCenterOffset: 6
                width: 1
                height: 5
                z: -1
                color: Flat.FlatStyle.lightFrameColor
                Text {
                    anchors.top: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 12
                    color: Flat.FlatStyle.defaultTextColor
                    text: {
                        var sec = timeSlider.from+(timeSlider.to - timeSlider.from)/6*index;
                        sec = sec.toFixed(0);
                        var date = TimeScript.secsSinceEpochToDate(sec);
                        var datestr = TimeScript.dateToTimeString(date);
                        var datestrs = datestr.split(" ");
                        return datestrs[0]+"\n  "+datestrs[1];
                    }
                }
            }
        }
    }

    Rectangle {
        id: summery
        width: 350
        height: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 40
        color: "transparent"
        visible: logGraphic.markerSize == 32 ? true : false

        Text {
            id: sumeryText
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            color: "black"
            font.pixelSize: 12
        }
    }

    Rectangle {
        id: legend
        width: 400
        height: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        anchors.right: parent.right

        Repeater {
            model: ListModel {
                ListElement { esize: 10; eradius: 5; ex: 0; ecolor: "#0098db"; name: QT_TR_NOOP("measure") }
                ListElement { esize: 10; eradius: 0; ex: 80; ecolor: "#ffb446"; name: QT_TR_NOOP("event") }
                ListElement { esize: 10; eradius: 0; ex: 240; ecolor: "#ee5353"; name: QT_TR_NOOP("diagnosis") }
                ListElement { esize: 10; eradius: 0; ex: 160; ecolor: "#71C671"; name: QT_TR_NOOP("calibration") }
                ListElement { esize: 10; eradius: 0; ex: 320; ecolor: "#80b4ff"; name: QT_TR_NOOP("operation") }
            }

            delegate: Rectangle {
                Rectangle {
                    id: sharp
                    anchors.verticalCenter: parent.verticalCenter
                    width: esize
                    height: esize
                    radius: eradius
                    color: ecolor
                    x: ex
                    border.width: markerBorderWidth
                    border.color: markerBorderColor
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: sharp.right
                    anchors.leftMargin: 5
                    text: qsTr(name) + translator.tr
                    font.pixelSize: 12
                }
            }
        }
    }

    H2oArrowsPannel {
        id: arrowsPannel
        anchors.top: parent.top
        anchors.topMargin: 70
        anchors.right: parent.right
        anchors.rightMargin: 10
        vValue: 0
        vDelta: 10
        hValue: 0
        hDelta: 10
        upArrowText: "\ue644"
        downArrowText: "\ue643"
        leftArrowText: "\uf053"
        rightArrowText: "\uf054"

        onVValueIncreased: {
            chartView.scrollUp(logGraphic.scrollStep);
            eventAxisY.max = 100
            eventAxisY.min = 0
        }

        onVValueDecreased: {
            chartView.scrollDown(logGraphic.scrollStep);
            eventAxisY.max = 100
            eventAxisY.min = 0
        }

        onHValueIncreased: {
            //chartView.scrollRight(logGraphic.scrollStep);
            //eventAxisY.max = 100
            //eventAxisY.min = 0
            arrowsPannel.enabled = false;
            timeSlider.first.increase();
            timeSlider.second.increase();
        }

        onHValueDecreased: {
            //chartView.scrollLeft(logGraphic.scrollStep);
            //eventAxisY.max = 100
            //eventAxisY.min = 0
            arrowsPannel.enabled = false;
            timeSlider.first.decrease();
            timeSlider.second.decrease();
        }

        onValueReset: {
            chartView.zoomReset();

            //timeAxisX1.max = TimeScript.secsSinceEpochToDate(maxAxisTime);
            //timeAxisX1.min = TimeScript.secsSinceEpochToDate(minAxisTime);
            //timeAxisX2.max = TimeScript.secsSinceEpochToDate(maxAxisTime);
            //timeAxisX2.min = TimeScript.secsSinceEpochToDate(minAxisTime);
            valueAxisY.max = maxAxisMeasValue;
            valueAxisY.min = minAxisMeasValue;

            timeSlider.first.value = minAxisTime;
            timeSlider.second.value = maxAxisTime;

            markerSizeSwitch.status = false;
        }
    }

    H2oSpinBox {
        id: vScale
        anchors.verticalCenter: arrowsPannel.verticalCenter
        anchors.horizontalCenter: arrowsPannel.horizontalCenter
        anchors.verticalCenterOffset: 180
        delta: 10
        textWidth: 0
        value: 0
        onValueChanged: {
            if(vScale.value <= 0) {
                vScale.value = 0;
            }
        }

        onValueIncreased: {
            //var vmax = valueAxisY.max;
            //var vmin = valueAxisY.min;
            chartView.zoom(1+logGraphic.zoomStep)
            eventAxisY.max = 100
            eventAxisY.min = 0
            //valueAxisY.max = vmax;
            //valueAxisY.min = vmin;
        }

        onValueDecreased: {
            //var vmax = valueAxisY.max;
            //var vmin = valueAxisY.min;
            chartView.zoom(1-logGraphic.zoomStep)
            eventAxisY.max = 100
            eventAxisY.min = 0
            //valueAxisY.max = vmax;
            //valueAxisY.min = vmin;
        }
    }

    H2oRegSwitch {
        id: markerSizeSwitch
        anchors.verticalCenter: arrowsPannel.verticalCenter
        anchors.horizontalCenter: arrowsPannel.horizontalCenter
        anchors.verticalCenterOffset: 100
        onStatusChanged: {
            logGraphic.markerSize = status ? 32 : 8
        }
    }

    H2oRegSwitch {
        id: buttonSwitch
        anchors.verticalCenter: markerSizeSwitch.verticalCenter
        anchors.horizontalCenter: markerSizeSwitch.horizontalCenter
        anchors.horizontalCenterOffset: 40
        status: true
        text: status ? "H" : "S"
        opacity: pressed ? 1.0 : 0.4
        onStatusChanged: {
            arrowsPannel.visible = status ? true : false;
            vScale.visible = status ? true : false;
            markerSizeSwitch.visible = status ? true : false;
        }
    }

    /*H2oArrowsPannel {
        //resetButtonVisable: false
        anchors.verticalCenter: markerSizeSwitch.verticalCenter
        anchors.horizontalCenter: markerSizeSwitch.horizontalCenter
        anchors.verticalCenterOffset: 100
        vValue: 0
        vDelta: 10
        hValue: 0
        hDelta: 10
        upArrowText: "+"
        downArrowText: "-"
        leftArrowText: "-"
        rightArrowText: "+"

        onVValueIncreased: {
            var vmax = timeAxisX1.max;
            var vmin = timeAxisX1.min;
            chartView.zoom(1+logGraphic.zoomStep)
            eventAxisY.max = 100
            eventAxisY.min = 0
            timeAxisX1.max = vmax;
            timeAxisX1.min = vmin;
        }

        onVValueDecreased: {
            var vmax = timeAxisX1.max;
            var vmin = timeAxisX1.min;
            chartView.zoom(1-logGraphic.zoomStep)
            eventAxisY.max = 100
            eventAxisY.min = 0
            timeAxisX1.max = vmax;
            timeAxisX1.min = vmin;
        }

        onHValueIncreased: {
            var vmax = valueAxisY.max;
            var vmin = valueAxisY.min;
            chartView.zoom(1+logGraphic.zoomStep)
            eventAxisY.max = 100
            eventAxisY.min = 0
            valueAxisY.max = vmax;
            valueAxisY.min = vmin;
        }

        onHValueDecreased: {
            var vmax = valueAxisY.max;
            var vmin = valueAxisY.min;
            chartView.zoom(1-logGraphic.zoomStep)
            eventAxisY.max = 100
            eventAxisY.min = 0
            valueAxisY.max = vmax;
            valueAxisY.min = vmin;
        }

        onValueReset: {
            chartView.zoomIn(Qt.rect(zoomRect.x+15, zoomRect.y-45, zoomRect.width, zoomRect.height))
            zoomRect.x = (chartView.width - zoomRect.width)/2 + 15
            zoomRect.y = (chartView.height - zoomRect.height)/2 - 25

            markerSizeSwitch.status = false;
        }
    }*/

    /*Rectangle {
        id: zoomRect
        x: 150
        y:150
        width: 150
        height: 100
        border.color: "black"
        border.width: 1
        color: "transparent"

        MouseArea {
            id: mouseArea
            anchors.fill: zoomRect
            visible: logGraphic.markerSize == 8 ? true : false
            drag.target: zoomRect
            drag.minimumX: 0
            drag.maximumX: chartView.width - zoomRect.width
        }
    }*/


    function getMeasVal(summery)
    {
        var ret = 0;
        var value = summery.split(' ');

        if(value.length === 2) {
            // console.debug("meas:"+summery);
            var value0 = value[0];
            if(value0.length > 0) {
                if(value0[0] === '>') {
                    ret = 1200.0;
                } else {
                    ret = Number.fromLocaleString(Qt.locale(), value[0]);
                    if(ret > 1200) {
                        ret = 1200.0;
                    } else if(ret < 0){
                        ret = 0.001;
                    }
                }
            }
        }

        return ret;
    }

    function updateMeasSeries()
    {
        var logMaxLength = 3000;
        var logOutofLength = false;
        sumeryText.text = "";
        markerSizeSwitch.status = false;
        measScatterSeries.clear();
        measLineSeries.clear();
        eventScatterSeries.clear();
        diagScatterSeries.clear();
        calibScatterSeries.clear();

        var result = log_view.getObjJsonValue("read_data");
        maxMeasValue = 0.0;
        minMeasValue = 0.0;

        if(result !== null) {
            logTable = result["table"];
            // Limit the max number of logs
            if(logTable.length > logMaxLength) {
                logOutofLength = true;
            } else {
                logMaxLength = logTable.length;
            }

            if(logMaxLength > 0) {
                var firstMeasLog = true;
                var x, y;
                var row = logTable[0]

                maxTime = TimeScript.strTimeToSecsSinceEpoch(row[1]);
                minTime = TimeScript.strTimeToSecsSinceEpoch(row[1]);

                var titleKey = ["type", "time", "summary"];

                for (var i = 0; i < logMaxLength; i++) {
                    row = logTable[i];
                    var datetime = row[1];
                    var sec = TimeScript.strTimeToSecsSinceEpoch(datetime);
                    if(sec > maxTime) {
                        maxTime = sec;
                    }
                    if(sec < minTime) {
                        minTime = sec;
                    }

                    switch(row[0])
                    {
                    case "mcuevent":
                        x = sec*1000;
                        y = 87.5+i/10000;
                        eventScatterSeries.append(x, y);
                        break;
                    case "mcudiag":
                        x = sec*1000;
                        y = 62.5+i/10000;
                        diagScatterSeries.append(x, y);
                        break;
                    case "mculog.measure":
                        x = sec*1000;
                        y = getMeasVal(row[2]);
                        if(firstMeasLog) {
                            maxMeasValue = getMeasVal(row[2]);
                            minMeasValue = getMeasVal(row[2]);
                            firstMeasLog = false;
                        }

                        if(y > maxMeasValue) maxMeasValue = y;
                        if(y < minMeasValue) minMeasValue = y;
                        measScatterSeries.append(x, y);
                        measLineSeries.append(x, y);
                        break;
                    case "mcucalib":
                        x = sec*1000;
                        y = 37.5+i/10000;
                        calibScatterSeries.append(x, y);
                        break;
                    case "appop":
                        x = sec*1000;
                        y = 12.5+i/10000;
                        operationScatterSeries.append(x, y);
                        break;
                    }
                }

                var valueDelta = (maxTime - minTime)/20
                if(valueDelta <= 0) {
                    valueDelta = 1;
                }

                minAxisTime = minTime;
                maxAxisTime = maxTime + valueDelta;
                if(minTime > valueDelta) {
                    minAxisTime -= valueDelta;
                }

                valueDelta = (maxMeasValue-minMeasValue)/20
                if(valueDelta <= 0) {
                    valueDelta = 0.001;
                }
                // console.debug("QML::Loggraphic time valueDelta: "+valueDelta)

                minAxisMeasValue = minMeasValue;
                maxAxisMeasValue = maxMeasValue + valueDelta;
                if(minMeasValue >= valueDelta) {
                    minAxisMeasValue -= valueDelta;
                }

                timeAxisX1.max = TimeScript.secsSinceEpochToDate(maxAxisTime);
                timeAxisX1.min = TimeScript.secsSinceEpochToDate(minAxisTime);
                timeAxisX2.max = TimeScript.secsSinceEpochToDate(maxAxisTime);
                timeAxisX2.min = TimeScript.secsSinceEpochToDate(minAxisTime);
                valueAxisY.max = maxAxisMeasValue;
                valueAxisY.min = minAxisMeasValue;

                timeSlider.from = minAxisTime;
                timeSlider.to = maxAxisTime;
                timeSlider.first.value = minAxisTime;
                timeSlider.second.value = maxAxisTime;
                //console.debug("QML::Loggraphic time max: "+timeAxisX1.max.toString())
                //console.debug("QML::Loggraphic time min: "+timeAxisX1.min.toString())
                //console.debug("QML::Loggraphic value max: "+valueAxisY.max.toString())
                //console.debug("QML::Loggraphic value min: "+valueAxisY.min.toString())
            }
        }
        mainStackView.push({item: logGraphic, immediate: true})
        mainBusyDialog.close();

        if(logOutofLength) {
            mainMessageDialogOneButton.type = "reminder";
            var maxDate = TimeScript.secsSinceEpochToDate(maxTime);
            var minDate = TimeScript.secsSinceEpochToDate(minTime);
            mainMessageDialogOneButton.text = qsTr("The number of logs is out of scope. Only logs with timestamp")+" ("
                                                   +TimeScript.dateToTimeString(minDate)+" ~ "
                                                   +TimeScript.dateToTimeString(maxDate)
                                                   +") "+qsTr("are shown in graphic.");
            mainMessageDialogOneButton.open();
        }
    }

    function updateMeasValueAxis(from, to)
    {
        var logMaxLength = 3000;
        var logOutofLength = false;

        var maxMeasVal = 0.0;
        var minMeasVal = 0.0;

        if(logTable !== null && logTable !== undefined) {
            // Limit the max number of logs
            if(logTable.length > logMaxLength) {
                logOutofLength = true;
            } else {
                logMaxLength = logTable.length;
            }

            if(logMaxLength > 0) {
                var firstMeasLog = true;
                var x, y;
                var row = logTable[0]

                for (var i = 0; i < logMaxLength; i++) {
                    row = logTable[i];
                    var datetime = row[1];
                    var sec = TimeScript.strTimeToSecsSinceEpoch(datetime);

                    if(sec >= from && sec <= to) {
                        switch(row[0])
                        {
                        case "mculog.measure":
                            y = getMeasVal(row[2]);
                            if(firstMeasLog) {
                                maxMeasVal = getMeasVal(row[2]);
                                minMeasVal = getMeasVal(row[2]);
                                firstMeasLog = false;
                            }

                            if(y > maxMeasVal) maxMeasVal = y;
                            if(y < minMeasVal) minMeasVal = y;

                            break;
                        }
                    }
                }

                var valueDelta = (maxMeasVal-minMeasVal)/20
                if(valueDelta <= 0) {
                    valueDelta = 0.001;
                }

                maxMeasVal = maxMeasVal + valueDelta;
                if(minMeasVal >= valueDelta) {
                    minMeasVal -= valueDelta;
                }

                valueAxisY.max = maxMeasVal;
                valueAxisY.min = minMeasVal;
            }
        }

    }
}
