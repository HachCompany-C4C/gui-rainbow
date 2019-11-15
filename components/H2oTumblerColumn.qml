/****************************************************************************
** H2oTumblerColumn.qml
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

TumblerColumn {
    property bool operated: false
    property int offset: 0
    function value() {
        return currentIndex + offset;
    }
}
