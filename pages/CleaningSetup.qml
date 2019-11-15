/****************************************************************************
** CleaningSetup.qml - Cleaning setup menu
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
import "setup"
import "../components"

Rectangle {
    id: root
    objectName: "cleaning_setup"
    property string title: qsTr("Cleaning Setup")+translator.tr
    property alias pageTabView: tabView
    width: 800

    property var pageName: [
        "cleaning.schedule",
        "cleaning.mode"
    ]

    property list<Item> tabList: [
        CleanSchedule {id: schedulePage; width: 800},
        CleanMode {}
    ]

    property var tabTitles: [
        qsTr("Schedule")+translator.tr,
        qsTr("Mode")+translator.tr,
    ]

    Connections {
        target: mainStackView
        onCurrentItemChanged: {
            if(mainStackView.currentItem) {
                var objName = mainStackView.currentItem.objectName
                if(objName.length > 0) {
                    var pageName = mainStackView.currentItem.objectName;
                    if(pageName == "cleaning_setup") {
                        page_manager.startUpdate(root.pageName[tabView.currentIndex])
                    }

                    var index = mainNaviPage.currentPageIndex();
                    // console.debug("QML::index main="+index.main+" sub="+index.sub+" tab="+index.tab);

                    if(index.main === 1 && index.sub === 3 && index.tab === 1 && schedulePage.timeBtnEnabled) {
                        mainMessageDialogTwoButton.openDialog("reminder",
                                                              qsTr("The setting of start time hasn't been applied, do you want to ignore this operation ?"));
                        mainMessageDialogTwoButton.parentItem = root;
                    }
                }
            }
        }
    }

    H2oLineTabView {
        id: tabView
        width: 800
        height: 420
        property int preIndex: 0
        model: ListModel {
            ListElement { name: "Schedule"; check: true }
            ListElement { name: "Mode"; check: false }
        }

        viewList: tabList
        titleList: tabTitles
        onCurrentIndexChanged: {
            page_manager.startUpdate(root.pageName[tabView.currentIndex])

            if(model.get(tabView.preIndex).name === "Schedule" && schedulePage.timeBtnEnabled)
            {
                mainMessageDialogTwoButton.openDialog("reminder",
                                                      qsTr("The setting of start time hasn't been applied, do you want to ignore this operation ?"));
                mainMessageDialogTwoButton.parentItem = tabView;
            } else {
                tabView.preIndex = currentIndex;
            }
        }

        function accept()
        {
            tabView.preIndex = tabView.currentIndex;
            schedulePage.timeBtnEnabled = false;
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
        schedulePage.timeBtnEnabled = false;
    }

    function reject()
    {
        mainNaviPage.navigate(1, 3, 1);
    }
}
