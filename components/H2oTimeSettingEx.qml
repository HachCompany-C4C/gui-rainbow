/****************************************************************************
** H2oTimeSettingEx.qml
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
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Styles.Flat 1.0 as Flat
import QtQuick.Layouts 1.0

Rectangle {
    id: root
    property int currentIndex: 0
    property var listName: [""]
    property string currentName : root.listName[currentIndex]+translator.tr === undefined ? "" : root.listName[currentIndex]+translator.tr
    signal indexChanged()
    property alias model: dropList.model
    property int modelSize: model.rowCount()
    property int dropSize: 4  //Edit this value to change the row of the dropArea
    property int dropAreaSize: modelSize > dropSize ? dropSize : modelSize
    width: 200
    height: 40
    z: dropArea.visible ? 1 : 0
    //opacity: enabled ? 1.0 : 0.4

    Rectangle {
        id: background
        x: -800
        y: -480
        width: 1600
        height: 960
        color: "transparent"
        visible: false

        MouseArea{
            anchors.fill: parent
            onClicked: {
                dropArea.visible = false
                background.visible = false
                arrow.rotation = 0
                //console.debug("background closed")
            }
        }
    }

    function updateDropList(model)
    {
        dropList.model = model;
    }

    // drop area
    Rectangle {
        id: dropArea
        anchors.left: editArea.left
        anchors.bottom: editArea.top
        width: parent.width
        height: 40 * root.dropAreaSize + tabItem.height
        visible: false

        Rectangle {
            id: tabItem
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            height: 40
            border.width: 1
            border.color: Flat.FlatStyle.lightFrameColor

            Rectangle {
                Row {
                    id: row
                    anchors.top: parent.top
                    anchors.topMargin: tabButtonPosition ? 0 : parent.height - tabButtonHeight
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width
                    height: tabButtonHeight
                    anchors.horizontalCenterOffset: 0
                    spacing: 0
                    Repeater {
                        id: tabView
                        model: root.model
                        delegate: RadioButton {
                            id: radioButton
                            exclusiveGroup: tabGroup
                            checked: check
                            onCheckedChanged: {
                                //console.debug("QML::H2oTabView index "+index+" "+check)
                            }

                            style: RadioButtonStyle {
                                indicator: Rectangle {
                                    implicitWidth: 0
                                    implicitHeight: row.height
                                }
                                label: Component {
                                    Rectangle {
                                        implicitWidth: (row.width/root.model.count)
                                        implicitHeight: row.height

                                        Rectangle {
                                            anchors.fill: parent
                                            visible: true
                                            color: radioButton.checked ? "#0098db" : "#f2f2f2"
                                            anchors.margins: 0
                                            Text {
                                                anchors.centerIn: parent
                                                text: root.titleList[index]
                                                font: mainTheme.smallFont
                                                color: radioButton.checked ? "white" : "black"
                                            }
                                        }
                                    }
                                }
                            }
                            onClicked: {
                                root.currentIndex = index;
                                listStackView.push({item: viewList[root.currentIndex], immediate: true, replace: true })
                                //console.debug("QML::TabView index: "+index)
                            }
                        }
                    }
                }
            }
            MouseArea {
                anchors.fill: parent
            }
        }

        ScrollView {
            //id: dropArea
            anchors.left: parent.left
            anchors.top: tabItem.bottom
            width: parent.width
            height: 40 * root.dropAreaSize
            //visible: false

            frameVisible: true
            highlightOnFocus: true
            verticalScrollBarPolicy: root.modelSize > dropSize ? Qt.ScrollBarAlwaysOn:Qt.ScrollBarAlwaysOff

            ListView {
                id: dropList
                //cacheBuffer: root.model.rowCount() > 4 ? 4 : root.model.rowCount()
                //model: root.model
                //snapMode: ListView.SnapOneItem
                //boundsBehavior: Flickable.StopAtBounds
                flickableDirection: Flickable.VerticalFlick
                boundsBehavior: Flickable.StopAtBounds
                anchors.fill: parent

                delegate: Rectangle {
                    width: parent.width
                    height: 40
                    //border.color: Flat.FlatStyle.lightFrameColor
                    //border.width: Flat.FlatStyle.onePixel
                    //color: "#f2f2f2"
                    Text {
                        text: name
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 15
                        horizontalAlignment: Text.AlignLeft
                    }

                    MouseArea {
                        id: dropMouseArea
                        anchors.fill: parent
                        onClicked: {
                            currentText.text = root.listName[index]
                            dropArea.visible = false
                            background.visible = false
                            arrow.rotation = 0
                            root.currentIndex = index
                            //console.debug("current index: " + root.currentIndex)
                            indexChanged()
                        }
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
    }

    // edit area
    Rectangle {
        id: editArea
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        height: 40
        border.color: root.enabled ? mainTheme.mediumGrayColor : mainTheme.mediumBackgroundColor
        border.width: 1
        radius: 4
        color: root.enabled ? "white": mainTheme.mediumBackgroundColor

        Text {
            id: currentText
            //text: root.model.get(root.currentIndex).name
            text: {
                var currentName = root.listName[root.currentIndex]
                if(currentName != undefined) {
                    return currentName
                } else {
                    return ""
                }
            }

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 15
            horizontalAlignment: Text.AlignLeft
            font: mainTheme.smallFont
            color: root.enabled ? mainTheme.darkGrayColor : mainTheme.mediumGrayColor
        }

        /*Image {
            id: arrow
            source: "qrc:///resources/images/navigation_next_item-hach.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 3
            rotation: 90
        }*/

        Text {
            id: arrow
            font: mainTheme.smallIcon
            color: root.enabled ? "#0098db" : mainTheme.mediumGrayColor
            text: "\ue643"
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 15
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(dropArea.visible) {
                    dropArea.visible = false
                    background.visible = false
                    arrow.rotation = 0
                } else {
                    dropArea.visible = true
                    background.visible = true
                    arrow.rotation = 180
                }
            }
        }
    }
}
