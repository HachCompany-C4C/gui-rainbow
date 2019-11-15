/****************************************************************************
** SignalService.qml - Data initilization
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
import "components"

Item {
    property alias initTimer: startInitTimer

    property bool probeDataInitDone: false
    property bool probeDataInitFailed: false

    signal dataInitDone()
    signal dataInitFailed()

    property int count: 0

    // This connection checks whether mcu on "bootloader" or "application" after startup
    Connections {
        target: software_update  //software update page
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            console.debug("QML::UpdatePage software.update")

            if(!probeDataInitDone) {
                var mode = software_update.getObjString("flash_result");
                if(mode === "bootloader") {
                    page_manager.setInitPage(false);
                    page_manager.setTimerRepeat(false);
                    probe_worker.stopWork();
                    dataInitFailed();
                    probeDataInitDone = true;

                    mainNaviPage.navigate(2, 2, 1); //-> Servicemenu, Softwareupgrade, 0
                    mainMessageDialogOneButton.openDialog("error",
                                                         qsTr("MCU firmware is missed or broken, please update software."));
                }
            }

            page_manager.updatePageDone();
        }
    }

    Connections {
        target: if_probe
        ignoreUnknownSignals: true

        onProbeIfError: { // timeout and disconnected.
            if(!probeDataInitDone) {
                page_manager.setInitPage(false);
                page_manager.setTimerRepeat(false);
                probe_worker.stopWork();
                dataInitFailed();
                probeDataInitDone = true;
                mainMessageDialogOneButton.openDialog("error",
                                                     qsTr("Probe communication error, UI initialization failed. Please check the connection and restart it"));
            }
        }
    }

    property var pageList: [
        software_update,
        startup_initial,
        system_info,
        notification_error,
        mask_notification_error,
        notification_error_s,
        current_measure,
        measure_range,
        measure_schedule,
        measure_mode,
        measure_others,
        measure_bias,

        calibration_schedule,
        calibration_mode,

        cleaning_schedule,
        cleaning_mode,
        io_main,
        io_modbus,
        maintenance_manual,
        maintenance_reagent,
        status_page1,
        status_page2,
        status_page3,
        latest_measure,
        notification_concentration,
        prognosys_service,
        prognosys_indicator,
        test_pv,
        test_mh,
        test_ad,
        test_substep,
        test_io,
        latest2_measure
    ]

    Connections {
        target: page_manager
        ignoreUnknownSignals: true
        onInitPageNext: {
            if(!probeDataInitDone)
            {
                if(count < (pageList.length-1))
                {
                    count++;
                    page_manager.startUpdate(pageList[count].orgName());
                    // console.debug("QML::DataInit pageName: "+pageList[count].orgName())
                } else {
                    page_manager.setInitPage(false);

                    latest_measure.clearObjTList();
                    latest_measure.addObjToTList("log_rawdata", "enable");
                    latest_measure.addObjToTList("log_result", "enable");
                    latest_measure.addObjToTList("log_auto", "enable");
                    io_main.clearObjTList();
                    io_main.addObjToTList("clear_err", 1); // 1=clear io error
                    login_perms.clearObjTList();
                    login_perms.addObjToTList("user", mainPermisMgr.permission);

                    var setPageList;
                    if(system_time.isSync())
                    {
                        // sync HMI board rtc to dosing board
                        var datetime = new Date();
                        var year = datetime.getFullYear();
                        var month = datetime.getMonth()+1; // Date start from 0
                        var day = datetime.getDate();
                        var hour = datetime.getHours();
                        var minute = datetime.getMinutes();
                        var seconds = datetime.getSeconds();
                        system_info.clearObjTList();
                        system_info.addObjToTList("year", year);
                        system_info.addObjToTList("month", month);
                        system_info.addObjToTList("day", day);
                        system_info.addObjToTList("hour", hour);
                        system_info.addObjToTList("minute", minute);
                        system_info.addObjToTList("seconds", seconds);

                        setPageList = ["latest.measure", "system.info", "io.main", "login.perms"];
                    }
                    else
                    {
                        setPageList = ["latest.measure", "io.main", "login.perms"];
                    }

                    var inital = startup_initial.getObjBool("flag");
                    console.debug("QML::DataInit inital flag: "+inital)
                    if(inital === false) {
                        factory_reset.clearObjTList();
                        factory_reset.addObjToTList("hmi", 1);
                        var type = system_info.getObjInt("instr_type");
                        if(type === 1)
                            factory_reset.addObjToTList("hmi_ext", 1);

                        startup_initial.clearObjTList();
                        startup_initial.addObjToTList("recovery", 1);
                        startup_initial.addObjToTList("break", 1);

                        setPageList.push("factory.reset");
                        setPageList.push("startup.initial");
                    } else {
                        startup_initial.clearObjTList();
                        startup_initial.addObjToTList("recovery", 1);
                        setPageList.push("startup.initial");
                    }

                    page_manager.startSetPageList(setPageList);

                    dataInitDone();
                    probeDataInitDone = true;
                }
            }
        }
    }

    // Oneshot time to initialize pages after statup
    Timer {
        id: startInitTimer
        interval: 2000
        running: false
        repeat: false
        triggeredOnStart: false
        onTriggered: {
            //console.debug("QML::DataInit startInitTimer")
            //translator.translate("ZH");
            page_manager.setInitPage(true);
            page_manager.startUpdate(pageList[0].orgName());
        }
    }
}
