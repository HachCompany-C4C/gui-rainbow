/****************************************************************************
** AdvancedService.qml - Advance service menu
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

import QtQuick 2.1
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.0
import "../content"
import "service"
import "../components"

Rectangle {
    id: root
    objectName: "advanced_service"
    property string title: qsTr("Advanced")+translator.tr
    property alias pageTabView: tabView

    width: 800

    property list<Item> tabList: [
        FactoryReset { width: 800},
        ScreenCalibration {},
        Test {},
        Permission {id: permsPage}
    ]

    property var tabTitles: [
        qsTr("Factory Reset")+translator.tr,
        qsTr("Screen Calibration")+translator.tr,
        qsTr("Test")+translator.tr,
        qsTr("Permission")+translator.tr
    ]

    function stopSchedule()
    {
        var mcuState;
        /*schedule:
        0=Normal
        1=Maintenance
        2=schedule off/trigger
        3=break*/

        if(mainPermisMgr.editabled)
        {
            mcuState = current_measure.getObjInt("schedule") // 1-Stop
            if(mcuState == 0 || mcuState == 2) // if normal or schedule off/trigger
            {
                messageDialog.text = qsTr("Do you want to STOP the device and enter to test function?")+translator.tr;
                messageDialog.open();
            }
        }
    }

    Connections {
        target: mainPermisMgr
        onEditabledChanged: {
            if(mainStackView.currentItem) {
                var objName = mainStackView.currentItem.objectName
                if(objName.length > 0) {
                    var pageName = mainStackView.currentItem.objectName;
                    if(pageName == "advanced_service") {
                        //page_manager.startUpdate(root.pageName[tabView.currentIndex])
                        if(tabView.model.get(tabView.currentIndex).name === "Test")
                        {
                            stopSchedule();
                        }
                    }
                }
            }
        }
    }

    Connections {
        target: mainStackView
        onCurrentItemChanged: {
            if(mainStackView.currentItem) {
                var objName = mainStackView.currentItem.objectName
                if(objName.length > 0) {
                    var pageName = mainStackView.currentItem.objectName;
                    if(pageName == "advanced_service") {
                        //page_manager.startUpdate(root.pageName[tabView.currentIndex])
                        if(tabView.model.get(tabView.currentIndex).name === "Test")
                        {
                            stopSchedule();
                        }
                        else
                        {
                            if(tabView.model.get(tabView.currentIndex).name === "Permission")
                            {
                                permsPage.updatePermsPage();
                            }
                            //page_manager.startUpdate(root.pageName[tabView.currentIndex])
                            tabView.preIndex = tabView.currentIndex;
                           // tabView.model.setProperty(tabView.currentIndex, "check", true)
                        }
                    }
                }
            }
        }
    }

    H2oLineTabView {
        id: tabView
        width: 800
        height: 420
        model: ListModel {
            ListElement { name: "Factory Reset"; check: true ; index: 0}
            ListElement { name: "Screen Calibration"; check: false; index: 1 }
            ListElement { name: "Test"; check: false; index: 2 }
            ListElement { name: "Permission"; check: false; index: 3 }
        }

        viewList: tabList
        titleList: tabTitles
        property int preIndex: 0 // Restore the index of previous page except 'test' page

        onCurrentIndexChanged: {
            if(model.get(currentIndex).name === "Test")
            {
                stopSchedule();
            }
            else
            {
                if(model.get(currentIndex).name === "Permission")
                {
                    permsPage.updatePermsPage();
                }

                tabView.preIndex = currentIndex;
            }
        }
    }
    H2oMessageDialog {
        id: messageDialog

        onAccepted: {
            // 1 - stop
            latest_measure.setObj("startgo", "1");
            //page_manager.startUpdate(root.pageName[tabView.currentIndex])
            //preIndex = tabView.currentIndex; // test page not record in preIndex
        }

        onRejected: {
            tabView.currentIndex = tabView.preIndex;
        }
    }
}
