import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
//import QtQuick.Controls.Styles.Flat 1.0 as Flat
import "../content"
import "status"

Item {
    width: 800
    height: 400

    //Component.onCompleted: mainMessage.titleMessage = qsTr("Statusxx")

    Item {
        id: list
        width: parent.width / 3
        height: parent.height

        ListModel {
            id: pageModel
            ListElement { title: qsTr("Instrument Info"); page: "status/InstrumentInformation.qml" }
            ListElement { title: qsTr("Instrument Status"); page: "status/InstrumentInformation.qml" }
            ListElement { title: qsTr("Measurement Info");  page: "status/InstrumentInformation.qml" }
            ListElement { title: qsTr("Input & Output");  page: "status/InstrumentInformation.qml" }
        }

        ListView {
            width: 218
            height: 400
            boundsBehavior: Flickable.StopAtBounds
            anchors.bottomMargin: 3
            anchors.topMargin: 0
            scale: 1
            anchors.rightMargin: 3
            cacheBuffer: 320
            contentHeight: 1144
            anchors.fill: parent
            model: pageModel
            delegate: AndroidDelegate {
                text: title
                onClicked: {
                    listStackView.push({item: Qt.resolvedUrl(page), immediate: true, replace: true})
                    //message.subTitleMessage = title
                }
            }

            Rectangle {
                width: parent.height
                height: 8 //* Flat.FlatStyle.scaleFactor
                rotation: 90
                anchors.left: parent.right
                transformOrigin: Item.TopLeft

                gradient: Gradient {
                    GradientStop {
                        color: Qt.rgba(0, 0, 0, 0.15)
                        position: 0
                    }
                    GradientStop {
                        color: Qt.rgba(0, 0, 0, 0.05)
                        position: 0.5
                    }
                    GradientStop {
                        color: Qt.rgba(0, 0, 0, 0)
                        position: 1
                    }
                }
            }
        }
    }

    StackView {
        id: listStackView
        x: list.width
        y: 0
        width: parent.width - list.width
        height: parent.height
        initialItem: Qt.resolvedUrl(pageModel.get(0).page)
        //onCurrentItemChanged: message.subTitleMessage = pageModel.get(0).title
    }

    /*
    StackView {
        id: setupStackView
        y: message.height
        anchors.rightMargin: 545
        anchors.fill: parent
        // Implements back key navigation
        focus: true
        Keys.onReleased: if (event.key === Qt.Key_Back && stackView.depth > 1) {
                             stackView.pop();
                             event.accepted = true;
                         }

        initialItem: Item {
            width: parent.width
            height: parent.height
            ListView {
                width: 218
                height: 400
                anchors.bottomMargin: 3
                anchors.topMargin: 0
                scale: 1
                anchors.rightMargin: 3
                cacheBuffer: 320
                contentHeight: 1144
                anchors.fill: parent
                model: pageModel
                delegate: AndroidDelegate {
                    text: title
                    onClicked: setupStackView.push(Qt.resolvedUrl(page))
                }

                Rectangle {
                    width: parent.height
                    height: 8 //* Flat.FlatStyle.scaleFactor
                    rotation: 90
                    anchors.left: parent.right
                    transformOrigin: Item.TopLeft

                    gradient: Gradient {
                        GradientStop {
                            color: Qt.rgba(0, 0, 0, 0.15)
                            position: 0
                        }
                        GradientStop {
                            color: Qt.rgba(0, 0, 0, 0.05)
                            position: 0.5
                        }
                        GradientStop {
                            color: Qt.rgba(0, 0, 0, 0)
                            position: 1
                        }
                    }
                }
            }
        }
    }*/

}

