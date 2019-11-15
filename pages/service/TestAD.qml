/****************************************************************************
** TestAD.qml - UI for AD test
**
** Created on: 2017-10-31
**
** Author:
**
** Copyright (C) 2016 Hach DDC
**              All Rights Reserved
**
**
** Notes:
**
****************************************************************************/

import QtQuick 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.0
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import "../../components"

Rectangle{
    id: testroot
    objectName: "test_ad"
    property string title: qsTr("AD")+translator.tr
    width: 800
    height: 360

    property int processIndex: 0
    property bool busy: false
    property bool checkBusy: false
    property bool initCheckBusy: false

    Connections {
        target: test_ad
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            console.debug("QML::UpdatePage Test-PV")
            detectBusy();
            tempTableView.updateTemp()
            adTableView.updateAd()
            page_manager.updatePageDone();
        }
    }

    Connections {
        target: test_ad
        ignoreUnknownSignals: true
        onProbeSetObjDone: {
            if(objName == "fluid") {
                 page_manager.startUpdate("test.ad");
                initCheckBusy = false;
                checkBusy = true;
            }
        }
    }

    Text{
        id:tempAbsText
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 10
        font: mainTheme.titleFont
        text:qsTr("Temperature & Signals") + translator.tr
    }

    H2oTableView {
        id: tempTableView
        width: 800 - 40
        height: 60
        anchors.top: tempAbsText.bottom
        anchors.topMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter

        verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        highlightOnFocus: false
        headerVisible: true
        alternatingRowColors: false
        //backgroundVisible: false
        frameVisible: false

        TableViewColumn {
            role: "item"
            title: " "
            width: tempTableView.width / 5
            resizable: false
            movable: false
            //delegate: textDelegate

        }
        TableViewColumn {
            role: "heating"
            title: qsTr("heating") + translator.tr
            width: tempTableView.width / 5
            resizable: false
            movable: false
            //delegate: textDelegate
        }
        TableViewColumn {
            role: "colorimeter"
            title: qsTr("colorimeter") + translator.tr
            width: tempTableView.width / 5
            resizable: false
            movable: false
            //delegate: textDelegate
        }
        TableViewColumn {
            role: "envirenment"
            title: qsTr("envirenment") + translator.tr
            width: tempTableView.width / 5
            resizable: false
            movable: false
            //delegate: textDelegate
        }
        TableViewColumn {
            role: "deviceCase"
            title: qsTr("case") + translator.tr
            width: tempTableView.width / 5
            resizable: false
            movable: false
            //delegate: textDelegate
        }

        model: ListModel {
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","Temp"); heating: "0"; colorimeter: "0"; envirenment: "0"; deviceCase: "0"}
        }

        rowDelegate: Rectangle {
            id: tempRowItem
            height: 30

            SystemPalette {
                id: tempPalette;
                colorGroup: SystemPalette.Active
            }
            color: {
                var baseColor = styleData.row%2 == 0 ? tempPalette.alternateBase : tempPalette.base
                return styleData.selected ? tempPalette.highlight : baseColor
            }
        }
        function updateTemp()
        {
            var temp = "";
            temp = (test_ad.getObjInt("al_temp")/100).toFixed(1);
            model.setProperty(0, "heating", temp);
            temp = (test_ad.getObjInt("peek_temp")/100).toFixed(1);
            model.setProperty(0, "colorimeter", temp);
            temp = (test_ad.getObjInt("env_temp")/100).toFixed(1);
            model.setProperty(0, "envirenment", temp);
            temp = (test_ad.getObjInt("pcb_temp")/100).toFixed(1);
            model.setProperty(0, "deviceCase", temp);
        }
    }
    H2oTableView {
        id: adTableView
        width: 800 - 40
        height: 240
        anchors.top: tempTableView.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        highlightOnFocus: false
        headerVisible: true
        alternatingRowColors: false
        //backgroundVisible: false
        frameVisible: false

        TableViewColumn {
            role: "item"
            title: " "
            width: adTableView.width / 3
            resizable: false
            movable: false
            //delegate: textDelegate

        }
        TableViewColumn {
            role: "meas"
            title: qsTr("Measure/Level") + translator.tr
            width: adTableView.width / 3
            resizable: false
            movable: false
            //delegate: textDelegate
        }
        TableViewColumn {
            role: "ref"
            title: qsTr("Reference/Level") + translator.tr
            width: adTableView.width / 3
            resizable: false
            movable: false
            //delegate: textDelegate
        }


        model: ListModel {
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","L660"); meas: "0"; ref: "0"}
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","L880"); meas: "0"; ref: "0"}
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","S660"); meas: "0"; ref: "0"}
            ListElement { item: QT_TRANSLATE_NOOP("H2oTableView","S880"); meas: "0"; ref: "0"}
        }

        rowDelegate: Rectangle {
            id: absrowItem
            height: 30

            SystemPalette {
                id: absPalette;
                colorGroup: SystemPalette.Active
            }
            color: {
                var baseColor = styleData.row%2 == 0 ? absPalette.alternateBase : absPalette.base
                return styleData.selected ? absPalette.highlight : baseColor
            }
        }
        function updateAd()
        {
            model.setProperty(0, "meas", test_ad.getObjString("l660_mea")+" / "+test_ad.getObjString("l660_mea_chn"));
            model.setProperty(0, "ref", test_ad.getObjString("l660_ref")+" / "+test_ad.getObjString("l660_ref_chn"));
            model.setProperty(1, "meas", test_ad.getObjString("l880_mea")+" / "+test_ad.getObjString("l880_mea_chn"));
            model.setProperty(1, "ref", test_ad.getObjString("l880_ref")+" / "+test_ad.getObjString("l880_ref_chn"));
            model.setProperty(2, "meas", test_ad.getObjString("s660_mea")+" / "+test_ad.getObjString("s660_mea_chn"));
            model.setProperty(2, "ref", test_ad.getObjString("s660_ref")+" / "+test_ad.getObjString("s660_ref_chn"));
            model.setProperty(3, "meas", test_ad.getObjString("s880_mea")+" / "+test_ad.getObjString("s880_mea_chn"));
            model.setProperty(3, "ref", test_ad.getObjString("s880_ref")+" / "+test_ad.getObjString("s880_ref_chn"));
        }
    }

    Text {
        id: textWizard
        visible: false
        font: mainTheme.mediumFont
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 85
        wrapMode: Text.WordWrap
        width: 500
        anchors.horizontalCenterOffset: 0
        horizontalAlignment: Text.AlignHCenter
    }

    property var wizardText: [
        qsTr("Please check whether the heater temperature is stable on 43℃±0.5."), //0
        qsTr("Please check the connection of blank reagent pipe."), //1
        //qsTr("The flow is preparing, please wait for a minute..."),
        //qsTr("Confirm to start AD adjust ?"),
        qsTr("AD adjusting, please wait ..."), //2
        qsTr("AD adjust done.") //3
    ]

    function accept() {
        if(processIndex == 0) {
            adjustButton.visible = false;
            cancelButton.visible = true;
            okButton.visible = true;
            textWizard.visible = true;
            // Please check whether the heater temperature is stable on 43℃±0.5.
            textWizard.text = qsTr(wizardText[processIndex]);
            processIndex++;
            test_ad.setObj("heat", 1)
        }
    }

    function reject() {

    }

    function setButton(ena)
    {
        if(ena) {
            cancelButton.enabled = true;
            okButton.enabled = true;
            cancelButton.visible = false;
            okButton.visible = false;
            adjustButton.visible = true;
        }
    }


    H2oButton {
        id: adjustButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        width: parent.width
        height: 60
        text: qsTr("ADJUST")+translator.tr
        anchors.horizontalCenterOffset: 0
        visible: true
        buttonRadius: 0
        onClicked: {
            if(!busy) {
                mainMessageDialogTwoButton.parentItem = testroot;
                mainMessageDialogTwoButton.type = "reminder";
                mainMessageDialogTwoButton.text = qsTr("Do you want to Adjust AD ?")+translator.tr;
                mainMessageDialogTwoButton.open();
            } else {
                mainMessageDialogOneButton.type = "reminder";
                mainMessageDialogOneButton.text = qsTr("The device is busy.")+translator.tr;
                mainMessageDialogOneButton.open();
            }
        }
    }

    H2oButton {
        id: cancelButton
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: parent.width/2
        height: 60
        text: qsTr("CANCEL")+translator.tr
        anchors.horizontalCenterOffset: 0
        visible: false
        buttonRadius: 0
        buttonTextColor: theme.mainTextColor
        buttonColor: theme.mediumBackgroundColor
        buttonBorderColor: theme.mediumBackgroundColor
        onClicked: {

            // cancel
            cancelButton.enabled = true;
            okButton.enabled = true;
            cancelButton.visible = false;
            okButton.visible = false;
            adjustButton.visible = true;
            textWizard.text = "";
            processIndex = 0;
        }
    }

    H2oButton {
        id: okButton
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        width: parent.width/2
        height: 60
        text: qsTr("CONFIRM")+translator.tr
        anchors.horizontalCenterOffset: 0
        visible: false
        buttonRadius: 0
        onClicked: {
            switch(processIndex)
            {
            case 1: // Please check the connection of blank reagent pipe.
                textWizard.text = qsTr(wizardText[processIndex]);
                processIndex++;
                break;
            case 2: // The flow is preparing, please wait for a minute...
                page_manager.stopCurrentRepeat();
                test_ad.setObj("fluid", 1)
                textWizard.text = qsTr(wizardText[processIndex]);
                processIndex++;
                cancelButton.enabled = false;
                okButton.enabled = false;
                mainMessage.buttonEnabled = false;

                break;
//            case 4: // AD adjusting, please wait ...
//                test_ad.setObj("adjust", 1)
//                textWizard.text = qsTr(wizardText[processIndex]);
//                processIndex++;
//                cancelButton.enabled = false;
//                okButton.enabled = false;
//                waitTimer.interval = 30000;
//                waitTimer.start();
//                break;
            }
        }
    }

    // Oneshot time to initialize pages after statup
