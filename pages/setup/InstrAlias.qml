/****************************************************************************
** InstrAlias.qml - Interface for device name setting
**
** Created on: 2017-10-31
**
** Author: BW
**
** Copyright (C) 2016 Hach DDC
**              All Rights Reserved
**
**
** Notes:
**
****************************************************************************/
import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import "../../components"
import "../../content"

import "../../content/Strconvert.js" as StringConv

Item {
    width: 800
    height: 360
    enabled: mainPermisMgr.editabled

    Connections {
        target: system_info
        ignoreUnknownSignals: true
        onProbeUpdateDone: {
            // console.debug("QML::Instr Alias ")
            aliasText.updateAliasText();

            page_manager.updatePageDone();
        }
    }

    H2oTextField {
        id: aliasText
        x: 41
        y: 40
        width: 400
        height: 40
        keyBoard: mainVKeyBoard
        plaintext: text

        onEditDone: {
            var str = inputStr;
            str = str.substr(0, 32);
            var outList = StringConv.stringToCode32(str);

            aliasText.text = str;

            system_info.setObj("alias", outList);
        }

        function updateAliasText() {
            var aliasStr = system_info.getObjString("alias");
            var strText = StringConv.codeToString32(aliasStr);

            aliasText.text = strText;
        }
    }
}
