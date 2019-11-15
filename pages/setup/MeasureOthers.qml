/****************************************************************************
** MeasureOthers.qml - Interface for measure others setting
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
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.0
import "../../components"

Rectangle {
    id: measureOthers
    width: 800
    height: 420
    visible: true
    enabled: mainPermisMgr.editabled

    Connections {
        target: measure_others
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            console.debug("QML::UpdatePage measure.others")
            sampleDectSw.updateSampleDect();
            installPowerDrainSw.updateStatus();
            enablePowerDrainSw.updateStatus();
            customRangeUp.updateValue();
            page_manager.updatePageDone();
        }
    }

    Text {
        id: sampleDectText
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.top: parent.top
        anchors.topMargin: 10
        text: qsTr("Enable sample flow detection")+translator.tr
        font: mainTheme.titleFont
    }

    H2oSwitch {
        id: sampleDectSw
        anchors.left: sampleDectText.right
        anchors.leftMargin: 10
        anchors.verticalCenter: sampleDectText.verticalCenter
        onValueChanged: {
            measure_others.setObj("sample_detect", checked)
        }

        function updateSampleDect() {
            checked = measure_others.getObjInt("sample_detect");
        }
    }

    Text {
        id:  installPowerDrainText
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.top: sampleDectSw.bottom
        anchors.topMargin: 30
        text: qsTr("Install power drain")+translator.tr
        font: mainTheme.titleFont
    }

    H2oSwitch {
        id: installPowerDrainSw
        anchors.left: installPowerDrainText.right
        anchors.leftMargin: 10
        anchors.verticalCenter: installPowerDrainText.verticalCenter
        onValueChanged: {

            if(checked)
            {
                measure_others.setObj("pwrdrain_install", checked);
            }
            else
            {
                mainMessageDialogTwoButton.openDialog("reminder",
                   qsTr("The uninstallation of power drain will reset the lifespan of pump tube, do you want to apply it.") + translator.tr)
                mainMessageDialogTwoButton.parentItem = installPowerDrainSw;


            }

            mainPowerDrain.installed = installPowerDrainSw.checked;
            enablePowerDrainSw.updateStatus();
        }

        function updateStatus()
        {
            installPowerDrainSw.checked = measure_others.getObjBool("pwrdrain_install");
            mainPowerDrain.installed = installPowerDrainSw.checked;
        }

        function accept()
        {
            measure_others.clearObjTList();
            measure_others.addObjToTList("pwrdrain_install", 0);
            measure_others.addObjToTList("pwrdrain_enable", 0);
            prognosys_service.clearObjTList();
            prognosys_service.addObjToTList("pdrain_tube", 365);
            page_manager.startSetPageList(["measure.others", "prognosys.service"]);
        }

        function reject()
        {

        }
    }

    Text {
        id:  enablePowerDrainText
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.top: installPowerDrainSw.bottom
        anchors.topMargin: 30
        text: qsTr("Enable power drain")+translator.tr
        font: mainTheme.titleFont
    }

    H2oSwitch {
        id: enablePowerDrainSw
        anchors.left: enablePowerDrainText.right
        anchors.leftMargin: 10
        anchors.verticalCenter: enablePowerDrainText.verticalCenter
        onValueChanged: {
            measure_others.setObj("pwrdrain_enable", checked);
            mainPowerDrain.enabled = checked;
            if(checked) {
                mainMessageDialogOneButton.openDialog("reminder",
                         qsTr("Please disable sample cleaning in calibration setup and clean setup when power drain is enabled."));
            }
        }

        function updateStatus()
        {
            if(installPowerDrainSw.checked)
            {
                enablePowerDrainSw.enabled = true;
                enablePowerDrainSw.checked = measure_others.getObjBool("pwrdrain_enable");
            }
            else
            {
                enablePowerDrainSw.checked = false;
                enablePowerDrainSw.enabled = false;
            }

            mainPowerDrain.enabled = enablePowerDrainSw.checked;
        }
    }

    Text {
        id: customRangeUpText
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.top: enablePowerDrainSw.bottom
        anchors.topMargin: 30
        text: qsTr("Upper limit of work range")+translator.tr
        font: mainTheme.titleFont
    }

    H2oTextField {
        id: customRangeUp
        anchors.left: customRangeUpText.left
        anchors.leftMargin: 10
        anchors.top: customRangeUpText.bottom
        anchors.topMargin: 10
        width: 200
        height: 40
        plaintext: text+" "+qsTr("mg/L")+translator.tr
        text: "0"

        onEditDone: {
            var numOrg = Number.fromLocaleString(Qt.locale(), inputStr);
            var num = numOrg.toFixed(3);

            if(measure_others.isInRange("range_up", num))
            {
                text = num;
                measure_others.setObj("range_up", num);
            } else {
                var range = measure_others.rangeString("range_up");
                mainMessageDialogOneButton.text = qsTr("Your input ")+numOrg+qsTr(" out of range")+translator.tr+range;
                mainMessageDialogOneButton.open();
                text = preText;
            }
        }

        function updateValue() {
            var textTime = measure_others.getObjFloat("range_up")
            text = Number(textTime).toFixed(3)
        }
    }

    /*Text {
        id: pretrementText
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.top: sampleDectSw.bottom
        anchors.topMargin: 10
        text: qsTr("Pretrement Delay Time")+translator.tr
        font: mainTheme.titleFont
    }

    H2oTextField {
        id: pretreatDelay
        anchors.left: pretrementText.left
        anchors.leftMargin: 10
        anchors.top: pretrementText.bottom
        anchors.topMargin: 10
        width: 200
        height: 40
        plaintext: text+" "+qsTr("seconds")+translator.tr
        text: "0"

        onEditDone: {
            var numOrg = Number.fromLocaleString(Qt.locale(), inputStr);
            var num = numOrg.toFixed(0);

            if(io_spdt.isInRange("ch1pretreat", num))
            {
                text = num;
                io_spdt.setObj("ch1pretreat", num);
            } else {
                var range = io_spdt.rangeString("ch1pretreat");
                mainMessageDialogOneButton.text = qsTr("Your input ")+numOrg+qsTr(" out of range")+translator.tr+range;
                mainMessageDialogOneButton.open();
                text = preText;
            }
        }

        function updatePretreat() {
            var textTime = io_spdt.getObjInt("ch1pretreat")
            text = Number(textTime).toString()
        }
    }*/
}



