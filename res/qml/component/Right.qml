import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    //radius:50
    id:rightRoot
    //border.color: "white"
    //border.width: 0
    //opacity:1
    //color: "#33FF0000"
    property string targetId: targetSelector.currentItem ? targetSelector.currentItem.IdPlayer : "No selection"
    onTargetIdChanged: {
        globals.currentTarget.id = targetId;
        globals.currentTarget.distance = targetSelector.currentItem ? targetSelector.currentItem.Distance : 0;
        globals.currentTarget.azimuth = targetSelector.currentItem ? targetSelector.currentItem.Azimuth : 0;
        globals.currentTarget.name = targetSelector.currentItem ? targetSelector.currentItem.NamePlayer : targetId;
    }

    Column{
        opacity: 1
        anchors.fill:parent
        anchors.margins: 20
        spacing:20
        property int rowHeight: (height - 2* spacing - 2* anchors.margins) / 5


        SPSSpinButton{
             id:targetSelector
             width:parent.width
             height:parent.rowHeight
             model:playerModel
             roleToDisplayName:"NamePlayer"
             labelPrefix:"Target<br>"
        }



        Rectangle{
            id: skill
            width: parent.width
            height: 2 * parent.rowHeight
            radius: Math.max( 20, height * globals.ui.buttonRadiusPercHeight)
            color:globals.ui.buttonBkColor

            Text{
                text:"Steal !"
                anchors.fill: parent
                anchors.centerIn: parent
                anchors.margins: globals.ui.buttonMargin
                color: globals.ui.textcolor
                font.pixelSize: globals.ui.textXL
                minimumPixelSize: globals.ui.minimumPixelSize
                fontSizeMode : Text.Fit
                font.family: "Syncopate"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment : Text.AlignVCenter
            }

        }

        Rectangle{
            id:weapon
            width: parent.width
            height: 2 * parent.rowHeight
            radius: Math.max( 20, height * globals.ui.buttonRadiusPercHeight)
            color:globals.ui.buttonBkColor
            enabled: ( (globals.currentTarget.distance < 15) && (globals.stuff.gunAmmonition >0))

            Item{
                anchors.fill: parent
                anchors.margins: 10

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
                    anchors.margins: 15
                    source: imgWeapon
                    color: weapon.enabled ? "black" : "grey"
                }
                Item{
                    anchors.left: imgWeapon.right
                    height: imgWeapon.height
                    width: parent.width * 0.4
                    Grid{
                        rowSpacing : 30
                        columnSpacing: 20
                        rows : 2
                        columns : 5
                        anchors.fill: parent
                        anchors.margins: 15
                        Repeater{
                            model:globals.stuff.gunAmmonition
                            Image{
                                //width: parent.width / 5
                                //height: 5 * width
                                scale:2
                                fillMode: Image.PreserveAspectCrop
                                source:"qrc:/res/bullet.png"
                            }
                        }
                    }
                }

                Text{
                    width: parent.width
                    height: parent.height * 0.4
                    anchors.top: imgWeapon.bottom
                    visible: weapon.enabled
                    text:"Shoot !"
                    font.pixelSize: globals.ui.textXL
                    color: globals.ui.textcolor
                    anchors.margins: globals.ui.buttonMargin
                    minimumPixelSize: globals.ui.minimumPixelSize
                    fontSizeMode : Text.Fit
                    font.family: "Syncopate"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment : Text.AlignVCenter
                }
                MouseArea{
                    anchors.fill: parent
                    enabled: weapon.enabled
                    onClicked:{
                        gameManager.shoot(rightRoot.targetId);
                        globals.sounds.shoot.play();
                        globals.stuff.gunAmmonition--;
                    }
                }

            }


        }

    }

}


