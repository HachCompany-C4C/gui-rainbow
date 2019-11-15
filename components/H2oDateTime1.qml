/****************************************************************************
** H2oDateTime1.qml
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

Rectangle {
    width: 800
    height: 50
    property int dtYear: 2000
    property int dtMonth: 1
    property int dtDay: 1
    property int dtHour: 0
    property int dtMinute: 0
    property int dtSecond: 0
    color: mouseArea.pressed ? "#e4e4e4" : "#f2f2f2"
    opacity: enabled ? 1.0 : 0.4

    signal timeSetting(var year, var month, var day, var hour, var minute)

    Text {
        id: timeText
        x: 16
        y: 15
        width: 80
        height: 20
        verticalAlignment: Text.AlignVCenter
        font: mainTheme.mediumFont
        text:   dtYear+"/"
                +(dtMonth < 10 ? "0":"") + dtMonth+"/"
                +(dtDay < 10 ? "0":"")+dtDay
                +" "+(dtHour < 10 ? "0":"")+dtHour+":"
                +(dtMinute < 10 ? "0":"")+dtMinute;
                //+(second < 10 ? "0":"")+second;
    }

    Text {
        id: arrow
        x: 744
        y: 13
        width: 24
        height: 24
        font: mainTheme.mediumFont
        color: "#3ebdf2"
        text: "\uf054"
        verticalAlignment: Text.AlignVCenter
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent

        onClicked: {
            timeSettingDialog.initDateTime(dtYear, dtMonth, dtDay, dtHour, dtMinute);
            timeSettingDialog.open();
        }
    }

    H2oTimeSettingDialog {
        id: timeSettingDialog

        onTimeAccept: {
            dtYear = year;
            dtMonth = month;
            dtDay = day;
            dtHour = hour;
            dtMinute = minute;
            //console.debug("QML::TimeSetting:", year, month, day, hour, minute)
            timeSetting(year, month, day, hour, minute);
        }
    }
}
