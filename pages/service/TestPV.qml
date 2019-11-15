/****************************************************************************
** TestPV.qml - UI for peng and value test
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
import QtQuick.Controls.Styles.Flat 1.0 as Flat
import "../../components"
import "../../content"

Rectangle{
    id: testroot
    objectName: "test_pv"
    property string title: qsTr("Pump & Valve")+translator.tr
    width: 800
    height: 360
    property real valveStatus: 0
    property bool busyStatus: false

    Connections {
        target: test_pv
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            //console.debug("QML::UpdatePage Test-PV")
            absTableView.updateAbs();
            tempTableView.updateTemp();
            valveRepeater.updateValve();
            setBusyStatus();
            page_manager.updatePageDone();
        }
    }

    function setBusyStatus() {
        var b = test_pv.getObjBool("busy");
        if(b != busyStatus) {
            busyStatus = b;
            if(busyStatus) { //busy
                pumpRepeater.disablePumps();
                valveRepeater.disableValves();
            } else {
                pumpRepeater.enablePumps();
                valveRepeater.enableValves();
            }
        }
    }

    Text{
        id:valveTestText
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 5
        font: mainTheme.titleFont
        text:qsTr("Valves Test") + translator.tr
    }

    Column{
        id:valveColumn
        anchors.top: valveTestText.bottom
        anchors.topMargin: 5
        anchors.left: valveTestText.left
        anchors.leftMargin: 5

        ListModel {
            id: valveModel
            ListElement { ename: "V1"; evCheck: true}
            ListElement { ename: "V2"; evCheck: false}
            ListElement { ename: "V3"; evCheck: true}
            ListElement { ename: "V4"; evCheck: false}
            ListElement { ename: "V5"; evCheck: true}
            ListElement { ename: "V6"; evCheck: false}
            ListElement { ename: "V7"; evCheck: true}
            ListElement { ename: "V8"; evCheck: false}
            ListElement { ename: "V9"; evCheck: true}
        }

//        ListModel {
//            id: valveModelExtend
//            ListElement { ename: "V1"; evCheck: true}
//            ListElement { ename: "V2"; evCheck: false}
//            ListElement { ename: "V3"; evCheck: true}
//            ListElement { ename: "V4"; evCheck: false}
//            ListElement { ename: "V5"; evCheck: true}
//            ListElement { ename: "V6"; evCheck: false}
//            ListElement { ename: "V7"; evCheck: true}
//            ListElement { ename: "V8"; evCheck: false}
//            ListElement { ename: "V9"; evCheck: true}
//            ListElement { ename: "V10"; evCheck: true}

//        }

        Repeater{
            id: valveRepeater
            property var valveValue
            model : valveModel // mainPowerDrain.enabled ? valveModelExtend : valveModelStandard

            delegate : TestValve {
                x: (testroot.width - 240)/2*(index%3) + 15 //mainPowerDrain.enabled ? (testroot.width - 240)/3*(index%4) + 15 : (testroot.width - 240)/2*(index%3) + 15
                y: (parseInt(index/3)%3)*48 //mainPowerDrain.enabled ? (parseInt(index/4)%4)*48 : (parseInt(index/3)%3)*48
                name: ename
                vCheck: evCheck
                onStatusChanged:  {
                    //console.debug("QML::Change the valve state");
                    //valveModel.get(index).evCheck = valveModel.get(index).evCheck?false:true;
                    valveModel.get(index).evCheck = checkValue;
                    //vCheck = valveModel.get(index).evCheck
                    var valve = 0;
                    var check = 0;
                    for(var i = 15; i > 6; i--)
                    {
                        check = valveModel.get(15 - i).evCheck ? 1 : 0
                        valve |= (check << i);
                        //console.debug("QML::valve "+(15-i)+" is " + valveModel.get(15-i).evCheck);
                    }
                    test_pv.setObj("valve", valve);
                    //page_manager.startUpdate("test.pv")
                }
            }
            function updateValve()
            {
                var valveStatus = test_pv.getObjInt("valve");
                //console.debug("QML::valve "+valve);
                for(var i = 15; i > 6; i--)
                {
                    var status = (valveStatus & (0x1 << i)) > 0 ? true : false;
                    valveRepeater.model.setProperty(15 - i, "evCheck", status);
                    valveRepeater.itemAt(15 - i).vCheck = status;

                    //console.debug("QML::valve "+(15-i)+" is " + valveModel.get(15-i).evCheck);
                }
            }

            function disableValves()
            {
                for(var i = 15; i > 6; i--)
                {
                    valveRepeater.itemAt(15 - i).enabled = false;
                }
            }

            function enableValves()
            {
                for(var i = 15; i > 6; i--)
                {
                    valveRepeater.itemAt(15 - i).enabled = true;
                }
            }
        }
    }

    Rectangle {
        id: sp1
        anchors.top: valveTestText.bottom
        anchors.topMargin: 145
        anchors.horizontalCenter: parent.horizontalCenter
        height: Flat.FlatStyle.onePixel
        width: parent.width - 40
        color: Flat.FlatStyle.lightFrameColor
    }

    Text{
        id:pumpTestText
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: sp1.top
        anchors.topMargin: 5
        font: mainTheme.titleFont
        text:qsTr("Pumps Test") + translator.tr
    }

    Column{
        id:pumpColumn
        anchors.top: pumpTestText.bottom
        anchors.topMargin: 5
        anchors.left: pumpTestText.left
        anchors.leftMargin: 5

        ListModel {
            id: pumpModelStandard
            ListElement { ename: QT_TRANSLATE_NOOP("TestPump", "Pump1")}
            ListElement { ename: QT_TRANSLATE_NOOP("TestPump", "Pump2")}
            ListElement { ename: QT_TRANSLATE_NOOP("TestPump", "Pump3")}
        }

        ListModel {
            id: pumpModelExtend
            ListElement { ename: QT_TRANSLATE_NOOP("TestPump", "Pump1")}
            ListElement { ename: QT_TRANSLATE_NOOP("TestPump", "Pump2")}
            ListElement { ename: QT_TRANSLATE_NOOP("TestPump", "Pump3")}
            ListElement { ename: QT_TRANSLATE_NOOP("TestPump", "Pump4")}
        }

        Repeater{
            id: pumpRepeater
            model : mainPowerDrain.enabled ? pumpModelExtend : pumpModelStandard

            delegate : TestPump {
                x: mainPowerDrain.enabled ? (testroot.width - 240)/3*(index%4) + 15 : (testroot.width - 240)/2*(index%3) + 15
                name: ename
                onClicked:  {
                    console.debug("QML::TestPump")
                    //conc pump command X, 0xXX11(XX = 60,61,62(Dec)
                    //test_pv.setObj("pump", 0x3C0b+(index<<8));
                    test_pv.setObj("pump", index+1);
                    valveRepeater.disableValves();
                    pumpRepeater.disablePumps();
                }
            }

            function enablePumps() {
                var itemCount = mainPowerDrain.enabled ? 4 : 3
                for(var i = 0; i < itemCount; i++) {
                    pumpRepeater.itemAt(i).enabled = true;
                }
            }

            function disablePumps() {
                var itemCount = mainPowerDrain.enabled ? 4 : 3
                for(var i = 0; i < itemCount; i++) {
                    pumpRepeater.itemAt(i).enabled = false;
                }
            }
        }
    }

    Rectangle {
        id: sp2
        anchors.top: pumpTestText.bottom
        anchors.topMargin: 50
        anchors.horizontalCenter: parent.horizontalCenter
        height: Flat.FlatStyle.onePixel
        width: parent.width - 40
        color: Flat.FlatStyle.lightFrameColor
    }

    H2oTableView {
        id: tempTableView
        width: 800 - 40
        height: 60
        anchors.top: tempAbsText.bottom
        anchors.topMargin: -10
        anchors.horizontalCenter: parent.horizontalCenter

        verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        highlightOnFocus: false
        headerVisible: true
        alternatingRowColors: false
        //backgroundVisible: false
        frameVisible: false

        TableViewColumn {
            role: "item"
            title: " "
            width: tempTableView.width / 5
            resizable: false
            movable: false
            //delegate: textDelegate

        }
        TableViewColumn {
            role: "heating"
            title: qsTr("heating") + translator.tr
            width: tempTableView.width / 5
            resizable: false
            movable: false
            //delegate: textDelegate
        }
        TableViewColumn {
            role: "colorimeter"
            title: qsTr("colorimeter") + translator.tr
            width: tempTableView.width / 5
            resizable: false
            movable: false
            //delegate: textDelegate
        }
        TableViewColumn {
            role: "envirenment"
            title: qsTr("environment") + translator.tr
            width: tempTableView.width / 5
            resizable: false
            movable: false
            //delegate: textDelegate
        }
        TableViewColumn {
            role: "deviceCase"
            title: qsTr("case") + translator.tr
            width: tempTableView.width / 5
            resizable: false
            movable: false
            //delegate: textDelegate
        }

        model: ListModel {
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Temp"); heating: "0"; colorimeter: "0"; envirenment: "0"; deviceCase: "0"}
        }

        rowDelegate: Rectangle {
            id: tempRowItem
            height: 30

            SystemPalette {
                id: tempPalette;
                colorGroup: SystemPalette.Active
            }
            color: {
                var baseColor = styleData.row%2 == 0 ? tempPalette.alternateBase : tempPalette.base
                return styleData.selected ? tempPalette.highlight : baseColor
            }
        }
        function updateTemp()
        {
            var temp = "";
            temp = (test_pv.getObjInt("al_temp")/100).toFixed(1);
            model.setProperty(0, "heating", temp);
            temp = (test_pv.getObjInt("peek_temp")/100).toFixed(1);
            model.setProperty(0, "colorimeter", temp);
            temp = (test_pv.getObjInt("env_temp")/100).toFixed(1);
            model.setProperty(0, "envirenment", temp);
            temp = (test_pv.getObjInt("pcb_temp")/100).toFixed(1);
            model.setProperty(0, "deviceCase", temp);
        }
    }

    Text{
        id:tempAbsText
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: sp2.top
        anchors.topMargin: 5
        font: mainTheme.titleFont
        text:qsTr("Temperature & Abs") + translator.tr
    }

    H2oTableView {
        id: absTableView
        width: 800 - 40
        height: 60
        anchors.top: tempTableView.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        highlightOnFocus: false
        headerVisible: true
        alternatingRowColors: false
        //backgroundVisible: false
        frameVisible: false

        TableViewColumn {
            role: "item"
            title: " "
            width: absTableView.width / 5
            resizable: false
            movable: false
            //delegate: textDelegate

        }
        TableViewColumn {
            role: "L660"
            title: qsTr("L660")
            width: absTableView.width / 5
            resizable: false
            movable: false
            //delegate: textDelegate
        }
        TableViewColumn {
            role: "L880"
            title: qsTr("L880")
            width: absTableView.width / 5
            resizable: false
            movable: false
            //delegate: textDelegate
        }
        TableViewColumn {
            role: "S660"
            title: qsTr("S660")
            width: absTableView.width / 5
            resizable: false
            movable: false
            //delegate: textDelegate
        }
        TableViewColumn {
            role: "S880"
            title: qsTr("S880")
            width: absTableView.width / 5
            resizable: false
            movable: false
            //delegate: textDelegate
        }

        model: ListModel {
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Abs"); L660: "0"; L880: "0"; S660: "0"; S880: "0"}
        }

        rowDelegate: Rectangle {
            id: absrowItem
            height: 30

            SystemPalette {
                id: absPalette;
                colorGroup: SystemPalette.Active
            }
            color: {
                var baseColor = styleData.row%2 == 0 ? absPalette.alternateBase : absPalette.base
                return styleData.selected ? absPalette.highlight : baseColor
            }
        }
        function updateAbs()
        {
            var temp = "";
            temp = test_pv.getObjFloat("l660")
            model.setProperty(0, "L660", temp.toFixed(3))
            temp = test_pv.getObjFloat("l880")
            model.setProperty(0, "L880", temp.toFixed(3))
            temp = test_pv.getObjFloat("s660")
            model.setProperty(0, "S660", temp.toFixed(3))
            temp = test_pv.getObjFloat("s880")
            model.setProperty(0, "S880", temp.toFixed(3))
            //model.setProperty(0, "etext", test_substep.getObjString("l660"));
            //model.setProperty(1, "etext", test_substep.getObjString("l880"));
            //model.setProperty(2, "etext", test_substep.getObjString("s660"));
            //model.setProperty(3, "etext", test_substep.getObjString("s880"));
        }
    }

    /*Text{
        id:valve
        x:5
        y: testroot.height - 180
        font.pixelSize: 24
        text:qsTr("Valve 1-9:") + translator.tr
    }
    ListModel{
        id: valveStateModel
        ListElement{eonOff: true; etxt:"1"}
        ListElement{eonOff: false; etxt:"2"}
        ListElement{eonOff: true; etxt:"3"}
        ListElement{eonOff: false; etxt:"4"}
        ListElement{eonOff: true; etxt:"5"}
        ListElement{eonOff: true; etxt:"6"}
        ListElement{eonOff: false; etxt:"7"}
        ListElement{eonOff: true; etxt:"8"}
        ListElement{eonOff: true; etxt:"9"}
    }

    Row {
        id:valveRow
        x:15
        y:testroot.height - 145
        spacing: 40
        Repeater {
            id: valveStateRepeater
            model: valveStateModel
            delegate: TestOnOff{
                dioameter: 40
                onOff: eonOff
                txt:etxt
            }
            function updateValve()
            {
                //var valve = test_pv.getObjInt("valve");
                //console.debug("QML::valve "+valve);
                for(var i = 15; i > 6; i--)
                {
                    var status = (valveStatus & (0x1 << i)) > 0 ? true : false;
                    model.setProperty(15-i, "eonOff", status);
                }
            }
        }
    }*/


    /*Text {
        id: abs
        x: 5
        y: parent.height - 55
        font.pixelSize: 24
        text: qsTr("ABS") + translator.tr + (" (l660/l880/s660/s880):")
    }
    Text {
        id: temp
        x: 5
        y: parent.height - 95
        font.pixelSize: 24
        text: qsTr("Temp") + translator.tr + (" (al/peek/env/pcb)             :")
    }
    ListModel {
        id: absModel
        ListElement {etext: "0.2121"}
        ListElement {etext: "0.2122"}
        ListElement {etext: "0.2123"}
        ListElement {etext: "0.2124"}
    }


    ListModel{
        id: tempModel
        ListElement {etext: "25.0"}
        ListElement {etext: "26.0"}
        ListElement {etext: "27.0"}
        ListElement {etext: "28.0"}
    }

    Row{
        id: tempRow
        //x: 285
        anchors.left: temp.right
        anchors.leftMargin: 5
        spacing: (testroot.width - 30*24)/3
        Repeater{
            id: tempRepeater
            model: tempModel
            function updateTemp()
            {
                var temp = "";
                temp = "" + (test_pv.getObjInt("al_temp")/100).toFixed(2);
                model.setProperty(0, "etext", temp);
                temp = "" + (test_pv.getObjInt("peek_temp")/100).toFixed(2);
                model.setProperty(1, "etext", temp);
                temp = (test_pv.getObjInt("env_temp")/100).toFixed(2);
                model.setProperty(2, "etext", temp);
                temp = (test_pv.getObjInt("pcb_temp")/100).toFixed(2);
                model.setProperty(3, "etext", temp);
            }
            delegate : Text {
                y: testroot.height-95
                font.pixelSize: 24
                text: etext
            }
        }
    }
    Row{
        id: absRow
        anchors.left: temp.right
        anchors.leftMargin: 5
        //x: 285
        spacing: (testroot.width - 31*24)/3
        Repeater{
            id: absRepeater
            model: absModel

            function updateAbs()
            {
                model.setProperty(0, "etext", test_pv.getObjString("l660"));
                model.setProperty(1, "etext", test_pv.getObjString("l880"));
                model.setProperty(2, "etext", test_pv.getObjString("s660"));
                model.setProperty(3, "etext", test_pv.getObjString("s880"));
            }

            delegate : Text {
                y: testroot.height-55
                font.pixelSize: 24
                text: etext
            }
        }
    }*/
    /*Rectangle {
              id:rect
              x: 10; y: 10
              width: 50; height: 50
              color: "red"

              NumberAnimation on x{
                  id:ani
                  duration: 400
                  easing.type: Easing.OutCubic
              }


              Drag.active: dragArea.drag.active

              MouseArea {
                  id: dragArea
                  anchors.fill: parent

                  drag.target: parent
                  drag.maximumY:root.height-rect.height
                  drag.minimumY: 0
                  onPositionChanged: {
                      console.log("x",mouseX,"y",mouseY,rect.x,rect.y)
                  }

                  onReleased: {
                      if(rect.x > root.width/2.){
                          ani.to = root.width - rect.width
                          ani.start()
                      }
                      else{
                          ani.to = 0
                          ani.start()
                      }
                  }
              }
          }*/
}
