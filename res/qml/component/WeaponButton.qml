import QtQuick 2.3
import QtGraphicalEffects 1.0

Rectangle{
    id:weapon
    width: parent.width
    height: 2 * parent.rowHeight
    radius: Math.min( 20, height * globals.ui.buttonRadiusPercHeight)
    color:globals.ui.buttonBkColor
    enabled: ( percChanceToSucceed > 0) && (globals.stuff.gunAmmonition >0)

    property int percChanceToSucceed : globals.currentTarget.distance <= globals.currentWeapon.minDistance ? 100 :
                                       globals.currentTarget.distance > globals.currentWeapon.maxDistance ? 0 :
                                       100 - ((globals.currentTarget.distance - globals.currentWeapon.minDistance) / ( globals.currentWeapon.maxDistance - globals.currentWeapon.minDistance) * 100)

    Item{
        anchors.fill: parent
        anchors.margins: Math.min( 10, parent.height * 0.1)

        Image{
            id:imgWeapon
            anchors.left : parent.left
            width: parent.width * 0.5
            height: parent.height * 0.5
            source:"qrc:/res/gun.png"
            visible:false
        }

        ColorOverlay {
            anchors.fill: imgWeapon
            anchors.margins: Math.min( 15, parent.height * 0.1)
            source: imgWeapon
            color: weapon.enabled ? "black" : "grey"
        }

        Item{
            id:ammoCartridge
            anchors.left: imgWeapon.right
            height: imgWeapon.height
            width: parent.width * 0.4
            Grid{
                //rowSpacing : Math.min( 30, height * 0.01)
                //columnSpacing: Math.min( 20, height * 0.01)
                spacing : 1//Math.min( 5, height * 0.01)
                rows : 2
                columns : 5
                anchors.fill: parent
                anchors.margins: 1//Math.min( 15, height * 0.1)
                Repeater{
                    model:globals.stuff.gunAmmonition == 0 ? 0 : (globals.stuff.gunAmmonition % 10)+1
                    Image{
                        width: ammoCartridge.width / 6
                        height: ammoCartridge.height / 2
                        //scale:2
                        fillMode: Image.PreserveAspectCrop
                        source:"qrc:/res/bullet.png"
                    }
                }
            }
        }

        SPSProgressBar{
            width: parent.width
            height: parent.height * 0.4
            anchors.margins: Math.min( 5, parent.height * 0.1)
            anchors.top: imgWeapon.bottom
            value: weapon.percChanceToSucceed
            visible : weapon.enabled
            prefixText : "Shoot : "
            color : "darkgrey"
            foregroundColor : "green"
        }
        MouseArea{
            anchors.fill: parent
            enabled: weapon.enabled
            onClicked:{
                var rand = Math.random() *100;

                globals.sounds.shoot.play();
                globals.stuff.gunAmmonition--;

                //TODO : implement criticial success, critical failure
                if ( rand <= weapon.percChanceToSucceed)
                {
                    notificationBox.showMessage("Great shoot!",10);
                    gameManager.shoot(rightRoot.targetId);

                }
                else{
                    notificationBox.showMessage("Too bad...You missed your shoot !",11);

                }



            }
        }

    }


}


