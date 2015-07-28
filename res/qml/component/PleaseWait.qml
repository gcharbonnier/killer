import QtQuick 2.0

Item {

    anchors.fill :parent
    //anchors.margins: parent.height * 0.1
    visible : false

    property alias text : embText.text

    function show()
    {
        visible=true;
    }

    Image{
        anchors.centerIn: parent
        source: "qrc:/res/background_character.png"

    }
    Image{
        anchors.centerIn: parent
        source: "qrc:/res/pleasewait.png"
        rotation : 0

        RotationAnimation on rotation {
                loops: Animation.Infinite
                from: 0
                to: 360
                duration : 2000
                running: true
            }
    }

    Text{
        id:embText
        text:qsTr("Please wait...")
        anchors.fill: parent
        anchors.margins: globals.ui.buttonMargin
        color: "lightgrey"
        font.pixelSize: globals.ui.textGodzilla
        minimumPixelSize: globals.ui.minimumPixelSize
        fontSizeMode : Text.Fit
        font.family: "Syncopate"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment : Text.AlignVCenter
    }
}

