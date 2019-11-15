import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2

Item {
    width: 800
    height: 300

    // animated rotation box
    Rectangle {
        id: rotationBox
        width: 50
        height: 50
        color: "green"
        opacity: 0

        NumberAnimation on x {
            id: xa
            //paused: btnPause.pressed
            to: 800-50
            duration: 10000
            loops: Animation.Infinite
        }
        NumberAnimation on y {
            id: ya
            //paused: btnPause.pressed
            to: 480-50
            duration: 20000
        }
        RotationAnimation on rotation {
            from: 0
            to: 360
            duration: 500
            loops: Animation.Infinite
        }

        ColorAnimation on color {
            id: ca
            from: "green"
            to: "red"
            duration: 2000
        }

    }

    // painting area
    Canvas {
        id: paintCanvas
        width: 700
        height: 300
        property int lastX: 0
        property int lastY: 0

        function clear() {
            var ctx = getContext("2d")
            ctx.reset()
            paintCanvas.requestPaint()
            mouse.reset()
        }

        onPaint: {
            // demo javascript canvas
            var ctx = getContext("2d")
            ctx.lineWidth = 2
            ctx.strokeStyle = color.red
            ctx.beginPath()
            ctx.moveTo(lastX, lastY)
            lastX = paintArea.mouseX
            lastY = paintArea.mouseY
            ctx.lineTo(lastX, lastY)

            ctx.fillStyle = colorDialog.color
            ctx.font = "24px courier"
            //ctx.fillText(txtField.text, 100, 100)

            ctx.stroke()

            mouse.test()
            mouse.drawPoint(lastX, lastY)
        }

        MouseArea {
            id: paintArea
            anchors.leftMargin: 0
            anchors.fill: parent

            onPressed: {
                paintCanvas.lastX = mouseX
                paintCanvas.lastY = mouseY
            }
            onPositionChanged: {
                paintCanvas.requestPaint()
            }
        }

    }

    // controlling buttons
    property int buttonHeight: testButtons.height / 6

    Rectangle {
        id: testButtons
        x: 760
        y: 30
        width: 40
        height: 240
        color: "#faf5cf"

        Button {
            id: btnAnimation
            width: parent.width
            height: buttonHeight
            text: "Box"
            onClicked: rotationBox.opacity = rotationBox.opacity == 1 ? 0 : 1
        }

        Button {
            id: clearButton
            width: parent.width
            height: buttonHeight
            anchors.top: btnAnimation.bottom
            text: "Clear"
            onClicked: {
                paintCanvas.clear()
                message.stateMessage.state = "RESET"
            }
        }

        Button {
            id: startButton
            width: parent.width
            height: buttonHeight
            anchors.top: clearButton.bottom
            text: "Start"
            onClicked: message.stateMessage.state = "START"
        }

        Button {
            id: stopButton
            width: parent.width
            height: buttonHeight
            anchors.top: startButton.bottom
            text: "Stop"
            onClicked: message.stateMessage.state = "STOP"
        }

        // modal window test
        ColorDialog {
            id: colorDialog
            modality: Qt.WindowModal
            title: "choose a color"
            color: "green"
        }

        FontDialog {
            id: fontDialog
            modality: Qt.WindowModal
            title: "choose a font"
        }

        Button {
            id: btnColor
            width: parent.width
            height: buttonHeight
            anchors.top: stopButton.bottom
            text: "Color"
            onClicked: {
                colorDialog.open()
                paintCanvas.requestPaint()
            }
        }

        Button {
            id: btnFont
            width: parent.width
            height: buttonHeight
            anchors.top: btnColor.bottom
            text: "Font"
            onClicked: {
                fontDialog.open()
                message.stateMessage.font = fontDialog.font
                message.stateMessage.renderType
            }
        }

    }
}

