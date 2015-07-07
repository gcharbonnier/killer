import QtQuick 2.0

Item{
    property alias text : embText.text
    property alias color : embRect.color
    signal clicked()
    
    Rectangle{
        id:embRect
        radius : height * globals.ui.buttonRadiusPercHeight
        opacity: globals.ui.buttonBkOpacity
        anchors.fill: parent
        color:globals.ui.buttonMenuBkColor
    }

    Text
    {
        id: embText
        enabled: parent.enabled
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

    MouseArea{
        id:embMA
        anchors.fill:parent
        enabled: parent.enabled
        onClicked: parent.clicked()
    }

}



