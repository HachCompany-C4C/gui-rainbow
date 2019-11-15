/****************************************************************************
** HelpPage.qml - Help definition
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
import QtQuick.Controls.Styles.Flat 1.0 as Flat
import "../components"
import "../content/time.js" as TimeScript

Rectangle {
    width: 800
    height: 360
    objectName: "help"
    property string title: qsTr("Help")+translator.tr

    property var helpList: [
        [ "<b>"+qsTr("diag0_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag0_guide1"), QT_TR_NOOP("diag0_guide2"),
         ("goto_2_4_3") ], //USB_WRITE_FAILURE
        [ "<b>"+qsTr("diag1_guide0")+"</b>"+translator.tr ], //LOCAL_COMMUNICATION_ERR
        [ "<b>"+qsTr("diag2_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag2_guide1"), ("goto_3_1_1"), QT_TR_NOOP("diag2_guide2") ], //LED_OUTPUT_LOW
        [ "<b>"+qsTr("diag3_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag3_guide1"), ("goto_1_1_3"),
         QT_TR_NOOP("diag3_guide2"), ("goto_1_4_1"),
         QT_TR_NOOP("diag3_guide3"),
         QT_TR_NOOP("diag3_guide4"), ("goto_1_1_4") ], //NO_SAMPLE_FLOW
        [ "<b>"+qsTr("diag4_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag4_guide1"), QT_TR_NOOP("diag4_guide2"),
         QT_TR_NOOP("diag4_guide3"), ("goto_3_1_1") ], //HEAT_OUT_CTRL
        [ "<b>"+qsTr("diag5_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag5_guide1"), QT_TR_NOOP("diag5_guide2") ], //DOOR_OPEN
        [ "<b>"+qsTr("diag6_guide0")+"</b>"+translator.tr ], //AD_SPI_FAILURE
        [ "<b>"+qsTr("diag7_guide0")+"</b>"+translator.tr ], //FLASH_FAILURE
        [ "<b>"+qsTr("diag8_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag8_guide1"), ("goto_2_4_1") ], //EEPROM_ERROR
        [ "<b>"+qsTr("diag9_guide0")+"</b>"+translator.tr ], //RAM_FAILURE
        [ "<b>"+qsTr("diag10_guide0")+"</b>"+translator.tr ], //POWER_FAILUR
        [ "<b>"+qsTr("diag11_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag11_guide1"), ("goto_3_1_1") ], //VOLT_OUT_RANGE
        [ "<b>"+qsTr("diag12_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag12_guide1"), ("goto_3_1_1"),
         QT_TR_NOOP("diag12_guide2"), QT_TR_NOOP("diag12_guide3") ], //HEATER_SENSOR_FAILURE
        [ "<b>"+qsTr("diag13_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag13_guide1"), QT_TR_NOOP("diag13_guide2"),
         QT_TR_NOOP("diag13_guide3"), ("goto_3_1_1") ], //CASE_TEMP_WARNING
        [ "<b>"+qsTr("diag14_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag14_guide1"), QT_TR_NOOP("diag14_guide2"),
         QT_TR_NOOP("diag14_guide3"), ("goto_5_3_1"), QT_TR_NOOP("diag14_guide4"), ("goto_2_4_3") ], //FAILED_CALIBRATION
        [ "<b>"+qsTr("diag15_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag15_guide1"), QT_TR_NOOP("diag15_guide2"),
         ("goto_4_2_3") ], //LEAKAGE_WARNING
        [ "<b>"+qsTr("diag16_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag16_guide1"), ("goto_2_3_1"),
         QT_TR_NOOP("diag16_guide2"), ("goto_3_1_1") ], //CHECK_OPTICS
        [ "<b>"+qsTr("diag17_guide0")+"</b>"+translator.tr ], //REAGENT_INVALID
        [ "<b>"+qsTr("diag18_guide0")+"</b>"+translator.tr ], //CURRENT_ERROR
        [ "<b>"+qsTr("diag19_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag19_guide1"), ("goto_4_2_2") ], //ALARM_LOW
        [ "<b>"+qsTr("diag20_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag20_guide1"), ("goto_4_2_2") ], //ALARM_HIGH
        [ "<b>"+qsTr("diag21_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag21_guide1"), QT_TR_NOOP("diag21_guide2"), ("goto_2_3_2") ], //REAGNET_EMPTY_A�
        [ "<b>"+qsTr("diag22_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag22_guide1"), QT_TR_NOOP("diag22_guide2"), ("goto_2_3_2") ], //REAGNET_EMPTY_B
        [ "<b>"+qsTr("diag23_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag23_guide1"), QT_TR_NOOP("diag23_guide2"), ("goto_2_3_2") ], //REAGNET_EMPTY_C
        [ "<b>"+qsTr("diag24_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag24_guide1"), QT_TR_NOOP("diag24_guide2"), ("goto_2_3_2") ], //STD_EMPTY_0
        [ "<b>"+qsTr("diag25_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag25_guide1"), QT_TR_NOOP("diag25_guide2"), ("goto_2_3_2") ], //STD_EMPTY_1
        [ "<b>"+qsTr("diag26_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag26_guide1"), QT_TR_NOOP("diag26_guide2"), ("goto_2_3_2") ], //STD_EMPTY_2
        [ "<b>"+qsTr("diag27_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag27_guide1"), QT_TR_NOOP("diag27_guide2"), ("goto_2_3_2") ], //CLEANING_EMPTY
        [ "<b>"+qsTr("diag28_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag28_guide1"), QT_TR_NOOP("diag28_guide2"), ("goto_2_3_2") ], //REAGNET_LOW_A
        [ "<b>"+qsTr("diag29_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag29_guide1"), QT_TR_NOOP("diag29_guide2"), ("goto_2_3_2") ], //REAGNET_LOW_B
        [ "<b>"+qsTr("diag30_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag30_guide1"), QT_TR_NOOP("diag30_guide2"), ("goto_2_3_2") ], //REAGNET_LOW_C
        [ "<b>"+qsTr("diag31_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag31_guide1"), QT_TR_NOOP("diag31_guide2"), ("goto_2_3_2") ], //STD_LOW_0
        [ "<b>"+qsTr("diag32_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag32_guide1"), QT_TR_NOOP("diag32_guide2"), ("goto_2_3_2") ], //STD_LOW_1
        [ "<b>"+qsTr("diag33_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag33_guide1"), QT_TR_NOOP("diag33_guide2"), ("goto_2_3_2") ], //STD_LOW_2
        [ "<b>"+qsTr("diag34_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag34_guide1"), QT_TR_NOOP("diag34_guide2"), ("goto_2_3_2") ], //CLEANING_LOW
        [ "<b>"+qsTr("diag35_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag35_guide1"), QT_TR_NOOP("diag35_guide2"), ("goto_5_3_2") ], //LIFESPAN_TUBING_VALVE
        [ "<b>"+qsTr("diag36_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag36_guide1"), QT_TR_NOOP("diag36_guide2"), ("goto_5_3_2") ], //LIFESPAN_TUBING_PUMP
        [ "<b>"+qsTr("diag37_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag37_guide1"), ("goto_5_3_1")  ], //LIFESPAN_MOTOR_PUMP1
        [ "<b>"+qsTr("diag38_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag38_guide1"), ("goto_5_3_1")  ], //LIFESPAN_MOTOR_PUMP2
        [ "<b>"+qsTr("diag39_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag39_guide1"), ("goto_5_3_1")  ], //LIFESPAN_MOTOR_PUMP3
        [ "<b>"+qsTr("diag40_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag40_guide1"), ("goto_5_3_1")  ], //LIFESPAN_MOTOR_MIX
        [ "<b>"+qsTr("diag41_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag41_guide1") ], //RTC_ALARM
        [ "<b>"+qsTr("diag42_guide0")+"</b>"+translator.tr ], //LED_ERROR
        [ "<b>"+qsTr("diag43_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag43_guide1"), ("goto_1_4_1") ], //CANOPEN_WARNING
        [ "<b>"+qsTr("diag44_guide0")+"</b>"+translator.tr ], //CANOPEN_ERROR
        [ "<b>"+qsTr("diag45_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag45_guide1"), QT_TR_NOOP("diag45_guide2"), ("goto_2_4_2") ], //CANOPEN_ER_CONNECT
        [ "<b>"+qsTr("diag46_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag46_guide1"), ("goto_2_4_3") ], //CANOPEN_ER_CONFIG
        [ "<b>"+qsTr("diag47_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag47_guide1") ],
        [ "<b>"+qsTr("diag48_guide0")+"</b>"+translator.tr, QT_TR_NOOP("diag48_guide1") ], // Communication Error
        /*[ QT_TR_NOOP("diag49_guide0"), QT_TR_NOOP("diag49_guide1"), QT_TR_NOOP("diag49_guide2"), QT_TR_NOOP("diag49_guide3"),
              QT_TR_NOOP("diag49_guide4"), QT_TR_NOOP("diag49_guide5"), QT_TR_NOOP("diag49_guide6"), QT_TR_NOOP("diag49_guide7"),
              QT_TR_NOOP("diag49_guide8"), QT_TR_NOOP("diag49_guide9"), QT_TR_NOOP("diag49_guide10"), QT_TR_NOOP("diag49_guide11"),
              QT_TR_NOOP("diag49_guide12"), QT_TR_NOOP("diag49_guide13"), QT_TR_NOOP("diag49_guide14"), QT_TR_NOOP("diag49_guide15"),
              QT_TR_NOOP("diag49_guide16"), QT_TR_NOOP("diag49_guide17") ], // Free schedule*/
        [ "<big><b>"+qsTr("How to use the manual trigger function")+"</b></big>"+translator.tr,
         "<b>"+qsTr("Function:")+"</b>"+translator.tr,
         qsTr(" Manual trigger to edit and execute a custom action list (up to 16 actions)")+translator.tr,
         "<b>"+qsTr("Usage:")+"</b>"+translator.tr,
         qsTr("1. Select the desired action and range from the drop-down box. After clicking Add Action, the action will be added to the list on the right.")+translator.tr,
         qsTr("2. Click on the execution list and the instrument will perform the actions in the list in sequence when it is idle.")+translator.tr,
         qsTr("3. Clicking Clear List will clear all actions that have been added.")+translator.tr,
         qsTr("4. Click to stop execution, the instrument will cancel the execution of all subsequent actions and clear the list. The currently executing action will not be stopped.")+translator.tr,
         "",
         "<big><b>"+qsTr("Action definition:")+"</b></big>"+translator.tr,
         "<b>"+qsTr("Infusion:")+"</b>"+qsTr(" The instrument pre-fills the reagent, standard solution, and sample. When the 80-1000mg/L range is selected, the deionized water will fill the pipeline.")+translator.tr,
         "<b>"+qsTr("Calibration:")+"</b>"+qsTr(" The instrument performs a calibration at a specified range")+translator.tr,
         "<b>"+qsTr("Off-line measurement:")+"</b>"+qsTr(" The measurement of the pre-processing device is not triggered when the instrument performs a specified range.")+translator.tr,
         "<b>"+qsTr("Measurement:")+"</b>"+qsTr(" The instrument performs a normal measurement at a specified range. If the instrument is connected to a pre-processing unit, the pre-processing is initiated.")+translator.tr,
         "<b>"+qsTr("Drain:")+"</b>"+qsTr(" The instrument performs an emptying action for a specified range. The cuvette and dilution tank are simultaneously emptied on the 80-1000 mg/L range, and the remaining ranges are emptied only to empty the cuvette.")+translator.tr,
         "<b>"+qsTr("Power drain:")+"</b>"+qsTr(" The instrument performs an emptying action for overflow cup.")+translator.tr,
         "<b>"+qsTr("Verify Blank Solution:")+"</b>"+qsTr(" The instrument performs a blank standard solution backtest at a specified range.")+translator.tr,
         "<b>"+qsTr("Verification Standard Solution:")+"</b>"+qsTr(" The instrument performs a standard solution backtest at a specified range.")+translator.tr,
         "<b>"+qsTr("Sample Flush:")+"</b>"+qsTr(" The instrument performs a flushing of the sample injection line at a specified range.")+translator.tr,
         "<b>"+qsTr("Cleaning:")+"</b>"+qsTr(" The instrument performs a cleaning process at a specified range.")+translator.tr,
         "<b>"+qsTr("Turn off periodic tasks:")+"</b>"+qsTr(" The instrument turns off the response of all periodic tasks.")+translator.tr,
         "<b>"+qsTr("Start cycle task:")+"</b>"+qsTr(" The instrument resumes the response of all periodic tasks.")+translator.tr,
        ],// Free schedule

        /*[ qsTr("diag50_guide0"), qsTr("diag50_guide1"), qsTr("diag50_guide2"), qsTr("diag50_guide3"),
              qsTr("diag50_guide4"), qsTr("diag50_guide5"), ("goto_2_3_1") ] // Reagent usage*/
        [
            "<big><b>"+qsTr("How to set the reagent balance")+"</b></big>",
            "<b>"+qsTr("Function:")+"</b>",
            qsTr(" The reagent usage interface displays or edits the current allowance (ml) and remaining percentage of reagents, standards, and cleaning solutions."),
            "<b>"+qsTr("Usage:")+"</b>",
            qsTr("1. Click on the plus or minus sign on the right side of each reagent bottle to increase or decrease the display of the current reagent allowance. Long press on the plus or minus sign to speed up."),
            qsTr("2. Click on the liquid level in the reagent bottle alone to quickly adjust the current allowance to the desired margin."),
            qsTr("3. After each reagent change, adjust the reagent balance and go to the manual trigger page to perform the perfusion.")

        ],// 50 - Reagent usage
        [
            "<b>"+qsTr("progservice54_guide0")+"</b>"+translator.tr, QT_TR_NOOP("progservice54_guide1"), QT_TR_NOOP("progservice54_guide2"), QT_TR_NOOP("progservice54_guide3"),
            QT_TR_NOOP("progservice54_guide4"), QT_TR_NOOP("progservice54_guide5"), QT_TR_NOOP("goto_2_3_1"), QT_TR_NOOP("progservice54_guide6"), QT_TR_NOOP("progservice54_guide7"),
            "qrc:///resources/images/prog_valvetube_01.PNG",
            "qrc:///resources/images/prog_valvetube_02.PNG",
            QT_TR_NOOP("progservice54_guide8"), QT_TR_NOOP("goto_2_3_3"), QT_TR_NOOP("progservice54_guide9"), QT_TR_NOOP("goto_2_3_1"), QT_TR_NOOP("progservice54_guide10")
        ],//51- Prognosys service valve tube life time

        [
            "<b>"+qsTr("progservice51_guide0")+"</b>"+translator.tr, QT_TR_NOOP("progservice51_guide1"), QT_TR_NOOP("progservice51_guide2"), QT_TR_NOOP("progservice51_guide3"),
            QT_TR_NOOP("progservice51_guide4"), QT_TR_NOOP("progservice51_guide5"),
            "qrc:///resources/images/prog_pumptube_01.PNG", QT_TR_NOOP("progservice51_guide6"), QT_TR_NOOP("progservice51_guide7"),
            "qrc:///resources/images/prog_pumptube_02.PNG", QT_TR_NOOP("progservice51_guide8"),
            "qrc:///resources/images/prog_pumptube_03.PNG", QT_TR_NOOP("progservice51_guide9"), QT_TR_NOOP("goto_2_3_3"), QT_TR_NOOP("progservice51_guide10")

        ], // 52- Prognosys service pump1 tube life time

        [
            "<b>"+qsTr("progservice52_guide0")+"</b>"+translator.tr, QT_TR_NOOP("progservice52_guide1"), QT_TR_NOOP("progservice52_guide2"), QT_TR_NOOP("progservice52_guide3"), QT_TR_NOOP("progservice52_guide4"), QT_TR_NOOP("goto_2_3_1"),
            QT_TR_NOOP("progservice52_guide5"), QT_TR_NOOP("progservice52_guide6"), QT_TR_NOOP("progservice52_guide7"), QT_TR_NOOP("progservice52_guide8"), QT_TR_NOOP("progservice52_guide9"),
            QT_TR_NOOP("progservice52_guide10"), QT_TR_NOOP("goto_2_3_3"), QT_TR_NOOP("progservice52_guide11"), QT_TR_NOOP("goto_2_3_1"), QT_TR_NOOP("progservice52_guide12")
        ],// 53- Prognosys service pump2 tube life time

        [
            "<b>"+qsTr("progservice53_guide0")+"</b>"+translator.tr, QT_TR_NOOP("progservice53_guide1"), QT_TR_NOOP("progservice53_guide2"), QT_TR_NOOP("progservice53_guide3"), QT_TR_NOOP("progservice53_guide4"), QT_TR_NOOP("goto_2_3_1"), QT_TR_NOOP("progservice53_guide5"), QT_TR_NOOP("progservice53_guide6"),
            "qrc:///resources/images/prog_pumptube3_02.PNG", QT_TR_NOOP("progservice53_guide7"),
            "qrc:///resources/images/prog_pumptube3_03.PNG", QT_TR_NOOP("progservice53_guide8"), QT_TR_NOOP("goto_2_3_3"), QT_TR_NOOP("progservice53_guide9")
        ],//54- Prognosys service pump3 tube life time
        [
            "<b>"+qsTr("progservice55_guide0")+"</b>"+translator.tr, QT_TR_NOOP("progservice55_guide1"), QT_TR_NOOP("progservice55_guide2"),  QT_TR_NOOP("progservice55_guide3"), ("goto_2_3_2")
        ], //55-Reagent volume

        [
            "<b>"+qsTr("progservice56_guide0")+"</b>"+translator.tr, QT_TR_NOOP("progservice56_guide1"), QT_TR_NOOP("progservice56_guide2"), QT_TR_NOOP("progservice56_guide3"), QT_TR_NOOP("progservice56_guide4"), QT_TR_NOOP("goto_2_3_1"), QT_TR_NOOP("progservice56_guide5"), QT_TR_NOOP("progservice56_guide6"), QT_TR_NOOP("progservice56_guide7"), QT_TR_NOOP("progservice56_guide8"), QT_TR_NOOP("goto_2_3_3")
        ], //56-Power drain pump tube

        [
            "<b>"+qsTr("progmeasure57_guide0")+"</b>"+translator.tr, QT_TR_NOOP("progmeasure57_guide1"), ("goto_5_3_1")
        ],//57-Prognosys measure pump1 tube

        [
            "<b>"+qsTr("progmeasure58_guide0")+"</b>"+translator.tr, QT_TR_NOOP("progmeasure58_guide1"), ("goto_5_3_1")
        ],//58-Prognosys measure pump2 tube

        [
            "<b>"+qsTr("progmeasure59_guide0")+"</b>"+translator.tr, QT_TR_NOOP("progmeasure59_guide1"), ("goto_5_3_1")
        ],//59-Prognosys measure pump3 tube

        [
            "<b>"+qsTr("progmeasure60_guide0")+"</b>"+translator.tr, QT_TR_NOOP("progmeasure60_guide1")
        ],//60-Case_down temperature

        [
            "<b>"+qsTr("progmeasure61_guide0")+"</b>"+translator.tr, QT_TR_NOOP("progmeasure61_guide1")
        ],//61-Cell optical

        [
            "<b>"+qsTr("progmeasure62_guide0")+"</b>"+translator.tr, QT_TR_NOOP("progmeasure62_guide1"), QT_TR_NOOP("progmeasure62_guide2")
        ],//62-Calibration interval

        [
            "<b>"+qsTr("progmeasure63_guide0")+"</b>"+translator.tr, QT_TR_NOOP("progmeasure63_guide1"), QT_TR_NOOP("progmeasure63_guide2")
        ],//63-Slope

        [
            "<b>"+qsTr("progmeasure64_guide0")+"</b>"+translator.tr, QT_TR_NOOP("progmeasure64_guide1"), QT_TR_NOOP("goto_3_1_1")
        ], //64-LED error
        [
            "<b>"+qsTr("progmeasure65_guide0")+"</b>"+translator.tr, QT_TR_NOOP("progmeasure65_guide1"), QT_TR_NOOP("progmeasure65_guide2"), QT_TR_NOOP("progmeasure65_guide3"), QT_TR_NOOP("goto_3_1_1")
        ], //65-heat out of control

    ]

    /*Connections {
        target: eventView
        ignoreUnknownSignals: true
        onGotoHelp: {
            listView.model.clear();
            var list = helpList[index];
            console.debug("QML::EventHelp")
            for(var i = 0; i < list.length; i++) {
                listView.model.append({"content": list[i]})
            }
        }
    }*/

    TextArea {
        id: textArea
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        height: 380
        width: 800-40
        textFormat: TextEdit.AutoText
        //text: "<b>Hello</b>"
        font: mainTheme.smallFont
        textColor: "black"
        activeFocusOnPress: false
        //selectByMouse: false
        readOnly: true

        onLinkActivated: {
            console.debug("QML::HelpPage onLinkActivated: "+link);
            Qt.openUrlExternally()
            if(link.substring(0, 5) === "goto_")
            {
                var codes = link.split('_');
                if(codes.length === 4) {
                    mainNaviPage.navigate(codes[1], codes[2], codes[3]); // goto reagent page
                    //console.debug("QML::help:"+link);
                }
            }
        }

        style: TextAreaStyle {

            textColor: "#333"
            selectionColor: "steelblue"
            selectedTextColor: "#eee"
            backgroundColor: "white"

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
                //color: styleData.pressed ? "#9e9e9e" : "#f2f2f2"
                border.width: Flat.FlatStyle.onePixel
                border.color: Flat.FlatStyle.lightFrameColor
                //Rectangle {
                //    color: styleData.pressed ? "#9e9e9e" : "#e4e4e4"
                //    anchors.fill: parent
                //    anchors.topMargin: 6
                //    anchors.leftMargin: 4
                //    anchors.rightMargin: 4
                //    anchors.bottomMargin: 6
                //    //border.width: 1
                //    //border.color: "black"
                //}
            }
            incrementControl: Rectangle {
                implicitWidth: 40
                implicitHeight: 40
                border.width: Flat.FlatStyle.onePixel
                border.color: Flat.FlatStyle.lightFrameColor
                //color: styleData.pressed ? "#9e9e9e" : "#f2f2f2"
                Text {
                    font: mainTheme.mediumIcon
                    color: "#3ebdf2"
                    text: "\ue643"
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            decrementControl: Rectangle {
                implicitWidth: 40
                implicitHeight: 40
                border.width: Flat.FlatStyle.onePixel
                border.color: Flat.FlatStyle.lightFrameColor
                //color: styleData.pressed ? "#9e9e9e" : "#f2f2f2"
                Text {
                    font: mainTheme.mediumIcon
                    color: "#3ebdf2"
                    text: "\ue644"
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            scrollBarBackground: Rectangle {
                implicitWidth: 40
                implicitHeight: 26
                color: "#f2f2f2"
            }
        }
    }

    function gotoHelp(index)
    {
        /*listView.model.clear();
        var list = helpList[index];
        console.debug("QML::EventHelp")
        for(var i = 0; i < list.length; i++) {
            listView.model.append({"content": list[i]})
        }*/

        textArea.text = "";

        var list = helpList[index];
        //console.debug("QML::EventHelp")

        if(list === undefined) return;

        for(var i = 0; i < list.length; i++) {
            var content = list[i];
            if(content.substring(0, 5) === "goto_")
            {
                textArea.append('<html><body><style type="text/css"></style><a href="'+qsTr(content)+'">'+qsTr("goto")+'</a></body></html>');
            } else if(content.substring(0, 4) === "qrc:") {
                textArea.append("<img src=\""+content+"\" />")
            } else {
                //var str = ""+content.match(/[^>]+?(?=<\/b>)/gi);
                //var trstr = qsTr(str);
                //content.replace(str, trstr);
                //console.debug("QML::HelpPage content:"+content);
                textArea.append("<body>"+qsTr(content)+"</body>");
            }
        }
        textArea.cursorPosition = 0;
        textArea.moveCursorSelection(0);
    }

    //Text {}
    /*ScrollView {
        id: scrollArea
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        height: 380
        width: 800-40
        frameVisible: false
        highlightOnFocus: true
        verticalScrollBarPolicy: Qt.ScrollBarAsNeeded

        ListView {
            id: listView
            property int focusIndex: 0

            model: ListModel {
            }

            delegate: Rectangle {
                color: {
                    var color = (index % 2 == 0) ? "#d3d3d3" : "white"
                    if(listView.focusIndex == index) {
                        //color = "#3ebdf2";
                    }
                    return color;
                }
                width: 800-40
                height: 40
                Text {
                    id: helpText
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    text: content.substring(0, 5) === "goto_" ? qsTr("goto") : qsTr(content)
                    color: content.substring(0, 5) === "goto_" ? "#0098db" : "black"
                    font: mainTheme.smallFont
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        listView.focusIndex = index;
                        if(content.substring(0, 5) === "goto_")
                        {
                            var codes = content.split('_');
                            if(codes.length === 4) {
                                mainNaviPage.navigate(codes[1], codes[2], codes[3]); // goto reagent page
                                console.debug("QML::help:"+helpText.text.substring());
                            }
                        }
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
                //Rectangle {
                //    color: styleData.pressed ? "#9e9e9e" : "#e4e4e4"
                //    anchors.fill: parent
                //    anchors.topMargin: 6
                //    anchors.leftMargin: 4
                //    anchors.rightMargin: 4
                //    anchors.bottomMargin: 6
                //    //border.width: 1
                //    //border.color: "black"
                //}
            }
            incrementControl: Rectangle {
                implicitWidth: 40
                implicitHeight: 40
                border.width: Flat.FlatStyle.onePixel
                border.color: Flat.FlatStyle.lightFrameColor
                color: styleData.pressed ? "#9e9e9e" : "#f2f2f2"
                Text {
                    font: mainTheme.mediumIcon
                    color: "#3ebdf2"
                    text: "\ue643"
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            decrementControl: Rectangle {
                implicitWidth: 40
                implicitHeight: 40
                border.width: Flat.FlatStyle.onePixel
                border.color: Flat.FlatStyle.lightFrameColor
                color: styleData.pressed ? "#9e9e9e" : "#f2f2f2"
                Text {
                    font: mainTheme.mediumIcon
                    color: "#3ebdf2"
                    text: "\ue644"
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            scrollBarBackground: Rectangle {
                implicitWidth: 40
                implicitHeight: 26
                color: "#f2f2f2"
            }
        }
    }*/
}
