import QtQuick 2.4
import "../../../GameLogic.js" as EquipmentAction

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
            notificationBox.showMessage(qsTr("You have been shooted by %1").arg(killer),21);
            if (globals.perso.health <= 0)
            {
                notificationBox.displayMessage(qsTr("You have been killed by %1").arg(killer),100);

            }
        }
        onKilled: {
            //notificationBox.color="green";
            //notificationBox.text="You killed "+victim;
        }

        onGameStarted:{
            EquipmentAction.startGame();//loadPlayerData();
            pleaseWait.visible = false;
        }
        onGameStopped:{
            EquipmentAction.stopGame();//savePlayerData();
        }
    }
    Connections {
        target: playerModel
        onNewPlayer: {
            notificationBox.showMessage(qsTr("%1 joined the campaign !").arg(playerName),1);
        }
        onPlayerLeave:{
            notificationBox.showMessage(qsTr("%1 left the campaign !").arg(playerName),1);
        }
    }

    Connections {
        target: geoLocalItemsModel
        onBonusItemFound: {
            if (Type == 0)
                EquipmentAction.modifyEnergy(value);
                //globals.perso.energy += value;
            else if (Type == 1)
                EquipmentAction.modifyHealth(value);
                //globals.perso.health += value;
            else if (Type == 2)
                globals.perso.credits += value;
            globals.sounds.energy.play();
        }

    }

    EventBox{
        id:notificationBox
        radius : Math.min(50, height*0.1)
        anchors.fill: parent
        anchors.margins: Math.min(50, parent.height*0.1)
    }




}
