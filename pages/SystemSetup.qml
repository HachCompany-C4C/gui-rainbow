/****************************************************************************
** SystemSetup.qml - System setup tab menu
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
    objectName: "system_setup"
    property string title: qsTr("System Setup")+translator.tr
    property alias pageTabView: tabView
    width: 800
    property var pageName: [
        "system.info",
        "",
        "",
        "system.info"
    ]

    property list<Item> tabList: [
        SysDateTime { id: timeSetup; width: 800},
        DisplayBrightness {},
        Language {},
        InstrAlias {}
    ]

    property var tabTitles: [
        qsTr("Date&Time")+translator.tr,
        qsTr("Backlight")+translator.tr,
        qsTr("Language")+translator.tr,
        qsTr("Alias")+translator.tr
    ]

    Connections {
        target: mainStackView
        onCurrentItemChanged: {
            if(mainStackView.currentItem) {
                var objName = mainStackView.currentItem.objectName
                if(objName.length > 0) {
                    var pageName = mainStackView.currentItem.objectName;
                    if(pageName == "system_setup") {
                        page_manager.startUpdate(root.pageName[tabView.currentIndex]);
                        updatePage();
                    }

                    var index = mainNaviPage.currentPageIndex();
                    // console.debug("QML::index main="+index.main+" sub="+index.sub+" tab="+index.tab);

                    if(index.main === 1 && index.sub === 5 && index.tab === 1 && timeSetup.timeBtnEnabled) {
                        mainMessageDialogTwoButton.openDialog("reminder",
                                                              qsTr("The setting of system time hasn't been applied, do you want to ignore this operation ?"));
                        mainMessageDialogTwoButton.parentItem = root;
                    }
                }
            }
        }
    }

    function updatePage()
    {
        if(tabList[tabView.currentIndex].updateData !== undefined) {
            tabList[tabView.currentIndex].updateData();
        }
    }

    H2oLineTabView {
        id: tabView
        width: 800
        height: 420
        property int preIndex: 0
        model: ListModel {
            ListElement { name: "Date&Time"; check: true }
            ListElement { name: "Backlight"; check: false }
            ListElement { name: "Language"; check: false }
            ListElement { name: "Alias"; check: false }
        }

        viewList: tabList
        titleList: tabTitles
        onCurrentIndexChanged: {
            page_manager.startUpdate(root.pageName[tabView.currentIndex])
            updatePage();

            if(model.get(tabView.preIndex).name === "Date&Time" && timeSetup.timeBtnEnabled)
            {
                mainMessageDialogTwoButton.openDialog("reminder",
                                                      qsTr("The setting of system time hasn't been applied, do you want to ignore this operation ?"));
                mainMessageDialogTwoButton.parentItem = tabView;
            } else {
                tabView.preIndex = currentIndex;
            }
        }

        function accept()
        {
            tabView.preIndex = tabView.currentIndex;
            timeSetup.timeBtnEnabled = false;
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
        timeSetup.timeBtnEnabled = false;
    }

    function reject()
    {
        mainNaviPage.navigate(1, 5, 1);
    }
}
