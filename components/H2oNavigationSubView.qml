/****************************************************************************
** H2oNavigationSubView.qml
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
    id: root
    anchors.fill: parent
    color: "#e0e0e0"

    property list<Item> viewList
    property var listName
    property var listModel
    property int currentIndex: 0

    function entryItemPage(index) {
        if(index < listModel.rowCount()) {
            root.currentIndex = index;
            mainStackView.push({item: viewList[index], immediate: true });
            var pageName = listModel.get(index).pageName;
            if(pageName !== undefined) {
                page_manager.startUpdate(pageName);
            }
        }
    }

    ListView {
        id: listView
        anchors.fill: parent
        boundsBehavior: Flickable.StopAtBounds
        scale: 1
        cacheBuffer: 200
        contentHeight: 1144
        snapMode: ListView.SnapToItem
        model: root.listModel

        delegate: H2oNavigationSubItem {
            width: parent.width
            text: root.listName[index]
            imageSource: source

            onClicked: {
                mainStackView.push({item: root.viewList[index], immediate: true})
                root.currentIndex = index;
                if(pageName != "") {
                    page_manager.startUpdate(pageName);
                }
            }
        }
    }
}



