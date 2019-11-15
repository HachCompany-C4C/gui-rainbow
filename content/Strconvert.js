/****************************************************************************
** CalibFactor.qml - Function to convert string to char code and char code to string
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

function stringToCode32(str)
{
    var ret = [];
    if(str.length > 32) {
        str = str.substr(0, 32);
    }

    for(var i = 0; i < str.length; i++) {
        var ch = str.charCodeAt(i);
        ret.push(ch);
    }

    for(var j = 0; j < 32 - str.length; j++) {
        ret.push(" ".charCodeAt(0))
    }

    return ret;
}

function codeToString32(str)
{
    var ret = "";
    for(var i = 0; i < str.length; i++)
    {
        var ch = String.fromCharCode(str.charCodeAt(i));
        ret += ch;
    }

    return ret;
}
