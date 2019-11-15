/****************************************************************************
** MaintenanceService.qml - Maintenance service menu
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
    objectName: "maintenance_service"
    property string title: qsTr("Maintenance")+translator.tr
    property alias pageTabView: tabView
    width: 800
    property var pageName: [
        "maintenance.manual",
        "maintenance.reagent",
        "prognosys.service"
    ]

    property list<Item> tabList: [
        ManualSchedule { width: 800},
        Reagent {id: reagentPage},
        ConsumableLife {},
        ServiceTool {}
    ]

    property var tabTitles: [
        qsTr("Manual Schedule")+translator.tr,
        qsTr("Reagent")+translator.tr,
        qsTr("Consumable life")+translator.tr,
        qsTr("ServiceTool")+translator.tr
    ]

    Connections {
        target: mainStackView
        onCurrentItemChanged: {
            if(mainStackView.currentItem) {
                var objName = mainStackView.currentItem.objectName
                if(objName.length > 0) {
                    var pageName = mainStackView.currentItem.objectName;
                    if(pageName == "maintenance_service") {
                        page_manager.startUpdate(root.pageName[tabView.currentIndex])
                        // console.debug("QML::MaintenanceService mainStackView: "+root.pageName[tabView.currentIndex])
                    }

                    var index = mainNaviPage.currentPageIndex();
                    // console.debug("QML::index main="+index.main+" sub="+index.sub+" tab="+index.tab);

                    if(index.main === 2 && index.sub === 3 && index.tab === 2 && reagentPage.applyBtnEnabled) {
                        mainMessageDialogTwoButton.openDialog("reminder",
                                                              qsTr("The setting of reagent volume hasn't been applied, do you want to ignore this operation ?"));
                        mainMessageDialogTwoButton.parentItem = root;
                    }
                }
            }
        }
    }

    Connections {
        target: contentWindow
        onInitialDone: {
            var value = local_settings.getValueBool("advance", "servicetool", true);
            if(value === true) {
                var drive = file_tool.getDrivePath();
                if(drive !== "") {
                    var res = exec_script.findScriptPack()
                    //console.debug("QML::Service find res:"+res);
                    if(res) {
                        tabView.model = model2;
                        tabView.showServiceTool = true;
                    }
                }
            }
        }
    }

    Connections {
        target: udisk_dectect
        ignoreUnknownSignals: true
        onSigUDiskDectect: {
            if(exist) {
                if(mainPermisMgr.superperms) {
                    if(!tabView.showServiceTlsool) {
                        var res = exec_script.findScriptPack()
                        //console.debug("QML::Service find res:"+res);
                        if(res) {
                            tabView.model = model2;
                            tabView.showServiceTool = true;
                        }
                    }
                }
            } else {
                if(tabView.showServiceTool) {
                    tabView.model = model1;
                    tabView.showServiceTool = false;
                    tabView.currentIndex = 0;
                }
            }
        }
    }

    H2oLineTabView {
        id: tabView
        width: 800
        height: 420
        property bool showServiceTool: false // service tool
        property int preIndex: 0
        model: ListModel {
            id: model1
            ListElement { name: "Manual Schedule"; check: true }
            ListElement { name: "Reagent"; check: false }
            ListElement { name: "Comsumable life"; check: false }
        }

        ListModel {
            id: model2
            ListElement { name: "Manual Schedule"; check: true }
            ListElement { name: "Reagent"; check: false }
            ListElement { name: "Comsumable life"; check: false }
            ListElement { name: "Service tool"; check: false }
        }

        viewList: tabList
        titleList: tabTitles
        onCurrentIndexChanged: {
            page_manager.startUpdate(root.pageName[tabView.currentIndex])

            if(model.get(tabView.preIndex).name === "Reagent" && reagentPage.applyBtnEnabled)
            {
                mainMessageDialogTwoButton.openDialog("reminder",
                                                      qsTr("The setting of reagent volume hasn't been applied, do you want to ignore this operation ?"));
                mainMessageDialogTwoButton.parentItem = tabView;
            } else {
                tabView.preIndex = currentIndex;
            }
        }

        function accept()
        {
            tabView.preIndex = tabView.currentIndex;
            reagentPage.applyBtnEnabled = false;
        }

        function reject()
        {
            var temp = tabView.preIndex;
            tabView.preIndex = tabView.currentIndex;
            tabView.currentIndex = temp;
        }
    }

    function accept()
    {
        reagentPage.applyBtnEnabled = false;
    }

    function reject()
    {
        mainNaviPage.navigate(2, 3, 2);
    }

    H2oHelpButton {
        x: 742
        width: 50
        height: 48
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 0

        onClicked: {
            if(tabView.currentIndex < 2) {
                mainHelpPage.gotoHelp(tabView.currentIndex+49);
                mainStackView.push({item: mainHelpPage, immediate: true})
            }
        }
    }
}
