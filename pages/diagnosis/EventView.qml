/****************************************************************************
** EventView.qml - UI to show current errors
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


import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.1
import "../../components"
import "../../content/time.js" as TimeScript

Rectangle {
    id: eventView
    width: 800
    height: 360
    objectName: "diagnosis view"
    property string title: qsTr("Diagnosis View")+translator.tr

    Connections {
        target: mainEventModel
        ignoreUnknownSignals: true
        onEventUpdated: {
            updateEventModel();
        }
    }

    function updateEventModel() {
        tableView.model = mainEventModel.eventModel;
    }

    /*function updateEventModel()
    {
        tableView.model.clear();
        var list = notification_error.getObjStringList("list");
        var attrList = notification_error.getObjStringList("attr_list");
        var timeList = notification_error.getObjStringList("time_list");
        var colorText = ["white", "\ue609", "\ue627", "\ue631"]
        var typeText = ["",
                        QT_TRANSLATE_NOOP("H2oTableView", "Reminder"),
                        QT_TRANSLATE_NOOP("H2oTableView", "Warning"),
                        QT_TRANSLATE_NOOP("H2oTableView", "Error")]

        for(var i = 0; i < list.length; i++)
        {
            if(list[i] > 0)
            {
                if(i < attrList.length)
                {
                    var attr = (attrList[i] & 0x60) >> 5;
                    var time = TimeScript.convertU32Time(timeList[i]);
                    tableView.model.append({"icon": colorText[attr], "time": time, "type":  typeText[attr], "content": mainEventDesc.description(i)})
                }
            }
        }
    }*/

    H2oTableView {
        id: tableView
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        width: 800-40
        height: 390

        verticalScrollBarPolicy: 0
        highlightOnFocus: false
        headerVisible: true
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
                    font: mainTheme.smallIcon
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
            width: 100
            resizable: false
            movable: false
            //delegate: textDelegate
        }
        TableViewColumn {
            role: "content"
            title: qsTr("Summery")+translator.tr
            width: 320
            resizable: false
            movable: false

        }

        TableViewColumn {
            role: "code"
            title: qsTr("Help")+translator.tr
            width: 200
            resizable: false
            movable: false
            delegate: Rectangle {
                SystemPalette {
                    id: palette
                    colorGroup: SystemPalette.Active
                    //styleData.alternate: true
                }
                color: {
                    //var baseColor = styleData.alternate ? palette.alternateBase : palette.base
                    var baseColor = styleData.row%2 == 0 ? "#D3D3D3" : palette.base
                    //console.debug("QML::styleData alternate: "+styleData.alternate)

                    return styleData.selected ? palette.highlight : baseColor
                }
                Rectangle {
                    id: btn
                    x: 20
                    width: 20
                    height: 20
                    anchors.verticalCenter: parent.verticalCenter
                    radius: 10
                    color: "#0098db"
                    Text {
                        anchors.centerIn: parent
                        text: "?"
                        color: "white"
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        // console.debug("QML::MaskSettings CheckBox index: "+styleData.value)
                        mainHelpPage.gotoHelp(styleData.value);
                        mainStackView.push({item: mainHelpPage, immediate: true})
                    }
                }
            }
        }

        model: ListModel {
            id: eventModel

            //ListElement { icon: "\ue631"; time: "2017-11-12 11:23:11"; type: "Error"; content: "Water leakage"  }

        }

    }
}
