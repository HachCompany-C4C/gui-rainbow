/****************************************************************************
** HomePage.qml - Home page
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

import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.2
import QtQuick.Controls.Styles.Flat 1.0 as Flat
import QtQuick.Window 2.2
import "../content"
//import "pages"
import "../components"

Rectangle {
    id: mainView
    width: 800
    height: 420
    color: "#f2f2f2"

    objectName: "home page"
    property string title: qsTr("Home")+translator.tr

    ProcessDescription {
        id: processDescription
        x: 453
        y: 8
    }

    Connections {
        target: prognosys_indicator
        ignoreUnknownSignals: true
        onProbeUpdateDone: {

            if(mainPrognosysMgr.prognosysEnabled) {
                var min = prognosys_indicator.getObjInt("service");
                serviceDiagnosys.indictor = min
                var p = prognosys_indicator.getObjInt("measure");
                measureDiagnosys.indictor = p;
            }

            page_manager.updatePageDone();
        }
    }

    Connections {
        target: latest_measure
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            console.debug("QML::UpdatePage latest.measure")
            measureValue.updateValue();
            progressCircle.updateStartGo();
            //lastMeasureTime.updateMeasureTime();

            page_manager.updatePageDone();
        }
    }

    Connections {
        target: current_measure
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            //console.debug("QML::UpdatePage Home current.measure")
            process.updateProcess();
            subProcess.updateSubProcess();
            progressCircle.updateProgress();
            lastMeasureTime.updateMeasureTime();
            //remainTime.updateRemainTime();
            page_manager.updatePageDone();
        }
    }

    //Component.onCompleted: {
    //    page_manager.startUpdate(latest_measure.orgName());
    //}

    Text {
        id: name
        x: 59
        y: 48
        text: qsTr(" NH")+translator.tr
        font: mainTheme.mediumFont
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Text {
        id: nameSuperscript
        anchors.left: name.right
        anchors.bottom: name.bottom
        width: 10
        height: 20
        text: "3"
        font.pixelSize: 20
        visible: name.text == " NH" ? true : false
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Text {
        id: nameN
        anchors.left: nameSuperscript.right
        anchors.verticalCenter: name.verticalCenter
        text: "-N"
        font: mainTheme.mediumFont
        visible: name.text == " NH" ? true : false
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Text {
        id: measureValue
        x: 59
        y: 74
        text: "0.000"
        font: mainTheme.veryhugeFont
        //horizontalAlignment: Text.AlignHCenter
        //verticalAlignment: Text.AlignVCenter
        //property string value: "0.000"

        function updateValue() {

            measureValue.text = latest_measure.getObjString("concentration");
            if(measureValue.text === ">1200" || measureValue.text === ">120")
            {
                plusText.visible = true;
                var str = measureValue.text;
                measureValue.text = str.substr(1,str.length-1);
            } else {
                plusText.visible = false;
            }

            //console.debug("QML::HomePage conc: "+ measureValue.value);
            //if(measureValue.value < 0.0015) { //the value can't be 0
            //    measureValue.value = 0.001;
            //}

            // 0: 0.02~100 > 120
            // 1: 0.02~1000 > 1200
            // 2: 0.02~15 > 18
            // 3: 0.05~30 > 36
            // 4: 7.5~100 > 120
            // 5: 80~1000 > 1200
            //var rangeIndex = measure_range.getObjInt("index");
            //if(rangeIndex > 5) rangeIndex = 5;

            //var maxValue = [1200, 1200, 1200, 1200, 1200, 1200];
            //var maxValue = [120, 1200, 18, 36, 120, 1200];
            //var maxValueText = ["120", "1200", "18", "36", "120", "1200"];

            //if(measureValue.value > maxValue[rangeIndex])
            //    measureValue.value = maxValue[rangeIndex];
            //    plusText.visible = true;
            //} else {
            //    plusText.visible = false;
            //}

            var maxValue = [120, 1200];
            var type = system_info.getObjInt("instr_type");

            //if(valueFloat > maxValue[type]) { //standard - 120.0 mg/L extend - 1200.0
            //    measureValue.value = ""+maxValue[type];
            //    plusText.visible = true;
            //} else {
            //    plusText.visible = false;
            //}

            // format value
            //if(measureValue.value < 1.000) {
            //    text = measureValue.value.toFixed(3);
            //} else {
            //    text = measureValue.value.toPrecision(4);
            //}
        }
    }

    Text {
        id: plusText
        x: 40
        y: 111
        text: qsTr(">")
        font: mainTheme.bigFont
        visible: false
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Text {
        id: unit
        anchors.left: measureValue.right
        anchors.verticalCenter: measureValue.verticalCenter
        anchors.verticalCenterOffset: 45
        text: "mg/L"
        font: mainTheme.mediumFont
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Text {
        id: lastMeasureTimeText
        x: 59
        y: 247
        color: "#bfa0a0"
        text: qsTr("Last measurement: ")+translator.tr
        font: mainTheme.mediumFont
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Text {
        id: lastMeasureTime
        anchors.left: lastMeasureTimeText.right
        anchors.verticalCenter: lastMeasureTimeText.verticalCenter
        color: "#ba9797"
        text: " "
        font: mainTheme.mediumFont
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        function updateMeasureTime() {
            var time = latest_measure.getObjInt("time");
            var year = 2000 + (time >> 26);
            var month = (time >> 22) & 0x0F;
            var day = (time >> 17) & 0x1F;
            var hour = (time >> 12) & 0x1F;
            var minute = (time >> 6) & 0x3F;
            var second = (time) & 0x3F;

            var timeUTC = year+"/"
                    +(month < 10 ? "0":"") + month+"/"
                    +(day < 10 ? "0":"")+day+" "
                    +(hour < 10 ? "0":"")+hour+":"
                    +(minute < 10 ? "0":"")+minute+":"
                    +(second < 10 ? "0":"")+second;
            text = timeUTC;
        }
    }

    Rectangle {
        id: sp2
        anchors.top: lastMeasureTime.bottom
        anchors.topMargin: 30
        anchors.horizontalCenter: parent.horizontalCenter
        height: Flat.FlatStyle.onePixel
        width: 765
        color: Flat.FlatStyle.mediumFrameColor
    }

    H2oTriStatusBar {
        id: measureDiagnosys
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.top: sp2.bottom
        anchors.topMargin: 10

        width: 350
        height: 60
        red: 50
        yellow: 25
        range: 100
        indictor: 100
        enabled: mainPrognosysMgr.prognosysEnabled

        Text {
            id: measureIcon
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 30
            width: 24
            height: 24
            color: measureDiagnosys.enabled ? "#0098db" :"#ba9797"
            font: mainTheme.mediumIcon
            text: "\ue635"
        }

        Text {
            id: textMeasurement
            height: 20
            anchors.verticalCenter: measureIcon.verticalCenter
            anchors.left: measureIcon.right
            anchors.leftMargin: 10
            color: measureDiagnosys.enabled ? "#0098db" :"#ba9797"
            text: qsTr("Measurement")+translator.tr
            anchors.verticalCenterOffset: -5
            font: mainTheme.mediumFont
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.debug("QML::HomePage measure icon clicked");
                //if(mainPermisMgr.checkPermission()) {
                mainNaviPage.navigate(5, 2, 1); // PrognosysMenu, MeasureIndictor, 0
                //}
            }
        }
    }

    H2oTriStatusBar {
        id: serviceDiagnosys
        anchors.right: parent.right
        anchors.rightMargin: 30
        anchors.top: sp2.bottom
        anchors.topMargin: 10
        dayEnabled: true

        width: 350
        height: 60
        red: 1
        yellow: 30
        range: 60
        indictor: 60

        enabled: mainPrognosysMgr.prognosysEnabled

        Text {
            id: serviceIcon
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 30
            width: 24
            height: 24
            color: measureDiagnosys.enabled ? "#0098db" :"#ba9797"
            font: mainTheme.mediumIcon
            text: "\ue618"
        }

        Text {
            id: textService
            anchors.verticalCenter: serviceIcon.verticalCenter
            anchors.left: serviceIcon.right
            anchors.leftMargin: 10
            width: 256
            height: 20
            color: measureDiagnosys.enabled ? "#0098db" :"#ba9797"
            text: qsTr("Service")+translator.tr
            anchors.verticalCenterOffset: -5
            font: mainTheme.mediumFont
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.debug("QML::HomePage measure icon clicked");
                //if(mainPermisMgr.checkPermission()) {
                mainNaviPage.navigate(5, 3, 1); // PrognosysMenu, ServiceIndictor, 0
                //}
            }
        }
    }

    /*BusyIndicator {
        id: busyIndicatorControl
        width: 190
        height: 190
        anchors.verticalCenter: progressCircle.verticalCenter
        anchors.horizontalCenter: progressCircle.horizontalCenter

        running: progressCircle.running

        style: BusyIndicatorStyle {
            indicator: Image {
                visible: busyIndicatorControl.running
                RotationAnimator on rotation {
                    running: busyIndicatorControl.running
                    loops: Animation.Infinite
                    duration: 20000
                    from: 0 ; to: 360
                }
            }
        }
    }*/

    /*Rectangle {
        id: container
        width: 200
        height: 200
        anchors.centerIn: progressCircle
        color: "transparent"
        visible: progressCircle.running

        Rectangle {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: 10
            height: 10
            radius: 5
            color: "blue"
        }

        NumberAnimation on rotation {
            running: container.visible
            from: 0; to: 360;
            loops: Animation.Infinite;
            duration: 20000
        }
    }*/

    Rectangle {
        id: backgroud
        anchors.fill: progressCircle
        radius: 100
        color: mouseArea.pressed ? "#9e9e9e" : "#f2f2f2"
    }

    H2oProgressCircle {
        id: progressCircle
        x: 563
        y: 63
        width: 180
        height: 180
        scale: 1
        lineWidth: 12
        colorBackground: "#e4e4e4"
        property bool running: false
        property int schedule: 0

        Text {
            id: process
            width: 100
            color: mouseArea.pressed ? "white" : "#b29a9a"
            text: processDescription.mainProcessDesc(mainIndex, rangeIndex, subIndex)
            anchors.horizontalCenterOffset: 0
            wrapMode: Text.WordWrap
            anchors.horizontalCenter: progressCircle.horizontalCenter
            anchors.verticalCenter: progressCircle.verticalCenter
            anchors.verticalCenterOffset: -35
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font: mainTheme.smallFont
            property int mainIndex: 0
            property int rangeIndex: rangeIndex = processDescription.rangeLength -1;
            property int subIndex: processDescription.subDescLength -1;

            function updateProcess()
            {
                var i = current_measure.getObjInt("main");
                var detail = current_measure.getObjInt("detail");
                if(i >= 0 && i < processDescription.mainDescLength)
                {
                    mainIndex = i;
                } else {
                    mainIndex = processDescription.mainDescLength-1;
                }

                if(detail >= 0x00FF && detail <= 0x03FF)
                {
                    rangeIndex = (detail >> 8) & 0xFF;
                } else {
                    rangeIndex = processDescription.rangeLength -1;
                }

                if(detail >= 0x0001 && detail <= 0x00E0)
                {
                    subIndex = detail;
                } else {
                    subIndex = processDescription.subDescLength -1;
                }

                //console.debug("QML::HomePage detail: "+detail)
            }
        }

        Text {
            id: subProcess
            width: 100
            color: mouseArea.pressed ? "white" : "#a88989"
            text: processDescription.description(index);
            anchors.horizontalCenterOffset: 0
            wrapMode: Text.WordWrap
            anchors.horizontalCenter: progressCircle.horizontalCenter
            anchors.verticalCenter: progressCircle.verticalCenter
            anchors.verticalCenterOffset: 35
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font: mainTheme.smallFont
            property int index: 0

            function updateSubProcess()
            {
                var i = current_measure.getObjInt("action");
                if(i >= 0 && i < processDescription.length)
                {
                    index = i;
                }
            }
        }

        function updateProgress() {
            var rem = current_measure.getObjInt("remain_time");
            var total = current_measure.getObjInt("total_time");
            var val;
            if(total > 0) {
                val = rem/total;
                if(val < 1.0) {
                    val = val;
                } else {
                    val = 1.0;
                }
            } else {
                val = 1.0;
            }

            progressCircle.value = 1.0 - val;
            //console.debug("QML::updateProgress rem "+rem+" total "+total);
        }

        function updateStartGo() {
            //console.debug("QML::StartGo "+control.status);
            progressCircle.running = !latest_measure.getObjBool("startgo");
            progressCircle.schedule = latest_measure.getObjInt("schedule");

            // if schudule locked or waiting status, disable startgo button
            if(progressCircle.schedule == 3 || progressCircle.schedule == 4) {
                progressCircle.enabled = false;
            } else {
                progressCircle.enabled = true;
            }
        }

        onRunningChanged: {
            progressCircle.enabled = true;
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            onClicked: {
                if(mainPermisMgr.checkPermission()) {
                    if(progressCircle.running === true) {
                        messageDialog.text = qsTr("Do you want to STOP the measurement?")+translator.tr;
                    } else { //control.status == false
                        messageDialog.text = qsTr("Do you want to START the measurement?")+translator.tr;
                    }
                    messageDialog.open();
                }
            }
        }
    }

    Text {
        id: startStop
        anchors.horizontalCenter: progressCircle.horizontalCenter
        anchors.top: progressCircle.bottom
        anchors.topMargin: 10
        text: processDescription.systemStatus[progressCircle.schedule]+translator.tr
        font: mainTheme.titleFont
    }

    H2oMessageDialog {
        id: messageDialog

        onAccepted: {
            //console.debug("QML::Startgo Accepted")
            //progressCircle.running = !latest_measure.getObjBool("startgo");
            //progressCircle.schedule = latest_measure.getObjInt("schedule");
            /*var items = ["log_rawdata", "log_result", "startgo"];
            var values;
            if(progressCircle.running) {
                values = ["enable", "enable", "1"];
            } else {
                values = ["disable", "disable", "0"];
            }*/

            var items = ["set/startgo"];
            var values = progressCircle.running ? "1" : "0"; //1-stop

            latest_measure.setObjs(items, values);
            progressCircle.enabled = false;
        }
    }

    // notified line
    /*Rectangle {
        id: notifiedLine
        x: 0
        y: 0
        width: 800
        height: 40
        color: "#ffb446"

        Rectangle {
            id: dropIcon
            x: 760
            y: 0
            width: 40
            height: 40
            color: notifMouseArea.pressed ? "#9e9e9e":"white"
            Text {
                anchors.centerIn: parent
                text: notifyDialog.visible ? "\ue644" : "\ue643"
                color: theme.hachBlueColor
                font: theme.mediumIcon
            }
            MouseArea {
                id: notifMouseArea
                anchors.rightMargin: 0
                anchors.bottomMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0
                anchors.fill: parent
                onClicked: {
                    if(!mainNotifyDialog.visible)
                        mainNotifyDialog.open("Hello");
                    else
                        mainNotifyDialog.close();
                }
            }
        }
    }*/
}


