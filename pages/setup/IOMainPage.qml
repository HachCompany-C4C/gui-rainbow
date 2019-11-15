/****************************************************************************
** IOMainPage.qml - IO list view
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
import "../../content"


Rectangle {
    id: list
    objectName: "IOMain page"
    property int ioNumber: 0
    property list<Item> ioPageList : [
        DigitalInput {}, // DI
        CommSpdt {},     //DO
        Rectangle {},
        AnalogOutput {}  //AO
    ]
    signal listClick(var name)
    property var ioArray: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    width: 800
    height: 360

    Connections {
        target: io_main
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            console.debug("QML::UpdatePage io.main")
            listView.updateIOList();
            page_manager.updatePageDone();
        }
    }

    /*Timer {
        id: flashTimer
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            console.debug("QML::IOMainPage timer-latest measure update")
            page_manager.startUpdate("io.main")
        }
    }

    Connections {
        target: setupStackView
        onCurrentItemChanged: {
            console.debug("mainStackView onCurrentItemChanged")
            if(setupStackView.currentItem) {
                var objName = setupStackView.currentItem.objectName
                if(objName.length > 0) {
                    if(setupStackView.currentItem.objectName == "IOMain page") {
                        flashTimer.start()
                    } else {
                        flashTimer.stop()
                    }
                } else {
                    flashTimer.stop()
                }
            }
        }
    }*/


    ListView {
        id: listView
        width: 800
        height: 360
        boundsBehavior: Flickable.StopAtBounds
        scale: 1
        cacheBuffer: 200
        contentHeight: 1144
        snapMode: ListView.SnapToItem

        model: ListModel {}

        delegate: IODelegate {
            width: parent.width
            height: 64
            mType: ioType
            mCh1Value: ioCh1Text
            mCh2Value: ioCh2Text
            mEnabled: ioEnabled
            mIndex: index

            onClicked: {
                // Switch to io detail setting page
                if(ioType > 0)
                {
                    //mainStackView.push({item: ioPageList[ioType-1], immediate: true})
                    console.debug("QML::ioType: "+ioType)
                    switch(ioType)
                    {
                    case "1":
                        io_di.setAllObjParameter(mIndex);
                        break;
                    case "2":
                        var items = ["enabled", "ch1output", "ch2output"];
                        var paras = [mIndex, mIndex, mIndex];
                        io_spdt.setObjParameter(items, paras);
                        break;
                    case "4":
                        io_ao.setAllObjParameter(mIndex);
                        break;
                    }

                    console.debug("QML IOList to Detail: page name: "+mPageName)
                    page_manager.startUpdate(mPageName);
                }
            }
        }

        function updateIOList() {

            var typeList = io_main.getObjStringList("type_list");
            var enabledList = io_main.getObjStringList("enabled_list");
            var aoch1List = io_main.getObjStringList("aoch1_list");
            var aoch2List = io_main.getObjStringList("aoch2_list");
            var spdtch1List = io_main.getObjStringList("spdtch1_list");
            var spdtch2List = io_main.getObjStringList("spdtch2_list");
            var dich1List = io_main.getObjStringList("dich1_list");
            var dich2List = io_main.getObjStringList("dich2_list");

            listView.model.clear();
            ioNumber = 1;

            for(var i = 0; i < typeList.length; i++)
            {
                var value = typeList[i];
                switch(value)
                {
                case "1":
                    // DI_Board
                    listView.model.append({"ioType": typeList[i], "ioCh1Text": dich1List[i], "ioCh2Text": dich2List[i], "ioEnabled": enabledList[i], "index": i });
                    ioNumber++;
                    break;
                case "2":
                    // DO_Board
                    listView.model.append({"ioType": typeList[i], "ioCh1Text": spdtch1List[i], "ioCh2Text": spdtch2List[i], "ioEnabled": enabledList[i], "index": i });
                    ioNumber++;
                    break;
                case "4":
                    // AO_Board
                    listView.model.append({"ioType": typeList[i], "ioCh1Text": aoch1List[i], "ioCh2Text": aoch2List[i], "ioEnabled": enabledList[i], "index": i });
                    ioNumber++;
                    break;
                }

                //console.debug("QML::IOMainPage ioType: "+typeList[i]+" ioCh1Text "+aoch1List[i]+" ioCh2Text "+aoch2List[i]+" ioEnabled "+enabledList[i])
                ioArray[i] = value;
            }
        }

            /*Component.onCompleted: {
                model.append({"ioType": 1, "ioCh1Text": qsTr("1.23"), "ioCh2Text": qsTr("3.32"), "ioEnabled": true, "index": ioNumber });
                ioNumber++;
                model.append({"ioType": 2, "ioCh1Text": qsTr("ON"), "ioCh2Text": qsTr("OFF"), "ioEnabled": true, "index": ioNumber });
                ioNumber++;
                model.append({"ioType": 3, "ioCh1Text": qsTr("---"), "ioCh2Text": qsTr("---"), "ioEnabled": false, "index": ioNumber });
                ioNumber++;
            }*/

    }
}


