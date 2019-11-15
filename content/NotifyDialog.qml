/****************************************************************************
** NotifyDialog.qml - Notify dialog
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
import "../components"
import "time.js" as TimeScript

Item {
    id: root
    width: 800

    property int notifyLevelPre: 0
    property var typeTextLocal : ["",
                    QT_TR_NOOP("Reminder"),
                    QT_TR_NOOP("Warning"),
                    QT_TR_NOOP("Error")
    ]

    Connections {
        target: mainEventModel
        ignoreUnknownSignals: true
        onEventUpdated: {
            updateEventModel();
        }
    }

    Connections {
        target: mainStackView
        onCurrentItemChanged: {
            if(mainStackView.currentItem) {
                var objName = mainStackView.currentItem.objectName
                if(objName.length > 0) {
                    var pageName = mainStackView.currentItem.objectName;
                    if(pageName != "home page") {
                        dropIcon.opened = false;
                    }
                }
            }
        }
    }

    // error dialog
    H2oNotifyDialog {
        id: notifyDialog
        x: 0
        y: 0
        width: 800
        height: tableView.width
        visible: mainEventModel.isEventExist && (mainStackView.depth <= 1 && dropIcon.opened)

        H2oTableView {
            id: tableView
            x: 0
            y: 100
            width: 800
            height: 320

            verticalScrollBarPolicy: 0
            highlightOnFocus: false
            headerVisible: false
            alternatingRowColors: false
            //backgroundVisible: false
            frameVisible: false

            TableViewColumn {
                role: "icon"
                title: ""
                width: 50
                resizable: false
                movable: false
                delegate: Rectangle {
                    Text {
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: styleData.textAlignment
                        anchors.leftMargin: 12
                        text: styleData.value !== undefined ? styleData.value : ""
                        font: mainTheme.textFont
                        color: {
                            if(styleData.value === "\ue631") {
                                return "#ee5353"
                            } else if(styleData.value === "\ue627") {
                                return "#ffb446"
                            } else if(styleData.value === "\ue609") {
                                return "#0098db"
                            } else {
                                return "white"
                            }
                        }
                    }

                    SystemPalette {
                        id: myPalette;
                        colorGroup: SystemPalette.Active
                        //styleData.alternate: true
                    }
                    color: {
                        //var baseColor = styleData.alternate ? myPalette.alternateBase : myPalette.base
                        var baseColor = styleData.row%2 == 0 ? "#D3D3D3" : myPalette.base
                        //console.debug("QML::styleData alternate: "+styleData.alternate)

                        return styleData.selected ? myPalette.highlight : baseColor
                    }
                }
            }
            TableViewColumn {
                role: "time"
                title: qsTr("Time")+translator.tr
                width: 180
                resizable: false
                movable: false
                //delegate: textDelegate
            }
            TableViewColumn {
                role: "type"
                title: qsTr("Type")+translator.tr
                width: 90
                resizable: false
                movable: false
                //delegate: textDelegate
            }
            TableViewColumn {
                role: "content"
                title: qsTr("Summery")+translator.tr
                width: 520
                resizable: false
                movable: false
                //delegate: textDelegate
            }

            model: ListModel {
                id: eventModel

                //ListElement { icon: "\ue631"; time: "2017-11-12 11:23:11"; type: "Error"; content: "Water leakage"  }

            }

        }
    }

    function updateEventModel()
    {
        // set panel leds
        var ledState = [1, 2, 2, 3];
        if(mainEventModel.firstPriorityAttr != notifyLevelPre) {
            panelleds_setting.setValue(ledState[mainEventModel.firstPriorityAttr]);
            notifyLevelPre = mainEventModel.firstPriorityAttr;
        }

        tableView.model = mainEventModel.eventModel;

        //var count = tableView.model.rowCount();

        //if(mainStackView.depth > 1)
        //{
        //    return; //if not in home page ; do nothing
        //}
    }

    Rectangle {
        id: notifyLine
        x: 0
        y: 60
        width: 800
        height: 40
        z: 1
        color: mainEventModel.firstPriorityColor
        visible: mainEventModel.isEventExist && mainStackView.depth <= 1

        Text {
            id: notifyLineIcon

            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignHCenter
            visible: !notifyDialog.visible
            text: qsTr(mainEventModel.firstPriorityTypeText)+translator.tr+":"
            font: mainTheme.smallFont
        }

        Text {
            id: notifyLineContent

            anchors.left: notifyLineIcon.right
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            //visible: !notifyDialog.visible
            text: dropIcon.opened == true ? qsTr("Check here and go to diagnosis view page") :
                                    mainEventDesc.descriptionList[mainEventModel.firstPriorityIndex]+translator.tr
            //text: mainEventDesc.descriptionList[mainEventModel.firstPriorityIndex]+translator.tr
            font: mainTheme.smallFont
            color: dropIcon.opened == true ? (mainEventModel.firstPriorityAttr == 1 ? "white" : "#0098db") // 1 - reminder
                                           : "black"

            MouseArea {
                id: notifContentMouseArea
                anchors.fill: parent
                onClicked: {
                    if(dropIcon.opened) {
                        //if(mainPermisMgr.checkPermission()) {
                        mainNaviPage.navigate(4, 1, 1) // goto diagnosis detail page
                        //}
                    }
                }
            }
        }

        Rectangle {
            id: dropIcon
            x: 760
            y: 0
            width: 40
            height: 40
            property bool opened: false

            color: notifMouseArea.pressed ? "#9e9e9e":"white"

            Text {
                anchors.centerIn: parent
                text: dropIcon.opened ? "\ue644" : "\ue643"
                color: "#ffb446"
                font: theme.mediumIcon
            }
            MouseArea {
                id: notifMouseArea
                anchors.rightMargin: 0
                anchors.bottomMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0
                anchors.fill: parent
                onClicked: {
                    dropIcon.opened = !dropIcon.opened
                    /*if(!notifyDialog.visible)
                        notifyDialog.open("Hello");
                    else
                        notifyDialog.close();*/
                }
            }
        }
    }
}
