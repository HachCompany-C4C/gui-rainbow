/****************************************************************************
** TestIO.qml - UI for I/O test
**
** Created on: 2017-10-31
**
** Author:
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
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.0
import "../../components"
import "../../content"

Rectangle{
    id: testroot
    objectName: "test_io"
    property string title: qsTr("IO")+translator.tr
    width: 800
    height: 370

    Connections {
        target: test_io
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            console.debug("QML::UpdatePage Test-PV")

            listView.updateIOList();

            page_manager.updatePageDone();
        }
    }

    Connections {
        target: mainMessage
        onMainWindowPopped: {
            if(objName == "test_io") {
                console.debug("QML::TestIO onMainWindowPopped")
                test_io.setObj("exit", 0);
            }
        }
    }

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

        delegate: TestIo {
            width: parent.width
            mType: ioType
            mIndex: index
            ch1Value: ioCh1Text == undefined ? "" : ioCh1Text
            ch2Value: ioCh2Text == undefined ? "" : ioCh2Text
            ch1Check: ioCh1Check
            ch2Check: ioCh2Check

            onAoCh1Clicked: {
                var temp = [mIndex, Number(ch1Value)*1000]
                test_io.setObj("simu_ao_ch1", temp)
                //listView.updateIOList()
                page_manager.startUpdate("test.io")
            }

            onAoCh2Clicked: {
                var temp = [mIndex, Number(ch2Value)*1000]
                test_io.setObj("simu_ao_ch2", temp)
                //listView.updateIOList()
                page_manager.startUpdate("test.io")

            }

            onDoCh1StatusChanged: {
                ch1Check = !ch1Check;
                var check1 = ch1Check?1:0
                var temp = [mIndex, check1]
                test_io.setObj("simu_do_ch1", temp)
                //listView.updateIOList()

            }
            onDoCh2StatusChanged: {
                ch2Check = !ch2Check
                var check2 = ch2Check?1:0
                var temp = [mIndex, check2]
                test_io.setObj("simu_do_ch2", temp)
                //listView.updateIOList()

            }

        }

        function updateIOList() {

            var typeList = test_io.getObjStringList("type_list");
            var aoch1List = test_io.getObjStringList("state_ao_ch1");
            var aoch2List = test_io.getObjStringList("state_ao_ch2");
            var spdtch1List = test_io.getObjStringList("state_do_ch1");
            var spdtch2List = test_io.getObjStringList("state_do_ch2");

            model.clear();
            //ioNumber = 1;

            for(var i = 0; i < typeList.length; i++)
            {
                var value = typeList[i];
                switch(value)
                {
                /*case "1":
                    // DI_Board
                    model.append({"ioType": typeList[i], "ioCh1Text": dich1List[i], "ioCh2Text": dich2List[i], "ioEnabled": enabledList[i], "index": i });
                    ioNumber++;
                    break;*/
                case "2":
                    // DO_Board
                    var check1 = false
                    var check2 = false
                    if(spdtch1List[i] === "0")
                        check1 = false
                    else
                        check1 = true
                    if(spdtch2List[i] === "0")
                        check2 = false
                    else
                        check2 = true
                    model.append({"ioType": typeList[i], "ioCh1Check": check1, "ioCh2Check": check2, "index": i });
                    //ioNumber++;
                    break;
                case "4":
                    // AO_Board
                    model.append({"ioType": typeList[i], "ioCh1Text": (Number(aoch1List[i])/1000).toFixed(2), "ioCh2Text": (Number(aoch2List[i])/1000).toFixed(2), "index": i });
                    //ioNumber++;
                    break;
                }
            }
        }

    }




















    /*ListModel {
        id: relayModel
        ListElement { ename: qsTr("Relay"); eaddr: "3"}
    }
    Column{
        id:relayColumn
        x: 40
        //y: 10
        width: testroot.width
        spacing: 5
        Repeater{
            model : relayModel
            delegate : H2oTestRelay {
                y: index * 85 + 10
                name: ename
                addr: eaddr
                onStatusChanged:  {
                    //console.debug("QML::parent is width is %d", );
                }
                function updateStatus()
                {
                    vCheck = true;
                }
            }
        }
    }
    Rectangle{
        id: l1
        x: 5
        y: 85 * relayModel.count + 15
        height: 2
        width: parent.width -5
        color: "gray"
    }
    ListModel {
        id: aoModel
        ListElement { ename: "AO"; eaddr: "5"}
    }
    Column{
        id:aoColumn
        x: relayColumn.x

        spacing: 5
        width: testroot.width
        Repeater{
            model : aoModel
            delegate : H2oTestAo {
                y: l1.y + 85*index+10
                name: ename
                addr: eaddr
                onAoEditdone: {
                    //console.debug("QML::parent is width is %d", );
                }
                onSimulateClicked: {

                }
            }
        }
    }
    Rectangle{
        id: l2
        x: 5
        y: l1.y + 85 *aoModel.count +15
        height: 2
        width: parent.width -5
        color: "gray"
    }*/

}
