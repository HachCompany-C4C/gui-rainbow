/****************************************************************************
** CalibFactor.qml - Functions for time
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

function convertU32Time(time)
{
    var year = 2000 + (time >> 26);
    var month = (time >> 22) & 0x0F;
    var date = (time >> 17) & 0x1F;
    var hour = (time >> 12) & 0x1F;
    var minute = (time >> 6) & 0x3F;
    var second = (time >> 0) & 0x3F;

    var timeStr = year+"-"+month+"-"+date+" "
            +(hour < 10 ? ("0"+hour) : hour)+":"
            +(minute < 10 ? ("0"+minute) : minute)+":"
            +(second < 10 ? ("0"+second) : second);
    return timeStr;
}

function convertU32Date(time)
{
    var year = 2000 + (time >> 26);
    var month = (time >> 22) & 0x0F;
    var day = (time >> 17) & 0x1F;
    var hour = (time >> 12) & 0x1F;
    var minute = (time >> 6) & 0x3F;
    var second = (time >> 0) & 0x3F;

    var date = new Date(year, month-1, day, hour, minute, second);

    return date;
}

function convertTimeU32(year, month, date, hour, minute, second)
{
    var time;
    time = (year - 2000) << 26;
    time |= (month & 0x0F) << 22;
    time |= (date & 0x1F) << 17;
    time |= (hour & 0x1F) << 12;
    time |= (minute & 0x3F) << 6;
    time |= (second & 0x3F);
    return time;
}

// DateTimeAxis is based on QDateTimes so we must convert our JavaScript dates to
// milliseconds since epoch to make them match the DateTimeAxis values
function toMsecsSinceEpoch(date) {
    var msecs = date.getTime();
    return msecs;
}

function strTimeToMsecsSinceEpoch(datetime) {
    var datetimes = datetime.split(" ");
    var date = datetimes[0];
    var time = datetimes[1];
    var dates = date.split("-");
    var times = time.split(":");
    var year = Number.fromLocaleString(Qt.locale(), dates[0]);
    var month = Number.fromLocaleString(Qt.locale(), dates[1]);
    var day = Number.fromLocaleString(Qt.locale(), dates[2]);
    var hour = Number.fromLocaleString(Qt.locale(), times[0]);
    var minute = Number.fromLocaleString(Qt.locale(), times[1]);
    var second = Number.fromLocaleString(Qt.locale(), times[2]);

    var msecs = toMsecsSinceEpoch(new Date(year, month, day, hour, minute, second));
    return msecs;
}

function strTimeToDate(datetime) {
    var datetimes = datetime.split(" ");
    var date = datetimes[0];
    var time = datetimes[1];
    var dates = date.split("-");
    var times = time.split(":");
    var year = Number.fromLocaleString(Qt.locale(), dates[0]);
    var month = Number.fromLocaleString(Qt.locale(), dates[1]);
    var day = Number.fromLocaleString(Qt.locale(), dates[2]);
    var hour = Number.fromLocaleString(Qt.locale(), times[0]);
    var minute = Number.fromLocaleString(Qt.locale(), times[1]);
    var second = Number.fromLocaleString(Qt.locale(), times[2]);

    var date = new Date(year, month-1, day, hour, minute, second); // Date start from 0
    return date;
}

function strTimeToSecsSinceEpoch(datetime) {
    var datetimes = datetime.split(" ");
    var date = datetimes[0];
    var time = datetimes[1];
    var dates = date.split("-");
    var times = time.split(":");
    var year = Number.fromLocaleString(Qt.locale(), dates[0]);
    var month = Number.fromLocaleString(Qt.locale(), dates[1]);
    var day = Number.fromLocaleString(Qt.locale(), dates[2]);
    var hour = Number.fromLocaleString(Qt.locale(), times[0]);
    var minute = Number.fromLocaleString(Qt.locale(), times[1]);
    var second = Number.fromLocaleString(Qt.locale(), times[2]);

    // date month start form 0
    var msecs = toMsecsSinceEpoch(new Date(year, month-1, day, hour, minute, second));
    return msecs/1000;
}

function secsSinceEpochToDate(secs) {
    var date = new Date();
    date.setTime(secs*1000);
    return date;
}

function dateToTimeString(date) {
    var datetime = date;
    var hour = datetime.getHours();
    var minute = datetime.getMinutes();
    var second = datetime.getSeconds();
    var timeUTC = (hour < 10 ? "0":"")+hour+":"
            +(minute < 10 ? "0":"")+minute+":"
            +(second < 10 ? "0":"")+second;

    var year = datetime.getFullYear();
    var month = datetime.getMonth()+1; // Date start from 0
    var day = datetime.getDate();
    var dateUTC = year+"-"
            +(month < 10 ? "0":"") + month+"-"
            +(day < 10 ? "0":"")+day;

    var dateString = dateUTC+" "+timeUTC;

    return dateString;
}
