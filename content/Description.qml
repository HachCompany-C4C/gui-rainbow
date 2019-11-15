import QtQuick 2.0

Item {
    property var range: [
        qsTr("0.02~15")+translator.tr,
        qsTr("0.05~30")+translator.tr,
        qsTr("3~100")+translator.tr,
        qsTr("80~1000")+translator.tr,
        qsTr("Error")+translator.tr
    ]
}
