/****************************************************************************
** ClearSettings.qml - UI to clear error
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
    width: 800
    height: 360
    objectName: "diagnosis clear"
    property string title: qsTr("Diagnosis clear")+translator.tr

    enabled: mainPermisMgr.editabled

    Connections {
        target: mainEventModel
        ignoreUnknownSignals: true
        onEventUpdated: {
            updateEventModel();
        }
    }

    function updateEventModel() {
        tableView.model.clear();
        for(var i = 0; i < mainEventModel.canClearModel.rowCount(); i++) {
            var exist = mainEventModel.canClearModel.get(i).exist;
            if(exist) {
                var code = mainEventModel.canClearModel.get(i).code;
                tableView.model.append({ "item": mainEventDesc.description(code)})
            }
        }

        applyButton.enabled = tableView.model.rowCount() > 0 ? true : false
    }

    H2oTableView {
        id: tableView
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        width: 800-40
        height: 280

        verticalScrollBarPolicy: 0
        highlightOnFocus: false
        headerVisible: true
        alternatingRowColors: false
        //backgroundVisible: false
        frameVisible: false

        TableViewColumn {
            role: "item"
            title: qsTr("Item")+translator.tr
            width: 800-40
            resizable: false
            movable: false
            /*delegate: Rectangle {
                Text {
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: styleData.textAlignment
                    anchors.leftMargin: 12
                    text: styleData.value !== undefined ? styleData.value : ""
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
            }*/
        }

        /*TableViewColumn {
            role: "clear"
            title: qsTr("Clear")+translator.tr
            width: 200
            resizable: false
            movable: false
            delegate: Rectangle {
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
                H2oCheckBox {
                    id: checkBox
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    checked: styleData.value
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        checkBox.checked = !checkBox.checked
                        eventModel.get(styleData.row).clear = checkBox.checked;

                    }
                }
            }
        }*/

        /*TableViewColumn {
            role: "help"
            title: qsTr("Help")+translator.tr
            width: 110
            resizable: false
            movable: false
            delegate: Rectangle {
                SystemPalette {
                    id: palette1
                    colorGroup: SystemPalette.Active
                    //styleData.alternate: true
                }
                color: {
                    //var baseColor = styleData.alternate ? palette.alternateBase : palette.base
                    var baseColor = styleData.row%2 == 0 ? "#D3D3D3" : palette1.base
                    //console.debug("QML::styleData alternate: "+styleData.alternate)

                    return styleData.selected ? palette1.highlight : baseColor
                }
                Rectangle {
                    id: btn1
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
                        //gotoHelp(styleData.value);
                        //mainStackView.push({item: eventHelp, immediate: true})
                    }
                }
            }
        }*/

        model: ListModel {
            id: eventModel

            //ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Water leakage"); clear: false; obj: "leakage"}
        }

    }

    H2oButton {
        id: applyButton

        width: parent.width
        height: 60
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        text: qsTr("APPLY CLEAR")+translator.tr
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        buttonRadius: 0
        onClicked: {

            /*notification_clear.clearObjTList();
            for(var i = 0; i < eventModel.rowCount(); i++) {
                var isclear = eventModel.get(i).clear;
                if(isclear > 0) {
                    var obj = eventModel.get(i).obj;

                    notification_clear.addObjToTList(obj, 1);
                }
            }

            if(notification_clear.objTListLength() > 0) {
                notification_clear.setObjTList();
                mainMessageDialogOneButton.text = qsTr("Apply clear done.");
            } else {
                mainMessageDialogOneButton.text = qsTr("Please select items.");
            }*/

            if(tableView.model.rowCount() > 0) {
                // clear all error which can be cleared
                notification_clear.setObj("leakage", 1);

                //mainMessageDialogOneButton.type = "reminder";
                mainMessageDialogOneButton.openDialog("reminder", qsTr("Apply clear done."));
            }
        }
    }
}
