/****************************************************************************
** H2oTimeSettingDialog.qml
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
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.0
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Extras 1.4

Dialog
{
    id: messageDialog
    //width: 450
    //height: 330

    signal timeAccept(var year, var month, var day, var hour, var minute);

    function initDateTime(year, month, day, hour, minute) {
        tumbler.setCurrentIndexAt(0, year-2000, 0) //year
        tumbler.setCurrentIndexAt(1, month-1, 0) //month
        tumbler.setCurrentIndexAt(2, day-1, 0) //day
        tumbler.setCurrentIndexAt(3, hour, 0) //hour
        tumbler.setCurrentIndexAt(4, minute, 0) //minute
    }

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

    function setCompletedFlags() {
        tcYear.operated = true;
        tcMonth.operated = true;
        tcDay.operated = true;
        tcHour.operated = true;
        tcMinute.operated = true;

        //console.debug("setCompletedFlags")
    }

    contentItem: Rectangle {
        x: 0
        y: 0
        width: 450
        height: 330

        Rectangle {
            color: "gray"
            Text {
                x: 369
                y: 8
                text: qsTr("Minute")
            }
            Text {
                x: 285
                y: 8
                text: qsTr("Hour")
            }
            Text {
                x: 213
                y: 8
                text: qsTr("Day")
            }
            Text {
                x: 120
                y: 8
                text: qsTr("Month")
            }
            Text {
                x: 33
                y: 8
                text: qsTr("Year")
            }
        }

        Tumbler {
            id: tumbler
            y: 28
            width: 450
            height: 251
            anchors.left: parent.left
            anchors.leftMargin: 0


            H2oTumblerColumn {
                id: tcYear
                model: periods(2000, 3000)
                offset: 2000
                onCurrentIndexChanged: {
                    if(tcMonth.value() === 2) { // when month = 2
                        tcDay.model = periods(1, itemDateTime.getDay(tcYear.value(), tcMonth.value()))
                        //yearChanged(tcYear.value())
                    }
                }
            }


            H2oTumblerColumn {
                id: tcMonth
                model: periods(1, 12);
                offset: 1

                onCurrentIndexChanged: {
                    tcDay.model = periods(1, getDay(tcYear.value(), tcMonth.value()))
                    //monthChanged(tcMonth.value())
                }
            }

            H2oTumblerColumn {
                id: tcDay
                model: periods(1, getDay(tcYear.value(), tcMonth.value()))
                offset: 1
                onCurrentIndexChanged: {
                    //dayChanged(tcDay.value())
                }
            }

            H2oTumblerColumn {
                id: tcHour
                model: periods(0, 23);
                onCurrentIndexChanged: {
                    //hourChanged(tcHour.value())
                }
            }

            H2oTumblerColumn {
                id: tcMinute
                model: periods(0, 59);
                onCurrentIndexChanged: {
                    //minuteChanged(tcMinute.value())
                }
            }

            style: TumblerStyle {
                id: tumblerStyle
                visibleItemCount: 5

                delegate: Item {
                    implicitHeight: (tumbler.height - padding.top - padding.bottom) / tumblerStyle.visibleItemCount
                    Text {
                        id: label
                        text: styleData.value
                        color: styleData.current ? "#313131" : "#9e9e9e"
                        font.bold: true
                        font.family: theme.mediumFont
                        opacity: 0.4 + Math.max(0, 1 - Math.abs(styleData.displacement)) * 0.6
                        anchors.centerIn: parent
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

        H2oButton {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            width: parent.width/2-1
            text: "Cancel"
            onClicked: {
                reject();
            }
        }
        H2oButton {
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            width: parent.width/2-1
            text: "Yes"
            onClicked: {
                accept();
                //console.debug("QML::tcYear: "+tcYear.value())
                timeAccept(tcYear.value(), tcMonth.value(), tcDay.value(), tcHour.value(), tcMinute.value());
            }
        }
    }
}
