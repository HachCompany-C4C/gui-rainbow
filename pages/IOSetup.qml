/****************************************************************************
** IOSetup.qml - IO list
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
import "setup"
import "../components"

Rectangle {
    id: root
    objectName: "io_setup"
    property string title: qsTr("IO/Modbus")+translator.tr
    property alias pageTabView: tabView
    width: 800

    property var pageName: [
        "io.main",
        "io.modbus"
    ]

    property list<Item> tabList: [
        IOMainPage { width: 800},
        Communication {}
    ]

    property var tabTitles: [
        qsTr("IO List")+translator.tr,
        qsTr("Com")+translator.tr,
    ]

    Connections {
        target: mainStackView
        onCurrentItemChanged: {
            if(mainStackView.currentItem) {
                var objName = mainStackView.currentItem.objectName
                if(objName.length > 0) {
                    var pageName = mainStackView.currentItem.objectName;
                    if(pageName == "io_setup") {
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
            ListElement { name: "IO List"; check: true }
            ListElement { name: "Com"; check: false }
        }

        viewList: tabList
        titleList: tabTitles
        onCurrentIndexChanged: {
            page_manager.startUpdate(root.pageName[tabView.currentIndex])
        }
    }
}
