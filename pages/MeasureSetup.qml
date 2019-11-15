/****************************************************************************
** MeasureSetup.qml - Measure setup menu
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
    objectName: "measure_setup"
    property string title: qsTr("Measure Setup")+translator.tr
    property alias pageTabView: tabView

    width: 800
    property var pageName: [
        "measure.range",
        "measure.schedule",
        "measure.mode",
        "measure.others"
    ]

    property list<Item> tabList: [
        MeasureRange {},
        MeasureSchedule {id: schedulePage},
        MeasureMode {},
        MeasureOthers {}
    ]

    property var tabTitles: [
        qsTr("Range")+translator.tr,
        qsTr("Schedule")+translator.tr,
        qsTr("Mode")+translator.tr,
        qsTr("Others")+translator.tr
    ]

    Connections {
        target: mainStackView
        onCurrentItemChanged: {
            if(mainStackView.currentItem) {
                var objName = mainStackView.currentItem.objectName
                if(objName.length > 0) {
                    var pageName = mainStackView.currentItem.objectName;
                    if(pageName == "measure_setup") {
                        page_manager.startUpdate(root.pageName[tabView.currentIndex])
                    }

                    var index = mainNaviPage.currentPageIndex();
                    // console.debug("QML::index main="+index.main+" sub="+index.sub+" tab="+index.tab);

                    if(index.main === 1 && index.sub === 1 && index.tab === 2 && schedulePage.timeBtnEnabled) {
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
            ListElement { name: "Range"; check: true }
            ListElement { name: "Schedule"; check: false }
            ListElement { name: "Mode"; check: false }
            ListElement { name: "Others"; check: false }
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
        mainNaviPage.navigate(1, 1, 2);
    }
}
