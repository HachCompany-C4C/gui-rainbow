/****************************************************************************
** ServiceMenu.qml - Service menu
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

Rectangle {
    id: list

    objectName: "service_menu"
    property string title: qsTr("Service Menu")+translator.tr
    property alias subNaviPage: naviPage

    width: 550
    height: 420

    H2oNavigationSubView {
        id: naviPage
        viewList: [
            SignalService {},
            SoftwareService {},
            MaintenanceService {},
            AdvancedService {},
            SystemService {}
        ]

        listName: [
            qsTr("Signals")+translator.tr,
            qsTr("Software Update")+translator.tr,
            qsTr("Maintenance")+translator.tr,
            qsTr("Advanced")+translator.tr,
            qsTr("System Info")+translator.tr
        ]

        listModel: ListModel {
            ListElement { index: 0; source: "\ue618"; pageName: "" }
            ListElement { index: 1; source: "\ue618"; pageName: "" }
            ListElement { index: 2; source: "\ue618"; pageName: "" }
            ListElement { index: 3; source: "\ue618"; pageName: "" }
            ListElement { index: 4; source: "\ue618"; pageName: "" }
        }
    }

    /*Rectangle {
        anchors.fill: parent
        color: "#e0e0e0"

        ListView {
            id: listView
            boundsBehavior: Flickable.StopAtBounds
            anchors.bottomMargin: 3
            anchors.topMargin: 0
            scale: 1
            anchors.rightMargin: 3
            cacheBuffer: 200
            contentHeight: 1144
            anchors.fill: parent
            snapMode: ListView.SnapToItem

            property var listName: [qsTr("Signals")+translator.tr,
                            qsTr("System Info")+translator.tr,
                            qsTr("Software Update")+translator.tr,
                            qsTr("Maintenance")+translator.tr,
                            qsTr("Advanced")+translator.tr]

            model: ListModel {
                id: listModel
                ListElement { name: qsTr("Signals"); index: 0; source: "\ue618" }
                ListElement { name: qsTr("System Info"); index: 1; source: "\ue618" }
                ListElement { name: qsTr("Software Update"); index: 2; source: "\ue618" }
                ListElement { name: qsTr("Maintenance"); index: 3; source: "\ue618" }
                ListElement { name: qsTr("Advanced"); index: 4; source: "\ue618" }
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


