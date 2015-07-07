
import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1



Item {
    /*gradient: Gradient{
        GradientStop { position: 0.0; color: "#dd000000" }
        GradientStop { position: 0.3; color: "#aa000000" }
        GradientStop { position: 1.0; color: "transparent" }
    }*/

    anchors.fill: parent

    Image{
        anchors.fill: parent
        source:"qrc:/res/backgroundGame.png"
    }

    Top{
        id:top
        z:1                             //We need the menu to be above the other area
        height: parent.height * 0.2
        width:parent.width
    }



    Content{
        id:content
        anchors.top : top.bottom
        anchors.bottom : parent.bottom
        width: parent.width*0.8

    }

    Right{

        anchors.left : content.right
        anchors.right : parent.right
        anchors.top : top.bottom
        anchors.bottom : parent.bottom

    }



    Connections {
        target: gameManager
        onKilledBy: {
            notificationBox.color="red";
            notificationBox.text="You have been killed by "+killer;
        }
        onKilled: {
            notificationBox.color="green";
            notificationBox.text="You killed "+victim;
        }
    }

    Rectangle{
        id:notificationBox
        color:"grey"
        opacity:0
        radius : 50
        anchors.fill: parent
        anchors.margins: 50
        visible: true
        property alias text: notificationMessage.text
        z:100

        Text {
            id:notificationMessage
            anchors.centerIn: parent
            font.pixelSize: 50
        }

        onTextChanged: {
            showMessage.restart();
        }
        SequentialAnimation {
               id: showMessage
               running: false
               NumberAnimation { target: notificationBox; property: "opacity"; to: 1.0; duration: 100}
               NumberAnimation { target: notificationBox; property: "opacity"; to: 0.0; duration: 5000}

           }


    }


}
