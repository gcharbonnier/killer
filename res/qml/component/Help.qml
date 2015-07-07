import QtQuick 2.3

Item{
    height: parent.height
    width: parent.width*0.5

    Rectangle{
        anchors.fill: parent
        anchors.margins : 20
        color : globals.ui.background
        opacity : globals.ui.buttonBkOpacity
        radius : 30

        Text{
            anchors.fill: parent
            anchors.margins : 20
            text:"Killer is an Alternate Reality Game. The principle is to interact with other players using the geolocalisation service of your mobile.<br>" +
                 "More information can be found on ..."
            color: globals.ui.textcolor
            font.pixelSize: globals.ui.textGodzilla
            minimumPixelSize: globals.ui.minimumPixelSize
            fontSizeMode : Text.Fit
            font.family: "Syncopate"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment : Text.AlignVCenter
        }
    }


}

