import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.1
import "../../components"

Rectangle {
    width: 800
    height: 480

    Connections {
        target: system_info
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            // console.debug("QML::PageUpdate system_info")
            typeSwitch.updateChecked();
        }
    }

    H2oSwitch {
        id: typeSwitch
        x: 214
        y: 148

        function updateChecked() {
            var value = system_info.getObjBool("instr_type");
            checked = value;
        }

        onValueChanged: {
            system_info.setObj("instr_type", checked)
        }
    }

    Text {
        id: text1
        x: 313
        y: 158
        text: qsTr("Extended")+translator.tr
        font.pixelSize: 16
    }

    Text {
        id: text2
        x: 129
        y: 158
        text: qsTr("Standard")+translator.tr
        font.pixelSize: 16
    }

    Text {
        id: text3
        x: 129
        y: 102
        text: qsTr("Instrument Mode:")+translator.tr
        font.pixelSize: 21
    }

    Text {
        id: text4
        x: 129
        y: 216
        text: qsTr("Note: Please restart the instrument after change the Instrument Mode")+translator.tr
        font.pixelSize: 15
    }
}
