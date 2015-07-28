import QtQuick 2.3
import QtGraphicalEffects 1.0

Rectangle{
    id:weapon
    width: parent.width
    height: 2 * parent.rowHeight
    radius: Math.min( 20, height * globals.ui.buttonRadiusPercHeight)
    color:globals.ui.buttonBkColor

    //Component.onCompleted: globals.weaponModel.recreateModel();

    Rectangle{
        color:"white"
        radius: parent.radius
        anchors.fill:parent
        //anchors.margins: parent.height *0.1
        z:1
        visible : timer.running
        opacity:0.8


        Text{
            id:remainingTime
            property int reloadtime : 0

            text:qsTr("Wait : %1 sec").arg(reloadtime)


            height:parent.height
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment : Text.AlignVCenter

            font.pixelSize: globals.ui.textXL
            color: "red"
            minimumPixelSize: globals.ui.minimumPixelSize
            fontSizeMode : Text.Fit

            Timer{
                id:timer
                interval:1000
                triggeredOnStart: true
                running:false
                repeat:true


                onRunningChanged: {
                    weapon.enabled = !running;
                }

                onTriggered: {
                    if (parent.reloadtime > 0)
                        parent.reloadtime--;
                    else{
                        running = false;
                    }
                }
            }
        }
    }
    Component{
        id: weaponDelegate

        Item{
            id:weaponItem
            width: weapon.width
            height: weapon.height
            //anchors.fill : parent
            anchors.margins: Math.min( 10, parent.height * 0.1)
            enabled : ( percChanceToSucceed > 0) && (remainingAmmo >0)
            property int percChanceToSucceed : globals.currentTarget.distance <= model.minDistance ? 100 :
                                               globals.currentTarget.distance > model.maxDistance ? 0 :
                                               100 - ((globals.currentTarget.distance - model.minDistance) / ( model.maxDistance - model.minDistance) * 100)
            property int remainingAmmo : model.ammoType === 1 ? globals.stuff.gunAmmonition :
                                         model.ammoType === 2 ? globals.stuff.shotgunAmmonition :
                                         model.ammoType === 3 ? globals.stuff.riffleAmmonition :
                                         model.ammoType === 0 ? globals.stuffModel.get(model.idStuffModel).quantity : 0
            property var currentData : model

            Image{
                id:imgWeapon
                anchors.left : parent.left
                width: parent.width * 0.5
                height: parent.height * 0.7
                source: imageWeapon
                visible:weaponItem.enabled
                fillMode : Image.PreserveAspectFit
            }

            ColorOverlay {
                anchors.fill: imgWeapon
                anchors.margins: Math.min( 15, parent.height * 0.1)
                source: imgWeapon
                color: "grey"
                visible : !weaponItem.enabled

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
                    rows : model.maxAmmo / columns
                    columns : 5
                    anchors.fill: parent
                    anchors.margins: 1//Math.min( 15, height * 0.1)
                    Repeater{
                        model:weaponItem.remainingAmmo <= weaponItem.currentData.maxAmmo ? weaponItem.remainingAmmo : weaponItem.remainingAmmo % (weaponItem.currentData.maxAmmo)
                        Image{
                            width: ammoCartridge.width / 6
                            height: ammoCartridge.height / 2
                            //scale:2
                            //fillMode: Image.PreserveAspectCrop
                            fillMode : Image.PreserveAspectFit
                            source: weaponItem.currentData.imageAmmo
                        }
                    }
                }
            }

            SPSProgressBar{
                width: parent.width * 0.8
                height: parent.height * 0.15
                anchors.margins: Math.min( 10, parent.height * 0.5)
                anchors.top: imgWeapon.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                value: weaponItem.percChanceToSucceed
                prefixText : qsTr("Shoot : ")
                color : "darkgrey"
                foregroundColor : "green"
            }
            MouseArea{
                anchors.fill: parent
                enabled: weaponItem.enabled
                onClicked:{
                    var rand = Math.random() *100;
                    globals.sounds.shoot.source = model.sound
                    globals.sounds.shoot.play();

                    remainingTime.reloadtime = 3;
                    timer.restart();

                    switch (model.ammoType)
                    {
                    case 0:
                        globals.stuffModel.setProperty(model.idStuffModel, "quantity", globals.stuffModel.get(model.idStuffModel).quantity -1);
                        break;
                    case 1:
                        globals.stuff.gunAmmonition--;
                        break;
                    case 2 :
                        globals.stuff.shotgunAmmonition--;
                        break;
                    case 3 :
                        globals.stuff.riffleAmmonition--;
                        break;
                    }

                    //TODO : implement criticial success, critical failure
                    if ( rand <= weaponItem.percChanceToSucceed)
                    {
                        weaponEvent.showMessage(qsTr("Great shoot!"),10);
                        gameManager.shoot( globals.currentTarget.id );

                    }
                    else{
                        weaponEvent.showMessage(qsTr("Too bad...You missed your shoot !"),11);

                    }



                }
            }

        }
    }

    ListView{
        id:lstView
        anchors.fill : parent
        model :  globals.weaponModel
        spacing : 5
        clip : lstView

        snapMode: ListView.SnapOneItem
        highlightRangeMode: ListView.StrictlyEnforceRange
        orientation: ListView.Horizontal

        delegate: weaponDelegate
    }

    EventBox{
        id:weaponEvent
        anchors.fill:parent
        anchors.margins: parent.height *0.1
        z:50
    }
}


