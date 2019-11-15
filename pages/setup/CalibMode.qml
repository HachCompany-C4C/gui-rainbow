/****************************************************************************
** CalibMode.qml - Interface for calibration mode setting
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

import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.0
import "../../components"

Rectangle {
    width: 800
    height: 420

    enabled: mainPermisMgr.editabled

    Connections {
        target: calibration_mode
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            console.debug("QML::UpdatePage calibration.mode")
            listView.updateIndex();
            postFlush.updatePostFlush();

            page_manager.updatePageDone();
        }
    }

    H2oExclusiveGroup {
        id: tabGroup
    }

    Text {
        id: modeText
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.top: parent.top
        anchors.topMargin: 10
        text: qsTr("Mode")+translator.tr
        font: mainTheme.titleFont
    }

    ListView {
        id: listView
        anchors.left: modeText.left
        anchors.leftMargin: 10
        anchors.top: modeText.bottom
        anchors.topMargin: 5
        width: 148
        height: 84
        boundsBehavior: Flickable.StopAtBounds
        scale: 1
        cacheBuffer: 200
        contentHeight: 1144
        snapMode: ListView.SnapToItem
        flickableDirection: Flickable.VerticalFlick
        spacing: 5
        property var listName: [
            qsTr("Standard")+translator.tr,
            qsTr("Profession")+translator.tr
        ]

        model: ListModel {
            ListElement { name: qsTr("Standard"); check: false; index: 0 }
            ListElement { name: qsTr("Profession"); check: false; index: 1 }
        }

        delegate: H2oLineRadioButton {
            text: listView.listName[index]
            checked: check
            exclusiveGroup: tabGroup
            onValueChanged: {
                calibration_mode.setObj("index", index);
            }
        }

        function updateIndex() {
            var i = calibration_mode.getObjInt("index");
            //listView.model.setProperty(i, "check", true);
            if(i <= 1) {
                listView.contentItem.children[i].checked = true;
            }
        }
    }

    Text {
        id: postActionText
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.top: listView.bottom
        anchors.topMargin: 20
        text: qsTr("Post Action")+translator.tr
        font: mainTheme.titleFont
    }

    Text {
        id: postFlushText
        anchors.left: postActionText.left
        anchors.leftMargin: 10
        anchors.top: postActionText.bottom
        anchors.topMargin: 20
        text: qsTr("Flush")+translator.tr
        font: mainTheme.smallFont
    }

    H2oSwitch {
        id: postFlush
        anchors.left: postFlushText.right
        anchors.leftMargin: 10
        anchors.verticalCenter: postFlushText.verticalCenter

        width: 75
        height: 40

        function updatePostFlush()
        {
            checked = calibration_mode.getObjBool("post");
        }

        onValueChanged: {
            calibration_mode.setObj("post", checked);
        }
    }
}
