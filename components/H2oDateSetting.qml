/****************************************************************************
** H2oDateSetting.qml -
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
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Controls.Styles.Flat 1.0 as Flat
import QtQuick.Layouts 1.0

Rectangle {
    id: root
    width: 300
    height: 40
    z: calendar.visible ? 1 : 0
    property int dtYear: 2000
    property int dtMonth: 1
    property int dtDay: 1
    property bool isOnBottom: false
    property date currentDate
    property bool currentDateUpdated: false
    opacity: enabled ? 1.0 : 0.4

    signal dateSetting(var year, var month, var day)

    property var monthList: [
        qsTr("January")+translator.tr,
        qsTr("February")+translator.tr,
        qsTr("March")+translator.tr,
        qsTr("April")+translator.tr,
        qsTr("May")+translator.tr,
        qsTr("June")+translator.tr,
        qsTr("July")+translator.tr,
        qsTr("August")+translator.tr,
        qsTr("September")+translator.tr,
        qsTr("October")+translator.tr,
        qsTr("November")+translator.tr,
        qsTr("December")+translator.tr
    ]

    function init(year, month, day) {
        dtYear = year;
        dtMonth = month;
        dtDay = day;
        dateText.text = dtYear+"/"+(dtMonth < 10 ? "0":"") + dtMonth+"/"+(dtDay < 10 ? "0":"")+dtDay
        //dateText.text = monthList[dtMonth]+" "+dtDay+", "+dtYear;
        currentDateUpdated = true;
        calendar.selectedDate = new Date(dtYear, dtMonth > 0 ? (dtMonth - 1) : 0, dtDay); // Date start from 0
        currentDateUpdated = false;
        //console.debug("QML::H2oDateSetting dateText: "+dateText.text);
        currentDate = calendar.selectedDate;
        calendar.inited = true;
    }

    Rectangle {
        id: background
        x: -800
        y: -480
        width: 1600
        height: 960
        color: "transparent"
        visible: calendar.visible

        MouseArea {
            anchors.fill: parent
            onClicked: {
                calendar.visible = false
            }
        }
    }

    Rectangle {
        id: editRect
        radius: 4
        border.color: Flat.FlatStyle.lightFrameColor
        border.width: 1
        width: parent.width
        height: 40
        color: root.enabled ? "white": theme.mediumBackgroundColor

        Text {
            id: dateText
            font: mainTheme.smallFont
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 15
            horizontalAlignment: Text.AlignLeft

            /*text:   dtYear+"/"
                  +(dtMonth < 10 ? "0":"") + dtMonth+"/"
                +(dtDay < 10 ? "0":"")+dtDay*/
        }
    }

    Text {
        id: arrow
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 10
        width: 24
        height: 24
        font: mainTheme.mediumIcon
        color: "#3ebdf2"
        text: calendar.visible ? (isOnBottom ? "\ue644" : "\ue643") : "\ue636"
        verticalAlignment: Text.AlignVCenter
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent

        onClicked: {
            calendar.visible = !calendar.visible;
        }
    }

    Calendar {
        id: calendar
        anchors.top: parent.bottom
        anchors.topMargin: isOnBottom ? 0: -(calendar.height+editRect.height)
        anchors.left: parent.left
        width: parent.width
        height: 250
        weekNumbersVisible: false
        navigationBarVisible: true
        minimumDate: new Date(2000, 1, 1)
        maximumDate: new Date(3000, 1, 1)
        visible: false
        property bool inited: false

        onSelectedDateChanged: {
            var date = calendar.selectedDate;
            root.dtYear = date.getFullYear();
            root.dtMonth = date.getMonth()+1;
            root.dtDay = date.getDate();
            if(currentDateUpdated == true) {
                currentDateUpdated = false;
            } else if(inited){
                dateSetting(root.dtYear, root.dtMonth, root.dtDay);
            }

            currentDate = calendar.selectedDate;
            dateText.text = root.dtYear+"/"+(root.dtMonth < 10 ? "0":"") + root.dtMonth+"/"+(root.dtDay < 10 ? "0":"")+root.dtDay
            //dateText.text = monthList[dtMonth]+" "+dtDay+", "+dtYear;
            //console.debug("QML::H2oDateSetting onSelectedDateChanged: "+calendar.selectedDate);
        }

        style: CalendarStyle {
            navigationBar: Rectangle {
                height: 48
                Rectangle {
                    id: prevBtnMonth
                    width: parent.height
                    height: parent.height
                    anchors.top: parent.top
                    anchors.left: parent.left
                    color: prevMouseAreaMonth.pressed ? "#e4e4e4" : "white"

                    Text {
                        anchors.centerIn: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: "\uf053"
                        font: mainTheme.smallFont
                        color: "#0098db"
                    }

                    MouseArea {
                        id: prevMouseAreaMonth
                        anchors.fill: parent
                        onClicked: {
                            calendar.showPreviousMonth();
                            root.dtMonth = calendar.visibleMonth+1;
                            root.dtYear = calendar.visibleYear;
                            dateText.text = dtYear+"/"+(dtMonth < 10 ? "0":"") + dtMonth+"/"+(dtDay < 10 ? "0":"")+dtDay
                            dateSetting(root.dtYear, root.dtMonth, root.dtDay);
                        }
                    }
                }

                Rectangle {
                    id: nextBtnMonth
                    width: parent.height
                    height: parent.height
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.rightMargin: parent.width/2+10
                    color: nextMouseAreaMonth.pressed ? "#e4e4e4" : "white"

                    Text {
                        anchors.centerIn: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: "\uf054"
                        font: mainTheme.smallFont
                        color: "#0098db"
                    }

                    MouseArea {
                        id: nextMouseAreaMonth
                        anchors.fill: parent
                        onClicked: {
                            calendar.showNextMonth();
                            root.dtMonth = calendar.visibleMonth+1;
                            root.dtYear = calendar.visibleYear;
                            dateText.text = dtYear+"/"+(dtMonth < 10 ? "0":"") + dtMonth+"/"+(dtDay < 10 ? "0":"")+dtDay
                            dateSetting(root.dtYear, root.dtMonth, root.dtDay);
                        }
                    }
                }

                Label {
                    text: calendar.visibleMonth+1

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font: mainTheme.smallFont
                    anchors.left: prevBtnMonth.right
                    anchors.right: nextBtnMonth.left
                    anchors.verticalCenter: parent.verticalCenter
                }

                Rectangle {
                    id: prevBtnYear
                    width: parent.height
                    height: parent.height
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width/2+10
                    color: prevMouseAreaYear.pressed ? "#e4e4e4" : "white"

                    Text {
                        anchors.centerIn: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: "\uf053"
                        font: mainTheme.smallFont
                        color: "#0098db"
                    }

                    MouseArea {
                        id: prevMouseAreaYear
                        anchors.fill: parent
                        onClicked: {
                            calendar.showPreviousYear();
                            dtYear = calendar.visibleYear;
                            dateText.text = dtYear+"/"+(dtMonth < 10 ? "0":"") + dtMonth+"/"+(dtDay < 10 ? "0":"")+dtDay
                            dateSetting(root.dtYear, root.dtMonth, root.dtDay);
                        }
                    }
                }

                Rectangle {
                    id: nextBtnYear
                    width: parent.height
                    height: parent.height
                    anchors.top: parent.top
                    anchors.right: parent.right
                    color: nextMouseAreaYear.pressed ? "#e4e4e4" : "white"

                    Text {
                        anchors.centerIn: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: "\uf054"
                        font: mainTheme.smallFont
                        color: "#0098db"
                    }

                    MouseArea {
                        id: nextMouseAreaYear
                        anchors.fill: parent
                        onClicked: {
                            calendar.showNextYear();
                            dtYear = calendar.visibleYear;
                            dateText.text = dtYear+"/"+(dtMonth < 10 ? "0":"") + dtMonth+"/"+(dtDay < 10 ? "0":"")+dtDay
                            dateSetting(root.dtYear, root.dtMonth, root.dtDay);
                        }
                    }
                }

                Label {
                    text: calendar.visibleYear

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font: mainTheme.smallFont
                    anchors.left: prevBtnYear.right
                    anchors.right: nextBtnYear.left
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            dayOfWeekDelegate: Rectangle{
            }

            dayDelegate: Rectangle {
                id: dayDelegate
                width: calendar.width/7
                height: 250/6
                color: styleData.selected ? "#0098db" : "white"
                opacity: styleData.visibleMonth ? 1.0 : 0.4
                Text {
                    anchors.centerIn: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    text: {
                        var date = styleData.date;
                        return date.getDate();
                    }
                    font: mainTheme.smallFont
                }
            }
        }
    }

    //Component.onCompleted: {
    //    var date = new Date(root.dtYear, root.dtMonth > 0 ? (root.dtMonth - 1) : 0, root.dtDay)
    //    calendar.selectedDate = date
    //}
}
