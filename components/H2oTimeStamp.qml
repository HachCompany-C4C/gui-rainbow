/****************************************************************************
** H2oTimeStamp.qml
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
import QtQml 2.2

Item {
    id: item1
    width: 100
    height: 50
    property int oriention: Qt.Horizontal

    Text {
        id: timeBox
        x: 5
        width: parent.width - 10
        font: theme.smallFont
        color: theme.secondaryTextColor
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenterOffset: 0
        horizontalAlignment: Text.AlignHCenter
        anchors.verticalCenter: parent.verticalCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: item1.oriention == Qt.Vertical ? Text.WordWrap : Text.NoWrap
        function update() {
            var datetime = new Date();
            var hour = datetime.getHours();
            var minute = datetime.getMinutes();
            var second = datetime.getSeconds();
            var timeUTC = (hour < 10 ? "0":"")+hour+":"
                    +(minute < 10 ? "0":"")+minute+":"
                    +(second < 10 ? "0":"")+second;

            var year = datetime.getFullYear();
            var month = datetime.getMonth()+1; // Date start from 0
            var day = datetime.getDate();
            var dateUTC = year+"/"
                    +(month < 10 ? "0":"") + month+"/"
                    +(day < 10 ? "0":"")+day;

            this.text = timeUTC+" "+dateUTC;
        }
    }

    /*Text {
        id: dateBox
        width: parent.width - 10
        anchors.top: (oriention === Qt.Vertical) ? timeBox.bottom : timeBox.top
        anchors.left: (oriention === Qt.Vertical) ? timeBox.left : timeBox.right
        font: theme.smallFont
        color: theme.secondaryTextColor
        function update(d) {
            var datetime = new Date();
            var year = datetime.getFullYear();
            var month = datetime.getMonth()+1;
            var day = datetime.getDate();
            var timeUTC = year+"/"
                    +(month < 10 ? "0":"") + month+"/"
                    +(day < 10 ? "0":"")+day;

            this.text = timeUTC;
        }
    }*/

    Timer {
        id: timer500ms
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            timeBox.update()
            //dateBox.update()
        }
    }
}
