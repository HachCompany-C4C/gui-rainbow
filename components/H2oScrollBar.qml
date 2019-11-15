import QtQuick 2.0

Rectangle {
    width: 50
    height: parent.height
    anchors.right: parent.right
    anchors.top: parent.top
    color: "#f2f2f2"
    // inscrease control
    Rectangle {
        width: parent.width
        height: 50
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        color: descreaseCtrl.pressed ? "#9e9e9e" : "#e4e4e4"
        Text {
            font.family: theme.bigIcon
            font.pixelSize: 24
            color: "#3ebdf2"
            text: "\ue644"
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        MouseArea {
            id: descreaseCtrl
            anchors.fill: parent
            onClicked: {
                console.debug("QML::descrease Ctrl")
                logTable.logViewIndex = logTable.logViewIndex > 8 ? (logTable.logViewIndex-8) : 0
                var title = ["mcudata.rtc", "mcudata.abs.l880", "mcudata.abs.s600", "mcudata.abs.l660", "mcudata.monitor.concentration", "mcudata.temperature.pt0", "mcudata.step.main0"];
                var param = {"title": title, "start": logTable.logViewIndex, "count": 8, "type": "mcudata"};
                log_view.setObj("read_data", param);
            }
        }

    }
    // descrease control
    Rectangle {
        width: parent.width
        height: 50
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        color: inscreaseCtrl.pressed ? "#9e9e9e" : "#e4e4e4"
        Text {
            font.family: theme.bigIcon
            font.pixelSize: 24
            color: "#3ebdf2"
            text: "\ue643"
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        MouseArea {
            id: inscreaseCtrl
            anchors.fill: parent
            onClicked: {
                console.debug("QML::inscrease Ctrl")
                logTable.logViewIndex+=8;
                var title = ["mcudata.rtc", "mcudata.abs.l880", "mcudata.abs.s600", "mcudata.abs.l660", "mcudata.monitor.concentration", "mcudata.temperature.pt0", "mcudata.step.main0"];
                var param = {"title": title, "start": logTable.logViewIndex, "count": 8, "type": "mcudata"};
                log_view.setObjsJson("read_data", param);
            }
        }
    }
}
