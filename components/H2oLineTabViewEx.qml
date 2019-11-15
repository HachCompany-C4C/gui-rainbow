/****************************************************************************
** H2oLineTabViewEx.qml
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
import QtQuick.Controls.Styles.Flat 1.0 as Flat
import "../pages/setup"

Item {
    id: root
    width: 800
    height: 420
    property ListModel model
    property int currentIndex : 0
    property list<Item> viewList
    property var titleList
    property bool tabButtonPosition: true // on top
    property int tabButtonHeight: 50
    property int tabButtonWidth: 180
    property bool tabEnabled: true
    opacity: enabled ? 1.0 : 0.4

    function switchPage(index) {
        var count = model.rowCount();
        if(index < count) {
            root.currentIndex = index;
        }
    }

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
        anchors.left: parent.left
        anchors.leftMargin: 30
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
                enabled: tabEnabled
                onCheckedChanged: {
                    //console.debug("QML::H2oTabView index "+index+" "+check)
                }

                style: RadioButtonStyle {
                    indicator: Rectangle {
                        implicitWidth: 0
                        implicitHeight: parent.height
                    }
                    label: Component {
                        Rectangle {
                            implicitWidth: tabButtonWidth
                            implicitHeight: tabButtonHeight

                            Rectangle {
                                anchors.fill: parent
                                visible: true
                                //color: radioButton.checked ? "#0098db" : "#f2f2f2"
                                anchors.margins: 0
                                Text {
                                    anchors.centerIn: parent
                                    text: qsTr(name)+translator.tr
                                    font: mainTheme.smallFont
                                    color: radioButton.checked ? "black" : "#0098db"
                                }
                            }

                            Rectangle {
                                anchors.bottom: parent.bottom
                                implicitWidth: parent.width
                                implicitHeight: 6
                                color: radioButton.checked ? "#0098db" : "white"
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
        width: parent.width - 60
        height: Flat.FlatStyle.onePixel
        anchors.bottom: row.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        //anchors.left: parent.left
        //anchors.right: parent.right
        //anchors.margins: 15
        color: Flat.FlatStyle.lightFrameColor
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