//    Timer {
//        id: waitTimer
//        interval: 3000
//        running: false
//        repeat: false
//        triggeredOnStart: false
//        onTriggered: {
//            switch(processIndex)
//            {
//            /*case 3: // Confirm to start AD adjust ?
//                cancelButton.enabled = true;
//                okButton.enabled = true;
//                textWizard.text = wizardText[processIndex];
//                processIndex++;
//                mainMessage.buttonEnabled = true;
//                break;*/
//            case 5: // AD adjust done.
//                cancelButton.enabled = true;
//                okButton.enabled = true;
//                cancelButton.visible = false;
//                okButton.visible = false;
//                adjustButton.visible = true;
//                textWizard.text = qsTr(wizardText[processIndex]);
//                processIndex = 0;
//                break;
//            }
//        }
//    }

    function detectBusy() {
        busy = test_ad.getObjBool("busy");
        if(checkBusy && initCheckBusy)
        {
            console.debug("QML::TestAD busy: "+busy);
            switch(processIndex)
            {
            case 3: // AD adjusting, please wait ...
                if(!busy) {
                    //cancelButton.enabled = true;
                    //okButton.enabled = true;
                    //textWizard.text = qsTr(wizardText[processIndex]);
                    //processIndex++;
                    mainMessage.buttonEnabled = true;

                    cancelButton.enabled = true;
                    okButton.enabled = true;
                    cancelButton.visible = false;
                    okButton.visible = false;
                    adjustButton.visible = true;
                    textWizard.text = qsTr(wizardText[processIndex]);
                    processIndex = 0;

                    checkBusy = false;
                }
                break;
            default:
                break;
            }
        }
        initCheckBusy = true;
    }

    /*Rectangle {
        id: adPopup
        x: testroot.width/2-120
        y: 15
        width: 240
        height: 120
        border.color: "black"
        visible: false

        Text {
            id: textAdPopup
            font: mainTheme.smallFont
            anchors.horizontalCenter: parent.horizontalCenter
            y: 5
            text: qsTr("Do you want to Adjust AD?")+translator.tr
        }
        H2oButton {
            id: yesPopupButton
            x: (parent.width-160)/3
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            width: 80
            height: 50
            buttonRadius: 5
            text: qsTr("YES")+translator.tr
            onClicked: {
                wizardPopup.visible = true;
                adPopup.visible = false;
            }
        }
        H2oButton {
            id: noPopupButton
            x: (parent.width-160)/3*2+80
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            width: yesPopupButton.width
            height: yesPopupButton.height
            buttonRadius: 5
            text: qsTr("Cancel")+translator.tr
            onClicked: {
                adjustButton.visible = true;
                adPopup.visible = false;
            }
        }
    }

    Rectangle {
        id: wizardPopup
        x: testroot.width/2-170
        y: 180
        width: 340
        height: 155
        border.color: "black"
        visible: false

        Text {
            id: textWizardPopup
            font: mainTheme.smallFont
            anchors.horizontalCenter: parent.horizontalCenter
            y: 5
            text: qsTr("Check aluminum-block temperature!") + translator.tr
        }
        H2oButton {
            id: heatPopupButton
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: textWizardPopup.bottom
            anchors.topMargin: 15
            width: yesPopupButton.width
            height: yesPopupButton.height
            buttonRadius: 5
            text: qsTr("Heat") + translator.tr
            onClicked: {
                //test_ad.setObj("heat", 0x660b)
                test_ad.setObj("heat", 1)
            }
        }
        H2oButton {
            id: okPopupButton
            x: (parent.width-160)/3
            anchors.top: heatPopupButton.bottom
            anchors.topMargin: 5
            width: yesPopupButton.width
            height: yesPopupButton.height
            buttonRadius: 5
            text: qsTr("OK") + translator.tr
            onClicked: {
                //TODO
                adjustButton.visible = true
                wizardPopup.visible = false
                test_ad.setObj("adjust", 1)
            }
        }
        H2oButton {
            id: cancelPopupButton
            x: (parent.width-160)/3*2+80
            anchors.top: okPopupButton.top
            width: yesPopupButton.width
            height: yesPopupButton.height
            buttonRadius: 5
            text: qsTr("Cancel") + translator.tr
            onClicked: {
                adjustButton.visible = true
                wizardPopup.visible = false
            }
        }
    }*/



    /*
    Text {
        id: tempText
        x: 15
        y: parent.height - 205
        font.pixelSize: 24
        text: qsTr("Temp") + translator.tr+" (al/peek/env/pcb)     :"
    }
    ListModel{
        id: tempModel
        ListElement {etext: "25.0"}
        ListElement {etext: "26.0"}
        ListElement {etext: "27.0"}
        ListElement {etext: "28.0"}
    }
    Row{
        id: tempRow
        anchors.left: tempText.right
        anchors.leftMargin: 15
        y: tempText.y+5
        spacing: (testroot.width - 30*24)/3
        Repeater{
            id: tempRepeater
            model: tempModel
            delegate : Text {
                font.pixelSize: 24
                text: etext
            }
            function updateTemp()
            {
                var temp = "";
                temp = "" + (test_ad.getObjInt("al_temp")/100).toFixed(2);
                model.setProperty(0, "etext", temp);
                temp = "" + (test_ad.getObjInt("peek_temp")/100).toFixed(2);
                model.setProperty(1, "etext", temp);
                temp = (test_ad.getObjInt("env_temp")/100).toFixed(2);
                model.setProperty(2, "etext", temp);
                temp = (test_ad.getObjInt("pcb_temp")/100).toFixed(2);
                model.setProperty(3, "etext", temp);
            }
        }
    }
    ListModel {
        id: adTextModel
        ListElement {etext: "L660   Mea/Ref        :"}
        ListElement {etext: "L880   Mea/Ref        :"}
        ListElement {etext: "S660   Mea/Ref        :"}
        ListElement {etext: "S880   Mea/Ref        :"}
    }

    Column {
        id:adTextColumn
        x: 15
        y: testroot.height-170
        spacing: 8
        Repeater {
            model: adTextModel
            delegate: Text {
                font.pixelSize: 24
                text: etext
            }
        }
    }

    ListModel {
        id: measModel
        ListElement {etext: "2333"}
        ListElement {etext: "3333"}
        ListElement {etext: "4333"}
        ListElement {etext: "5333"}
    }

    Column {
        x: 365
        y: adTextColumn.y
        spacing: adTextColumn.spacing
        Repeater {
            id: measRepeater
            model: measModel
            delegate: Text {
                font.pixelSize: 24
                text: etext
            }
            function updateMeas() {
                model.setProperty(0, "etext", test_ad.getObjString("l660_mea"));
                model.setProperty(1, "etext", test_ad.getObjString("l880_mea"));
                model.setProperty(2, "etext", test_ad.getObjString("s660_mea"));
                model.setProperty(3, "etext", test_ad.getObjString("s880_mea"));
            }

        }
    }
    Column {
        x:470
        y: adTextColumn.y
        spacing: adTextColumn.spacing
        Repeater {
            model: 4
            delegate: Text {
                font.pixelSize: 24
                text: "/"
            }
        }
    }

    ListModel {
        id: refModel
        ListElement {etext: "6333"}
        ListElement {etext: "7333"}
        ListElement {etext: "8333"}
        ListElement {etext: "9333"}
    }

    Column {
        x: 490
        y: adTextColumn.y
        spacing: adTextColumn.spacing
        Repeater {
            id: refRepeater
            model: refModel
            delegate: Text {
                font.pixelSize: 24
                text: etext
            }
            function updateRef() {
                model.setProperty(0, "etext", test_ad.getObjString("l660_ref"));
                model.setProperty(1, "etext", test_ad.getObjString("l880_ref"));
                model.setProperty(2, "etext", test_ad.getObjString("s660_ref"));
                model.setProperty(3, "etext", test_ad.getObjString("s880_ref"));
            }
        }
    }*/
}
