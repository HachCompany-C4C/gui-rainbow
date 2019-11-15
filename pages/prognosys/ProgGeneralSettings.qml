/****************************************************************************
** ProgGeneralSettings.qml - UI for prognosys general settings
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
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.0
import "../../components"


Rectangle {
    id: root
    objectName: "prog general settings"
    property string title: qsTr("General Settings")+translator.tr
    width: 800
    height: 360

    Text {
        x: 32
        y: 31
        text: qsTr("Enable PROGNOSYS")+translator.tr
        font: mainTheme.titleFont
    }

    H2oSwitch {
        x: 41
        y: 70
        checked: mainPrognosysMgr.prognosysEnabled
        onClicked: {
            mainPrognosysMgr.prognosysEnabled = checked;
        }
    }
}
