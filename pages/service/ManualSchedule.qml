/****************************************************************************
** ManualSchedule.qml - UI for free schudle to edit and execute trigger command
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
import QtQuick.Controls.Styles.Flat 1.0 as Flat
import "../../components"

//display normal actions only

Rectangle {
    id: rectangle
    width: 800
    height: 360
    objectName: "free schedule"
    property string title: qsTr("Free Schedule")+translator.tr
    property var editList: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    property int editIndex: 0
    property int messageDialogIndex: 0
    property bool editMode: false  // true - edit mode; false - view mode
    property bool isNeedDelDoneAction: false
    property string usrAction: "init"

    enabled: mainPermisMgr.editabled

    Connections {
        target: maintenance_manual
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            console.debug("QML::UpdatePage maintenance.manual")

            var status = actionStatus();
            switch(status)
            {
            case "running":
                if(usrAction == "start") {
                    waitTimer.stop();
                    mainBusyDialog.close();

                    // goto started mode
                    usrAction = "started";
                }

                // disable edit mode
                editMode = false;

                // update task status
                updateActionTable();
                break;
            case "done":
                // if done goto edit mode
                if(editMode == false)
                {
                    isNeedDelDoneAction = true;
                    editMode = true;
                    updateActionTable();
                }

                // "start schedule"/"stop schedule" action hasn't "running" status and it goes to "done" after executed immediately.
                // For these action, restore idle from busy status.
                if(usrAction == "start")
                {
                    isNeedDelDoneAction = true;
                    usrAction = "wait"; //wait for list update
                    editMode = false;
                } else if(usrAction == "wait") {
                    waitTimer.stop();
                    mainBusyDialog.close();
                    updateActionTable();
                    usrAction = "";
                    editMode = true;
                }

                break;
            case "none":

                // if usrAction == "started" and "none" case means the schedule task is stopped
                // by clicking the start/stop button in home page.
                if(usrAction == "stop" || usrAction == "started")
                {
                    waitTimer.stop();
                    mainBusyDialog.close();
                    usrAction = "";

                    // goto edit mode
                    if(editMode == false) {
                        clearAction();
                        editMode = true;
                    }
                }
                else if(usrAction == "start")
                {
                    console.debug("QML::ManualSchedule start");
                    // wait for schedule running
                }
                else if(usrAction == "init")
                {
                    editMode = true;
                    usrAction = "";
                }

                break;

            case "error":
                // ignore
                break;
            }

            /*initial range list*/
            rangeList.updateRangeList();

            // console.debug("QML::ManualSchedule onProbeUpdateDone")

            page_manager.updatePageDone();
        }
    }

    function clearEditList() {
        editIndex = 0;
        for(var i = 0; i < editList.length; i++)
        {
            editList[i] = 0;
        }
    }

    function clearAction()
    {
        actionTable.model.clear();
        clearEditList();
    }

    function editListLength()
    {
        var len = actionTable.model.length;
        return len;
    }

    function appendActionToTable(index, action, range, status)
    {
        var rangeName;

        if(action > (actionDesc.length-1)) {
            action = actionDesc.length-1; //Error
        }

        if(status > (statusDesc.length-1)) {
            status = statusDesc.length-1; // Error
        }

        if(action === 12 || action === 13 || action === 8 || action === 4) // if action = Start || action = Schedule Off || action = measure || action = powerDrain
        {
            rangeName = "";
        } else {
            if(range > (rangeDesc.length-1)) {
                range = rangeDesc.length-1; // Error
            }
            rangeName = rangeDesc[range];
        }

        actionTable.model.append({"number": (index+1),
                                     "action": qsTr(actionDesc[action-1]),
                                     "range": qsTr(rangeName),
                                     "status": qsTr(statusDesc[status])});
    }

    // remove ActionDone From Action Table
    function removeActionDone()
    {
        // remove action which done
        if(isNeedDelDoneAction) {
            isNeedDelDoneAction = false;
            clearAction();
        }
    }

    function actionStatus()
    {
        var ret = "none";
        var actionList = maintenance_manual.getObjStringList("action_list");

        if(actionList.length == 32) {
            for(var i = 0; i < actionList.length; i++) {
                var action = actionList[i] & 0xFF;
                if(action != 0) {
                    var status = (actionList[i] >> 24) & 0xFF; //status
                    if(status != 2) { //running or waiting
                        ret = "running";
                        break;
                    } else {
                        ret = "done";
                    }
                } else {
                    break;
                }
            }
        } else {
            ret = "error";
        }

        console.debug("action status: "+ret);

        return ret;
    }

    function updateActionTable()
    {
        var actionList = maintenance_manual.getObjStringList("action_list");
        var allActionDone = true;

        // Update action table model
        actionTable.model.clear();
        for(var i = 0; i < actionList.length; i++) {
            var type = (actionList[i] & 0xFF0000) >> 16;
            /*triggerType:
            0: UI normal
            1: UI Maintenance
            2: Modbus
            3: IO trigger*/
            if(type != 0) continue;  //display only UI normal actions

            /* byte 0: action
            byte 1: range Idx or flow steps
            byte 2: rev - trigger type
            byte 3: status(0: not exec; 1: doing; 2: done)*/
            var action = actionList[i] & 0xFF; //action
            //if none break
            if(action === 0) break;

            var range = (actionList[i] & 0xFF00) >> 8; //range

            var status = (actionList[i] >> 24) & 0xFF; //status
            //console.debug("QML::ManualSchedule action:"+actionList[i]+"status:"+status);

            if(status !== 2) // if(status != done)
            {
                allActionDone = false; // not all action been done yet
            }

            // console.debug("QML::action: "+action+" range: "+range+" status: "+status);
            appendActionToTable(i, action, range, status);
        }

        // var actionNum = maintenance_manual.getObjInt("action_num");

        // check if action list done
        if(allActionDone) {
            //editMode = true; // if done, back to edit mode
            //canUpdateActionTable = false;
            clearEditList();
            //isNeedDelDoneAction = true;
        }
    }

    function checkEditList()
    {
        var ret = false;
        for(var i = 0; i < editList.length; i++) {
            if(editList[i] > 0) {
                ret = true;
                break;
            }
        }

        return ret;
    }

    function addActionToEditList()
    {
        var actionCode = actionList.model.get(actionList.currentIndex).code;

        removeActionDone();

        if(actionCode > 0) {
            var rangeCode = rangeList.currentIndex;
            //console.debug("QML::ManualSchedule action code: "+actionCode);

            var value = (actionCode & 0xFF) | ((rangeCode & 0xFF) << 8);
            if(actionCode === 12 || actionCode === 13) // if action = Start || action = Schedule Off
            {
                value = (actionCode & 0xFF); // set range to 0
            }
            else if(actionCode === 8 || actionCode === 4) // if action = measure || action = powerDrain
            {
                value = (actionCode & 0xFF) | (0xFF << 8); // set range to 255 when action = measure
            }

            editList[editIndex] = value;
            appendActionToTable(editIndex, actionCode, rangeCode, 3); // status = ""
            editIndex++;
            console.debug("QML::FreeS editlist: "+editList)
        }
    }

    Rectangle {
        id: sp
        x: 280
        width: Flat.FlatStyle.onePixel
        height: parent.height
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 290
        color: Flat.FlatStyle.lightFrameColor
    }

    H2oTableView {
        id: actionTable
        x: 280
        anchors.left: sp.right
        anchors.verticalCenter: sp.verticalCenter
        width: parent.width - 300
        height: parent.height
        highlightOnFocus: false
        headerVisible: true
        alternatingRowColors: false
        //backgroundVisible: false
        frameVisible: false
        model: ListModel {}

        TableViewColumn {
            role: "number"
            title: qsTr("#")+translator.tr
            width: 30
            resizable: false
            movable: false
            //delegate: textDelegate

        }

        TableViewColumn {
            role: "action"
            title: qsTr("Action")+translator.tr
            width: 170
            resizable: false
            movable: false
            //delegate: textDelegate

        }
        TableViewColumn {
            role: "range"
            title: qsTr("Range")+translator.tr
            width: 185
            resizable: false
            movable: false
            //delegate: textDelegate
        }
        TableViewColumn {
            role: "status"
            title: qsTr("Status")+translator.tr
            width: 160
            resizable: false
            movable: false
            //delegate: textDelegate
        }
    }

    property var actionDesc: [
        QT_TRANSLATE_NOOP("H2oTableView", "Drain"),   //index = 1
        QT_TRANSLATE_NOOP("H2oTableView", "Flush"),   // 2
        QT_TRANSLATE_NOOP("H2oTableView", "Prime"),   // 3
        QT_TRANSLATE_NOOP("H2oTableView", "Power drain"),  // 4
        QT_TRANSLATE_NOOP("H2oTableView", "Online"), // 5 Offine defined in MCU
        QT_TRANSLATE_NOOP("H2oTableView", "Verify STD0"), // 6
        QT_TRANSLATE_NOOP("H2oTableView", "Verify STD1"),  // 7
        QT_TRANSLATE_NOOP("H2oTableView", "Measure"),      // 8
        QT_TRANSLATE_NOOP("H2oTableView", "Calibration"),  // 9
        QT_TRANSLATE_NOOP("H2oTableView", "Clean"),        // 10
        "FlowSteps Del", //delete for requirement          // 11
        QT_TRANSLATE_NOOP("H2oTableView", "Start"),        // 12
        QT_TRANSLATE_NOOP("H2oTableView", "Schedule Off"), // 13
        QT_TRANSLATE_NOOP("H2oTableView", "Empty OF cup"), // 14
        "Error"
    ]

    property var statusDesc: [
        QT_TRANSLATE_NOOP("H2oTableView", "Not done"),
        QT_TRANSLATE_NOOP("H2oTableView", "Doing"),
        QT_TRANSLATE_NOOP("H2oTableView", "Done"),
        ""
    ]

    property var rangeDesc: [
        QT_TRANSLATE_NOOP("H2oTableView", "ULR 0.02~15 mg/L"), // index = 0
        QT_TRANSLATE_NOOP("H2oTableView", "LR 0.05~30 mg/L"),
        QT_TRANSLATE_NOOP("H2oTableView", "MR 7.5~100 mg/L"),
        QT_TRANSLATE_NOOP("H2oTableView", "HR 80~1000 mg/L"),
        "Error"
    ]

    Rectangle {
        id: editItems
        enabled: tabView.currentIndex == 0 ? true:false
        Text {
            id: rangeText
            x: 14
            y: 106
            text: qsTr("Range")+translator.tr
            font.pixelSize: 20
        }

        H2oDropBoxEx {
            id: actionList
            x: 24
            y: 47
            width: 249
            height: 40
            dropAreaSize: 6

            model: mainPowerDrain.enabled ? listModelExtend : listModelStandard
            ListModel {
                id: listModelStandard
                ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "Drain"); range: true; code: 1; index: 0 }
                ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "Flush"); range: true; code: 2; index: 1 }
                ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "Prime"); range: true; code: 3; index: 2 }
                ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "Online"); range: true; code: 5; index: 3 }
                ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "Verify STD0"); range: true; code: 6; index: 4 }
                ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "Verify STD1"); range: true; code: 7; index: 5 }
                ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "Measure"); range: false; code: 8; index: 6 }
                ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "Calibration"); range: true; code: 9; index: 7 }
                ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "Clean"); range: true; code: 10; index: 8 }
                ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "Start"); range: false; code: 12; index: 9 }
                ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "Schedule Off"); range: false; code: 13; index: 10 }
            }

            ListModel {
                id: listModelExtend
                ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "Drain"); range: true; code: 1; index: 0 }
                ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "Flush"); range: true; code: 2; index: 1 }
                ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "Prime"); range: true; code: 3; index: 2 }
                ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "Power drain"); range: false; code: 4; index: 3 }
                ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "Online"); range: true; code: 5; index: 4 }
                ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "Verify STD0"); range: true; code: 6; index: 5 }
                ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "Verify STD1"); range: true; code: 7; index: 6 }
                ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "Measure"); range: false; code: 8; index: 7 }
                ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "Calibration"); range: true; code: 9; index: 8 }
                ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "Clean"); range: true; code: 10; index: 9 }
                ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "Start"); range: false; code: 12; index: 10 }
                ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "Schedule Off"); range: false; code: 13; index: 11 }
            }
        }

        H2oDropBoxEx {
            id: rangeList
            x: 24
            y: 152
            width: 249
            height: 40
            property bool inited: false
            enabled: actionList.model.get(actionList.currentIndex).range //actionList.currentIndex === 6 || actionList ? false : true
            model: ListModel {
                id: rangeStandardModel
                ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "ULR 0.02~15 mg/L"); check: false; index: 0 }
                ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "LR 0.05~30 mg/L"); check: false; index: 1 }
                ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "MR 7.5~100 mg/L"); check: false; index: 2 }
            }

            ListModel {
                id: rangeExtendModel
                ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "ULR 0.02~15 mg/L"); check: false; index: 0 }
                ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "LR 0.05~30 mg/L"); check: false; index: 1 }
                ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "MR 7.5~100 mg/L"); check: false; index: 2 }
                ListElement { name: QT_TRANSLATE_NOOP("H2oDropBoxEx", "HR 80~1000 mg/L"); check: false; index: 3 }
            }

            function updateRangeList() {
                if(inited === false)
                {
                    inited = true;
                    var instrType = system_info.getObjInt("instr_type");
                    //console.debug("QML::ManualSchedule instrType: "+instrType);
                    if(instrType === 1) //extended type
                    {
                        rangeList.model = rangeExtendModel;
                        //console.debug("QML::ManualSchedule updateRange")
                        dropAreaSize = 4;
                    } else {
                        rangeList.model = rangeStandardModel;
                    }
                }
            }
        }

        Text {
            id: actionText
            x: 14
            y: 8
            text: qsTr("Action")+translator.tr
            font.pixelSize: 20
        }

        H2oButton {
            id: addBtn
            anchors.left: rangeList.left
            anchors.top: rangeList.bottom
            anchors.topMargin: 20
            width: 120
            height: 40
            text: qsTr("ADD")+translator.tr
            enabled: (editIndex < 16 && editMode) ? true:false

            onClicked: {
                addActionToEditList();
            }
        }

        H2oButton {
            id: clrBtn
            anchors.left: addBtn.right
            anchors.leftMargin: 10
            anchors.verticalCenter: addBtn.verticalCenter
            width: 120
            height: 40
            text: qsTr("CLEAR")+translator.tr
            enabled: editMode

            onClicked: {
                clearAction();
            }
        }

        H2oMessageDialog {
            id: messageDialog

            onAccepted: {
                switch(messageDialogIndex)
                {

                case 0: // run action list
                    //console.debug("QML::ManualSchedule list: "+editList);

                    if(checkEditList()) {
                        console.debug("QML::FreeS runList: "+editList)
                        maintenance_manual.clearObjTList();
                        maintenance_manual.addObjToTList("action_stop", 1);
                        maintenance_manual.addObjToTList("set/action_list", editList);
                        maintenance_manual.addObjToTList("action_execute", 1);
                        maintenance_manual.setObjTList();
                        usrAction = "start";
                        mainBusyDialog.open();
                        waitTimer.start();
                    } else {
                        mainMessageDialogOneButton.openDialog("reminder", qsTr("Please add actions before execution."))
                    }

                    break;
                case 1: //stop action list
                    maintenance_manual.setObj("action_stop", 1);
                    usrAction = "stop";
                    mainBusyDialog.open();
                    waitTimer.start();

                    break;
                }
            }

            onRejected: {

            }
        }

        // timer for clearing busy status
        Timer {
            id: waitTimer
            interval: 4000
            running: false
            repeat: false
            triggeredOnStart: false
            onTriggered: {
                mainBusyDialog.close();
            }
        }

        H2oButton {
            id: runBtn
            anchors.left: addBtn.left
            anchors.top: addBtn.bottom
            anchors.topMargin: 20
            width: 120
            height: 40
            text: qsTr("RUN")+translator.tr
            enabled: editMode

            onClicked: {
                if(checkEditList()) {
                    messageDialog.text = qsTr("Do you want to run the action list ?")+translator.tr;
                    messageDialog.open();
                    messageDialogIndex = 0;
                } else {
                    mainMessageDialogOneButton.openDialog("reminder",
                                                          qsTr("Please add actions before execution."))
                }
            }
        }

        H2oButton {
            anchors.left: clrBtn.left
            anchors.verticalCenter: runBtn.verticalCenter
            width: 120
            height: 40
            text: qsTr("STOP")+translator.tr

            enabled: !editMode

            onClicked: {
                messageDialog.text = qsTr("Do you want to stop the action list ?")+translator.tr;
                messageDialog.open();
                messageDialogIndex = 1;
            }
        }
    }
}
