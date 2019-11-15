/****************************************************************************
** PrognosysMenu.qml - Prognosys menu
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

import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Controls.Styles.Flat 1.0 as Flat
import "../content"
import "../components"
import "prognosys"

Rectangle {
    id: list

    objectName: "prognosys menu"
    property string title: qsTr("Prognosys Menu")+translator.tr
    property alias subNaviPage: naviPage

    x: 0
    y: 0
    width: 550
    height: 420

    H2oNavigationSubView {
        id: naviPage
        viewList: [
            ProgSettings {},
            MeasureIndicator {},
            ServiceIndicator {}
        ]

        listName: [
            qsTr("PROGNOSYS Settings")+translator.tr,
            qsTr("Measure Indicator")+translator.tr,
            qsTr("Service Indicator")+translator.tr
        ]

        listModel: mainPrognosysMgr.prognosysEnabled ? enableModel : disableModel
        ListModel {
            id: enableModel
            ListElement { index: 0; source: "\ue601"; pageName: "" }
            ListElement { index: 1; source: "\ue601"; pageName: "prognosys.measure" }
            ListElement { index: 2; source: "\ue601"; pageName: "prognosys.service" }
        }

        ListModel {
            id: disableModel
            ListElement { index: 0; source: "\ue601"; pageName: "" }
        }
    }

    /*Rectangle {
        anchors.fill: parent
        color: "#e0e0e0"

        ListView {
            id: listView
            boundsBehavior: Flickable.StopAtBounds
            scale: 1
            cacheBuffer: 200
            contentHeight: 1144
            snapMode: ListView.SnapToItem

            property var listName: [
                qsTr("Prognosys")+translator.tr,
                qsTr("Prognosys")+translator.tr
            ]
            anchors.fill: parent

            model: ListModel {
                id: listModel
                ListElement { index: 0; source: "\ue601"; pageName: "notification.error" }
                ListElement { index: 0; source: "\ue601"; pageName: "notification.error" }
            }

            delegate: H2oNavigationSubItem {
                width: parent.width
                text: listView.listName[index]
                imageSource: source

                onClicked: {
                    mainStackView.push({item: viewList[index], immediate: true})
                    page_manager.startUpdate(pageName)
                }
            }
        }
    }*/
}


