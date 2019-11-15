/****************************************************************************
** MeasureSample.qml - UI for showing measure sample data in real time
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

Item {
    width: 800
    height: 360
    objectName: "measure sample page"

    Connections {
        target: status_page1
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            console.debug("QML::UpdatePage status.page1")
            tableView.updateModel();

            page_manager.updatePageDone();
        }
    }

    H2oTableView {
        id: tableView
        anchors.top: parent.top
        anchors.topMargin: 5
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
            width: tableView.width / 2 + 10
            resizable: false
            movable: false
            //delegate: textDelegate

        }
        TableViewColumn {
            role: "value1"
            title: qsTr("Value")+translator.tr
            width: tableView.width / 2 - 10
            resizable: false
            movable: false
            //delegate: textDelegate
        }
        /*TableViewColumn {
            role: "value2"
            title: "Value"
            width: tableView.width / 3
            resizable: false
            movable: false
            //delegate: textDelegate
        }*/

        model: ListModel {
            id: page1Model

            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView", "Abs L660/Abs L880"); value1: "0"; value2: "0"; }
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView", "Abs S660/Abs S880"); value1: "0"; value2: "0"; }

            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView", "Abs L660_mea/Abs L660_ref"); value1: "0"; value2: "0"; }
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView", "Abs L880_mea/Abs L880_ref"); value1: "0"; value2: "0"; }

            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView", "Abs S660_mea/Abs S660_ref"); value1: "0"; value2: "0"; }
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView", "Abs S880_mea/Abs S880_ref"); value1: "0"; value2: "0"; }

            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView", "Work range up/Curve range (mg/L)"); value1: "0";}
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView", "AL_Temp/PEEK_Temp/ENV_Temp/PCB_Temp (℃)"); value1: "0"; }
        }

        /*itemDelegate: Rectangle {
            Text {
                id: textCell
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: styleData.textAlignment
                anchors.leftMargin: 12
                text: styleData.value !== undefined ? qsTr(styleData.value)+translator.tr : ""
            }

            SystemPalette {
                id: myPalette;
                colorGroup: SystemPalette.Active
                //styleData.alternate: true
            }
            color: {
                //var baseColor = styleData.alternate ? myPalette.alternateBase : myPalette.base
                var baseColor = styleData.row%2 == 0 ? myPalette.alternateBase : myPalette.base
                //console.debug("QML::styleData alternate: "+styleData.alternate)

                return styleData.selected ? myPalette.highlight : baseColor
            }


            Connections {
                target: translator
                ignoreUnknownSignals: true
                onLanguageChanged: {
                    textCell.text = qsTr(styleData.value);
                    console.debug("QML::H2oTableView onLanguageChanged "+styleData.value)
                }
            }
        }*/

        function updateModel() {
            var value1, value2;
            value1 = status_page1.getObjFloat("l660");
            value1 = value1.toFixed(3);
            value2 = status_page1.getObjFloat("l880");
            value2 = value2.toFixed(3);
            model.setProperty(0, "value1", value1+" / "+value2);

            value1 = status_page1.getObjFloat("s660");
            value1 = value1.toFixed(3);
            value2 = status_page1.getObjFloat("s880");
            value2 = value2.toFixed(3);
            model.setProperty(1, "value1", value1+" / "+value2);

            model.setProperty(2, "value1", status_page1.getObjString("l660_mea")+" / "+status_page1.getObjString("l660_ref"));

            model.setProperty(3, "value1", status_page1.getObjString("l880_mea")+" / "+status_page1.getObjString("l880_ref"));

            model.setProperty(4, "value1", status_page1.getObjString("s660_mea")+" / "+status_page1.getObjString("s660_ref"));

            model.setProperty(5, "value1", status_page1.getObjString("s880_mea")+" / "+status_page1.getObjString("s880_ref"));

            var arange = ["0.02~15", "0.05~30", "7.5~100", "80~1000"];
            var index = status_page1.getObjInt("range");
            index = index > 3 ? 3 : index;

            var range_up = measure_others.getObjFloat("range_up");
            model.setProperty(6, "value1", range_up.toFixed(3) + " / " +arange[index]);

            var temp = "";
            var fval;
            fval = status_page1.getObjInt("al_temp")/100;
            temp ="" + fval.toFixed(1);
            //model.setProperty(7, "value1", temp);
            fval = status_page1.getObjInt("peek_temp")/100;
            temp +=" / " + fval.toFixed(1);
            //model.setProperty(8, "value1", temp);
            fval = status_page1.getObjInt("env_temp")/100;
            temp +=" / " + fval.toFixed(1);
            //model.setProperty(9, "value1", temp);
            fval = status_page1.getObjInt("pcb_temp")/100;
            temp +=" / " + fval.toFixed(1);
            model.setProperty(7, "value1", temp);
        }
    }
}
