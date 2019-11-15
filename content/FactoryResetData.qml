/****************************************************************************
** FactoryResetData.qml - Interface to factory reset
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
import "time.js" as Time

Item {
    property bool initial: false

    function init()
    {
        initial = true;

        //translator.translate("ZH");
        //local_settings.setValue("system", "language", "ZH");
        //local_settings.setValue("system", "backlight", false);
        //local_settings.setValue("system", "backlighttime", 2);

        factory_reset.clearObjTList();
        factory_reset.addObjToTList("hmi", 1);
        var type = system_info.getObjInt("instr_type");
        if(type === 1)
            factory_reset.addObjToTList("hmi_ext", 1);

        startup_initial.clearObjTList();
        startup_initial.addObjToTList("recovery", 1);
        startup_initial.addObjToTList("break", 1);

        var setPageList = ["factory.reset", "startup.initial"];

        page_manager.startSetPageList(setPageList);
    }

    function initCompleted()
    {
        // set prime command
        // set active Time
        // set init flag

        startup_initial.clearObjTList();
        startup_initial.addObjToTList("flag", true);
        var date = new Date();
        //console.debug("QML::FactoryReset date: "+date.getFullYear()+"-"+date.getMonth()+"-"+date.getDate());

        var time = Time.convertTimeU32(date.getFullYear(), date.getMonth()+1, date.getDate(),
                            date.getHours(), date.getMinutes(), date.getSeconds());

        var hmiTime = local_settings.getValueInt("startup", "activetime", 0);
        //var hmiTime = Number.fromLocaleString(Qt.locale(), temp);
        var mcuTime = startup_initial.getObjInt("active_time");

        if(mcuTime === 0 && hmiTime === mcuTime) {
            local_settings.setValue("startup", "activetime", time);
            startup_initial.addObjToTList("active_time", "0x"+time.toString(16));
        }

        startup_initial.addObjToTList("init", 1); // Reset life of beng_tube valve_tube reagent volume
        var type = system_info.getObjInt("instr_type");
        startup_initial.addObjToTList("prime", type);

        startup_initial.setObjTList();
    }

    function reset()
    {
        local_settings.setValue("system", "backlight", false);
        local_settings.setValue("system", "backlighttime", 2);
        mainPrognosysMgr.prognosysEnabled = true;

        //translator.translate("ZH");
        //local_settings.setValue("system", "language", "ZH");
        var type = system_info.getObjInt("instr_type");
        if(type === 1) // extend
            factory_reset.setObjs(["hmi","hmi_ext"], ["1", "1"]);
        else // standard
            factory_reset.setObjs(["hmi"], ["1"]);
    }
}
