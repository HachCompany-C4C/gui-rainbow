/****************************************************************************
** MeasureRange.qml - Interface for measure range setting
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
import "../../components"

Rectangle {
    enabled: mainPermisMgr.editabled

    Connections {
        target: measure_range
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            console.debug("QML::UpdatePage measure.range")
            listView.updateIndex();

            page_manager.updatePageDone();
        }
    }

    H2oExclusiveGroup {
        id: tabGroup
    }

    Text {
        id: rangeText
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.top: parent.top
        anchors.topMargin: 10
        text: qsTr("Range setting")+translator.tr
        font: mainTheme.titleFont
    }

    ListView {
        id: listView
        anchors.left: rangeText.left
        anchors.leftMargin: 10
        anchors.top: rangeText.bottom
        anchors.topMargin: 10
        width: 300
        height: 200
        boundsBehavior: Flickable.StopAtBounds
        scale: 1
        cacheBuffer: 200
        contentHeight: 1144
        snapMode: ListView.SnapToItem
        flickableDirection: Flickable.VerticalFlick
        spacing: 5
        property bool inited: false
        property var nameList: [
            qsTr("Auto 0.02~100 mg/L")+translator.tr,
            qsTr("Auto 0.02~1000 mg/L")+translator.tr,
            qsTr("ULR 0.02~15 mg/L")+translator.tr,
            qsTr("LR 0.05~30 mg/L")+translator.tr,
            qsTr("MR 7.5~100 mg/L")+translator.tr,
            qsTr("HR 80~1000 mg/L")+translator.tr,
        ]

        model: ListModel {
            id: standardModel
            ListElement { name: "Auto 0.02~100 mg/L"; check: false; index: 0 }
            ListElement { name: "ULR 0.02~15 mg/L"; check: false; index: 2 }
            ListElement { name: "LR 0.05~30 mg/L"; check: false; index: 3 }
            ListElement { name: "MR 7.5~100 mg/L"; check: false; index: 4 }
        }

        ListModel {
            id: extendModel
            ListElement { name: "Auto 0.02~100 mg/L"; check: false; index: 0 }
            ListElement { name: "Auto 0.02~1000 mg/L"; check: false; index: 1 }
            ListElement { name: "ULR 0.02~15 mg/L"; check: false; index: 2 }
            ListElement { name: "LR 0.05~30 mg/L"; check: false; index: 3 }
            ListElement { name: "MR 7.5~100 mg/L"; check: false; index: 4 }
            ListElement { name: "HR 80~1000 mg/L"; check: false; index: 5 }
        }

        delegate: H2oLineRadioButton {
            text: listView.nameList[index]
            checked: check
            exclusiveGroup: tabGroup
            onValueChanged: {
                measure_range.setObj("index", index);
                var instrType = system_info.getObjInt("instr_type");
                if(instrType === 1) //extended type
                {
                    // if Auto 0.02~1000 mg/L or HR 80~1000 mg/L
                    if(index == 1 || index == 5) {
                        mainMessageDialogOneButton.openDialog("reminder",
                                                              qsTr("Please check DI water installed."))
                    }
                }
            }
        }

        function updateIndex()
        {
            if(inited === false)
            {
                inited = true;
                var instrType = system_info.getObjInt("instr_type");
                if(instrType === 1) //extended type
                {
                    model = extendModel;
                }
            }

            var i = measure_range.getObjInt("index");
            //console.debug("QML::MeasureRange index="+i);
            for(var j = 0; j < listView.model.rowCount(); j++) {
                if(i === listView.model.get(j).index) {
                    listView.contentItem.children[j].checked = true;
                    //console.debug("QML::range index: "+i+" "+j);
                    break;
                }

                //console.debug("QML::listView.model.get(j).index: "+listView.model.get(j).index);
            }
        }
    }
}


/*Rectangle {
    id: measureRangePg
    Connections {
        id: connetions
        target: measure_range
        enabled: false //a bug reported on https://codereview.qt-project.org/#/c/193980/
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            console.debug("measureRangePg updated")
            dilutionOn.checked = measure_range.getObjBool("auto")
            dropBox.currentIndex = measure_range.getObjInt("type")
        }
    }

    onVisibleChanged: {
        console.debug("onLayerChanged")
    }

    ColumnLayout {
        x: 25
        y: 25

        Text {
            text: qsTr("Auto Dilution")
            font.pixelSize: 24
        }

        RowLayout {
            H2oSwitch {
                id: dilutionOn
                onValueChanged: {
                    if(operated) {
                        if(dilutionOn.checked) {
                            console.debug("Auto dilution On")
                            //dilutionOn.text = qsTr("Dilution On")

                        } else {
                            console.debug("Auto dilution Off")
                            //dilutionOn.text = qsTr("Dilution Off")
                        }

                        measure_range.setObj("auto", dilutionOn.checked)
                    }

                    operated = true
                }



                Component.onCompleted: {
                    //checked = measure_range.getObjBool("auto")
                    //measure_range.start()
                    //text = checked ? qsTr("Dilution On") : qsTr("Dilution Off")
                }

            }
        }

        Rectangle {
            height: 50
            Text {
                text: qsTr("Measuring Range")
                font.pixelSize: 24
            }
        }

        RowLayout {

            /*H2oComboBox {
                id: rangeTypeCombox
                width: 300

                model: ListModel {
                    id: rangeTypeItem
                    ListElement { text: qsTr("ULR") }
                    ListElement { text: qsTr("LR") }
                    ListElement { text: qsTr("MR") }
                    ListElement { text: qsTr("HR") }
                }

                onCurrentIndexChanged: {
                    if(rangeTypeCombox.operated) {
                        console.debug("Measuring Range: " + rangeTypeItem.get(currentIndex).text)
                        settings.setMeasRangePickone(currentIndex)
                    } else {
                        rangeTypeCombox.currentIndex = settings.getMeasRangePickone()
                        console.debug("settings.getMeasRangePickone")
                    }

                    rangeTypeCombox.operated = true
                }
            }*/

/*            H2oDropBox {
                id: dropBox
                width: 200

                model: ListModel {
                    id: rangeTypeItem
                    ListElement { name: qsTr("ULR") }
                    ListElement { name: qsTr("LR") }
                    ListElement { name: qsTr("MR") }
                    ListElement { name: qsTr("HR") }
                }

                onIndexChanged: {
                    console.debug("Interval Time: ")
                    settings.setMeasRangePickone(currentIndex)
                }
            }
        }
    }
}*/

