/****************************************************************************
** H2oNavigationButtons.qml
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

import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.2
import "../pages"

Item {
    width: 125 * 4
    height: 90
    opacity: enabled ? 1.0 : 0.4

    property list<Item> viewList: [
        PageSetup {},
        PageService {},
        PageHistory {},
        PageStatus {}
    ]

    /*ListView {
        id: listView
        width: 120
        height: (120+5)*4
        boundsBehavior: Flickable.StopAtBounds
        anchors.bottomMargin: 3
        anchors.topMargin: 0
        scale: 1
        anchors.rightMargin: 3
        cacheBuffer: 4
        contentHeight: 1144
        anchors.fill: parent
        spacing: 5
        model: ListModel {
            ListElement { name: qsTr("Settings"); index: 0 }
            ListElement { name: qsTr("Service"); index: 1 }
            ListElement { name: qsTr("Logs"); index: 2 }
            ListElement { name: qsTr("Diagnosis/Prognosys"); index: 3 }
        }

        delegate: H2oButton {
            id: btnDelegate
            width: 120
            height: 64
            text: name
            onClicked: {
                mainMessage.titleMessage = name
                mainStackView.push({ item: viewList[index], immediate: true })
            }
        }
    }*/

    GridView {
        id: menuView
        anchors.fill: parent
        cellWidth: 125
        cellHeight: 64+10
        boundsBehavior: Flickable.StopAtBounds

        model: ListModel {
            ListElement { name: "Settings"; index: 0; source: "\ue601"; subMenu: ""; subMenuIcon: ""; }
            ListElement { name: "Service"; index: 1; source: "\ue618"; subMenu: ""; subMenuIcon: ""; }
            ListElement { name: "Logs"; index: 2; source: "\ue603"; subMenu: "Filter"; subMenuIcon: "\uf054"; }
            ListElement { name: "Diagnosis/Prognosys"; index: 3; source: "\ue635"; subMenu: ""; subMenuIcon: ""; }
        }

        delegate: H2oToolButton {
            id: btnDelegate
            width: 120
            height: 64
            text: name
            icon: source
            onClicked: {
                message.subMenu = "MENU"
                message.subMenuTitle = subMenu
                message.subMenuIcon = subMenuIcon
                mainStackView.push({ item: viewList[index], immediate: true })                
            }
        }
    }

    /*
    Grid {
        id: buttonGrids
        spacing: 5
        columns: 1

        Button {
            id: setupButton
            width: 120
            height: 80
            text: qsTr("Setup")
            activeFocusOnPress: false
            transformOrigin: Item.Center
            style: ButtonStyle {
                label: Text {
                    renderType: Text.NativeRendering
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font: theme.mediumFont
                    color: "black"
                    text: control.text
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    mainMessage.titleMessage = qsTr("Setup")
                    mainStackView.push({item: setupView, immediate: true})
                }
            }

        }

        Button {
            id: statusButton
            width: 120
            height: 80
            text: qsTr("Status")
            style: ButtonStyle {
                label: Text {
                    renderType: Text.NativeRendering
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font: theme.mediumFont
                    color: "black"
                    text: control.text
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    mainMessage.titleMessage = qsTr("Status")
                    mainStackView.push({item: statusView, immediate: true})
                }
            }
        }

        Button {
            id: serviceButton
            width: 120
            height: 80
            text: qsTr("Service")
            style: ButtonStyle {
                label: Text {
                    renderType: Text.NativeRendering
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font: theme.mediumFont
                    color: "black"
                    text: control.text
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    mainMessage.titleMessage = qsTr("Service")
                    mainStackView.push({item: serviceView, immediate: true})
                }
            }
        }

        Button {
            id: historyButton
            width: 120
            height: 80
            text: qsTr("History")
            style: ButtonStyle {
                label: Text {
                    renderType: Text.NativeRendering
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font: theme.mediumFont
                    color: "black"
                    text: control.text
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    mainMessage.titleMessage = qsTr("History")
                    mainStackView.push({item: historyView, immediate: true})
                }
            }
        }
    }*/
}   // end of navigation buttons
