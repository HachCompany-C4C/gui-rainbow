/****************************************************************************
** NaviPage.qml - Menu navigation
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

import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
//import QtQuick.Controls.Styles.Flat 1.0 as Flat
import "../content"
import "../components"
import "history"

Rectangle {
    id: root

    objectName: "navi page"
    property string title: qsTr("Menu")+translator.tr
    color: "#f2f2f2"

    //signal entryMenu(var index)

    property list<Item> viewList: [
        SetupMenu {},
        ServiceMenu {},
        LogMenu {},
        DiagnosisMenu {},
        PrognosysMenu {}
    ]

    property var menuName: [qsTr("Settings")+translator.tr,
                    qsTr("Service")+translator.tr,
                    qsTr("History")+translator.tr,
                    qsTr("Diagnosis")+translator.tr,
                    qsTr("PROGNOSYS")+translator.tr]
    width: 800
    height: 420

    function navigate(menu, submenu, page)
    {
        // goto home page
        navigateHome();
        // goto main menu
        if(menu > 0 && menu < (listModel.rowCount()+1)) {
            mainStackView.push({item: mainNaviPage, immediate: true})

            naviView.currentIndex = menu-1;

            if(submenu > 0) {
                // goto sub menu
                var subNaviPage = viewList[naviView.currentIndex].subNaviPage;
                if(subNaviPage !== undefined) {
                    subNaviPage.entryItemPage(submenu-1);

                    if(submenu < (subNaviPage.viewList.length+1)) {
                        // goto page menu
                        var tabView = subNaviPage.viewList[submenu-1].pageTabView;
                        if(page > 0) {
                            if(tabView !== undefined) {
                                tabView.switchPage(page-1);
                            }
                        }
                    }
                }
            }
        }
    }

    function currentPage()
    {
        var page = undefined;
        var subNaviPage = viewList[naviView.currentIndex].subNaviPage;
        if(subNaviPage !== undefined)
        {
            var tabView = subNaviPage.viewList[subNaviPage.currentIndex].pageTabView;
            if(tabView !== undefined) {
                page = tabView.currentPage();
            }
        }

        return page;
    }

    function currentPageIndex()
    {
        var page = undefined;
        var subNaviPage = viewList[naviView.currentIndex].subNaviPage;
        var subCurrentIndex = 0;
        var tabCurrentIndex = 0;
        if(subNaviPage !== undefined)
        {
            subCurrentIndex = subNaviPage.currentIndex+1;
            var tabView = subNaviPage.viewList[subNaviPage.currentIndex].pageTabView;
            if(tabView !== undefined) {
                tabCurrentIndex = tabView.currentIndex+1;
            }
        }

        var index = {   main: naviView.currentIndex+1,
                        sub: subCurrentIndex,
                        tab: tabCurrentIndex
                    };

        return index;
    }

    function navigateHome()
    {
        mainWelcomePage.close();
        while(mainStackView.depth > 1)
        {
            mainStackView.pop({immediate: true})
        }
    }

    H2oNavigationListView {
        id: naviView
        width: 800
        height: 420

        listName: menuName
        pageList: viewList

        pageModel: ListModel {
            id: listModel
            ListElement { name: qsTr("Settings"); check: true; index: 0; source: "\ue601";imgFont:0 }
            ListElement { name: qsTr("Service"); check: false; index: 1; source: "\ue618";imgFont:0 }
            ListElement { name: qsTr("Logs"); check: false; index: 2; source: "\ue633";imgFont:0 }
            ListElement { name: qsTr("Diagnosis"); check: false; index: 3; source: "\ue908";imgFont:1 }
            ListElement { name: qsTr("PROGNOSYS"); check: false; index: 4; source: "\ue900";imgFont:1 }
        }
    }

    /*Rectangle {
        x: 0
        y: 0
        width: 800
        height: 420
        color: "#e4e4e4"

        ListView {
            id: listView
            boundsBehavior: Flickable.StopAtBounds
            anchors.bottomMargin: 3
            anchors.topMargin: 0
            scale: 1
            anchors.rightMargin: 3
            cacheBuffer: 200
            contentHeight: 1144
            anchors.fill: parent
            snapMode: ListView.SnapToItem

            property var listName: [qsTr("Settings")+translator.tr,
                            qsTr("Service")+translator.tr,
                            qsTr("Logs")+translator.tr,
                            qsTr("Diagnosis/Prognosys")+translator.tr]

            model: ListModel {
                id: listModel
                ListElement { name: qsTr("Settings"); index: 0; source: "\ue601" }
                ListElement { name: qsTr("Service"); index: 1; source: "\ue618" }
                ListElement { name: qsTr("Logs"); index: 2; source: "\ue633" }
                ListElement { name: qsTr("Diagnosis/Prognosys"); index: 3; source: "\ue635" }
            }

            delegate: TestListItem {
                width: 800
                height: 64
                text: listView.listName[index]
                imageSource: source

                onClicked: {
                    mainStackView.push({item: viewList[index], immediate: true})
                    //titleMessage.text = name;
                }
            }
        }

        StackView {
            id: listStackView
            x: list.width
            y: 0
            width: parent.width - list.width
            height: parent.height
            //initialItem: pageList[0]
            //onCurrentItemChanged: message.subTitleMessage = pageModel.get(0).title
        }
    }*/
}


