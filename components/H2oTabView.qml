/****************************************************************************
** H2oTabView.qml
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
import "../pages/setup"

Item {
    id: root
    width: 800
    height: 420
    property ListModel model
    property int currentIndex : 0
    property list<Item> viewList
    property var titleList
    property bool tabButtonPosition: false // on bottom
    property int tabButtonHeight: 60

    onCurrentIndexChanged: {
        listStackView.push({item: viewList[root.currentIndex], immediate: true, replace: true })
        tabView.itemAt(root.currentIndex).checked = true;
    }

    H2oExclusiveGroup {
        id: tabGroup
    }

    // tab Button
    Row {
        id: row
        anchors.top: parent.top
        anchors.topMargin: tabButtonPosition ? 0 : parent.height - tabButtonHeight
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        height: tabButtonHeight
        anchors.horizontalCenterOffset: 0
        spacing: 0
        Repeater {
            id: tabView
            model: root.model
            delegate: RadioButton {
                id: radioButton
                exclusiveGroup: tabGroup
                checked: check
                onCheckedChanged: {
                    //console.debug("QML::H2oTabView index "+index+" "+check)
                }

                style: RadioButtonStyle {
                    indicator: Rectangle {
                        implicitWidth: 0
                        implicitHeight: row.height
                    }
                    label: Component {
                        Rectangle {
                            implicitWidth: (row.width/root.model.count)
                            implicitHeight: row.height

                            Rectangle {
                                anchors.fill: parent
                                visible: true
                                color: radioButton.checked ? "#0098db" : "#f2f2f2"
                                anchors.margins: 0
                                Text {
                                    anchors.centerIn: parent
                                    text: root.titleList[index]
                                    font: mainTheme.smallFont
                                    color: radioButton.checked ? "white" : "black"
                                }
                            }
                        }
                    }
                }
                onClicked: {
                    root.currentIndex = index;
                    listStackView.push({item: viewList[root.currentIndex], immediate: true, replace: true })
                    //console.debug("QML::TabView index: "+index)
                }
            }
        }
    }

    Rectangle {
        id: view
        anchors.top: parent.top
        anchors.topMargin: tabButtonPosition ? tabButtonHeight : 0
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        height: parent.height - tabButtonHeight

        StackView {
            id: listStackView
            anchors.fill: parent
            initialItem: viewList[0]
        }
    }
}
