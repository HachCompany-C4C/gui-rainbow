import QtQuick 2.5

Rectangle {
    id: mainWindow
    visible: true
    width: 800
    height: 480
    title: qsTr("Hello Rainbow")
    color: "#f2f2f2"
    
	property int smallFont: 18
	property int mediumFont: 24
	property int bigFont: 36
	property int hugeFont: 72
    FontLoader {
    	id: noto
    	source: "../fonts/NotoSans/NotoSans-Regular.ttf" 
    }

    BorderImage {
        id: border
        x: 0
        y: 0
        width: parent.width
        height: 80
        border.bottom: 8
        source: "../images/toolbar-hach.png"

        Text {
            id: title
            x: 20
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            text: "Amtax III"
            font.family: noto.name
            font.pixelSize: bigFont
        }
    }
    
	Text {
		id: hello
		text: "Hello, rainbow qmlweb!"
		color: "#0098db"
		anchors.centerIn: parent
		font.family: noto.name
		font.pixelSize: bigFont
	}

}

