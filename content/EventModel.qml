/****************************************************************************
** EventModel.qml - Event model
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

import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.1
import "../components"
import "time.js" as TimeScript

Item {
    id: root
    // notifyErrList records errors reported by HMI board
    // element 0 - Probe communication error (index 49 in error list)
    // element 1 - RTC battery failure (index 50 in error list)
    // element 2 - RTC battery low (index 51 in error list)
    property var notifyErrList: ["0", "0", "0"]
    property var notifyErrTimeList: ["0", "0", "0"]
    property var notifyErrAttrList: ["0", "0", "0"]

    property alias eventModel: listModel
    property alias canClearModel: clearModel

    // first priority attribute
    // 0 - none
    // 1 - reminder
    // 2 - warning
    // 3 - error
    property int firstPriorityAttr: 0 // 0-none 1-reminder 2-warning 3-error
    property int firstPriorityIndex: 0
    property color firstPriorityColor
    property string firstPriorityText
    property string firstPriorityTypeText

    property bool isEventExist: false
    property var iconText : ["", "\ue609", "\ue627", "\ue631"]
    property var colorText: ["#0098db", "#0098db", "#ffb446", "#ee5353"]
    property var typeText : [
        QT_TRANSLATE_NOOP("H2oTableView", "Reminder"),
        QT_TRANSLATE_NOOP("H2oTableView", "Reminder"),
        QT_TRANSLATE_NOOP("H2oTableView", "Warning"),
        QT_TRANSLATE_NOOP("H2oTableView", "Error")
    ]

    signal eventUpdated()

    ListModel {
        id: listModel
    }

    ListModel {
        id: clearModel
        ListElement { code: 15; exist: false }
        ListElement { code: 42; exist: false }
    }

    Connections {
        target: notification_error
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            updateModel(false);
            //console.debug("QML::NotifyDialog error")

            page_manager.updatePageDone();
        }
    }

    Connections {
        target: notification_error_s
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            page_manager.updatePageDone();
        }
    }

    Connections {
        target: if_probe
        ignoreUnknownSignals: true
        onProbeIfWriteError: {
            console.debug("QML::ProbeIfWriteError: "+errCode);

            messageDialog.type = "warning";
            messageDialog.text = qsTr("Probe Communication failed. Error: ")+translator.tr+errCode;
            messageDialog.open();

        }

        onProbeIfError: { // timeout and disconnected.

            if(errCode == "timeout" || errCode == "dbus err") {
                page_manager.setInitPage(false);
                page_manager.setTimerRepeat(false);
                probe_worker.stopWork();

                //Add probe comm err to list
                //0 - Probe communication error
                //3 - error type
                if(getErrInNotifyErrList(0) !== true)
                {
                    setErrInNotifyErrList(0, true, 3);
                    updateModel(true);
                }
            }
        }
    }

//    Connections {
//        target: if_probe
//        ignoreUnknownSignals: true
//        onProbeIfError: {
//            //0 - Probe communication error
//            //3 - error type
//            if(getErrInNotifyErrList(0) !== true)
//            {
//                setErrInNotifyErrList(0, true, 3);
//                updateModel(true);
//            }
//        }
//    }

    // exist: true-exist false-not exist
    // attr: 0-none 1-reminder 2-warning 3-error
    function setErrInNotifyErrList(index, exist, attr)
    {
        notifyErrList[index] = exist ? "1" : "0";
        var datetime = new Date();
        var time = TimeScript.convertTimeU32(datetime.getFullYear(),
                                             datetime.getMonth(),
                                             datetime.getDate(),
                                             datetime.getHours(),
                                             datetime.getMinutes(),
                                             datetime.getSeconds());
        notifyErrTimeList[index] = time;
        notifyErrAttrList[index] = attr<<5; // attribute
    }

    function getErrInNotifyErrList(index)
    {
        var ret = notifyErrList[index] === "1" ? true : false;

        return ret;
    }

    function checkProbeConnection()
    {
        page_manager.startUpdate("measure.range");
        var data = measure_range.getObjString("index");
        console.debug("QML::checkProbeConnection");
        // delete probe comm err from list
        if(data !== "timeout" && data !== "null") {
            //0 - Probe communication error
            //3 - error type
            setErrInNotifyErrList(0, false, 3);

            page_manager.setTimerRepeat(true);
        }
    }

    // HMI rtc error is reported to MCU through probe daemon,
    // and it is merged with MCU rtc error. View rtc error log detail info
    // to distinguish which rtc error happens.


    function checkRtcError()
    {
        var err = rtc_dectect.rtcStatus();

        if(rtc_dectect.isRtcStatusChanged())
        {
            notification_error.setObj("rtc_err", err);
        }
    }

    function formatList(list, num, addList)
    {
        var retList = list
        if(retList.length !== num) {
            retList = [];
            for(var i = 0; i < num; i++) {
                retList.push(0);
            }
        }

        for(var j = 0; j < addList.length; j++) {
            retList.push(addList[j]);
        }

        //console.debug("QML::EventModel list: "+retList)

        return retList;
    }

    function isChangedInList(list, preList)
    {
        var ret = false;
        if(list.length === preList.length)
        {
            for(var i = 0; i < list.length; i++)
            {
                if(list[i] !== preList[i])
                {
                    ret = true;
                    break;
                }
            }
        } else {
            ret = true;
        }

        return ret;
    }

    property var preList: [];
    property var preTimeList: [];

    function updateModel(commErr) // notification_error
    {
        var list = [];
        var attrList = [];
        var timeList = [];

        if(!commErr)
        {
            list = notification_error.getObjStringList("list"); //list enabled: error exist
            attrList = notification_error_s.getObjStringList("attr_list");
            timeList = notification_error.getObjStringList("time_list");
        }

        // update error list
        if((list.length === 48 && attrList.length === 48 && timeList.length === 48) // check received list
           || commErr) // communication with timeout or dbus error
        {
            if(commErr)
            {
                list = formatList(list, 48, notifyErrList);
                attrList = formatList(attrList, 48, notifyErrAttrList);
                timeList = formatList(timeList, 48, notifyErrTimeList);
            }

            if(isChangedInList(list, preList) || isChangedInList(timeList, preTimeList))
            {
                eventModel.clear();

                isEventExist = false;
                firstPriorityAttr = 0;

                // clear can cleared error exist
                for(var j = 0; j < canClearModel.rowCount(); j++) {
                    clearModel.get(j).exist = false;
                }

                for(var i = 0; i < list.length; i++)
                {
                    if(list[i] > 0) //error exist
                    {
                        isEventExist = true;
                        if(i < attrList.length)
                        {
                            // get error attribute
                            var attr = (attrList[i] & 0x60) >> 5; // 0-none 1-reminder 2-warning 3-error
                            if(attr == 0) attr = 1;

                            // get error occurrs time
                            var time = TimeScript.convertU32Time(timeList[i]);
                            eventModel.append({"icon": iconText[attr], "time": time, "type":  typeText[attr], "content": mainEventDesc.description(i), "code": i })

                            // find first priority error
                            if(attr > firstPriorityAttr) {
                                firstPriorityAttr = attr;
                                firstPriorityColor = root.colorText[firstPriorityAttr];
                                firstPriorityTypeText = root.typeText[firstPriorityAttr];
                                firstPriorityIndex = i;
                                firstPriorityText = mainEventDesc.description(i);
                            }

                            // check can cleared error exist
                            for(var j = 0; j < clearModel.rowCount(); j++) {
                                if(clearModel.get(j).code === i) {
                                    clearModel.get(j).exist = true;
                                }
                            }

                            //console.debug("QML::EventModel firstPriorityAttr "+firstPriorityAttr);
                            //console.debug("QML::EventModel firstPriorityIndex "+firstPriorityIndex);
                            //console.debug("QML::EventModel firstPriorityColor "+firstPriorityColor);
                            //console.debug("QML::EventModel firstPriorityText "+firstPriorityText);
                            //console.debug("QML::EventModel firstPriorityTypeText "+firstPriorityTypeText);
                        }
                    }
                }

                eventUpdated();
            }

            preList = list;
            preTimeList = timeList;
        }
    }
}
