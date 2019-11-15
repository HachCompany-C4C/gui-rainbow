/****************************************************************************
** TestSubstep.qml - UI for sub step test
**
** Created on: 2017-10-31
**
** Author:
**
** Copyright (C) 2016 Hach DDC
**              All Rights Reserved
**
**
** Notes:
**
****************************************************************************/

import QtQuick 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles.Flat 1.0 as Flat
import "../../components"
import "../../content"

Rectangle{
    id: testroot
    objectName: "test_substep"
    property string title: qsTr("Test Substep")+translator.tr
    width: 800
    height: 400
    property alias rangeModel: rangeDropBox.model
    property var busyStatus
    property int busyUpdateIndex: 0

    Connections {
        target: test_substep
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            console.debug("QML::UpdatePage Test-PV")
            valveRepeater.updateValve();
            absTableView.updateAbs();
            tempTableView.updateTemp();
            rangeDropBox.updateRangeType();
            page_manager.updatePageDone();
            getBusyStatus();
        }
    }

    function getBusyStatus()
    {
        var status = test_substep.getObjBool("busy");

        // wait for busy status changed
        if(busyUpdateIndex == 0)
        {
            busyStatus = status;
            stepRun.enabled = !busyStatus;
            autoRun.enabled = !busyStatus;
            actionDropBox.enabled = !busyStatus;
            subactionDropBox.enabled = !busyStatus;
            rangeDropBox.enabled = !busyStatus;
        } else {
            busyUpdateIndex --;
        }
    }

    function doBusy()
    {
        busyUpdateIndex = 1;
        stepRun.enabled = false;
        autoRun.enabled = false;
        actionDropBox.enabled = false;
        subactionDropBox.enabled = false;
        rangeDropBox.enabled = false;
    }

    Text{
        id:stepAutoText
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 5
        font: mainTheme.titleFont
        text:qsTr("Step run & Auto run") + translator.tr
    }

    Text{
        id:actionText
        anchors.left: stepAutoText.left
        anchors.leftMargin: 15
        anchors.top: stepAutoText.bottom
        anchors.topMargin: 15
        font: mainTheme.smallFont
        text:qsTr("Action") + translator.tr
    }

    H2oDropBoxEx {
        id:actionDropBox
        anchors.verticalCenter: actionText.verticalCenter
        anchors.left: actionText.left
        anchors.leftMargin: 80
        width: 319
        height: 40
        currentIndex: 0
        dropSize: 5
        //enabled: !busyStatus
        /*listName: [
            qsTr("Measure ")+translator.tr,
            qsTr("Calibration 0 ")+translator.tr,
            qsTr("Calibration STD ")+translator.tr,
            qsTr("Prime ")+translator.tr,
            qsTr("Cleaning ")+translator.tr,
        ]*/
        model: ListModel {
            id: processModel
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "Measure "); process: "meas" }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "Calibration 0 "); process: "cali0" }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "Calibration STD "); process: "calis" }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "Prime "); process: "prime" }
            //ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "Cleaning "); process: "clean" } //deleted in 2019-2-1
        }
        onIndexChanged: {
            console.debug("Test-Substep Process: " + actionDropBox.currentIndex )
            var modeIndex = rangeDropBox.currentIndex*5 + actionDropBox.currentIndex;
            subactionDropBox.model = subactionDropBox.modelList[modeIndex];
            subactionDropBox.currentIndex = 0;
            console.debug("Test-Substep Process modeIndex: " + modeIndex )
        }
    }

    Text{
        id:rangeText
        anchors.left: stepAutoText.left
        anchors.leftMargin: 15
        anchors.top: stepAutoText.bottom
        anchors.topMargin: 60
        font: mainTheme.smallFont
        text:qsTr("Range") + translator.tr
    }
    H2oDropBox{
        id:rangeDropBox
        width: 319
        height: 40
        currentIndex: 0
        dropAreaSize: 3
        property bool inited: false
        anchors.verticalCenter: rangeText.verticalCenter
        anchors.left: rangeText.left
        anchors.leftMargin: 80
        //enabled: !busyStatus
        listName: [
            qsTr("ULR 0.02~15 mg/L")+translator.tr, // index = 0
            qsTr("LR 0.05~30 mg/L")+translator.tr,
            qsTr("MR 7.5~100 mg/L")+translator.tr,
            qsTr("HR 80~1000 mg/L")+translator.tr,
            qsTr("Error")+translator.tr
        ]

        model: ListModel {
            id: rangeStandardModel
            ListElement { name: qsTr("ULR 0.02~15 mg/L"); range: "ulr"; check: false; index: 0 }
            ListElement { name: qsTr("LR 0.05~30 mg/L"); range: "lr"; check: false; index: 1 }
            ListElement { name: qsTr("MR 7.5~100 mg/L"); range: "mr"; check: false; index: 2 }
        }

        ListModel {
            id: rangeExtendModel
            ListElement { name: qsTr("ULR 0.02~15 mg/L"); range: "ulr"; check: false; index: 0 }
            ListElement { name: qsTr("LR 0.05~30 mg/L"); range: "lr"; check: false; index: 1 }
            ListElement { name: qsTr("MR 7.5~100 mg/L"); range: "mr"; check: false; index: 2 }
            ListElement { name: qsTr("HR 80~1000 mg/L"); range: "hr"; check: false; index: 3 }
        }

        function updateRangeType() {
            if(inited === false)
            {
                inited = true;
                var instrType = system_info.getObjInt("instr_type");
                // console.debug("QML::ManualSchedule instrType: "+instrType);
                if(instrType === 1) //extended type
                {
                    rangeDropBox.model = rangeExtendModel;
                    // console.debug("QML::ManualSchedule updateRange")
                    dropAreaSize = 4;
                }
            }
        }

        onIndexChanged: {
            console.debug("Test-Substep Range: "+rangeDropBox.currentIndex )
            var modeIndex = rangeDropBox.currentIndex*5 + actionDropBox.currentIndex;
            subactionDropBox.model = subactionDropBox.modelList[modeIndex];
            subactionDropBox.currentIndex = 0;
            console.debug("Test-Substep Range modeIndex: " + modeIndex )
        }
    }

    Text{
        id: stepText
        anchors.left: stepAutoText.left
        anchors.leftMargin: 15
        anchors.top: stepAutoText.bottom
        anchors.topMargin: 105
        font: mainTheme.smallFont
        text:qsTr("Step") + translator.tr
    }

    H2oDropBoxEx {
        id:subactionDropBox
        anchors.verticalCenter: stepText.verticalCenter
        anchors.left: stepText.left
        anchors.leftMargin: 80
        width: 319
        height: 40
        currentIndex: 0
        dropSize: 6
        //enabled: !busyStatus

        property var modelList: [
            ulrMeasureSteps,
            ulrCali0Steps,
            ulrCaliSTDSteps,
            ulrPrimeSteps,
            ulrCleaningSteps,

            lrMeasureSteps,
            lrCali0Steps,
            lrCaliSTDSteps,
            lrPrimeSteps,
            lrCleaningSteps,

            mrMeasureSteps,
            mrCali0Steps,
            mrCaliSTDSteps,
            mrPrimeSteps,
            mrCleaningSteps,

            hrMeasureSteps,
            hrCali0Steps,
            hrCaliSTDSteps,
            hrPrimeSteps,
            hrCleaningSteps,
        ]

        model: ListModel {
            id: ulrMeasureSteps
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "ULR_MEASURE_STEP0"); index: 0 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "ULR_MEASURE_STEP1"); index: 1 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "ULR_MEASURE_STEP2"); index: 2 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "ULR_MEASURE_STEP3"); index: 3 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "ULR_MEASURE_STEP4"); index: 4 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "ULR_MEASURE_STEP5"); index: 5 }
        }

        ListModel {
            id: ulrCali0Steps
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "ULR_CALI0_STEP0"); index: 0 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "ULR_CALI0_STEP1"); index: 1 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "ULR_CALI0_STEP2"); index: 2 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "ULR_CALI0_STEP3"); index: 3 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "ULR_CALI0_STEP4"); index: 4 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "ULR_CALI0_STEP5"); index: 5 }
        }

        ListModel {
            id: ulrCaliSTDSteps
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "ULR_CALISTD_STEP0"); index: 0 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "ULR_CALISTD_STEP1"); index: 1 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "ULR_CALISTD_STEP2"); index: 2 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "ULR_CALISTD_STEP3"); index: 3 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "ULR_CALISTD_STEP4"); index: 4 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "ULR_CALISTD_STEP5"); index: 5 }
        }

        ListModel {
            id: ulrPrimeSteps
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "ULR_PRIME_STEP0"); index: 0 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "ULR_PRIME_STEP1"); index: 1 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "ULR_PRIME_STEP2"); index: 2 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "ULR_PRIME_STEP3"); index: 3 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "ULR_PRIME_STEP4"); index: 4 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "ULR_PRIME_STEP5"); index: 5 }
        }

        ListModel {
            id: ulrCleaningSteps
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "ULR_CLEAN_STEP0"); index: 0 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "ULR_CLEAN_STEP1"); index: 1 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "ULR_CLEAN_STEP2"); index: 2 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "ULR_CLEAN_STEP3"); index: 3 }
        }

        ListModel {
            id: lrMeasureSteps
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "LR_MEASURE_STEP0"); index: 0 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "LR_MEASURE_STEP1"); index: 1 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "LR_MEASURE_STEP2"); index: 2 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "LR_MEASURE_STEP3"); index: 3 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "LR_MEASURE_STEP4"); index: 4 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "LR_MEASURE_STEP5"); index: 5 }
        }

        ListModel {
            id: lrCali0Steps
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "LR_CALI0_STEP0"); index: 0 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "LR_CALI0_STEP1"); index: 1 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "LR_CALI0_STEP2"); index: 2 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "LR_CALI0_STEP3"); index: 3 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "LR_CALI0_STEP4"); index: 4 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "LR_CALI0_STEP5"); index: 5 }
        }

        ListModel {
            id: lrCaliSTDSteps
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "LR_CALISTD_STEP0"); index: 0 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "LR_CALISTD_STEP1"); index: 1 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "LR_CALISTD_STEP2"); index: 2 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "LR_CALISTD_STEP3"); index: 3 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "LR_CALISTD_STEP4"); index: 4 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "LR_CALISTD_STEP5"); index: 5 }
        }

        ListModel {
            id: lrPrimeSteps
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "LR_PRIME_STEP0"); index: 0 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "LR_PRIME_STEP1"); index: 1 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "LR_PRIME_STEP2"); index: 2 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "LR_PRIME_STEP3"); index: 3 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "LR_PRIME_STEP4"); index: 4 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "LR_PRIME_STEP5"); index: 5 }
        }

        ListModel {
            id: lrCleaningSteps
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "LR_CLEAN_STEP0"); index: 0 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "LR_CLEAN_STEP1"); index: 1 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "LR_CLEAN_STEP2"); index: 2 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "LR_CLEAN_STEP3"); index: 3 }
        }

        ListModel {
            id: mrMeasureSteps
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "MR_MEASURE_STEP0"); index: 0 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "MR_MEASURE_STEP1"); index: 1 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "MR_MEASURE_STEP2"); index: 2 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "MR_MEASURE_STEP3"); index: 3 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "MR_MEASURE_STEP4"); index: 4 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "MR_MEASURE_STEP5"); index: 5 }
        }

        ListModel {
            id: mrCali0Steps
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "MR_CALI0_STEP0"); index: 0 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "MR_CALI0_STEP1"); index: 1 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "MR_CALI0_STEP2"); index: 2 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "MR_CALI0_STEP3"); index: 3 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "MR_CALI0_STEP4"); index: 4 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "MR_CALI0_STEP5"); index: 5 }
        }

        ListModel {
            id: mrCaliSTDSteps
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "MR_CALISTD_STEP0"); index: 0 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "MR_CALISTD_STEP1"); index: 1 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "MR_CALISTD_STEP2"); index: 2 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "MR_CALISTD_STEP3"); index: 3 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "MR_CALISTD_STEP4"); index: 4 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "MR_CALISTD_STEP5"); index: 5 }
        }

        ListModel {
            id: mrPrimeSteps
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "MR_PRIME_STEP0"); index: 0 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "MR_PRIME_STEP1"); index: 1 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "MR_PRIME_STEP2"); index: 2 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "MR_PRIME_STEP3"); index: 3 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "MR_PRIME_STEP4"); index: 4 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "MR_PRIME_STEP5"); index: 5 }
        }

        ListModel {
            id: mrCleaningSteps
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "MR_CLEAN_STEP0"); index: 0 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "MR_CLEAN_STEP1"); index: 1 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "MR_CLEAN_STEP2"); index: 2 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "MR_CLEAN_STEP3"); index: 3 }
        }

        ListModel {
            id: hrMeasureSteps
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "HR_MEASURE_STEP0"); index: 0 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "HR_MEASURE_STEP1"); index: 1 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "HR_MEASURE_STEP2"); index: 2 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "HR_MEASURE_STEP3"); index: 3 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "HR_MEASURE_STEP4"); index: 4 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "HR_MEASURE_STEP5"); index: 5 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "HR_MEASURE_STEP6"); index: 6 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "HR_MEASURE_STEP7"); index: 7 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "HR_MEASURE_STEP8"); index: 8 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "HR_MEASURE_STEP9"); index: 9 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "HR_MEASURE_STEP10"); index: 10 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "HR_MEASURE_STEP11"); index: 11 }
        }

        ListModel {
            id: hrCali0Steps
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "HR_CALI0_STEP0"); index: 0 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "HR_CALI0_STEP1"); index: 1 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "HR_CALI0_STEP2"); index: 2 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "HR_CALI0_STEP3"); index: 3 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "HR_CALI0_STEP4"); index: 4 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "HR_CALI0_STEP5"); index: 5 }
        }

        ListModel {
            id: hrCaliSTDSteps
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "HR_CALISTD_STEP0"); index: 0 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "HR_CALISTD_STEP1"); index: 1 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "HR_CALISTD_STEP2"); index: 2 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "HR_CALISTD_STEP3"); index: 3 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "HR_CALISTD_STEP4"); index: 4 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "HR_CALISTD_STEP5"); index: 5 }
        }

        ListModel {
            id: hrPrimeSteps
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "HR_PRIME_STEP0"); index: 0 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "HR_PRIME_STEP1"); index: 1 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "HR_PRIME_STEP2"); index: 2 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "HR_PRIME_STEP3"); index: 3 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "HR_PRIME_STEP4"); index: 4 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "HR_PRIME_STEP5"); index: 5 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "HR_PRIME_STEP6"); index: 6 }
        }

        ListModel {
            id: hrCleaningSteps
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "HR_CLEAN_STEP0"); index: 0 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "HR_CLEAN_STEP1"); index: 1 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "HR_CLEAN_STEP2"); index: 2 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "HR_CLEAN_STEP3"); index: 3 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "HR_CLEAN_STEP4"); index: 4 }
            ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "HR_CLEAN_STEP5"); index: 5 }
        }

        onIndexChanged: {
            console.debug("Test-Substep Process: " + currentName )
        }
    }

    H2oButton {
        id: stepRun
        anchors.top: stepAutoText.bottom
        anchors.topMargin: 10
        anchors.left: stepAutoText.left
        anchors.leftMargin: 500
        width: 200
        height: 50
        text: qsTr("STEP RUN")+translator.tr
        //enabled: !busyStatus

        onClicked: {
            var command = rangeModel.get(rangeDropBox.currentIndex).range + "_"
                    + processModel.get(actionDropBox.currentIndex).process;

            console.debug(qsTr("Test-Substep Process: ")+command );
            test_substep.setObj(command, subactionDropBox.currentIndex);
            doBusy();
        }
    }

    H2oButton {
        id: autoRun
        anchors.top: stepRun.bottom
        anchors.topMargin: 20
        anchors.left: stepRun.left
        width: 200
        height: 50
        text: qsTr("AUTO RUN")+translator.tr
        //enabled: !busyStatus

        onClicked: {
            var command = rangeModel.get(rangeDropBox.currentIndex).range + "_"
                    + processModel.get(actionDropBox.currentIndex).process;
            var autoIndex = subactionDropBox.modelSize;
            console.debug(qsTr("Test-Substep Process: ")+command + " "+autoIndex);
            test_substep.setObj(command, autoIndex);
            doBusy();
        }
    }

    Rectangle {
        id: sp1
        anchors.top: stepAutoText.top
        anchors.topMargin: 175
        anchors.horizontalCenter: parent.horizontalCenter
        height: Flat.FlatStyle.onePixel
        width: parent.width - 40
        color: Flat.FlatStyle.lightFrameColor
        anchors.horizontalCenterOffset: 3
    }

    Text {
        id: valveStatus
        anchors.left: stepAutoText.left
        anchors.top: sp1.bottom
        anchors.topMargin: 5
        text: qsTr("Valve status") + translator.tr
        font: mainTheme.titleFont
    }

    Row {
        id:valveRow
        anchors.left: valveStatus.left
        anchors.leftMargin: 15
        anchors.top: valveStatus.bottom
        anchors.topMargin: 0
        spacing: 40

        Repeater {
            id: valveRepeater
            model: ListModel{
                id: valveModel
                ListElement{eonOff: true; etxt:"1"}
                ListElement{eonOff: false; etxt:"2"}
                ListElement{eonOff: true; etxt:"3"}
                ListElement{eonOff: false; etxt:"4"}
                ListElement{eonOff: true; etxt:"5"}
                ListElement{eonOff: true; etxt:"6"}
                ListElement{eonOff: false; etxt:"7"}
                ListElement{eonOff: true; etxt:"8"}
                ListElement{eonOff: true; etxt:"9"}
            }

            delegate: TestOnOff{
                dioameter: 40
                onOff: eonOff
                txt:etxt
            }
            function updateValve()
            {
                var valve = test_substep.getObjInt("valve");
                //console.debug("QML::valve "+valve);
                for(var i = 15; i > 6; i--)
                {
                    var status = (valve & (0x1 << i)) > 0 ? true : false;
                    model.setProperty(15-i, "eonOff", status);
                }
            }
        }
    }

    Rectangle {
        id: sp2

        width: parent.width - 40
        height: Flat.FlatStyle.onePixel
        color: Flat.FlatStyle.lightFrameColor
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: valveRow.bottom
        anchors.topMargin: 10
    }

    H2oTableView {
        id: tempTableView
        width: 800 - 40
        height: 60
        anchors.top: tempAbsText.bottom
        anchors.topMargin: -10
        anchors.horizontalCenter: parent.horizontalCenter

        verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        highlightOnFocus: false
        headerVisible: true
        alternatingRowColors: false
        //backgroundVisible: false
        frameVisible: false

        TableViewColumn {
            role: "item"
            title: " "
            width: tempTableView.width / 5
            resizable: false
            movable: false
            //delegate: textDelegate

        }
        TableViewColumn {
            role: "heating"
            title: qsTr("heating") + translator.tr
            width: tempTableView.width / 5
            resizable: false
            movable: false
            //delegate: textDelegate
        }
        TableViewColumn {
            role: "colorimeter"
            title: qsTr("colorimeter") + translator.tr
            width: tempTableView.width / 5
            resizable: false
            movable: false
            //delegate: textDelegate
        }
        TableViewColumn {
            role: "envirenment"
            title: qsTr("envirenment") + translator.tr
            width: tempTableView.width / 5
            resizable: false
            movable: false
            //delegate: textDelegate
        }
        TableViewColumn {
            role: "deviceCase"
            title: qsTr("case") + translator.tr
            width: tempTableView.width / 5
            resizable: false
            movable: false
            //delegate: textDelegate
        }

        model: ListModel {
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Temp"); heating: "0"; colorimeter: "0"; envirenment: "0"; deviceCase: "0"}
        }

        rowDelegate: Rectangle {
            id: tempRowItem
            height: 30

            SystemPalette {
                id: tempPalette;
                colorGroup: SystemPalette.Active
            }
            color: {
                var baseColor = styleData.row%2 == 0 ? tempPalette.alternateBase : tempPalette.base
                return styleData.selected ? tempPalette.highlight : baseColor
            }
        }
        function updateTemp()
        {
            var temp = "";
            temp = (test_substep.getObjInt("al_temp")/100).toFixed(1);
            model.setProperty(0, "heating", temp);
            temp = (test_substep.getObjInt("peek_temp")/100).toFixed(1);
            model.setProperty(0, "colorimeter", temp);
            temp = (test_substep.getObjInt("env_temp")/100).toFixed(1);
            model.setProperty(0, "envirenment", temp);
            temp = (test_substep.getObjInt("pcb_temp")/100).toFixed(1);
            model.setProperty(0, "deviceCase", temp);
        }
    }

    Text{
        id:tempAbsText
        anchors.left: stepAutoText.left
        anchors.top: sp2.bottom
        anchors.topMargin: 0
        font: mainTheme.titleFont
        text:qsTr("Temperature & Abs") + translator.tr
    }

    H2oTableView {
        id: absTableView
        width: 800 - 40
        height: 60
        anchors.top: tempTableView.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        highlightOnFocus: false
        headerVisible: true
        alternatingRowColors: false
        //backgroundVisible: false
        frameVisible: false

        TableViewColumn {
            role: "item"
            title: " "
            width: absTableView.width / 5
            resizable: false
            movable: false
            //delegate: textDelegate

        }
        TableViewColumn {
            role: "L660"
            title: qsTr("L660")
            width: absTableView.width / 5
            resizable: false
            movable: false
            //delegate: textDelegate
        }
        TableViewColumn {
            role: "L880"
            title: qsTr("L880")
            width: absTableView.width / 5
            resizable: false
            movable: false
            //delegate: textDelegate
        }
        TableViewColumn {
            role: "S660"
            title: qsTr("S660")
            width: absTableView.width / 5
            resizable: false
            movable: false
            //delegate: textDelegate
        }
        TableViewColumn {
            role: "S880"
            title: qsTr("S880")
            width: absTableView.width / 5
            resizable: false
            movable: false
            //delegate: textDelegate
        }

        model: ListModel {
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Abs"); L660: "0"; L880: "0"; S660: "0"; S880: "0"}
        }

        rowDelegate: Rectangle {
            id: absrowItem
            height: 30

            SystemPalette {
                id: absPalette;
                colorGroup: SystemPalette.Active
            }
            color: {
                var baseColor = styleData.row%2 == 0 ? absPalette.alternateBase : absPalette.base
                return styleData.selected ? absPalette.highlight : baseColor
            }
        }
        function updateAbs()
        {
            var temp = "";
            temp = test_substep.getObjFloat("l660")
            model.setProperty(0, "L660", temp.toFixed(3))
            temp = test_substep.getObjFloat("l880")
            model.setProperty(0, "L880", temp.toFixed(3))
            temp = test_substep.getObjFloat("s660")
            model.setProperty(0, "S660", temp.toFixed(3))
            temp = test_substep.getObjFloat("s880")
            model.setProperty(0, "S880", temp.toFixed(3))
            //model.setProperty(0, "etext", test_substep.getObjString("l660"));
            //model.setProperty(1, "etext", test_substep.getObjString("l880"));
            //model.setProperty(2, "etext", test_substep.getObjString("s660"));
            //model.setProperty(3, "etext", test_substep.getObjString("s880"));
        }
    }
}
