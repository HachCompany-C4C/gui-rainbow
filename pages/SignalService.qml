/****************************************************************************
** SignalService.qml - Signal tab menu
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

Rectangle {
    id: root
    objectName: "signal_service"
    property string title: qsTr("Signals")+translator.tr
    property alias pageTabView: tabView
    width: 800
    property var pageName: [
        "status.page1",
        "status.page2",
        "status.page3"
    ]

    property list<Item> tabList: [
        MeasureSample { width: 800},
        MechanicalComponent {},
        LeakagePower {}
    ]

    property var tabTitles: [
        qsTr("Measure Signals")+translator.tr,
        qsTr("Flow Path Actions")+translator.tr,
        qsTr("Others")+translator.tr
    ]

    Connections {
        target: mainStackView
        onCurrentItemChanged: {
            if(mainStackView.currentItem) {
                var objName = mainStackView.currentItem.objectName
                if(objName.length > 0) {
                    var pageName = mainStackView.currentItem.objectName;
                    if(pageName == "signal_service") {
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
            ListElement { name: "Page1"; check: true }
            ListElement { name: "Page2"; check: false }
            ListElement { name: "Page3"; check: false }
        }

        viewList: tabList
        titleList: tabTitles
        onCurrentIndexChanged: {
            page_manager.startUpdate(root.pageName[tabView.currentIndex])
        }
    }
}
