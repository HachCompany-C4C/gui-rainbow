/****************************************************************************
** H2oDateTime.qml -
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


import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4

Item {
    id: itemDateTime
    //property alias text: null
    width: 533
    height: 150
    opacity: enabled ? 1.0 : 0.4

    property string datetime: ""

    //FontLoader {
    //    id: localNotoSans
    //    source: "qrc:///resources/fonts/NotoSans/NotoSans-Regular.ttf"
    //}

    signal dateTimeChanged(var time)
    signal yearChanged(var year)
    signal monthChanged(var month)
    signal dayChanged(var day)
    signal hourChanged(var hour)
    signal minuteChanged(var minute)

    //onDateTimeChanged: console.debug("onDateTimeChanged")

    function getDay(year, month)
    {
        var amonthday = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

        if(year % 4 == 0 && year % 100 != 0) {
            amonthday[1] = 29;
        }

        return amonthday[month-1];
    }

    function periods(leftThr, rightThr) {
        var periodsArr = [];
        for (var i = leftThr; i <= rightThr; i++)
            periodsArr.push(i);
        return periodsArr;
    }

    function convertTime() {
        var timeStr = tcYear.value().toString()+","
                + tcMonth.value().toString()+","
                + tcDay.value().toString()+","
                + tcHour.value().toString()+","
                + tcMinute.value().toString()+",0";
        //console.debug("convert time: "+timeStr);
        return timeStr;
    }


    function initTimeDate(timeStr) {
        var atime = timeStr.toString().split(",");
        if(atime.length >= 5) {
            //console.debug(atime,atime[0],atime[1],atime[2],atime[3],atime[4]);
            tumbler.setCurrentIndexAt(0, atime[0]-2016, 0) //year
            tumbler.setCurrentIndexAt(1, atime[1]-1, 0) //month
            tumbler.setCurrentIndexAt(2, atime[2]-1, 0) //day
            tumbler.setCurrentIndexAt(3, atime[3], 0) //hour
            tumbler.setCurrentIndexAt(4, atime[4], 0) //minute
        }

        //console.debug("initTimeDate")
    }

    function initDateTime(year, month, day, hour, minute) {
        tumbler.setCurrentIndexAt(0, year-2000, 0) //year
        tumbler.setCurrentIndexAt(1, month-1, 0) //month
        tumbler.setCurrentIndexAt(2, day-1, 0) //day
        tumbler.setCurrentIndexAt(3, hour, 0) //hour
        tumbler.setCurrentIndexAt(4, minute, 0) //minute
    }

    function setCompletedFlags() {
        tcYear.operated = true;
        tcMonth.operated = true;
        tcDay.operated = true;
        tcHour.operated = true;
        tcMinute.operated = true;

        //console.debug("setCompletedFlags")
    }

    Item {
        id: rectangle1

        width: parent.width
        height: 150

        Tumbler {
            id: tumbler
            width: parent.width
            height: parent.height
            anchors.left: parent.left
            anchors.leftMargin: 19

            Component.onCompleted: {
                initTimeDate(datetime)
                //setCompletedFlags()
            }

            H2oTumblerColumn {
                id: tcYear
                model: periods(2000, 3000)
                offset: 2000
                onCurrentIndexChanged: {
                    if(operated) {
                        if(tcMonth.value() === 2) { // when month = 2
                            tcDay.model = periods(1, getDay(tcYear.value(), tcMonth.value()))
                        }
                        var time = convertTime()
                        //console.debug(time)
                        dateTimeChanged(time)
                        yearChanged(tcYear.value())
                    }
                }
            }

            H2oTumblerColumn {
                id: tcMonth
                model: periods(1, 12);
                offset: 1
                onCurrentIndexChanged: {
                    if(operated) {
                        tcDay.model = periods(1, getDay(tcYear.value(), tcMonth.value()))
                        var time = convertTime()
                        dateTimeChanged(time)
                        monthChanged(tcMonth.value())
                    }
                }
            }
            H2oTumblerColumn {
                id: tcDay
                model: periods(1, getDay(tcYear.value(), tcMonth.value()))
                offset: 1
                onCurrentIndexChanged: {
                    if(operated) {
                        var time = convertTime()
                        dateTimeChanged(time)
                        dayChanged(tcDay.value())
                    }
                }
            }
            H2oTumblerColumn {
                id: tcHour
                model: periods(0, 23);
                onCurrentIndexChanged: {
                    if(operated) {
                        var time = convertTime()
                        dateTimeChanged(time)
                        hourChanged(tcHour.value())
                    }
                }
            }

            H2oTumblerColumn {
                id: tcMinute
                model: periods(0, 59);
                onCurrentIndexChanged: {
                    if(operated) {
                        var time = convertTime()
                        dateTimeChanged(time)
                        minuteChanged(tcMinute.value())
                    }
                }
            }

            style: TumblerStyle {
                id: tumblerStyle

                delegate: Item {
                    implicitHeight: (tumbler.height - padding.top - padding.bottom) / tumblerStyle.visibleItemCount

                    Text {
                        id: label
                        text: styleData.value
                        color: styleData.current ? "#313131" : "#9e9e9e"
                        font.bold: true
                        //font.family: localNotoSans.name
                        opacity: 0.4 + Math.max(0, 1 - Math.abs(styleData.displacement)) * 0.6
                        anchors.centerIn: parent
                    }
                }

                columnForeground: Item {
                    Rectangle {
                        width: parent.width
                        height: 1
                        color: "#9e9e9e"
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: "#9e9e9e"
                        anchors.bottom: parent.bottom
                    }
                }

                // No frame
                property Component frame: Item {}

                // Do not draw any separator
                property Component separator: Item {}

                // No gradient background
                property Component background: Rectangle {}

                property Component foreground: Item {}

            }
        }
    }
}
