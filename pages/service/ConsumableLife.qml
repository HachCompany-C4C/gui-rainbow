/****************************************************************************
** ServiceIndicator.qml - UI for service indicator list
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
    objectName: "service indictor"
    property string title: qsTr("Service Indicator")+translator.tr

    enabled: mainPermisMgr.editabled

    Connections {
        target: prognosys_service
        ignoreUnknownSignals: true
        onProbeUpdateDone: {

            tableView.updateModel();
            page_manager.updatePageDone();
            console.debug("QML::ServiceIndicator update page")
        }

        onProbeSetObjsDone: {
            page_manager.startUpdate("prognosys.service");
        }
    }

    H2oTableView {
        id: tableView
        anchors.top: parent.top
        anchors.topMargin: 10
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
            width: 300
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
        TableViewColumn {
            role: "days"
            title: qsTr("Days")+translator.tr
            width: 150
            resizable: false
            movable: false
            //delegate: textDelegate
        }

        TableViewColumn {
            role: "reset"
            title: qsTr("Reset")+translator.tr
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
                    checked: (styleData.value & 0x10) > 0 ? true : false
                    visible: (styleData.value & 0x1) > 0 ? true : false
                }
                MouseArea {
                    anchors.fill: parent
                    visible: (styleData.value & 0x1) > 0 ? true : false
                    onClicked: {
                        var reset = tableView.model.get(styleData.row).reset;
                        var bcheck = (styleData.value & 0x10) > 0 ? (reset & ~0x10) : (reset | 0x10);
                        tableView.model.get(styleData.row).reset = bcheck;
                    }
                }
            }
        }

        TableViewColumn {
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
                        mainHelpPage.gotoHelp(styleData.value);
                        mainStackView.push({item: mainHelpPage, immediate: true})
                    }
                }
            }
        }

        model: mainPowerDrain.installed ? eventModelExtend : eventModelStandard

        ListModel {
            id: eventModelStandard

            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Valve Tube Life"); days: "360"; reset: 0x01; obj: "valve_tube"; help: 51} //0x11&0x10=checked, 0x11&0x1=reset available
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Pump Tube1 Life"); days: "360"; reset: 0x01; obj: "smp_tube"; help: 52 }
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Pump Tube2 Life"); days: "360"; reset: 0x01; obj: "rgt_tube"; help: 53 }
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Pump Tube3 Life"); days: "360"; reset: 0x01; obj: "drain_tube"; help: 54 }
            //ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Pump1 Life"); days: "360"; reset: 0x01; obj: "pump1"; help: 51 }
            //ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Pump2 Life"); days: "360"; reset: 0x01; obj: "pump2"; help: 51 }
            //ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Pump3 Life"); days: "360"; reset: 0x01; obj: "pump3"; help: 51 }
            //ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Pump Mixer Life"); days: "360"; reset: 0x01; obj: "pump_mixer"; help: 51 }
            //ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Error"); days: "360"; reset: 0x01; obj: "valve_tube"; help: 51 }
            //ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Reagent Volume"); days: "360"; reset: 0x00; obj: "reagent"; help: 55 }
            //ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Cell Optical"); days: "360"; reset: 0x01; obj: "valve_tube"; help: 51 }
        }

        ListModel {
            id: eventModelExtend

            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Valve Tube Life"); days: "180"; reset: 0x01; obj: "valve_tube"; help: 51} //0x11&0x10=checked, 0x11&0x1=reset available
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Pump Tube1 Life"); days: "90"; reset: 0x01; obj: "smp_tube"; help: 52 }
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Pump Tube2 Life"); days: "90"; reset: 0x01; obj: "rgt_tube"; help: 53 }
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Pump Tube3 Life"); days: "180"; reset: 0x01; obj: "drain_tube"; help: 54 }
            //ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Pump1 Life"); days: "360"; reset: 0x01; obj: "pump1"; help: 51 }
            //ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Pump2 Life"); days: "360"; reset: 0x01; obj: "pump2"; help: 51 }
            //ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Pump3 Life"); days: "360"; reset: 0x01; obj: "pump3"; help: 51 }
            //ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Pump Mixer Life"); days: "360"; reset: 0x01; obj: "pump_mixer"; help: 51 }
            //ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Error"); days: "360"; reset: 0x01; obj: "valve_tube"; help: 51 }
            //ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Reagent Volume"); days: "360"; reset: 0x00; obj: "reagent"; help: 55 }
            //ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Cell Optical"); days: "360"; reset: 0x01; obj: "valve_tube"; help: 51 }
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Pump Tube4 Life"); days: "365"; reset: 0x01; obj: "pdrain_tube"; help: 52 }
        }

        function updateModel()
        {
            var days;
            for(var i = 0; i < tableView.model.rowCount(); i++) {
                var obj = tableView.model.get(i).obj;
                var temp = prognosys_service.getObjFloat(obj);
                if(temp < 1) temp = 1;
                days = temp.toFixed();
                //console.debug("QML::ServiceIndicator days: "+days+" obj "+obj)
                tableView.model.get(i).days = days;
            }
        }
    }

    H2oButton {
        id: applyButton

        width: parent.width
        height: 60
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        text: qsTr("APPLY RESET")+translator.tr
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        buttonRadius: 0
        onClicked: {

            prognosys_service.clearObjTList();
            for(var i = 0; i < tableView.model.rowCount(); i++) {
                var reset = tableView.model.get(i).reset;
                if((reset & 0x10) > 0) {
                    var obj = tableView.model.get(i).obj;
                    var days = tableView.model.get(i).days;

                    prognosys_service.addObjToTList(obj, days);
                }
            }

            if(prognosys_service.objTListLength() > 0) {
                prognosys_service.setObjTList();
                mainMessageDialogOneButton.text = qsTr("Apply reset done.");
            } else {
                mainMessageDialogOneButton.text = qsTr("Please select items.");
            }

            mainMessageDialogOneButton.type = "reminder";
            mainMessageDialogOneButton.open();
        }
    }
}
