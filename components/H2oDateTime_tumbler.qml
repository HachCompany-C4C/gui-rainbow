import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4

Item {
    id: item
    //property alias text: null
    width: 533
    height: 120

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

    function convertToTime() {
        var timeStr = (tcYear.currentIndex+2016).toString()+","
                + (tcMonth.currentIndex+1).toString()+","
                + (tcDay.currentIndex+1).toString()+","
                + tcHour.currentIndex.toString()+","
                + tcMinute.currentIndex.toString()+",0";
        console.debug("convert time: "+timeStr);
        return timeStr;
    }

    Rectangle {
        id: rectangle1

        width: parent.width
        height: 100



        Tumbler {
            id: tumbler
            width: parent.width
            height: parent.height
            anchors.left: parent.left
            anchors.leftMargin: 19

            TumblerColumn {
                id: tcYear
                model: periods(2016, 2026)
                onCurrentIndexChanged: {
                    if(tcMonth.currentIndex == 1) // when month = 2
                        tcDay.model = periods(1, getDay(tcYear.currentIndex+2016, tcMonth.currentIndex+1))
                    var time = convertToTime()
                    console.debug(time)
                    dateTimeChanged(time)
                }
            }

            TumblerColumn {
                id: tcMonth
                model: periods(1, 12);
                onCurrentIndexChanged: {
                    tcDay.model = periods(1, getDay(tcYear.currentIndex+2016, tcMonth.currentIndex+1))
                    var time = convertToTime()
                    dateTimeChanged(time)
                }

            }
            TumblerColumn {
                id: tcDay
                model: periods(1, getDay(tcYear.currentIndex+2016, tcMonth.currentIndex+1))
                onCurrentIndexChanged: {
                    var time = convertToTime()
                    dateTimeChanged(time)
                }
            }
            TumblerColumn {
                id: tcHour
                model: periods(0, 23);
                onCurrentIndexChanged: {
                    var time = convertToTime()
                    dateTimeChanged(time)
                }
            }

            TumblerColumn {
                id: tcMinute
                model: periods(0, 59);
                onCurrentIndexChanged: {
                    var time = convertToTime()
                    dateTimeChanged(time)
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
                        font.family: localNotoSans.name
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
