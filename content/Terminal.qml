/****************************************************************************
** Terminal.qml - Terminal to recieve command for client
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

    function checkParamsNum(handle, params, num)
    {
        if(params.length >= num) {
            return true;
        } else {
            handle.respond("parameters error");
            return false;
        }
    }

    // dbus interface
    Connections {
        target: terminal_server
        ignoreUnknownSignals: true
        onReceived: {
            parseCommand(cmd, params, terminal_server);
        }
    }

    function parseCommand(cmd, params, respondHandle)
    {
        var page;

        switch(cmd) {
        case "navigate":
            if(checkParamsNum(respondHandle, params, 3)) {
                mainNaviPage.navigate(params[0], params[1], params[2]);
                respondHandle.respond("done");
            }
            break;
        case "setconfig":
            if(checkParamsNum(respondHandle, params, 3)) {
                local_settings.setValue(params[0], params[1], params[2]);
                respondHandle.respond("done");
            }
            break;
        case "getconfig":
            if(checkParamsNum(respondHandle, params, 2)) {
                var value = local_settings.getValue(params[0], params[1], "");
                respondHandle.respond(value);
            }
            break;
        case "maskmsg":
            if(checkParamsNum(respondHandle, params, 1)) {
                comm_terminal.maskMessage(params[0]);
                respondHandle.respond("done");
            }
            break;
        case "umaskmsg":
            if(checkParamsNum(respondHandle, params, 1)) {
                comm_terminal.unmaskMessage(params[0]);
                respondHandle.respond("done");
            }
            break;
        case "printmaskmsg":
            var msg = comm_terminal.printmaskMessage();
            console.debug("QML::Termianl: "+msg);
            respondHandle.respond(msg);
            break;
        case "setrepeat":
            if(checkParamsNum(respondHandle, params, 1)) {
                if(params[0] === "true")
                {
                    page_manager.setUserRepeat(true);
                } else if(params[0] === "false") {
                    page_manager.setUserRepeat(false);
                }

                respondHandle.respond("done");
            }
            break;
        case "print_screen":
            if(checkParamsNum(respondHandle, params, 1)) {
                fb2bmp_tool.startGenerate(params[0]);
                respondHandle.respond("done");
            }
            break;
        case "update_software":
            naviPage.navigate(2, 2, 2);
            page = naviPage.currentPage();
            if(page !== undefined) {
                page.startUpdateSoftware();
            }
            respondHandle.respond("done");
            break;
        case "update_progress":
            var progress = 0;
            if(software_upgrade.getStatus()) { //upgrade process running
                progress = software_upgrade.processPersent();
            }
            respondHandle.respond(progress);
            break;
        case "update_running":
            var isRunning = software_upgrade.getStatus();
            var ret = isRunning ? "true" : "false";
            respondHandle.respond(ret);
            break;
        case "update_error":
            var err = "update not started";
            if(software_upgrade.getStatus()) {
                err = software_upgrade.error();
                if(err == "") err = "ok";
            }
            respondHandle.respond(err);
            break;
        case "calibrate_touch":
            naviPage.navigate(2, 4, 2);
            page = naviPage.currentPage();
            if(page !== undefined) {
                page.calibrateTouch();
            }
            respondHandle.respond("done");
            break;
        case "test_touch":
            if(checkParamsNum(respondHandle, params, 1)) {
                var b = params[0] === "true" ? true : false;
                mainScreenTest.showTest(b);
                respondHandle.respond("done");
            }
            break;
        case "test_touch_status":
            var num = ""+mainScreenTest.getCheckNum();
            respondHandle.respond(num);
            break;
        case "set_initial_flag":
            if(checkParamsNum(respondHandle, params, 1)) {
                if(params[0] === "true")
                {
                    startup_initial.setObj("flag", true);
                } else {
                    startup_initial.setObj("flag", false);
                }

                respondHandle.respond("done");
            }
            break;
        case "set_active_time":
            if(checkParamsNum(respondHandle, params, 1)) {
                var time = params[0];
                local_settings.setValue("startup", "activetime", time);
                startup_initial.setObj("active_time", "0x"+time.toString(16));

                respondHandle.respond("done");
            }
            break;
        case "exec_script":
            if(checkParamsNum(respondHandle, params, 1)) {
                var script = params[0];
                for(var i = 1; i < params.length; i++) {
                    script += " ";
                    script += params[i];
                }

                exec_script.exec(script);

                respondHandle.respond("done");
            }
            break;
        case "exec_script_std":
            if(checkParamsNum(respondHandle, params, 1)) {
                var temp = params[0];
                for(var i = 1; i < params.length; i++) {
                    temp += " ";
                    temp += params[i];
                }

                var std = exec_script.execOutStd(temp);

                respondHandle.respond(std);
            }
            break;
        case "exec_script_err":
            if(checkParamsNum(respondHandle, params, 1)) {
                var temp = params[0];
                for(var i = 1; i < params.length; i++) {
                    temp += " ";
                    temp += params[i];
                }

                var err = exec_script.execOutErr(temp);

                respondHandle.respond(err);
            }
            break;
        case "exec_script_stderr":
            if(checkParamsNum(respondHandle, params, 1)) {
                var temp = params[0];
                for(var i = 1; i < params.length; i++) {
                    temp += " ";
                    temp += params[i];
                }

                var stderr = exec_script.execOutStdErr(temp);

                respondHandle.respond(stderr);
            }
            break;
        case "enable_log":
            if(checkParamsNum(respondHandle, params, 1)) {
                var b = params[0] === "true" ? "enable" : "disable";
                /* Stop measure and stop log when upgrade */
                var items = ["log_rawdata", "log_result", "log_auto"];
                var values = [b, b, b];
                latest_measure.setObjs(items, values);
                respondHandle.respond("done");
            }
            break;

        case "delete_log_files":
            exec_script.execOutStd("rm -r /var/log/mcu*.log");
            var isfile = exec_script.execOutStd("ls /var/log/mcu*.log");
            var res = "done";
            if(isfile !== "") {
                res = "failed";
            }

            respondHandle.respond(res);

            break;
        case "help":
            var respondMsg = "navigate main(0~5) sub(1~5) page(1~4)\n"+
                    "setconfig group key value\n"+
                    "getconfig group key\n"+
                    "maskmsg debugmsg\n"+
                    "umaskmsg debugmsg\n"+
                    "printmaskmsg\n"+
                    "setrepeat true/false\n"+
                    "catchscreen path(/media/sda1)";
            respondHandle.respond(respondMsg);
            break;
        case "version":
            var ver = page_manager.mainVersion();
            respondHandle.respond(ver);
            break;
        case "reset_config":
            var acttime = 0;

            local_settings.setValue("startup", "activetime", acttime);

            startup_initial.clearObjTList();
            startup_initial.addObjToTList("active_time", "0x"+acttime.toString(16));
            startup_initial.addObjToTList("flag", false);

            local_settings.setValue("permission", "enabled", false);
            password_mgr.resetPassword("operator");
            password_mgr.resetPassword("administer");
            local_settings.setValue("prognosys", "enabled", true);
            local_settings.setValue("system", "backlight", false);
            local_settings.setValue("system", "backlighttime", 2);
            local_settings.setValue("system", "language", "ZH");

            io_modbus.clearObjTList();
            io_modbus.addObjToTList("deviceid", 1)   //set device id to modbus deamon by session bus-by mandy
            io_modbus.addObjToTList("baudrate", 3)   //9600

            var setPageList = ["startup.initial", "io.modbus"];

            page_manager.startSetPageList(setPageList);

            respondHandle.respond("done");
            break;
        default:
            respondHandle.respond("unknown command");
        }
    }

    // socket interface
    /*Connections {
        target: comm_terminal
        ignoreUnknownSignals: true
        onRecieveCommand: {
            parseCommand(cmd, params, comm_terminal);
        }
    }*/

}
