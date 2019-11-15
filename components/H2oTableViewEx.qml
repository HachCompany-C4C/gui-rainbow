/****************************************************************************
** H2oTableViewEx.qml
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

import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.1
import QtQuick.Controls.Styles.Flat 1.0 as Flat

// scroll area
ScrollView {
    id: scrollArea
    height: 340
    width: 800-20
    frameVisible: false
    highlightOnFocus: true
    verticalScrollBarPolicy: Qt.ScrollBarAlwaysOn
    property alias model: logTable.model

    ListView {
        id: logTable
        anchors.top: parent.top
        anchors.topMargin: titleText.height
        anchors.horizontalCenter: parent.horizontalCenter
        height: parent.height - titleText.height
        width: parent.width
        property int focusIndex: 0

        model: ListModel {
            //ListElement { time: "2012-11-11"; type: "mculog"; summary: "summary" }
        }

        delegate: Rectangle {
            color: {
                var color = (index % 2 == 0) ? "#d3d3d3" : "white"
                if(logTable.focusIndex == index) {
                    color = "#3ebdf2";
                }
                return color;
            }
            width: parent.width
            height: 32
            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
                text: time
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 240
                text: type
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 320
                text: summary
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    viewLogDetail(index);
                    logTable.focusIndex = index;
                }
            }
        }

        Rectangle {
            id: titleText
            anchors.top: parent.top
            anchors.topMargin: -32
            anchors.horizontalCenter: parent.horizontalCenter
            height: 32
            width: parent.width
            z: 1
            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
                text: qsTr("Time")+translator.tr
                font: mainTheme.smallFont
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 240
                text: qsTr("Type")+translator.tr
                font: mainTheme.smallFont
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 320
                text: qsTr("Summary")+translator.tr
                font: mainTheme.smallFont
            }
        }
    }

    style: ScrollViewStyle {
        frame:Rectangle {
            border{
                color: Flat.FlatStyle.lightFrameColor
            }
            color: Flat.FlatStyle.lightFrameColor
        }

        handle: Rectangle {
            implicitWidth: 40
            implicitHeight: 30
            color: styleData.pressed ? "#9e9e9e" : "#f2f2f2"
            border.width: Flat.FlatStyle.onePixel
            border.color: Flat.FlatStyle.lightFrameColor
            /*Rectangle {
                color: styleData.pressed ? "#9e9e9e" : "#e4e4e4"
                anchors.fill: parent
                anchors.topMargin: 6
                anchors.leftMargin: 4
                anchors.rightMargin: 4
                anchors.bottomMargin: 6
                //border.width: 1
                //border.color: "black"
            }*/
        }
        incrementControl: Rectangle {
            implicitWidth: 40
            implicitHeight: 40
            border.width: Flat.FlatStyle.onePixel
            border.color: Flat.FlatStyle.lightFrameColor
            color: styleData.pressed ? "#9e9e9e" : "#f2f2f2"
            Text {
                font: mainTheme.mediumIcon
                color: "#3ebdf2"
                text: "\ue643"
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        decrementControl: Rectangle {
            implicitWidth: 40
            implicitHeight: 40
            border.width: Flat.FlatStyle.onePixel
            border.color: Flat.FlatStyle.lightFrameColor
            color: styleData.pressed ? "#9e9e9e" : "#f2f2f2"
            Text {
                font: mainTheme.mediumIcon
                color: "#3ebdf2"
                text: "\ue644"
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        scrollBarBackground: Rectangle {
            implicitWidth: 40
            implicitHeight: 26
            color: "#e4e4e4"
        }
    }
}
