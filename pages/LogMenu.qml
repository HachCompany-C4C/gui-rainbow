/****************************************************************************
** LogMenu.qml - Log menu
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
import "history"

Rectangle {
    id: list

    objectName: "log menu"
    property string title: qsTr("Log Menu")+translator.tr
    property alias mainLogDefinition: logDefinition
    property alias subNaviPage: naviPage

    x: 0
    y: 0
    width: 550
    height: 420

    LogDefinition {
        id: logDefinition
    }

    H2oNavigationSubView {
        id: naviPage
        viewList: [
            QueryLog {},
            ExportLog {}
        ]

        listName: [
            qsTr("View Log")+translator.tr,
            qsTr("Export Log")+translator.tr
        ]

        listModel: ListModel {
            ListElement { index: 0; source: "\ue601"; pageName: "" }
            ListElement { index: 1; source: "\ue601"; pageName: "" }
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
                qsTr("View Log")+translator.tr,
                qsTr("Export Log")+translator.tr
            ]
            anchors.fill: parent

            model: ListModel {
                id: listModel
                ListElement { index: 0; source: "\ue601" }
                ListElement { index: 1; source: "\ue601" }
            }

            delegate: H2oNavigationSubItem {
                width: parent.width
                text: listView.listName[index]
                imageSource: source

                onClicked: {
                    mainStackView.push({item: viewList[index], immediate: true})
                }
            }
        }
    }*/
}


