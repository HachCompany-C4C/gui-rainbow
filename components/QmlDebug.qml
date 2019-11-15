/****************************************************************************
** QmlDebug.qml
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
import QtQuick.Controls.Styles 1.2

import QtQuick.Window 2.2

Item {
    function setExpert(expert) {
        ifprobe.setExpert(expert);
    }
}
