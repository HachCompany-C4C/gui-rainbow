/****************************************************************************
** LogView.qml - UI for log view
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
import "../../content"
import "../setup"
import "../../components"

Rectangle {
    id: logTabView
    objectName: "log view"
    property string title: qsTr("Log View")+translator.tr
    width: 800

    property list<Item> tabList: [
        LogGraphic {width: 800},
        LogList {}
    ]

    property var tabTitles: [
        qsTr("GRAPHIC VIEW")+translator.tr,
        qsTr("LIST VIEW")+translator.tr,
    ]

    Connections {
        target: mainStackView
        onCurrentItemChanged: {
            if(mainStackView.currentItem) {
                var objName = mainStackView.currentItem.objectName
                if(objName.length > 0) {
                    var pageName = mainStackView.currentItem.objectName;
                    if(pageName == "log view") {
                        tabView.currentIndex = 1;
                    }
                }
            }
        }
    }

    H2oTabView {
        id: tabView
        width: 800
        height: 420
        signal tabToGraphicView()
        model: ListModel {
            ListElement { name: "Graphic View"; check: false }
            ListElement { name: "List View"; check: true }
        }

        viewList: tabList
        titleList: tabTitles
        onCurrentIndexChanged: {
            if(currentIndex == 0) {
                //console.debug("QML::LogView Change to Graphic View")
                tabToGraphicView();
            }
        }
    }

}
