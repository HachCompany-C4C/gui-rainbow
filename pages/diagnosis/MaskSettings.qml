/****************************************************************************
** MaskSettings.qml - UI for error mask setting
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

Rectangle {
    width: 800
    height: 340
    objectName: "Mask settings"
    property var attrList: []
    property string title: qsTr("Mask Settings")+translator.tr
    property int maskCode: 0x80 //enabled bit = mask bit

    enabled: mainPermisMgr.editabled

    Connections {
        target: mask_notification_error
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            tableView.updateEventMaskTable();
            // console.debug("QML::MaskSettings updatePage")
            page_manager.updatePageDone();
        }
    }

    H2oTableView {
        id: tableView
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        width: 800-40
        height: 350
        //rowHeight: 48

        verticalScrollBarPolicy: 0
        highlightOnFocus: false
        headerVisible: true
        alternatingRowColors: true
        //backgroundVisible: false
        frameVisible: false
        selectionMode: SelectionMode.SingleSelection

        TableViewColumn {
            role: "content"
            title: qsTr("Content")+translator.tr
            width: 600
            resizable: false
            movable: false
            //delegate: textDelegate
        }

        TableViewColumn {
            role: "index"
            title: qsTr("Mask")+translator.tr
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
                    x: 15
                    anchors.verticalCenter: parent.verticalCenter
                    checked: {
                        //console.debug("MaskSettings row "+styleData.row)
                        if(styleData.row !== -1) {
                            return eventModel.get(styleData.row).mask
                        } else {
                            return true;
                        }
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        // console.debug("QML::MaskSettings updateEventMaskTable attrList: "+attrList)

                        var index = styleData.row;
                        var code = eventModel.get(index).code;
                        checkBox.checked = !checkBox.checked;
                        eventModel.setProperty(index, "mask", checkBox.checked);
                        if(!checkBox.checked)
                            attrList[code] |= maskCode;
                        else
                            attrList[code] &= ~maskCode;

                        mask_notification_error.setObjParameter("mask", code);
                        mask_notification_error.setObj("mask", attrList[code]);
                        // console.debug("QML::MaskSettings CheckBox index: "+index)
                    }
                }
            }
        }

        model: ListModel {
            id: eventModel

            ListElement { content: QT_TRANSLATE_NOOP("H2oTableView", "USB_WRITE_FAILURE"); mask: false; code: 0; } // measure out of range
            // ListElement { content: QT_TRANSLATE_NOOP("H2oTableView", "NO_SAMPLE_FLOW"); mask: false; code: 3; }
            ListElement { content: QT_TRANSLATE_NOOP("H2oTableView", "MEASURE_OUT_WORK_RANGE"); mask: false; code: 9; }
            //ListElement { content: QT_TRANSLATE_NOOP("H2oTableView", "POWER_FAILURE"); mask: false; code: 10; }
            ListElement { content: QT_TRANSLATE_NOOP("H2oTableView", "CASE_TEMP_WARNING"); mask: false; code: 13; }
            ListElement { content: QT_TRANSLATE_NOOP("H2oTableView", "SAMPLE IN EXCEPTION"); mask: false; code: 17; }
            ListElement { content: QT_TRANSLATE_NOOP("H2oTableView", "ALARM_LOW"); mask: false; code: 19; }
            ListElement { content: QT_TRANSLATE_NOOP("H2oTableView", "ALARM_HIGH"); mask: false; code: 20; }
            ListElement { content: QT_TRANSLATE_NOOP("H2oTableView", "REAGNET_EMPTY_A"); mask: false; code: 21; }
            ListElement { content: QT_TRANSLATE_NOOP("H2oTableView", "REAGNET_EMPTY_B"); mask: false; code: 22; }
            ListElement { content: QT_TRANSLATE_NOOP("H2oTableView", "REAGNET_EMPTY_C"); mask: false; code: 23; }
            ListElement { content: QT_TRANSLATE_NOOP("H2oTableView", "STD_EMPTY_0"); mask: false; code: 24; }
            ListElement { content: QT_TRANSLATE_NOOP("H2oTableView", "STD_EMPTY_1"); mask: false; code: 25; }
            ListElement { content: QT_TRANSLATE_NOOP("H2oTableView", "STD_EMPTY_2"); mask: false; code: 26; }
            ListElement { content: QT_TRANSLATE_NOOP("H2oTableView", "CLEANING_EMPTY"); mask: false; code: 27; }
            ListElement { content: QT_TRANSLATE_NOOP("H2oTableView", "REAGNET_LOW_A"); mask: false; code: 28; }
            ListElement { content: QT_TRANSLATE_NOOP("H2oTableView", "REAGNET_LOW_B"); mask: false; code: 29; }
            ListElement { content: QT_TRANSLATE_NOOP("H2oTableView", "REAGNET_LOW_C"); mask: false; code: 30; }
            ListElement { content: QT_TRANSLATE_NOOP("H2oTableView", "STD_LOW_0"); mask: false; code: 31; }
            ListElement { content: QT_TRANSLATE_NOOP("H2oTableView", "STD_LOW_1"); mask: false; code: 32; }
            ListElement { content: QT_TRANSLATE_NOOP("H2oTableView", "STD_LOW_2"); mask: false; code: 33; }
            ListElement { content: QT_TRANSLATE_NOOP("H2oTableView", "CLEANING_LOW"); mask: false; code: 34; }
            ListElement { content: QT_TRANSLATE_NOOP("H2oTableView", "LIFESPAN_TUBING_VALVE"); mask: false; code: 35; }
            ListElement { content: QT_TRANSLATE_NOOP("H2oTableView", "LIFESPAN_TUBING_PUMP"); mask: false; code: 36; }
            //ListElement { content: QT_TRANSLATE_NOOP("H2oTableView", "LIFESPAN_MOTOR_PUMP1"); mask: false; code: 37; }
            //ListElement { content: QT_TRANSLATE_NOOP("H2oTableView", "LIFESPAN_MOTOR_PUMP2"); mask: false; code: 38; }
            //ListElement { content: QT_TRANSLATE_NOOP("H2oTableView", "LIFESPAN_MOTOR_PUMP3"); mask: false; code: 39; }
            //ListElement { content: QT_TRANSLATE_NOOP("H2oTableView", "LIFESPAN_MOTOR_MIX"); mask: false; code: 40; }
            ListElement { content: QT_TRANSLATE_NOOP("H2oTableView", "RTC_ALARM"); mask: false; code: 41; }
            ListElement { content: QT_TRANSLATE_NOOP("H2oTableView", "CANOPEN_WARNING"); mask: false; code: 43; }
            ListElement { content: QT_TRANSLATE_NOOP("H2oTableView", "CANOPEN_ERROR"); mask: false; code: 44; }
            ListElement { content: QT_TRANSLATE_NOOP("H2oTableView", "CANOPEN_ER_CONNECT"); mask: false; code: 45; }
            ListElement { content: QT_TRANSLATE_NOOP("H2oTableView", "CANOPEN_ER_CONFIG"); mask: false; code: 46; }
            //ListElement { content: QT_TRANSLATE_NOOP("H2oTableView", "FIX_RANGE_WARNING"); mask: false; code: 47; }
        }

        function updateEventMaskTable()
        {
            attrList = mask_notification_error.getObjStringList("attr_list");
            // console.debug("QML::MaskSettings updateEventMaskTable attrList: "+attrList)
            for(var i = 0; i < eventModel.rowCount(); i++)
            {
                var code = eventModel.get(i).code;
                var check = (attrList[code] & maskCode) > 0 ? false : true;
                eventModel.setProperty(i, "mask", check);
            }
        }
    }
}
