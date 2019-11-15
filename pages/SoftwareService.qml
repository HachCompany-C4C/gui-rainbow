/****************************************************************************
** SoftwareService.qml - Software service tab menu
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
    objectName: "software_service"
    property string title: qsTr("Software Update")+translator.tr
    property alias pageTabView: tabView
    width: 800
    property var pageName: [
        ""
    ]

    property list<Item> tabList: [
        FirmwareUpdate {}
    ]

    property var tabTitles: [
        qsTr("Software Update")+translator.tr,
    ]

    Connections {
        target: mainStackView
        onCurrentItemChanged: {
            if(mainStackView.currentItem) {
                var objName = mainStackView.currentItem.objectName
                if(objName.length > 0) {
                    var pageName = mainStackView.currentItem.objectName;
                    if(pageName == "software_service") {
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
            //ListElement { name: "Information"; check: true }
            ListElement { name: "Software Update"; check: true }
        }

        viewList: tabList
        titleList: tabTitles
        onCurrentIndexChanged: {
            //page_manager.startUpdate(root.pageName[tabView.currentIndex])
        }
    }
}
