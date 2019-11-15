/****************************************************************************
** EventDescription.qml - Event description
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
    property int length: descriptionList.length

    function description(index)
    {
        return descriptionList[index];
    }

    property var descriptionList: [
        qsTr("USB Write Failure")+translator.tr,
        qsTr("Local Communication Error")+translator.tr,
        qsTr("LED Output Low")+translator.tr,
        qsTr("No Sample Flow")+translator.tr,
        qsTr("Heat Out of Range")+translator.tr,
        qsTr("Door Open")+translator.tr,
        qsTr("AD SPI Failure")+translator.tr,
        qsTr("Flash Failure")+translator.tr,
        qsTr("EEPROM Error")+translator.tr,
        qsTr("Measure out of work range")+translator.tr,
        qsTr("Power Failure")+translator.tr,
        qsTr("Voltage Out of Range")+translator.tr,
        qsTr("Heater Sensor Failure")+translator.tr,
        qsTr("Case Temperature Warning")+translator.tr,
        qsTr("Calibration Failed")+translator.tr,
        qsTr("Water Leakage")+translator.tr,
        qsTr("Check Optics")+translator.tr,
        qsTr("Sample in exception")+translator.tr,
        qsTr("Current Error")+translator.tr,
        qsTr("Alarm Low")+translator.tr,
        qsTr("Alarm High")+translator.tr,
        qsTr("Reagent A Empty")+translator.tr,
        qsTr("Reagent B Empty")+translator.tr,
        qsTr("Reagent C Empty")+translator.tr,
        qsTr("STD 0 Empty")+translator.tr,
        qsTr("STD 1 Empty")+translator.tr,
        qsTr("STD 2 Empty")+translator.tr,
        qsTr("Cleaning Empty")+translator.tr,
        qsTr("Reagent A Low")+translator.tr,
        qsTr("Reagent B Low")+translator.tr,
        qsTr("Reagent C Low")+translator.tr,
        qsTr("STD 0 Low")+translator.tr,
        qsTr("STD 1 Low")+translator.tr,
        qsTr("STD 2 Low")+translator.tr,
        qsTr("Cleaning Low")+translator.tr,
        qsTr("Lifespan Tubing Valve")+translator.tr,
        qsTr("Lifespan Tubing Pump")+translator.tr,
        qsTr("Lifespan Motor pump1")+translator.tr,
        qsTr("Lifespan Motor pump2")+translator.tr,
        qsTr("Lifespan Motor pump3")+translator.tr,
        qsTr("Lifespan Motor Mix")+translator.tr,
        qsTr("RTC Alarm")+translator.tr,
        qsTr("LED Error")+translator.tr,
        qsTr("I/O CANopen Warning")+translator.tr,
        qsTr("I/O CANopen Error")+translator.tr,
        qsTr("I/O CANopen Connect Error")+translator.tr,
        qsTr("I/O CANopen Config Error")+translator.tr,
        qsTr("Fix Range Warning")+translator.tr,
        qsTr("Probe Communication Error")+translator.tr, //49
        qsTr("HMI RTC battery failure")+translator.tr, // 50
    ]
}
