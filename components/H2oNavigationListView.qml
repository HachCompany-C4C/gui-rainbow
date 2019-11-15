/****************************************************************************
** H2oNavigationListView.qml
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
//import QtQuick.Controls.Styles.Flat 1.0 as Flat
import "../content"

Item {
    id: root
    property list<Item> pageList
    property ListModel pageModel
    signal listClick(var name)
    property alias navListStackView: listStackView
    property var listName
    property int currentIndex: 0
    width: 800
    height: 420

    ExclusiveGroup {
        id: tabGroup
    }

    onCurrentIndexChanged: {
        listStackView.push({item: pageList[root.currentIndex], immediate: true, replace: true })
        listView.contentItem.children[root.currentIndex].checked = true;
    }

    ListView {
        id: listView
        x: 0
        width: 400
        height: 420
        boundsBehavior: Flickable.StopAtBounds
        scale: 1
        cacheBuffer: 200
        contentHeight: 1144
        model: pageModel
        snapMode: ListView.SnapToItem

        delegate: H2oNavigationItem {

            property ExclusiveGroup exclusiveGroup: tabGroup

            id: navigationItem
            text: listName[index]
            imageSource: source
            imageFont: imgFont
            color: checked ? "#e0e0e0" : "#f2f2f2"
            checked: check

            onExclusiveGroupChanged: {
                if(exclusiveGroup)
                    exclusiveGroup.bindCheckable(navigationItem)
            }

            onClicked: {
                checked = true;
                //listStackView.push({item: pageList[index], immediate: true, replace: true});
                listClick(name);
                currentIndex = index;
                //console.debug("QML::checked "+checked)
            }
        }

        /*Rectangle {
            width: 420
            height: 4 //* Flat.FlatStyle.scaleFactor
            rotation: 90
            anchors.left: parent.right
            transformOrigin: Item.TopLeft

            gradient: Gradient {
                GradientStop {
                    color: Qt.rgba(0, 0, 0, 0.15)
                    position: 0
                }
                GradientStop {
                    color: Qt.rgba(0, 0, 0, 0.05)
                    position: 0.5
                }
                GradientStop {
                    color: Qt.rgba(0, 0, 0, 0)
                    position: 1
                }
            }
        }*/
    }

    StackView {
        id: listStackView
        y: 0
        width: 400
        height: 420
        anchors.left: listView.right
        anchors.leftMargin: 0
        initialItem: pageList[0]
        //onCurrentItemChanged: message.subTitleMessage = pageModel.get(0).title
    }
}