/*import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.2

import QtQuick.Window 2.2
import "../content"
//import "pages"
import "../components"

Rectangle {
    id: mainView
    width: 800
    height: 400
    objectName: "main page"
    color: "#f2f2f2"

    Connections {
        target: latest_measure
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            console.debug("QML::UpdatePage latest.measure")
            measureValue.updateValue();
            lastMeasureTime.updateMeasureTime();
            control.updateStartGo();
            errorArea.updateError();
        }
    }

    Component.onCompleted: {
        page_manager.startUpdate(latest_measure.orgName());
    }

    Text {
        id: measureValue
        x: 319
        y: 67
        width: 173
        height: 96
        text: "- - - -"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
        font: theme.veryhugeFont

        function updateValue() {
            var value = latest_measure.getObjFloat("concentration");
            //console.debug("QML::HomePage measure "+value);
            if(value < 0.001) {
                value = 0.0;
            }

            text = value.toPrecision(4);
        }
    }

    Text {
        id: unit
        x: 508
        y: 134
        text: "mg/L"
        font.pointSize: 14
        //font: theme.mediumFont
    }

    H2oNavigationButtons {
        id: navigationButtons
        x: 680
        y: 8
        width: 117
        height: 294
    }

    H2oButton {
        id: control
        x: 716
        y: 316
        width: 80
        height: 80
        buttonRadius: 5
        property bool status: false
        Text {
            color: "#ffffff"
            text: control.status ? qsTr("Start") : qsTr("Stop") //false-start; true-stop
            anchors.verticalCenterOffset: 0
            anchors.horizontalCenterOffset: 1
            font.pointSize: 16
            anchors.centerIn: parent
        }

        function updateStartGo() {
            control.status = latest_measure.getObjBool("startgo");
            //console.debug("QML::StartGo "+control.status);
        }

        onClicked: {
            if(control.status == true) {
                messageDialog.text = "Do you want to START the measurement?";
            } else { //control.status == false
                messageDialog.text = "Do you want to STOP the measurement?";
            }
            messageDialog.open();
        }
    }

    Text {
        id: text1
        x: 137
        y: 197
        text: qsTr("Last measure time:")
        font.pixelSize: 20
    }

    Text {
        id: lastMeasureTime
        x: 335
        y: 197
        text: qsTr("0000-00-00 00:00:00")
        font.pixelSize: 20

        function updateMeasureTime() {
            var time = latest_measure.getObjInt("time");
            var year = 2000 + (time >> 26);
            var month = (time >> 22) & 0x0F;
            var day = (time >> 17) & 0x1F;
            var hour = (time >> 12) & 0x1F;
            var minute = (time >> 6) & 0x3F;
            var second = (time) & 0x3F

            var timeUTC = year+"/"
                    +(month < 10 ? "0":"") + month+"/"
                    +(day < 10 ? "0":"")+day+" "
                    +(hour < 10 ? "0":"")+hour+":"
                    +(minute < 10 ? "0":"")+minute+":"
                    +(second < 10 ? "0":"")+second;
            text = timeUTC;
        }
    }

    H2oTriStatusBar {
        id: measureDiagnosys
        x: 101
        y: 275
        width: 200
        height: 40
        red: 50
        yellow: 25
        range: 100
    }

    H2oTriStatusBar {
        id: serviceDiagnosys
        dayEnabled: true
        x: 357
        y: 275
        red: 1
        yellow: 44
        range: 60
    }

    H2oButton {
        id: dIndicator
        x: 0
        y: 352
        width: 48
        height: 48
        property bool status: false

        Text {
            color: "#ffffff"
            anchors.centerIn: parent
            text: qsTr("!")
            font.pointSize: 36
        }

        onClicked: {
            dIndicator.status = !dIndicator.status;
        }
    }

    Text {
        id: unit1
        x: 508
        y: 81
        text: "NH3-N"
        font.pointSize: 14
        //font: theme.mediumFont
    }

    Text {
        id: measureIcon
        x: 71
        y: 291
        width: 24
        height: 24
        font.family: theme.bigIcon
        font.pixelSize: 24
        color: "#3ebdf2"
        text: "\ue635"
    }

    Text {
        id: serviceIcon
        x: 327
        y: 291
        width: 24
        height: 24
        font.family: theme.bigIcon
        font.pixelSize: 24
        color: "#3ebdf2"
        text: "\ue618"
    }

    TextArea {
        id: errorArea
        x: 80
        y: 350
        z: 1
        width: 485
        height: dIndicator.status ? (25 * getLineCount()) : 50
        //height: mouseArea.containsMouse ? (25 * getLineCount()) : 50

        MouseArea {
            id: mouseArea
            hoverEnabled: true
            anchors.fill: parent
        }

        function getLineCount() {
            var n = 0;
            for(var i = 0; i < text.length; i++) {
                if(text.charAt(i) == '\n') {
                    n++;
                }
            }

            if(n > 10) n = 10;

            return n;
        }

        function updateError()
        {
            errorArea.text = page_manager.error();
        }

        text: ""//qsTr("Error: Water Leakage\nWarning: \nReminder: \nError: Flash Error\n")
        visible: true
        activeFocusOnPress: true
        frameVisible: true
        font.pointSize: 14
        anchors.bottom: parent.bottom
        verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff//dIndicator.status ? Qt.ScrollBarAsNeeded : Qt.ScrollBarAlwaysOff
        Behavior on height { NumberAnimation{ easing.type: Easing.OutCubic } }
    }

    //H2oProgressCircle {
    //    x: 546
    //    y: 81
    //    width: 100
    //    height: 100
    //}

    H2oMessageDialog {
        id: messageDialog

        onAccepted: {
            //console.debug("QML::Startgo Accepted")
            control.status = latest_measure.getObjBool("startgo");
            if(control.status) {
                latest_measure.setObj("startgo", false);
                //console.debug("QML::Control.status false");
            } else {
                latest_measure.setObj("startgo", true);
                //console.debug("QML::Control.status true");
            }
        }

        onRejected: {

        }
    }
}*/
