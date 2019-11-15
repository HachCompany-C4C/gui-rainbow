/****************************************************************************
** H2oTableView.qml
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

TableView {
    id: root
    frameVisible: true
    alternatingRowColors: true
    property color headerBackgroundColor: "#ccc"
    property color headerTextColor: "black"
    property font headerTextFont//: Qt.font()
    property int rowHeight: 40
    selectionMode: SelectionMode.NoSelection

    horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

    signal rowClicked(var index);

    itemDelegate: Rectangle {
        Text {
            id: textCell
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: styleData.textAlignment
            anchors.leftMargin: 12
            text: textCell.getCellText(styleData.value) + translator.tr
                /*{
                var txt = ""+(styleData.value !== undefined ? styleData.value : "0")

                return qsTr(txt);
            }*/
            font: mainTheme.textFont

            function getCellText(source) {
                var ret = "";
                var txt = ""+source;
                if(source !== undefined && txt !== "") {
                    ret = qsTr(txt);
                }

                return ret;
            }
        }


        SystemPalette {
            id: myPalette;
            colorGroup: SystemPalette.Active
            //styleData.alternate: true
        }
        color: {
            //var baseColor = styleData.alternate ? myPalette.alternateBase : myPalette.base
            var baseColor = styleData.row%2 == 0 ? "#D3D3D3" : myPalette.base
            //console.debug("QML::styleData alternate: "+styleData.alternate)

            return styleData.selected ? myPalette.highlight : baseColor
        }


        /*Connections {
            target: translator
            ignoreUnknownSignals: true
            onLanguageChanged: {
                //textCell.text = qsTr(""+styleData.value);
                //console.debug("QML::H2oTableView onLanguageChanged "+qsTr(styleData.value))
            }
        }*/
    }

    headerDelegate: Rectangle {
        height: 32
        color: "white"
        //border.width: Flat.FlatStyle.onePixel
        //border.color: Flat.FlatStyle.lightFrameColor
        /*Rectangle {
            width: parent.width
            height: Flat.FlatStyle.onePixel
            color: headerBackgroundColor //Flat.FlatStyle.lightFrameColor
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }*/

        Text {
            id: textItem
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: styleData.textAlignment
            anchors.leftMargin: 12
            text: styleData.value
            elide: Text.ElideRight
            renderType: Text.NativeRendering
            color: headerTextColor
            font: mainTheme.smallFont
        }


        /*Rectangle {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 1
            anchors.topMargin: 1
            width: 1
            color: headerBackgroundColor
        }*/
    }

    rowDelegate: Rectangle {
        id: rowItem
        height: rowHeight

        //Rectangle {
        //   anchors {
        //       right: parent.right
         //      left: parent.left
         //      bottom: parent.bottom
         //  }
        //   height: 1
        //   color: "gray"
       //}

       // MouseArea {
       //    anchors.fill: parent
       //    onClicked: {
       //        rowClicked(currentRow);
       //    }
       //}

        SystemPalette {
            id: myPalette1
            colorGroup: SystemPalette.Active
            //styleData.alternate: true
        }
        color: {
            //var baseColor = styleData.alternate ? myPalette.alternateBase : myPalette.base
            var baseColor = styleData.row%2 == 0 ? myPalette1.alternateBase : myPalette1.base
            //console.debug("QML::styleData alternate: "+styleData.alternate)

            return styleData.selected ? myPalette1.highlight : baseColor
        }

    }

    style:TableViewStyle {
        //rowDelegate: Rectangle{
        //    height: 50
        //}

        frame:Rectangle {
            border{
                color: "#e4e4e4"
            }
            color: "#e4e4e4"
        }

        handle: Rectangle {
            implicitWidth: 40
            implicitHeight: 30
            color: styleData.pressed ? "#9e9e9e" : "#f2f2f2"
            border.width: Flat.FlatStyle.onePixel
            border.color: Flat.FlatStyle.lightFrameColor
            /*Rectangle {
                color:
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
            implicitHeight: 30
            color: "#e4e4e4"
            //border.width: Flat.FlatStyle.onePixel
            //border.color: Flat.FlatStyle.lightFrameColor
        }
    }
}
