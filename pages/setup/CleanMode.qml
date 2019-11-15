/****************************************************************************
** CleanMode.qml - Interface for clean mode setting
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

    enabled: mainPermisMgr.editabled

    Connections {
        target: cleaning_mode
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            console.debug("QML::UpdatePage cleaning.mode")
            listView.updateIndex();

            page_manager.updatePageDone();
        }
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

    H2oExclusiveGroup {
        id: tabGroup
    }

    ListView {
        id: listView
        anchors.left: modeText.left
        anchors.leftMargin: 10
        anchors.top: modeText.bottom
        anchors.topMargin: 5
        width: 218
        height: 400
        boundsBehavior: Flickable.StopAtBounds
        scale: 1
        cacheBuffer: 200
        contentHeight: 1144
        snapMode: ListView.SnapToItem
        flickableDirection: Flickable.VerticalFlick
        spacing: 5
        property var listName: [
            qsTr("None")+translator.tr,
            qsTr("Flush")+translator.tr,
            qsTr("Calibration")+translator.tr
        ]

        model: ListModel {
            ListElement { name: qsTr("None"); check: false; index: 0 }
            ListElement { name: qsTr("Flush"); check: false; index: 1 }
            ListElement { name: qsTr("Calibration"); check: false; index: 2 }
        }

        delegate: H2oLineRadioButton {
            text: listView.listName[index]
            checked: check
            exclusiveGroup: tabGroup
            onValueChanged: {
                cleaning_mode.setObj("post", index);
            }
        }

        function updateIndex()
        {
            var i = cleaning_mode.getObjInt("post");
            //listView.model.setProperty(i, "check", true);
            listView.contentItem.children[i].checked = true;
        }
    }
}
