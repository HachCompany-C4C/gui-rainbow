/****************************************************************************
** ProgSettings.qml - entry for prognosys setting and view
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
import "../../components"

Rectangle {
    id: root
    objectName: "prog settings"
    property string title: qsTr("Prognosys Settings")+translator.tr
    width: 800

    enabled: mainPermisMgr.editabled

    property var pageName: [
        ""
        //""
    ]

    property list<Item> tabList: [
        ProgGeneralSettings {width: 800}
        //ProgServiceSettings {}
    ]

    property var tabTitles: [
        qsTr("General Setting")+translator.tr
        //qsTr("Service Indicator")+translator.tr,
    ]

    Connections {
        target: mainStackView
        onCurrentItemChanged: {
            if(mainStackView.currentItem) {
                var objName = mainStackView.currentItem.objectName
                if(objName.length > 0) {
                    var pageName = mainStackView.currentItem.objectName;
                    if(pageName == "prog settings") {
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
            ListElement { name: ""; check: true }
            //ListElement { name: ""; check: false }
        }

        viewList: tabList
        titleList: tabTitles
        onCurrentIndexChanged: {
            page_manager.startUpdate(root.pageName[tabView.currentIndex])
        }
    }
}
