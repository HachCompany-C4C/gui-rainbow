/****************************************************************************
** SettingsDiagnosis.qml - Diagnosis settings menu
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

import QtQuick 2.1
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.0
import "../content"
import "service"
import "../components"
import "diagnosis"

Rectangle {
    id: root
    objectName: "settings_diagnosis"
    property string title: qsTr("Diagnosis Settings")+translator.tr
    property alias pageTabView: tabView
    width: 800
    property var pageName: [
        "mask/notification.error",
        "notification.concentration"
    ]

    property list<Item> tabList: [
        MaskSettings {},
        LimitSettings {},
        ClearSettings {}
    ]

    property var tabTitles: [
        qsTr("Mask Settings")+translator.tr,
        qsTr("Limit Settings")+translator.tr,
        qsTr("Diagnosis Clear")+translator.tr
    ]

    Connections {
        target: mainStackView
        onCurrentItemChanged: {
            if(mainStackView.currentItem) {
                var objName = mainStackView.currentItem.objectName
                if(objName.length > 0) {
                    var pageName = mainStackView.currentItem.objectName;
                    if(pageName == "settings_diagnosis") {
                        page_manager.startUpdate(root.pageName[tabView.currentIndex])
                    }
                }
            }
        }
    }

    H2oLineTabView {
        id: tabView
        width: 800
        height: 420
        model: ListModel {
            ListElement { name: "Mask Settings"; check: true }
            ListElement { name: "Limit Settings"; check: false }
            ListElement { name: "Clear Settings"; check: false }
        }

        viewList: tabList
        titleList: tabTitles
        onCurrentIndexChanged: {
            page_manager.startUpdate(root.pageName[tabView.currentIndex])
        }
    }
}
