import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.0
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2


ApplicationWindow {
    visible: true
    width: 480
    height: 320
    title: qsTr("TSCVS")

    Button {
        id: button
        x: 64
        y: 67
        width: 160
        height: 40
        text: qsTr("csv 2 ts")
        onClicked: {
            ts_csv.convertCsvToTs();
        }
    }

    Button {
        id: button1
        x: 245
        y: 67
        width: 160
        height: 40
        text: qsTr("ts 2 csv")
        onClicked: {
            ts_csv.convertTsToCsv();
        }
    }

    Button {
        id: button2
        x: 64
        y: 210
        width: 160
        height: 40
        text: qsTr("merge csv")
        onClicked: {
            ts_csv.mergeCsv();
        }
    }

    Button {
        id: button3
        x: 245
        y: 210
        width: 160
        height: 40
        text: qsTr("update csv from merge")
        onClicked: {
            ts_csv.updateCsv();
        }
    }

    CheckBox {
        id: checkBox
        x: 245
        y: 124
        text: qsTr("Ignore vanished")

        onClicked: {
            if(checked) {
                ts_csv.setFilter("vanished")
            } else {
                ts_csv.delFilter("vanished")
            }
        }
    }

    CheckBox {
        id: checkBox1
        x: 245
        y: 164
        text: qsTr("Ignore obsolete")

        onClicked: {
            if(checked) {
                ts_csv.setFilter("obsolete")
            } else {
                ts_csv.delFilter("obsolete")
            }
        }
    }

    TextInput {
        id: textEdit
        x: 64
        y: 32
        width: 80
        height: 20
        text: qsTr("zh")
        font.pixelSize: 18
        visible: false

        onTextChanged: {
            ts_csv.setLang(text);
        }
    }
}
