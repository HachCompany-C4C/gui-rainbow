/****************************************************************************
** DiagnosisMenu.qml - Diagnosis menu
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
import "diagnosis"

Rectangle {
    id: list

    objectName: "diagnosis menu"
    property string title: qsTr("Diagnosis Menu")+translator.tr
    property alias subNaviPage: naviPage

    x: 0
    y: 0
    width: 550
    height: 420

    H2oNavigationSubView {
        id: naviPage
        viewList: [
            EventView {},
            SettingsDiagnosis {}
        ]

        listName: [
            qsTr("Diagnosis View")+translator.tr,
            qsTr("Diagnosis Settings")+translator.tr,
        ]

        listModel: ListModel {
            ListElement { index: 0; source: "\ue601"; pageName: "notification.error" }
            ListElement { index: 1; source: "\ue601"; pageName: "" }
            //ListElement { index: 1; source: "\ue601"; pageName: "mask/notification.error" }
            //ListElement { index: 2; source: "\ue601"; pageName: "notification.concentration" }
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

            property var listName: [qsTr("Event View")+translator.tr,
                            qsTr("Event Mask Settings")+translator.tr,
            ]
            anchors.fill: parent

            model: ListModel {
                id: listModel
                ListElement { index: 0; source: "\ue601"; pageName: "notification.error" }
                ListElement { index: 1; source: "\ue601"; pageName: "mask/notification.error" }
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


