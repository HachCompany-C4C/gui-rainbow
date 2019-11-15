/****************************************************************************
** H2oNavigationView.qml
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
    id: list
    width: parent.width / 3
    height: parent.height
    property list<Item> pageList
    property ListModel pageModel
    signal listClick(var name)
    property alias navListStackView: listStackView

    ListView {
        id: listView
        width: 200
        height: 420
        boundsBehavior: Flickable.StopAtBounds
        anchors.bottomMargin: 3
        anchors.topMargin: 0
        scale: 1
        anchors.rightMargin: 3
        cacheBuffer: 200
        contentHeight: 1144
        anchors.fill: parent
        model: pageModel
        snapMode: ListView.SnapToItem
        delegate: TestListItem {
            text: title
            onClicked: {
                listStackView.push({item: pageList[page], immediate: true, replace: true})
                //message.subTitleMessage = title
                listClick(name)
                //console.debug("TestListItem")
            }
        }

        Rectangle {
            width: parent.height
            height: 8 //* Flat.FlatStyle.scaleFactor
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
        }
    }

    StackView {
        id: listStackView
        x: list.width
        y: 0
        width: parent.width - list.width
        height: parent.height
        initialItem: pageList[0]
        //onCurrentItemChanged: message.subTitleMessage = pageModel.get(0).title
    }
}


