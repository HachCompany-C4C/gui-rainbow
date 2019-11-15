import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.0
import QtQuick.Layouts 1.0

TextField {
    id: h2oTextField
    property bool editTextHoldEnabled: false

    signal editDone(var inputStr)

    style: TextFieldStyle {
        textColor: "black"

        background: Rectangle {
            radius: 4
            border.color: "black"
            border.width: 1
            implicitHeight: 40

            Text {
                font.pixelSize: 40
            }
        }
    }

    //echoMode: TextInput.Password

    Button {
        id: button
        anchors.right: parent.right
        anchors.rightMargin: 2
        anchors.verticalCenter: parent.verticalCenter

        Label {
            width: 40
            height: 38
            text: "\ue637"
            color: "black"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: theme.mediumIcon
        }

        style: ButtonStyle {

            background: Rectangle {
                implicitWidth: 40
                implicitHeight: 38
                border.width: control.activeFocus ? 1 : 0
                //border.color: "#888"
                radius: 4
                gradient: Gradient {
                    GradientStop { position: 0 ; color: control.pressed ? "#ccc" : "#eee" }
                    GradientStop { position: 1 ; color: control.pressed ? "#aaa" : "#ccc" }
                }
            }
        }

        function keyboardOutput() {
            console.debug("QML::H2oTextField key board output")
        }

        onClicked: {
            //console.debug("H2o Virtual Key Board")
            mainKeyBoard.open();
            mainKeyBoard.textField = h2oTextField;
            //var compon = Qt.createComponent("H2oVKeyBoard.qml")
            //Incubators allow new component instances to be instantiated asynchronously and do not cause freezes in the UI.
            //var keyBoard = compon.incubateObject(h2oTextField, {"text": editTextHoldEnabled ? h2oTextField.text : ""});
            //keyBoard.open()
        }
    }
}

