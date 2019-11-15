/****************************************************************************
** SetupMenu.qml - Setup menu
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

    objectName: "setup menu"
    property string title: qsTr("Setup Menu")+translator.tr
    property alias subNaviPage: naviPage
    x: 0
    y: 0
    width: 550
    height: 420

    H2oNavigationSubView {
        id: naviPage
        viewList: [
            MeasureSetup {},
            CalibrationSetup {},
            CleaningSetup {},
            IOSetup {},
            SystemSetup {}
        ]

        listName: [
            qsTr("Measure")+translator.tr,
            qsTr("Calibration")+translator.tr,
            qsTr("Cleaning")+translator.tr,
            qsTr("IO/Com")+translator.tr,
            qsTr("System")+translator.tr
        ]

        listModel: ListModel {
            ListElement { index: 0; source: "\ue601"; pageName: "" }
            ListElement { index: 1; source: "\ue601"; pageName: "" }
            ListElement { index: 2; source: "\ue601"; pageName: "" }
            ListElement { index: 3; source: "\ue601"; pageName: "" }
            ListElement { index: 4; source: "\ue601"; pageName: "" }
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

            property var listName: [qsTr("Measure")+translator.tr,
                            qsTr("Calibration")+translator.tr,
                            qsTr("Cleaning")+translator.tr,
                            qsTr("IO/Com")+translator.tr,
                            qsTr("System")+translator.tr
            ]
            anchors.fill: parent

            model: ListModel {
                id: listModel
                ListElement { index: 0; source: "\ue601" }
                ListElement { index: 1; source: "\ue601" }
                ListElement { index: 2; source: "\ue601" }
                ListElement { index: 3; source: "\ue601" }
                ListElement { index: 4; source: "\ue601" }
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


