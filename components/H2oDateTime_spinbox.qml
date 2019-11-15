import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.0

Item {
    id: item
    //property alias text: null
    width: 533
    height: 120

    property bool operated: false

    property H2oSpinBox year:  tcYear
    property H2oSpinBox month:  tcMonth
    property H2oSpinBox day:  tcDay
    property H2oSpinBox hour:  tcHour
    property H2oSpinBox minute:  tcMinute

    FontLoader {
        id: localNotoSans
        source: "qrc:///resources/fonts/NotoSans/NotoSans-Regular.ttf"
    }

    signal dateTimeChanged(var time)

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
        var timeStr = tcYear.value.toString()+","
                + tcMonth.value.toString()+","
                + tcDay.value.toString()+","
                + tcHour.value.toString()+","
                + tcMinute.value.toString()+",0";
        console.debug("convert time: "+timeStr);
        return timeStr;
    }

    function initTimeDate(timeStr) {
        var atime = timeStr.toString().split(",");
        if(atime.length >= 5) {
            console.debug(atime,atime[0],atime[1],atime[2],atime[3],atime[4]);
            year.value = atime[0];
            month.value = atime[1];
            day.value = atime[2];
            hour.value = atime[3];
            minute.value = atime[4];
        }

        tcYear.operated = true;
        tcMonth.operated = true;
        tcDay.operated = true;
        tcHour.operated = true;
        tcMinute.operated = true;
    }

    Rectangle {
        id: rectangle1

        width: parent.width
        height: 100

        RowLayout {
            id: clayout
            width: parent.width
            height: parent.height
            anchors.left: parent.left

            H2oSpinBox {
                id: tcYear
                minimumValue: 2016
                maximumValue: 2026

                onValueChanged: {
                    if(operated) {
                        if(tcMonth.value == 2) // when month = 2
                            tcDay.maximumValue = getDay(tcYear.value, tcMonth.value)
                        var time = convertTime()
                        dateTimeChanged(time)
                    }

                }
            }

            H2oSpinBox {
                id: tcMonth
                width: 40
                minimumValue: 1
                maximumValue: 12
                onValueChanged: {
                    if(operated) {
                        tcDay.maximumValue = Number(getDay(tcYear.value, tcMonth.value))
                        var time = convertTime()
                        dateTimeChanged(time)
                    }
                }

            }
            H2oSpinBox {
                id: tcDay
                width: 40
                minimumValue: 1
                maximumValue: Number(getDay(tcYear.value, tcMonth.value))
                onValueChanged: {
                    if(operated) {
                        var time = convertTime()
                        dateTimeChanged(time)
                    }
                }
            }
            H2oSpinBox {
                id: tcHour
                width: 40
                minimumValue: 0
                maximumValue: 23
                onValueChanged: {
                    if(operated) {
                        var time = convertTime()
                        dateTimeChanged(time)
                    }

                }
            }

            H2oSpinBox {
                id: tcMinute
                width: 40
                minimumValue: 0
                maximumValue: 59
                onValueChanged: {
                    if(operated) {
                        var time = convertTime()
                        dateTimeChanged(time)
                    }
                }
            }
        }

    }

}
