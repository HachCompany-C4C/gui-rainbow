/****************************************************************************
** Language.qml - Interface for language setting
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
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import Qt.labs.settings 1.0
import "../../components"

Item {
    width: 800
    height: 360

    enabled: mainPermisMgr.editabled

    function updateData()
    {
        listView.updateIndex();
    }

    Rectangle {

        H2oExclusiveGroup {
            id: tabGroup
        }

        ListView {
            id: listView
            x: 60
            y: 41
            width: 218
            height: 137
            boundsBehavior: Flickable.StopAtBounds
            anchors.bottomMargin: 3
            anchors.topMargin: 0
            scale: 1
            anchors.rightMargin: 3
            cacheBuffer: 200
            contentHeight: 1144
            snapMode: ListView.SnapToItem
            flickableDirection: Flickable.VerticalFlick
            spacing: 5
            property int currentIndex: 1

            model: ListModel {
                id: langModel
                ListElement { name: "English"; lang: "EN"; check: true; index: 0 }
                ListElement { name: "简体中文"; lang: "ZH"; check: false; index: 1 }
            }

            delegate: H2oLineRadioButton {
                text: name
                checked: check
                exclusiveGroup: tabGroup
                onValueChanged: {
                    translator.translate(lang);
                    local_settings.setValue("system", "language", lang);
                    listView.currentIndex = index;
                    console.debug("QML::language:"+lang);
                }
            }

            function updateIndex()
            {
                //listView.model.setProperty(i, "check", true);
                //var i = translator.currentIndex();
                var hasSetting = false;
                var value = local_settings.getValueString("system", "language", "ZH");
                if(value !== undefined) {
                    for(var i = 0; i < langModel.rowCount(); i++) {
                        if(value === langModel.get(i).lang) {
                            listView.currentIndex = i;
                            hasSetting = true;
                            break;
                        }
                    }
                }

                if(!hasSetting) {
                    value = "ZH";
                    local_settings.setValue("system", "language", value);
                }

                listView.contentItem.children[listView.currentIndex].checked = true;
            }

            Component.onCompleted: {
                updateIndex();
            }
        }
    }
}

