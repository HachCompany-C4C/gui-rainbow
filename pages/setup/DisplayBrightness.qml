/****************************************************************************
** DisplayBrightness.qml - Interface for backlight setting
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

    enabled: mainPermisMgr.editabled

    function updateData()
    {
        customizeTime.updateIndex();
        switchBtn.updateIndex();
    }

    Text {
        id: screenText
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.top: parent.top
        anchors.topMargin: 10
        font: mainTheme.titleFont
        text: qsTr("Enable screen off")+translator.tr
    }

    H2oSwitch {
        id: switchBtn
        anchors.left: screenText.left
        anchors.leftMargin: 10
        anchors.top: screenText.bottom
        anchors.topMargin: 10
        checked: backlight_setting.switchState()
        onValueChanged: {
            backlight_setting.setOnOff(switchBtn.checked);
            local_settings.setValue("system", "backlight", switchBtn.checked);
        }

        function updateIndex()
        {
            var hasSetting = false;
            var value = local_settings.getValueBool("system", "backlight", false);
            var checked = false;
            if(value !== undefined) {
                if(value === true) {
                    checked = true;
                } else if(value === false) {
                    checked = false;
                }

                hasSetting = true;
            }

            if(!hasSetting) {
                checked = false; //local setting default
                local_settings.setValue("system", "backlight", false);
            }

            switchBtn.checked = checked;
            backlight_setting.setOnOff(switchBtn.checked);
        }

        //Component.onCompleted: {
        //    updateIndex();
        //}
    }


    Text {
        id: turnofftimeText
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.top: switchBtn.bottom
        anchors.topMargin: 10
        text: qsTr("Turn off Time")+translator.tr
        font: mainTheme.titleFont
    }


    H2oTextField {
        id: customizeTime
        anchors.left: turnofftimeText.left
        anchors.leftMargin: 10
        anchors.top: turnofftimeText.bottom
        anchors.topMargin: 10
        width: 240
        enabled: switchBtn.checked
        text: backlight_setting.time()
        plaintext: text+" "+qsTr("minutes")+translator.tr
        onEditDone: {
            var num = Number.fromLocaleString(Qt.locale(), inputStr)
            text = Number(num).toFixed()
            backlight_setting.setTime(num);
            local_settings.setValue("system", "backlighttime", num);
        }

        function updateIndex()
        {
            var value = local_settings.getValueInt("system", "backlighttime", 2);

            text = value;
            backlight_setting.setTime(value);
        }
    }
}
