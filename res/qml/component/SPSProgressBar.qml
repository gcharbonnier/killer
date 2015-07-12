import QtQuick 2.0

Rectangle {
    color:"darkgrey"
    property real minValue : 0
    property real maxValue : 100
    property real value : 0
    property bool showAsPerc : true
    property alias sourceSymbol : symbol.source
    property string prefixText : ""
    //property alias backgroundColor : color
    property alias foregroundColor : progress.color


    Rectangle{
        id:progress
        property int margins : 2
        x: margins
        y: margins
        height : parent.height - 2* margins
        width : (parent.width - 2 * margins) * parent.value / parent.maxValue
        color: globals.ui.buttonBkColor


    }
    Image{
        id: symbol
        height : parent.height
        width : height
        source : ""
    }

    Text
    {
        property real percValue : (parent.value - parent.minValue) / (parent.maxValue - parent.minValue) * 100
        text: parent.showAsPerc ? parent.prefixText + percValue + " %" : parent.prefixText + parent.value
        id: embText
        anchors.fill: parent
        anchors.margins: globals.ui.buttonMargin
        color: globals.ui.textcolor
        font.pixelSize: globals.ui.textGodzilla
        minimumPixelSize: globals.ui.minimumPixelSize
        fontSizeMode : Text.Fit
        font.family: "Syncopate"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment : Text.AlignVCenter
    }
}

