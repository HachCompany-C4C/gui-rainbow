/****************************************************************************
** LogDefinition.qml - Interface to get string translated for log
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

    function translate(str, begin, end)
    {
        var ret = "";

        //console.debug("QML::Log Translate:"+str)

        if(str !== "") {
            var bklist = str.split(' ');
            if(begin === undefined) {
                begin = 0;
            }

            if(end === undefined) {
                end = bklist.length;
            }

            for(var j = begin; j < end; j++) {
                //console.debug("QML::Log Translate:"+bklist[j]);
                if(bklist[j] !== undefined ) {
                    ret += log_string.trs(bklist[j])+" ";
                }
            }
        }

        return ret;
    }

    function title(type)
    {
        var ttl = [];
        var list = log_string.title(type);
        for(var i = 0; i < list.length; i++)
        {
            ttl.push(list[i]);
        }

        return ttl;
    }
/*
    property var logTypeListLogList : [
        QT_TR_NOOP("mculog.measure"),
        QT_TR_NOOP("mcucalib"),
        QT_TR_NOOP("mcudiag"),
        QT_TR_NOOP("mcuevent")
    ];

    property var eventLogDescLogList: [
        QT_TR_NOOP("EV_SCH_STOP"),
        QT_TR_NOOP("EV_FLUSH"),
        QT_TR_NOOP("EV_PRIME"),
        QT_TR_NOOP("EV_DRAIN"),
        QT_TR_NOOP("EV_FLOWSTEP"),
        QT_TR_NOOP("EV_SCH_START"),
        QT_TR_NOOP("EV_DIA_CLR"),
        QT_TR_NOOP("EV_DIA_SET"),
        QT_TR_NOOP("EV_RESET"),
        QT_TR_NOOP("EV_DIAG_INFO"),
        QT_TR_NOOP("EV_DIAG_WARN"),
        QT_TR_NOOP("EV_DIAG_ERR"),
        QT_TR_NOOP("EV_CALIBRATION"),
        QT_TR_NOOP("EV_CLEANING"),
        QT_TR_NOOP("EV_MEASURE"),
        QT_TR_NOOP("EV_CALC_GAIN"),
        QT_TR_NOOP("EV_CMD_PUT_OBJ"),
        QT_TR_NOOP("EV_CMD_PUT_MEM"),
        QT_TR_NOOP("EV_FAKE_TEST"),
        QT_TR_NOOP("EV_CFG_RESET"),
        QT_TR_NOOP("EV_SW_UPGRADE"),
        QT_TR_NOOP("EV_RTC_UPDATE"),
        QT_TR_NOOP("EV_AUTO_RANGE_REQ"),
        QT_TR_NOOP("EV_ACT_STOP"),
        QT_TR_NOOP("EV_ACT_START")
    ];

    property var diagLogDescLogList: [
        QT_TR_NOOP("USB_WRITE_FAILURE"),
        QT_TR_NOOP("LOCAL_COMMUNICATION_ERR"),
        QT_TR_NOOP("LED_OUTPUT_LOW"),
        QT_TR_NOOP("NO_SAMPLE_FLOW"),
        QT_TR_NOOP("HEAT_OUT_CTRL"),
        QT_TR_NOOP("DOOR_OPEN"),
        QT_TR_NOOP("AD_SPI_FAILURE"),
        QT_TR_NOOP("FLASH_FAILURE"),
        QT_TR_NOOP("EEPROM_ERROR"),
        QT_TR_NOOP("RAM_FAILURE"),
        QT_TR_NOOP("POWER_FAILURE"),
        QT_TR_NOOP("VOLT_OUT_RANGE"),
        QT_TR_NOOP("HEATER_SENSOR_FAILURE"),
        QT_TR_NOOP("CASE_TEMP_WARNING"),
        QT_TR_NOOP("FAILED_CALIBRATION"),
        QT_TR_NOOP("LEAKAGE_WARNING"),
        QT_TR_NOOP("CHECK_OPTICS"),
        QT_TR_NOOP("REAGENT_INVALID"),
        QT_TR_NOOP("CURRENT_ERROR"),
        QT_TR_NOOP("ALARM_LOW"),
        QT_TR_NOOP("ALARM_HIGH"),
        QT_TR_NOOP("REAGNET_EMPTY_A"),
        QT_TR_NOOP("REAGNET_EMPTY_B"),
        QT_TR_NOOP("REAGNET_EMPTY_C"),
        QT_TR_NOOP("STD_EMPTY_0"),
        QT_TR_NOOP("STD_EMPTY_1"),
        QT_TR_NOOP("STD_EMPTY_2"),
        QT_TR_NOOP("CLEANING_EMPTY"),
        QT_TR_NOOP("REAGNET_LOW_A"),
        QT_TR_NOOP("REAGNET_LOW_B"),
        QT_TR_NOOP("REAGNET_LOW_C"),
        QT_TR_NOOP("STD_LOW_0"),
        QT_TR_NOOP("STD_LOW_1"),
        QT_TR_NOOP("STD_LOW_2"),
        QT_TR_NOOP("CLEANING_LOW"),
        QT_TR_NOOP("LIFESPAN_TUBING_VALVE"),
        QT_TR_NOOP("LIFESPAN_TUBING_PUMP"),
        QT_TR_NOOP("LIFESPAN_MOTOR_PUMP1"),
        QT_TR_NOOP("LIFESPAN_MOTOR_PUMP2"),
        QT_TR_NOOP("LIFESPAN_MOTOR_PUMP3"),
        QT_TR_NOOP("LIFESPAN_MOTOR_MIX"),
        QT_TR_NOOP("RTC_ALARM"),
        QT_TR_NOOP("LED_ERROR"),
        QT_TR_NOOP("CANOPEN_WARNING"),
        QT_TR_NOOP("CANOPEN_ERROR"),
        QT_TR_NOOP("CANOPEN_ER_CONNECT"),
        QT_TR_NOOP("CANOPEN_ER_CONFIG"),
        QT_TR_NOOP("FIX_RANGE_WARNING")
    ];

    property var eventLogDescLogSummary: [
        QT_TR_NOOP("EV_SCH_STOP"),
        QT_TR_NOOP("EV_FLUSH"),
        QT_TR_NOOP("EV_PRIME"),
        QT_TR_NOOP("EV_DRAIN"),
        QT_TR_NOOP("EV_FLOWSTEP"),
        QT_TR_NOOP("EV_SCH_START"),
        QT_TR_NOOP("EV_DIA_CLR"),
        QT_TR_NOOP("EV_DIA_SET"),
        QT_TR_NOOP("EV_RESET"),
        QT_TR_NOOP("EV_DIAG_INFO"),
        QT_TR_NOOP("EV_DIAG_WARN"),
        QT_TR_NOOP("EV_DIAG_ERR"),
        QT_TR_NOOP("EV_CALIBRATION"),
        QT_TR_NOOP("EV_CLEANING"),
        QT_TR_NOOP("EV_MEASURE"),
        QT_TR_NOOP("EV_CALC_GAIN"),
        QT_TR_NOOP("EV_CMD_PUT_OBJ"),
        QT_TR_NOOP("EV_CMD_PUT_MEM"),
        QT_TR_NOOP("EV_FAKE_TEST"),
        QT_TR_NOOP("EV_INIT01"),
        QT_TR_NOOP("EV_INIT02"),
        QT_TR_NOOP("EV_AUTO_RANGE_REQ")
    ];

    property var diagLogDescLogSummary: [
        QT_TR_NOOP("USB_WRITE_FAILURE"),
        QT_TR_NOOP("LOCAL_COMMUNICATION_ERR"),
        QT_TR_NOOP("LED_OUTPUT_LOW"),
        QT_TR_NOOP("NO_SAMPLE_FLOW"),
        QT_TR_NOOP("HEAT_OUT_CTRL"),
        QT_TR_NOOP("DOOR_OPEN"),
        QT_TR_NOOP("AD_SPI_FAILURE"),
        QT_TR_NOOP("FLASH_FAILURE"),
        QT_TR_NOOP("EEPROM_ERROR"),
        QT_TR_NOOP("RAM_FAILURE"),
        QT_TR_NOOP("POWER_FAILURE"),
        QT_TR_NOOP("VOLT_OUT_RANGE"),
        QT_TR_NOOP("HEATER_SENSOR_FAILURE"),
        QT_TR_NOOP("CASE_TEMP_WARNING"),
        QT_TR_NOOP("FAILED_CALIBRATION"),
        QT_TR_NOOP("LEAKAGE_WARNING"),
        QT_TR_NOOP("CHECK_OPTICS"),
        QT_TR_NOOP("REAGENT_INVALID"),
        QT_TR_NOOP("CURRENT_ERROR"),
        QT_TR_NOOP("ALARM_LOW"),
        QT_TR_NOOP("ALARM_HIGH"),
        QT_TR_NOOP("REAGNET_EMPTY_A"),
        QT_TR_NOOP("REAGNET_EMPTY_B"),
        QT_TR_NOOP("REAGNET_EMPTY_C"),
        QT_TR_NOOP("STD_EMPTY_0"),
        QT_TR_NOOP("STD_EMPTY_1"),
        QT_TR_NOOP("STD_EMPTY_2"),
        QT_TR_NOOP("CLEANING_EMPTY"),
        QT_TR_NOOP("REAGNET_LOW_A"),
        QT_TR_NOOP("REAGNET_LOW_B"),
        QT_TR_NOOP("REAGNET_LOW_C"),
        QT_TR_NOOP("STD_LOW_0"),
        QT_TR_NOOP("STD_LOW_1"),
        QT_TR_NOOP("STD_LOW_2"),
        QT_TR_NOOP("CLEANING_LOW"),
        QT_TR_NOOP("LIFESPAN_TUBING_VALVE"),
        QT_TR_NOOP("LIFESPAN_TUBING_PUMP"),
        QT_TR_NOOP("LIFESPAN_MOTOR_PUMP1"),
        QT_TR_NOOP("LIFESPAN_MOTOR_PUMP2"),
        QT_TR_NOOP("LIFESPAN_MOTOR_PUMP3"),
        QT_TR_NOOP("LIFESPAN_MOTOR_MIX"),
        QT_TR_NOOP("RTC_ALARM"),
        QT_TR_NOOP("LED_ERROR"),
        QT_TR_NOOP("CANOPEN_WARNING"),
        QT_TR_NOOP("CANOPEN_ERROR"),
        QT_TR_NOOP("CANOPEN_ER_CONNECT"),
        QT_TR_NOOP("CANOPEN_ER_CONFIG"),
        QT_TR_NOOP("FIX_RANGE_WARNING")
    ];


    property var diagLogDetail: [
        QT_TR_NOOP("LED_OUT_LOW"),
        QT_TR_NOOP("LED_ERROR"),
        QT_TR_NOOP("CABLE_FAIL"),
        QT_TR_NOOP("LOW_POWER"),
        QT_TR_NOOP("HIGH_POWER"),
        QT_TR_NOOP("HEAT_SENS_HIGH"),
        QT_TR_NOOP("HEAT_SENS_LOW"),
        QT_TR_NOOP("PEEK_SENS_HIGH"),
        QT_TR_NOOP("PEEK_SENS_LOW"),
        QT_TR_NOOP("ENV_SENS_HIGH"),
        QT_TR_NOOP("ENV_SENS_LOW"),
        QT_TR_NOOP("CASE_TEMP_HIGH"),
        QT_TR_NOOP("CASE_TEMP_LOW"),
        QT_TR_NOOP("HEAT_OUT_HIGH"),
        QT_TR_NOOP("HEAT_OUT_LOW"),
        QT_TR_NOOP("LOPTICS_OUT_LMT"),
        QT_TR_NOOP("SOPTICS_OUT_LMT"),
        QT_TR_NOOP("LOPTICS_INVALID"),
        QT_TR_NOOP("SOPTICS_INVALID"),
        QT_TR_NOOP("P1TUB_LIFESPAN"),
        QT_TR_NOOP("P2TUB_LIFESPAN"),
        QT_TR_NOOP("P3TUB_LIFESPAN")
    ];

    property var measLogFlagLogSummary: [
        QT_TR_NOOP("FLAG_MEA_MEAS"),
        QT_TR_NOOP("FLAG_MEA_TRIG"),
        QT_TR_NOOP("FLAG_MEA_OFFLINE"),
        QT_TR_NOOP("FLAG_MEA_ONLINE"),
        QT_TR_NOOP("FLAG_MEA_STD0"),
        QT_TR_NOOP("FLAG_MEA_STD1"),
        QT_TR_NOOP("FLAG_CALI_STD0"),
        QT_TR_NOOP("FLAG_CALI_STD1"),
        QT_TR_NOOP("FLAG_CALI_STATUS_ER"),
        QT_TR_NOOP("FLAG_CALI_STATUS_OK"),
        QT_TR_NOOP("FLAG_MEA_AUTORANGE_REQ"),
        QT_TR_NOOP("FLAG_RETRY_MAX"),
    ]

    property var calibLogFlag: [
        QT_TR_NOOP("VALID_CALIBRATION"),
        QT_TR_NOOP("INVALID_CALIBRATION"),
        QT_TR_NOOP("SCHEDULE_CALIBRATION"),
        QT_TR_NOOP("TRIGGER_CALIBRAION"),
        QT_TR_NOOP("AUTORANGE_CALIBRATION")
    ]

    property var mcuLogTitle: [
        QT_TR_NOOP("ID"),
        QT_TR_NOOP("mculog.measure.time"),
        QT_TR_NOOP("mculog.measure.range_index"),
        QT_TR_NOOP("mculog.measure.concentration"),
        QT_TR_NOOP("mculog.measure.s660"),
        QT_TR_NOOP("mculog.measure.l660"),
        QT_TR_NOOP("mculog.measure.s880"),
        QT_TR_NOOP("mculog.measure.l880"),
        QT_TR_NOOP("mculog.measure.calibtime"),
        QT_TR_NOOP("mculog.measure.calibslop"),
        QT_TR_NOOP("mculog.measure.caliboffs"),
        QT_TR_NOOP("mculog.measure.temperature1"),
        QT_TR_NOOP("mculog.measure.temperature2"),
        QT_TR_NOOP("mculog.measure.temperature3"),
        QT_TR_NOOP("mculog.measure.temperature4"),
        QT_TR_NOOP("mculog.measure.measure_flag")
    ];

    property var mcuCalibTitle: [
        QT_TR_NOOP("ID"),
        QT_TR_NOOP("mcucalib.time"),
        QT_TR_NOOP("mcucalib.range_index"),
        QT_TR_NOOP("mcucalib.slope0"),
        QT_TR_NOOP("mcucalib.offset0"),
        QT_TR_NOOP("mcucalib.slope1"),
        QT_TR_NOOP("mcucalib.offset1"),
        QT_TR_NOOP("mcucalib.calib_status"),
        QT_TR_NOOP("mcucalib.calibtimes0"),
        QT_TR_NOOP("mcucalib.time2"),
        QT_TR_NOOP("mcucalib.l660"),
        QT_TR_NOOP("mcucalib.s660"),
        QT_TR_NOOP("mcucalib.l880"),
        QT_TR_NOOP("mcucalib.s880"),
        QT_TR_NOOP("mcucalib.temperature1"),
        QT_TR_NOOP("mcucalib.temperature2"),
        QT_TR_NOOP("mcucalib.temperature3"),
        QT_TR_NOOP("mcucalib.temperature4"),
        QT_TR_NOOP("mcucalib.calibtimes1"),
        QT_TR_NOOP("mcucalib.time3"),
        QT_TR_NOOP("mcucalib.l660_2"),
        QT_TR_NOOP("mcucalib.s660_2"),
        QT_TR_NOOP("mcucalib.l880_2"),
        QT_TR_NOOP("mcucalib.s880_2"),
        QT_TR_NOOP("mcucalib.temperature1_2"),
        QT_TR_NOOP("mcucalib.temperature2_2"),
        QT_TR_NOOP("mcucalib.temperature3_2"),
        QT_TR_NOOP("mcucalib.temperature4_2")
    ];

    property var mcuDiagTitle: [
        QT_TR_NOOP("ID"),
        QT_TR_NOOP("mcudiag.time"),
        QT_TR_NOOP("mcudiag.type"),
        QT_TR_NOOP("mcudiag.summary"),
        QT_TR_NOOP("mcudiag.detail")
    ];

    property var mcuEventTitle: [
        QT_TR_NOOP("ID"),
        QT_TR_NOOP("mcuevent.time"),
        QT_TR_NOOP("mcuevent.summary"),
    ];

    property var mcuEventSubStep: [
        QT_TR_NOOP("MAINSTEP"),
        QT_TR_NOOP("SUBSTEP")
    ];
    */
}
