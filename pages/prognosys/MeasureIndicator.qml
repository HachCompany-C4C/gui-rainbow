/****************************************************************************
** MeasureIndicator.qml - UI for measure indicator list
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
    objectName: "measure indictor"
    property string title: qsTr("Measure Indicator")+translator.tr

    Connections {
        target: prognosys_measure
        ignoreUnknownSignals: true
        onProbeUpdateDone: {

            tableView.updateModel();
            page_manager.updatePageDone();
            console.debug("QML::MeasureIndicator update page")
        }
    }

    H2oTableView {
        id: tableView
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        width: 800-40
        height: 360

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
            role: "persent"
            title: qsTr("Persent")+translator.tr
            width: 350
            resizable: false
            movable: false
            //delegate: textDelegate
        }

        TableViewColumn {
            role: "help"
            title: qsTr("Help")+translator.tr
            width: 200
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

        model: ListModel {
            id: eventModel

            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Pump Tube1 Life"); persent: "100%"; obj: "smp_tube"; help: 57; }
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Pump Tube2 Life"); persent: "100%"; obj: "rgt_tube"; help: 58; }
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Pump Tube3 Life"); persent: "100%"; obj: "drain_tube"; help: 59; }
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Environmental temperature"); persent: "100%"; obj: "room_temp"; help: 60; }
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Cell Optical"); persent: "100%"; obj: "optics"; help: 61; }
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Calibration Interval"); persent: "100%"; obj: "cal_intvl"; help: 62; }
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Slope"); persent: "100%"; obj: "slope"; help: 63; }
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Led error"); persent: "100%"; obj: "led_err"; help: 42; }
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Heat out of control"); persent: "100%"; obj: "heat_out_ctl"; help: 4; }
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Measure out of range"); persent: "100%"; obj: "mea_out_rng"; help: 9; }
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Door open"); persent: "100%"; obj: "door_open"; help: 5; }

        }

        function updateModel()
        {
            var p;
            for(var i = 0; i < tableView.model.rowCount(); i++) {
                var obj = tableView.model.get(i).obj;
                var temp = prognosys_measure.getObjFloat(obj);
                if(temp > 1) temp = 1;
                p = (temp*100).toFixed();
                //console.debug("QML::MeasureIndicator persent: "+p+" obj "+obj)
                tableView.model.get(i).persent = p+"%";
            }
        }
    }
}
