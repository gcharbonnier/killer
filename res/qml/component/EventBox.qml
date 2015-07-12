import QtQuick 2.0

Rectangle{
    id:notifRoot
    color:"grey"
    opacity:0
    //property alias text: notificationMessage.text
    property int typeblocking : 0
    /* Type description */
    // 0 : generic
    // 1 : information
    // 2 : great
    // 3 : caution
    // 4 : warning
    // 10 : action success
    // 11 : action failed
    // 21 : shooted : someone is shooting you
    // 22 : shoot : you have succeeded a shoot
    // 23 : shootAvoided : the target avoided the attack
    // 24 : injured : you are injured
    // 100 : dead : you are dead...game over !
    z:100

    function showMessage(message, type)
    {
        if (typeblocking < 100)
        {
            typeblocking = type;
            notificationMessage.text = message;
            proceedWithType( type);
            showMessageAnim.restart();
        }
    }

    function displayMessage(message, type)
    {
        showMessageAnim.stop();
        displayMessageAnim.restart();
        typeblocking = type;
        proceedWithType( type);
        notificationMessage.text = message;
    }

    function proceedWithType( type)
    {
        switch (type)
        {
            case 10: // action success
                globals.perso.xp += 1;
                globals.sounds.succeeded.play();
                color="lightgreen";
                embImage.source = "qrc:/res/actionSuccess.png"
                embImage.visible = true;
                break;
            case 11: // action failed
                globals.sounds.missed.play();
                color="yellow";
                embImage.source = "qrc:/res/fail.png"
                embImage.visible = true
                break;
            case 21: // shooted : someone is shooting you
                color="orange";
                globals.perso.health -= 34;
                //embImage.source = "qrc:/res/actionSuccess.png"
                embImage.visible = false;
                globals.sounds.injured.play();
                break;
            case 100: //dead : you are dead...game over !
                color="red";
                globals.sounds.dead.play();
                embImage.source = "qrc:/res/killed.png"
                embImage.visible = true;
                ackButton.text="Quit"
                gameManager.stopGame( );
                //Notify the others players using the intercom
                messageModel.sendSystemMessage( accountModel.accountName + " left the campaign");
                break;
            default:
                embImage.visible = false;
        }
    }

    Column{
        anchors.fill: parent
        anchors.margins: 5

        Row{
            width: parent.width
            height: parent.height - ackButton.height
            anchors.margins: 5


            Image{
                id:embImage
                width:parent.width * 0.5
                height: parent.height
                visible:false
            }

            Text {
                id:notificationMessage
                width: embImage.visible ? parent.width * 0.5 : parent.width
                height: parent.height
                //anchors.margins: globals.ui.buttonMargin
                color: globals.ui.textcolor
                font.pixelSize: globals.ui.textGodzilla
                minimumPixelSize: globals.ui.minimumPixelSize
                fontSizeMode : Text.Fit
                font.family: "Syncopate"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment : Text.AlignVCenter
            }
        }
        SPSButtonText{
            id: ackButton
            anchors.horizontalCenter: parent.horizontalCenter
            height:Math.min(150, parent.height * 0.2)
            width: parent.width * 0.5
            text : "OK"
            visible: notifRoot.typeblocking >= 100
            onClicked: {
                if (notifRoot.typeblocking == 100)
                {
                    //gameManager.stopGame( );
                    mainPanel.state="";

                }
                notifRoot.opacity=0;
                notifRoot.typeblocking = 0;
            }
        }
    }


    SequentialAnimation {
        id: showMessageAnim
        running: false
        NumberAnimation { target: notificationBox; property: "opacity"; to: 1.0; duration: 100}
        NumberAnimation { target: notificationBox; property: "opacity"; to: 0.0; duration: 5000}

    }
    SequentialAnimation {
        id: displayMessageAnim
        running: false
        NumberAnimation { target: notificationBox; property: "opacity"; to: 1.0; duration: 100}
    }


}

