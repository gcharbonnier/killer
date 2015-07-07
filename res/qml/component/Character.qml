import QtQuick 2.3

Item{
    height: parent.height
    width: parent.width*0.5

    Image{
        anchors.fill: parent
        source:"qrc:/res/mockupCharacter.png"
    }
    Text{
        anchors.fill: parent
        text: "Mockup only for now..."
    }
}

