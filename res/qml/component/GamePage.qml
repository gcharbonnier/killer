import QtQuick 2.4

Item {


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
            notificationBox.showMessage("You have been shooted by "+killer,21);
            if (globals.perso.health < 0)
            {
                notificationBox.displayMessage("You have been killed by "+killer,100);

            }
        }
        onKilled: {
            //notificationBox.color="green";
            //notificationBox.text="You killed "+victim;
        }
    }
    Connections {
        target: playerModel
        onNewPlayer: {
            notificationBox.showMessage(playerName + " joined the campaign !",1);
        }
        onPlayerLeave:{
            notificationBox.showMessage(playerName + " left the campaign !",1);
        }
    }

    EventBox{
        id:notificationBox
        radius : Math.min(50, height*0.1)
        anchors.fill: parent
        anchors.margins: Math.min(50, parent.height*0.1)
    }




}
