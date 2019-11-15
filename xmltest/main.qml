import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.0
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2


ApplicationWindow {
    visible: true
    width: 420
    height: 240
    title: qsTr("TSCVS")

    Button {
        id: button
        x: 36
        y: 81
        width: 160
        height: 40
        text: qsTr("csv 2 ts")
        onClicked: {
            ts_csv.csv2ts();
        }
    }

    Button {
        id: button1
        x: 217
        y: 81
        width: 160
        height: 40
        text: qsTr("ts 2 csv")
        onClicked: {
            ts_csv.ts2csv();
        }
    }

    CheckBox {
        id: checkBox
        x: 217
        y: 138
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
        x: 217
        y: 178
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
        x: 36
        y: 19
        width: 80
        height: 20
        text: qsTr("zh")
        font.pixelSize: 18

        onTextChanged: {
            ts_csv.setLang(text);
        }
    }
}
