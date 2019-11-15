/****************************************************************************
** Reagent.qml - UI for showing and setting reagent volume
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
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.0
import "../../components"

Rectangle {
    id: reagentPage
    objectName: "reagent"
    property string title: qsTr("Reagent")+translator.tr
    width: 800
    height: 370
    property var bottleChanged: [false, false, false, false, false]
    property alias applyBtnEnabled: applyBtn.enabled

    enabled: mainPermisMgr.editabled

    Connections {
        target: maintenance_reagent
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            bottleRepeater.updateReagent();

            page_manager.updatePageDone();
        }
    }

    ListModel {
        id: bottleModel
        ListElement {edefaultkey: "a_default"; ekey: "a_vol"; ename: "A"; epersent: 0.1; ecolor:"#ee5353"; edefault: 970; emax: 1000; /*eunlinked: true*/ }
        ListElement {edefaultkey: "b_default"; ekey: "b_vol"; ename: "B"; epersent: 0.2; ecolor:"#ffb446"; edefault: 970; emax: 1000; /*eunlinked: true*/ }
        ListElement {edefaultkey: "c_default"; ekey: "c_vol"; ename: "C"; epersent: 0.1; ecolor:"#0098db"; edefault: 1000; emax: 1000; /*eunlinked: true*/ }
        ListElement {edefaultkey: "std0_default"; ekey: "std0_vol"; ename: "STD0"; epersent: 0.1; ecolor:"#919191"; edefault: 1000; emax: 1000; /*eunlinked: true*/ }
        ListElement {edefaultkey: "std1_default"; ekey: "std1_vol"; ename: "STD1"; epersent: 0.4; ecolor:"#919191"; edefault: 1000; emax: 1000; /*eunlinked: true*/ }
        ListElement {edefaultkey: "std2_default"; ekey: "std2_vol"; ename: "STD2"; epersent: 0.9; ecolor:"#919191"; edefault: 1000; emax: 1000; /*eunlinked: true*/ }
        ListElement {edefaultkey: "cleaning_default"; ekey: "cleaning_vol"; ename: "Cleaning"; epersent: 0.2; ecolor:"#71C671"; edefault: 2000; emax: 2000;/*eunlinked: true*/ }
    }

    Repeater{
        id: bottleRepeater
        model : bottleModel
        delegate : H2oBottle {
            x: index > 2 ? 30+190*(index-3) : 110+190*index
            y: index > 2 ? 140 : 0
            title: ename
            persent: epersent
            volumnDefault: edefault
            volumnMax: emax
            bottleColor: ecolor
            /*onLinkedbottle: {
                    bottleModel.get(index).eunlinked = false
                    console.debug("bottleModel.get(" + index + ").eunlinked is " + bottleModel.get(index).eunlinked)
                }
                onDislinkedbottle: {
                    bottleModel.get(index).eunlinked = true
                    console.debug("QML::clicked the linked box")
                }*/
            onEditVolDone: {
                /*var temp=0.0;
                bottleModel.get(index).epersent = persent
                temp = bottleModel.get(index).epersent * maintenance_reagent.getObjFloat(bottleModel.get(index).edefaultkey);
                maintenance_reagent.setObj(bottleModel.get(index).ekey, parseInt(temp));*/
                bottleRepeater.setReagetVol(index, persent);
                applyBtn.enabled = true;
                bottleChanged[index] = true;
            }

            onSlidered: {
                bottleRepeater.setReagetVol(index, persent);
                applyBtn.enabled = true;
                bottleChanged[index] = true;
            }
        }

        function setReagetVol(index, persent) {
            //var temp=0.0;
            bottleModel.get(index).epersent = persent
            //temp = bottleModel.get(index).epersent * maintenance_reagent.getObjFloat(bottleModel.get(index).edefaultkey);
            //maintenance_reagent.setObj(bottleModel.get(index).ekey, parseInt(temp));
        }

        function updateSigReagent(index, objName, defObjName, defVol)
        {
            var tempDefault = maintenance_reagent.getObjFloat(defObjName)
            var tempVolumn = maintenance_reagent.getObjFloat(objName)
            // console.debug("QML::Reagent objName:"+objName+", vol:"+ tempVolumn+", def:"+tempDefault);

            if(tempVolumn < 0) tempVolumn = 0;
            if(tempDefault <= 0.000001)
                tempDefault = defVol;
            var tempPercent= tempVolumn / tempDefault
            //model.setProperty(index, "epersent", tempPercent)
            //model.setProperty(index, "edefault", tempDefault)
            //bottleRepeater.itemAt(index).persent = tempPercent;
            //bottleRepeater.itemAt(index).volumnDefault = tempDefault;
            bottleRepeater.itemAt(index).updateStatus(tempPercent, tempDefault);
        }

        function updateReagent()
        {
            if(!applyBtn.enabled)
            {
                for(var i = 0; i < bottleModel.rowCount(); i++)
                {
                    var objName = bottleModel.get(i).ekey;
                    var defObjName = bottleModel.get(i).edefaultkey;
                    var defVol = bottleModel.get(i).edefault;
                    updateSigReagent(i, objName, defObjName, defVol);
                }

                applyBtn.enabled = false;
                bottleChanged = [false, false, false, false, false];
            }

            /*var tempPercent = 0.0;
            var tempDefault = 5000;
            var tempVolumn = 0;
            tempDefault = maintenance_reagent.getObjFloat("a_default")
            if(tempDefault <= 0.0000001)
                tempDefault = 970

            tempVolumn = maintenance_reagent.getObjFloat("a_vol")
            if(tempVolumn < 0) tempVolumn = 0;
            tempPercent= tempVolumn / tempDefault
            model.setProperty(0, "epersent", tempPercent)
            model.setProperty(0, "edefault", tempDefault)

            tempDefault = maintenance_reagent.getObjFloat("b_default")
            tempVolumn = maintenance_reagent.getObjFloat("b_vol")
            if(tempVolumn < 0) tempVolumn = 0;
            if(tempDefault === 0)
                tempDefault = 970
            tempPercent= tempVolumn / tempDefault
            model.setProperty(1, "epersent", tempPercent)
            model.setProperty(1, "edefault", tempDefault)

            tempDefault = maintenance_reagent.getObjFloat("c_default")
            tempVolumn = maintenance_reagent.getObjFloat("c_vol")
            if(tempVolumn < 0) tempVolumn = 0;
            if(tempDefault === 0)
                tempDefault = 1000
            tempPercent= tempVolumn / tempDefault
            model.setProperty(2, "epersent", tempPercent)
            model.setProperty(2, "edefault", tempDefault)

            tempDefault = maintenance_reagent.getObjFloat("std0_default")
            tempVolumn = maintenance_reagent.getObjFloat("std0_vol")
            if(tempVolumn < 0) tempVolumn = 0;
            if(tempDefault === 0)
                tempDefault = 1000
            tempPercent= tempVolumn / tempDefault
            model.setProperty(3, "epersent", tempPercent)
            model.setProperty(3, "edefault", tempDefault)

            tempDefault = maintenance_reagent.getObjFloat("std1_default")
            tempVolumn = maintenance_reagent.getObjFloat("std1_vol")
            if(tempVolumn < 0) tempVolumn = 0;
            if(tempDefault === 0)
                tempDefault = 1000
            tempPercent= tempVolumn / tempDefault
            model.setProperty(4, "epersent", tempPercent)
            model.setProperty(4, "edefault", tempDefault)

            tempDefault = maintenance_reagent.getObjFloat("std2_default")
            tempVolumn = maintenance_reagent.getObjFloat("std2_vol")
            if(tempVolumn < 0) tempVolumn = 0;
            if(tempDefault === 0)
                tempDefault = 1000
            tempPercent= tempVolumn / tempDefault
            model.setProperty(5, "epersent", tempPercent)
            model.setProperty(5, "edefault", tempDefault)

            tempDefault = maintenance_reagent.getObjFloat("cleaning_default")
            tempVolumn = maintenance_reagent.getObjFloat("cleaning_vol")
            if(tempVolumn < 0) tempVolumn = 0;
            if(tempDefault === 0)
                tempDefault = 2000
            tempPercent= tempVolumn / tempDefault
            model.setProperty(6, "epersent", tempPercent)
            model.setProperty(6, "edefault", tempDefault)

//            //temp= maintenance_reagent.getObjFloat("b_vol") / maintenance_reagent.getObjFloat("b_default");
//                model.setProperty(1, "epersent", temp);
//                temp= maintenance_reagent.getObjFloat("c_vol") / maintenance_reagent.getObjFloat("c_default");
//                model.setProperty(2, "epersent", temp);
//                temp= maintenance_reagent.getObjFloat("std0_vol") / maintenance_reagent.getObjFloat("std0_default");
//                model.setProperty(3, "epersent", temp);
//                temp= maintenance_reagent.getObjFloat("std1_vol") / maintenance_reagent.getObjFloat("std1_default");
//                model.setProperty(4, "epersent", temp);
//                temp= maintenance_reagent.getObjFloat("std2_vol") / maintenance_reagent.getObjFloat("std2_default");
//                model.setProperty(5, "epersent", temp);
//                temp= maintenance_reagent.getObjFloat("cleaning_vol") / maintenance_reagent.getObjFloat("cleaning_default");
//                model.setProperty(6, "epersent", temp);*/
        }
    }

    /*Text {
            id: add
            x: 700
            y: 25

            font.pixelSize: 48
            text: "+"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    for(var i=0; i<7; i++)
                    {
                        if(bottleModel.get(i).eunlinked === false)
                        {
                            if((bottleModel.get(i).epersent + 0.01) >= 1.0)
                                bottleModel.get(i).epersent = 1.0;
                            else
                                bottleModel.get(i).epersent += 0.01;
                        }
                    }
                }
                onPressAndHold: {
                    addtimer.start();
                }
                onReleased: addtimer.stop();
            }
        }
    Text {
            id: minus
            x: add.x
            y: add.y+100
            font.pixelSize: 48
            text: "-"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    for(var i=0; i<7; i++)
                    {
                        if(bottleModel.get(i).eunlinked === false)
                        {
                            if((bottleModel.get(i).epersent - 0.01) <= 0.0)
                                bottleModel.get(i).epersent = 0.0;
                            else
                                bottleModel.get(i).epersent -= 0.01;
                        }
                    }
                }
                onPressAndHold: {
                    minustimer.start();
                }
                onReleased: minustimer.stop();
            }
        }
    H2oButton {
        id: sendChange
        x: add.x - 15
        y: minus.y + 100
        height: 45
        width: 80
        text: qsTr("OK") + translator.tr
        onClicked: {
            var temp=0.0;
            temp = bottleModel.get(0).epersent * maintenance_reagent.getObjFloat("a_default");
            maintenance_reagent.setObj("a_vol", parseInt(temp));
            temp = bottleModel.get(1).epersent * maintenance_reagent.getObjFloat("b_default");
            maintenance_reagent.setObj("b_vol", parseInt(temp));
            temp = bottleModel.get(2).epersent * maintenance_reagent.getObjFloat("c_default");
            maintenance_reagent.setObj("c_vol", parseInt(temp));
            temp = bottleModel.get(3).epersent * maintenance_reagent.getObjFloat("std0_default");
            maintenance_reagent.setObj("std0_vol", parseInt(temp));
            temp = bottleModel.get(4).epersent * maintenance_reagent.getObjFloat("std1_default");
            maintenance_reagent.setObj("std1_vol", parseInt(temp));
            temp = bottleModel.get(5).epersent * maintenance_reagent.getObjFloat("std2_default");
            maintenance_reagent.setObj("std2_vol", parseInt(temp));
            temp = bottleModel.get(6).epersent * maintenance_reagent.getObjFloat("cleaning_default");
            maintenance_reagent.setObj("cleaning_vol", parseInt(temp));

        }
    }
    H2oButton {
        id: cancelChange
        x: add.x - 15
        y: minus.y + 160
        height: sendChange.height
        width: sendChange.width

        text: qsTr("Cancel") + translator.tr
        onClicked: {
            console.debug("QML::clicked Cancel button")
            page_manager.startUpdate("maintenance.reagent");
        }
    }

    Timer {
        id: addtimer
        interval: 200
        repeat: true
        running: false
        triggeredOnStart: true
        onTriggered: {
            console.debug("QML::H2oBottle start timer")
            //persent<0.0? persent = 1.0 : persent -= 0.05;
            for(var i=0; i<7; i++)
            {
                if(bottleModel.get(i).eunlinked === false)
                {
                    if((bottleModel.get(i).epersent + 0.05) >= 1.0)
                        bottleModel.get(i).epersent = 1.0;
                    else
                        bottleModel.get(i).epersent += 0.05;
                }
            }

            //canvas.requestPaint();
        }
    }
    Timer {
        id: minustimer
        interval: 200
        repeat: true
        running: false
        triggeredOnStart: true
        onTriggered: {
            console.debug("QML::H2oBottle start timer")
            //persent<0.0? persent = 1.0 : persent -= 0.05;
            for(var i=0; i<7; i++)
            {
                if(bottleModel.get(i).eunlinked === false)
                {
                    if((bottleModel.get(i).epersent - 0.05) <= 0.0)
                        bottleModel.get(i).epersent = 0.0;
                    else
                        bottleModel.get(i).epersent -= 0.05;
                }
            }

            //canvas.requestPaint();
        }
    }*/

    H2oButton {
        id: applyBtn
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        height: 60
        width: parent.width
        text: qsTr("APPLY") + translator.tr
        buttonRadius: 0
        enabled: false
        onClicked: {
            mainMessageDialogOneButton.openDialog("reminder", qsTr("Reagent volumn settings done"));

            maintenance_reagent.clearObjTList();
            for(var i = 0; i < bottleModel.rowCount(); i++)
            {
                if(bottleChanged[i])
                {
                    var temp=0.0;
                    temp = bottleModel.get(i).epersent * maintenance_reagent.getObjFloat(bottleModel.get(i).edefaultkey);
                    maintenance_reagent.addObjToTList(bottleModel.get(i).ekey, parseInt(temp));
                    console.warn("QML::Reagent set: "+bottleModel.get(i).ename+" "+temp);
                }
            }
            maintenance_reagent.setObjTList();
            applyBtn.enabled = false;
            bottleChanged = [false, false, false, false, false];
        }
    }
}
