/****************************************************************************
** SignalService.qml - Welcome page
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

import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.2
import QtQuick.Window 2.2
import QtQuick.Controls.Styles.Flat 1.0 as Flat
import "components"
import "pages/setup"

Rectangle {
    id: root
    width: 800
    height: 480
    color: "#f2f2f2"

    property int step: 0

    Connections {
        target: startup_initial  //software update page
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            page_manager.updatePageDone();
        }
    }

    /*Image {
        id: hachLog
        source: "qrc:///resources/images/Hach_login_image.png"
    }*/

    MouseArea {
        anchors.fill: parent
    }

    function init()
    {
        // var inital = local_settings.getValueBool("startup", "initial", true);
        var inital = startup_initial.getObjBool("flag");
         console.debug("QML::WelcomePage inital: "+inital)
        if(inital === false) {
            //hachLog.visible = false;
            content.visible = true;

            mainPermisMgr.enablePermission(false, false);
            // send break command
            // send factory reset command
            //mainFactoryResetData.init();
        } else {
            //startup_initial.setObj("recovery", 1);
            root.visible = false;
        }
    }

    function close()
    {
        if(root.visible)
        {
            root.visible = false;
        }
    }

    Rectangle {
        id: content
        anchors.fill: parent
        visible: false

        property var pageName: [
            "system.info",
            "",
            ""
        ]

        property list<Item> tabList: [
            SysDateTime { width: 800},
            Language {},
            MeasureRange {}
        ]

        Rectangle {
            height: 60
            width: 800
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter

            Image {
                id: icon

                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 10
                anchors.left: parent.left
                anchors.leftMargin: 20
                verticalAlignment: Image.AlignVCenter
                source: "qrc:///resources/images/hach-logo.png"
                width: 100
                height: 60
            }

            Text {
                anchors.centerIn: parent
                text: qsTr("Settings Wizard")+translator.tr
                font: mainTheme.mediumFont
            }

            Rectangle {
                id: sp
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                height: Flat.FlatStyle.twoPixels
                width: parent.width
                color: Flat.FlatStyle.mediumFrameColor
            }
        }

        /*Connections {
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
                    }
                }
            }
        }

        function updatePage()
        {
            if(tabList[tabView.currentIndex].updateData !== undefined) {
                tabList[tabView.currentIndex].updateData();
            }
        }*/

        H2oLineTabViewEx {
            id: tabView
            width: 800
            height: 420
            opacity: 1
            tabButtonWidth: (800 - 40)/3
            tabEnabled: false
            anchors.top: parent.top
            anchors.topMargin: 60
            anchors.horizontalCenter: parent.horizontalCenter

            model: ListModel {
                ListElement { name: QT_TRANSLATE_NOOP("H2oLineTabViewEx", "Date&Time"); check: true; pageName: ""; index: 0 }
                ListElement { name: QT_TRANSLATE_NOOP("H2oLineTabViewEx", "Language"); check: false; pageName: ""; index: 1 }
                ListElement { name: QT_TRANSLATE_NOOP("H2oLineTabViewEx", "Range"); check: false; pageName: "measure.range"; index: 2 }
            }

            viewList: content.tabList
            titleList: content.tabTitles
            onCurrentIndexChanged: {
                var pageName = tabView.model.get(currentIndex).pageName;
                page_manager.startUpdate(pageName);

                if(content.tabList[tabView.currentIndex].updateData !== undefined) {
                    content.tabList[tabView.currentIndex].updateData();
                }
                // updatePage();
            }
        }

        H2oButton {
            id:backBtn
            width: parent.width/2
            height: 60
            text: qsTr("BACK")+translator.tr
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            enabled: root.step != 0 ? true : false
            buttonRadius: 0
            buttonTextColor: theme.mainTextColor
            buttonColor: theme.mediumBackgroundColor
            buttonBorderColor: theme.mediumBackgroundColor

            onClicked: {
                root.step--;
                if(root.step < 0) root.step = 0;
                tabView.currentIndex = root.step;
            }
        }

        H2oButton {
            id:nextBtn
            width: parent.width/2
            height: 60
            text: root.step != (tabView.model.rowCount()-1) ? qsTr("NEXT")+translator.tr
                                                       : qsTr("DONE")+translator.tr
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            enabled: true
            buttonRadius: 0

            onClicked: {
                root.step++;
                var count = tabView.model.rowCount()-1;
                if(root.step > count) {
                    root.step = 0;
                    root.visible = false;
                    local_settings.setValue("startup", "initial", false);

                    mainFactoryResetData.initCompleted();
                }

                tabView.currentIndex = root.step;
            }
        }
    }
}
