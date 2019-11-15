/****************************************************************************
** Test.qml - UI for list table of test
**
** Created on: 2017-10-31
**
** Author:
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
//import QtQuick.Controls.Styles.Flat 1.0 as Flat
import "../../content"


Rectangle {
    id: list
    objectName: "test_page"
    property string title: qsTr("Test")+translator.tr
    property list<Item> testPageList : [
            TestIO {},
            TestPV {},
            TestMH {},
            TestAD {},
            TestSubstep {}
    ]
    x: 0
    y: 0
    width: 800
    height: 360

    enabled: mainPermisMgr.editabled

    Rectangle {
        x: 0
        y: 0
        width: 800
        height: 360
        color: "white"

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

            property var listName: [qsTr("IO")+translator.tr,
                            qsTr("Pump & Valve")+translator.tr,
                            qsTr("Mixer & Heating")+translator.tr,
                            qsTr("AD Adjust")+translator.tr,
                            qsTr("Substep")+translator.tr
            ]
            height: 360

            model: ListModel {
                id: listModel
                ListElement { name: "test.io"; index: 0; source: ""}
                ListElement { name: "test.pv"; index: 1; source: ""}
                ListElement { name: "test.mh"; index: 2; source: "" }
                ListElement { name: "test.ad"; index: 3; source: ""}
                ListElement { name: "test.substep"; index: 4; source: ""}
            }

            delegate: TestListItem {
                width: 800
                height: 64
                text: listView.listName[index]
                imageSource: source

                onClicked: {
                    mainStackView.push({item: testPageList[index], immediate: true})
                    page_manager.startUpdate(name)
                }
            }
        }

        StackView {
            id: listStackView
            x: 0
            y: 0
            width: 800
            height: parent.height
        }
    }
}






