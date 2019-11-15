/****************************************************************************
** RefreshTimer.qml - Timer for refresh page in real time
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


import QtQuick 2.0

Item {
    id: root
    property bool running: false

    /*Connections {
        target: page_manager
        ignoreUnknownSignals: true
        onSigSetTimerRepeat: {
            refreshTimer.running = b;
        }
    }*/

    function detectUDisk()
    {
        // detect usb disk
        udisk_dectect.findFile("/sys/class/scsi_disk/");
    }

    Timer {
        id: refreshTimer
        interval: 2000
        running: root.running
        //repeat: page_manager.timerRepeat();
        repeat: true
        property int longInterval: 2000*longTick
        property int longTick: 10
        property int tick: 0
        property int syncRTCTick: 0
        onTriggered: {
            detectUDisk();
            mainEventModel.checkRtcError();

            if(page_manager.isTimerRunning() && page_manager.userRepeat())
            {
                if(page_manager.timerRepeat() )
                {
                    var pageList;
                    if(mainPrognosysMgr.prognosysEnabled) {
                        pageList = ["current.measure","notification.error","prognosys.indicator"];
                    } else {
                        pageList = ["current.measure","notification.error"];
                    }

                    if(mainStackView.depth <= 1)
                    {
                        pageList.push("latest.measure");
                    }

                    //console.debug("QML::RefreshTimer mainStackView.depth: "+mainStackView.depth)

                    var currentPageName = page_manager.currentPageName();
                    //if(tick == longTick) {
                    //console.debug("QML::RefreshTimer currentPage: "+currentPageName);
                    //}

                    // repeat command defined here
                    if(     currentPageName === "status.page1"
                            || currentPageName === "status.page2"
                            || currentPageName === "status.page3"
                            || currentPageName === "io.main"
                            || currentPageName === "maintenance.manual"
                            || currentPageName === "test.pv"
                            || currentPageName === "test.mh"
                            || currentPageName === "test.ad"
                            || currentPageName === "test.substep"
                            //|| ((currentPageName === "maintenance.reagent") && (tick == longTick))
                            //|| currentPageName === "prognosys.service"
                            )
                    {
                        pageList.push(currentPageName);
                    }

                    if(system_time.isSync() && syncRTCTick >= 3600) //1800 = 1 hour 3600 = 2 hours
                    {
                        syncRTCTick = 0;
                        // sync HMI board rtc to dosing board
                        var datetime = new Date();
                        var year = datetime.getFullYear();
                        var month = datetime.getMonth()+1; // Date start from 0
                        var day = datetime.getDate();
                        var hour = datetime.getHours();
                        var minute = datetime.getMinutes();
                        var seconds = datetime.getSeconds();

                        console.debug("Sync Time: "+year+"/"+month+"/"+day+" "+hour+":"+minute+":"+seconds);

                        system_info.clearObjTList();
                        system_info.addObjToTList("year", year);
                        system_info.addObjToTList("month", month);
                        system_info.addObjToTList("day", day);
                        system_info.addObjToTList("hour", hour);
                        system_info.addObjToTList("minute", minute);
                        system_info.addObjToTList("seconds", seconds);
                        system_info.setWorkType(1); //PageSetTList = 1
                        pageList.push("system.info");

                    }

                    syncRTCTick++;

                    // console.debug("QML::repeat current:"+currentPageName+" list: "+pageList)
                    page_manager.startUpdatePagesSetTList(pageList);

                } else if(tick == longTick) {

                    // If probe data init failed, the connections can't be restored
                    if(!mainDataInit.probeDataInitFailed) {
                        // check probe connection to restore it.
                        mainEventModel.checkProbeConnection();
                    }
                }
            }

            // increase tick
            if(tick == longTick) {
                tick = 0;
            }
            tick++;
        }
    }


    Timer {
        id: watchdogTimer
        interval: 20000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            watchdog.sdNotifyPidNotifyWatchdog();
        }
    }

    /*Connections {
        target: mainStackView
        onCurrentItemChanged:
        {
            if(mainStackView.currentItem)
            {
                var objName = mainStackView.currentItem.objectName

                if(objName.length > 0) {
                    var pageName = mainStackView.currentItem.objectName;
                    console.debug("QML::mainStackView current page name: "+pageName)
                    if(pageName == "home page") {
                        page_manager.startUpdate("latest.measure")
                    }
                }
            }
        }
    }*/
}
