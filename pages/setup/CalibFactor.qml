/****************************************************************************
** CalibFactor.qml - Interface for setting factor and offset
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
    objectName: "advanced_service"

    enabled: mainPermisMgr.editabled

    Connections {
        target: measure_bias
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            console.debug("QML::UpdatePage measure.bias")
            factorULR.updateULRFactor();
            offsetULR.updateULROffset();
            factorLR.updateLRFactor();
            offsetLR.updateLROffset();
            factorMR.updateMRFactor();
            offsetMR.updateMROffset();
            factorHR.updateHRFactor();
            offsetHR.updateHROffset();
            textHR.updateVisable();

            page_manager.updatePageDone();
        }
    }

    signal debugMessage(string message, string operate)

    Text {
        id: factorOffsetText
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.top: parent.top
        anchors.topMargin: 10
        text: qsTr("Factor & Offset")+translator.tr
        font: mainTheme.titleFont
    }

    GridLayout {
        anchors.left: factorOffsetText.left
        anchors.leftMargin: 10
        anchors.top: factorOffsetText.bottom
        anchors.topMargin: 10
        columns: 3
        columnSpacing: 10
        Text {
            x: 371
            y: 20
            text: qsTr("Range")+translator.tr
            font: mainTheme.smallFont
        }

        Rectangle {
            width: 190
            height: 32
            Text {
                text: qsTr("Factor")+translator.tr
                anchors.left: parent.left
                anchors.leftMargin: 10
                font: mainTheme.smallFont
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }

        Rectangle {
            width: 190
            height: 32
            Text {
                text: qsTr("Offset")+translator.tr
                anchors.left: parent.left
                anchors.leftMargin: 10
                font: mainTheme.smallFont
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }

        // ULR Factor Offset
        Text {
            x: 32
            y: 61
            text: qsTr("ULR 0.02~15 mg/L")+translator.tr
            font: mainTheme.smallFont
        }

        H2oTextField {
            id: factorULR
            x: 117
            y: 52
            width: 190
            plaintext: text

            onEditDone: {
                var numOrg = Number.fromLocaleString(Qt.locale(), inputStr);
                var num = numOrg.toFixed(3);

                if(measure_bias.isInRange("ulr_factor", num))
                {
                    text = num;
                    measure_bias.setObj("ulr_factor", num);
                } else {
                    var range = measure_bias.rangeString("ulr_factor");
                    mainMessageDialogOneButton.text = qsTr("Your input ")+numOrg+qsTr(" out of range")+translator.tr+range;
                    mainMessageDialogOneButton.open();
                    text = preText;
                }
            }

            function updateULRFactor() {
                var num = measure_bias.getObjFloat("ulr_factor");
                text = Number(num).toFixed(3);
            }
        }

        H2oTextField {
            id: offsetULR
            x: 347
            y: 52
            width: 190
            plaintext: text

            onEditDone: {

                var numOrg = Number.fromLocaleString(Qt.locale(), inputStr);
                var num = numOrg.toFixed(3);

                if(measure_bias.isInRange("ulr_offset", num))
                {
                    text = num;
                    measure_bias.setObj("ulr_offset", num);
                } else {
                    var range = measure_bias.rangeString("ulr_offset");
                    mainMessageDialogOneButton.text = qsTr("Your input ")+numOrg+qsTr(" out of range")+translator.tr+range;
                    mainMessageDialogOneButton.open();
                    text = preText;
                }
            }

            function updateULROffset() {
                var num = measure_bias.getObjFloat("ulr_offset");
                text = Number(num).toFixed(3);
            }
        }


        // LR Factor Offset
        Text {
            x: 32
            y: 116
            text: qsTr("LR 0.05~30 mg/L")+translator.tr
            font: mainTheme.smallFont
        }

        H2oTextField {
            id: factorLR
            x: 117
            y: 107
            width: 190
            plaintext: text

            onEditDone: {
                var numOrg = Number.fromLocaleString(Qt.locale(), inputStr);
                var num = numOrg.toFixed(3);

                if(measure_bias.isInRange("lr_factor", num))
                {
                    text = num;
                    measure_bias.setObj("lr_factor", num);
                } else {
                    var range = measure_bias.rangeString("lr_factor");
                    mainMessageDialogOneButton.text = qsTr("Your input ")+numOrg+qsTr(" out of range")+translator.tr+range;
                    mainMessageDialogOneButton.open();
                    text = preText;
                }
            }

            function updateLRFactor() {
                var num = measure_bias.getObjFloat("lr_factor");
                text = Number(num).toFixed(3);
            }
        }

        H2oTextField {
            id: offsetLR
            x: 347
            y: 107
            width: 190
            plaintext: text
            onEditDone: {
                var numOrg = Number.fromLocaleString(Qt.locale(), inputStr);
                var num = numOrg.toFixed(3);

                if(measure_bias.isInRange("lr_offset", num))
                {
                    text = num;
                    measure_bias.setObj("lr_offset", num);
                } else {
                    var range = measure_bias.rangeString("lr_offset");
                    mainMessageDialogOneButton.text = qsTr("Your input ")+numOrg+qsTr(" out of range")+translator.tr+range;
                    mainMessageDialogOneButton.open();
                    text = preText;
                }
            }

            function updateLROffset() {
                var num = measure_bias.getObjFloat("lr_offset");
                text = Number(num).toFixed(3);
            }
        }

        // MR Factor Offset
        Text {
            x: 32
            y: 167
            text: qsTr("MR 7.5~100 mg/L")+translator.tr
            font: mainTheme.smallFont
        }

        H2oTextField {
            id: factorMR
            x: 117
            y: 158
            width: 190
            plaintext: text
            onEditDone: {
                var numOrg = Number.fromLocaleString(Qt.locale(), inputStr);
                var num = numOrg.toFixed(3);

                if(measure_bias.isInRange("mr_factor", num))
                {
                    text = num;
                    measure_bias.setObj("mr_factor", num);
                } else {
                    var range = measure_bias.rangeString("mr_factor");
                    mainMessageDialogOneButton.text = qsTr("Your input ")+numOrg+qsTr(" out of range")+translator.tr+range;
                    mainMessageDialogOneButton.open();
                    text = preText;
                }
            }

            function updateMRFactor() {
                var num = measure_bias.getObjFloat("mr_factor");
                text = Number(num).toFixed(3);
            }
        }

        H2oTextField {
            id: offsetMR
            x: 347
            y: 158
            width: 190
            plaintext: text
            onEditDone: {
                var numOrg = Number.fromLocaleString(Qt.locale(), inputStr);
                var num = numOrg.toFixed(3);

                if(measure_bias.isInRange("mr_offset", num))
                {
                    text = num;
                    measure_bias.setObj("mr_offset", num);
                } else {
                    var range = measure_bias.rangeString("mr_offset");
                    mainMessageDialogOneButton.text = qsTr("Your input ")+numOrg+qsTr(" out of range")+translator.tr+range;
                    mainMessageDialogOneButton.open();
                    text = preText;
                }
            }

            function updateMROffset() {
                var num = measure_bias.getObjFloat("mr_offset");
                text = Number(num).toFixed(3);
            }
        }

        // HR Factor Offset
        Text {
            id: textHR
            x: 32
            y: 218
            text: qsTr("HR 80~1000 mg/L")+translator.tr
            font: mainTheme.smallFont
            visible: false
            property bool inited: false

            function updateVisable()
            {
                if(inited === false)
                {
                    inited = true;
                    var instrType = system_info.getObjInt("instr_type");
                    if(instrType === 1) //extended type
                    {
                        textHR.visible = true;
                        factorHR.visible = true;
                        offsetHR.visible = true;
                    }
                }
            }
        }

        H2oTextField {
            id: factorHR
            x: 117
            y: 209
            width: 190
            visible: false
            plaintext: text
            onEditDone: {
                var numOrg = Number.fromLocaleString(Qt.locale(), inputStr);
                var num = numOrg.toFixed(3);

                if(measure_bias.isInRange("hr_factor", num))
                {
                    text = num;
                    measure_bias.setObj("hr_factor", num);
                } else {
                    var range = measure_bias.rangeString("hr_factor");
                    mainMessageDialogOneButton.text = qsTr("Your input ")+numOrg+qsTr(" out of range")+translator.tr+range;
                    mainMessageDialogOneButton.open();
                    text = preText;
                }
            }

            function updateHRFactor() {
                var num = measure_bias.getObjFloat("hr_factor");
                text = Number(num).toFixed(3);
            }
        }



        H2oTextField {
            id: offsetHR
            x: 347
            y: 209
            width: 190
            visible: false
            plaintext: text
            onEditDone: {
                var numOrg = Number.fromLocaleString(Qt.locale(), inputStr);
                var num = numOrg.toFixed(3);

                if(measure_bias.isInRange("hr_offset", num))
                {
                    text = num;
                    measure_bias.setObj("hr_offset", num);
                } else {
                    var range = measure_bias.rangeString("hr_offset");
                    mainMessageDialogOneButton.text = qsTr("Your input ")+numOrg+qsTr(" out of range")+translator.tr+range;
                    mainMessageDialogOneButton.open();
                    text = preText;
                }
            }

            function updateHROffset() {
                var num = measure_bias.getObjFloat("hr_offset");
                text = Number(num).toFixed(3);
            }
        }
    }
}
