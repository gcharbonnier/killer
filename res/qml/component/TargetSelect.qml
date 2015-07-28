import QtQuick 2.0
import QtGraphicalEffects 1.0

Rectangle {
    radius:50
    border.color: "white"
    border.width: 5
    opacity:1
    color: "#330000FF"

    anchors.fill:parent
    anchors.margins: 20
    property string targetId:lstTarget.currentItem.currentData.IdPlayer
    onTargetIdChanged: {
        globals.currentTarget.id = targetId;
        globals.currentTarget.distance = lstTarget.currentItem.currentData.Distance;
        globals.currentTarget.azimuth = lstTarget.currentItem.currentData.Azimuth;
    }

    Column{
        opacity: 1
        anchors.fill:parent
        anchors.margins: 20
        spacing:20

        //Select target
        Row{
            id:targetSelector
            //property int currentSelection:0
            spacing: 30
            height:100
            width:parent.width
            Rectangle{
                height: parent.height
                width:100
                color: globals.ui.buttonBkColor
                radius: 30

                Text{
                    anchors.centerIn: parent
                    text:"<<"
                    font.pixelSize: globals.ui.textXL
                    color: globals.ui.textcolor
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: { lstTarget.decrementCurrentIndex();}
                }
            }

            ListView{
                id:lstTarget
                width:300
                height: parent.height
                model:playerModel
                delegate:
                    Rectangle{
                        property variant currentData: model
                        width:lstTarget.width
                        height:lstTarget.height
                        radius:10
                        color:"grey"
                        visible:index==lstTarget.currentIndex;
                        Text{
                            anchors.centerIn: parent
                            text: model.NamePlayer
                            font.pixelSize: globals.ui.textM
                            color: globals.ui.textcolor
                        }
                    }

            }

            Rectangle{
                height: parent.height
                width:100
                color: globals.ui.buttonBkColor
                radius: 30

                Text{
                    anchors.centerIn: parent
                    text:">>"
                    font.pixelSize: globals.ui.textXL
                    color: globals.ui.textcolor
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        lstTarget.incrementCurrentIndex();

                    }
                }
            }
        }

        Text{
            height:100
            width:100
            text:qsTr("distance to current selection %1 m").arg( lstTarget.currentItem.currentData.Distance)
        }

        Rectangle{
            id:weapon
            width: imgWeapon.width + 50
            height: imgWeapon.height + 50
            radius: 10
            color:globals.ui.buttonBkColor
            property bool enabled: ( (lstTarget.currentItem.currentData.Distance < 15) && (globals.stuff.gunAmmonition >0))

            Image{
                id:imgWeapon
                anchors.centerIn: weapon
                source:"qrc:/res/gun.png"
                visible:visible
            }

            ColorOverlay {
                anchors.fill: imgWeapon
                source: imgWeapon
                color: weapon.enabled ? "darkgreen" : "darkgrey"
            }

            Text{
                anchors.centerIn: weapon
                visible: weapon.enabled
                text:qsTr("Shoot !")
                font.pixelSize: globals.ui.textXL
                color: globals.ui.textcolor
            }
            MouseArea{
                anchors.fill: weapon
                enabled: weapon.enabled
                onClicked:{
                    gameManager.shoot(lstTarget.currentItem.currentData.IdPlayer);
                    globals.sounds.shoot.play();
                    globals.stuff.gunAmmonition--;
                }
            }
            Item{
                anchors.left: weapon.right
                height: weapon.height
                Row{
                    Repeater{
                        model:globals.stuff.gunAmmonition
                        Image{
                            source:"qrc:/res/bullet.png"
                        }
                    }
                }
            }
        }

    }

}

