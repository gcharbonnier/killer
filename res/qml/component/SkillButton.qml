import QtQuick 2.0
import "../../../GameLogic.js" as EquipmentAction

Rectangle{
    id:content
    radius: Math.min( 20, height * globals.ui.buttonRadiusPercHeight)
    color:globals.ui.buttonBkColor
    property alias currentSelection:lstView.currentIndex




    EventBox{
        id:skillEvent
        anchors.fill:parent
        anchors.margins: parent.height *0.1
        z:50
    }

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
                    content.enabled = !running;
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


    ListView{
    id:lstView
    anchors.fill: parent
    anchors.margins: 5
    model:globals.skillModel
    clip:content
    snapMode: ListView.SnapOneItem
    highlightRangeMode: ListView.StrictlyEnforceRange
    orientation: ListView.Horizontal
    delegate: Item{
                    width:content.width
                    height: content.height
                    enabled:model.available
                    Image{
                        anchors.fill: parent
                        //visible:index === lstView.currentIndex;
                        source:model.image

                        Text{

                            height:parent.height
                            width: parent.width
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment : Text.AlignVCenter
                            text: qsTr(model.label)
                            font.pixelSize: globals.ui.textXL
                            color: "white"
                            minimumPixelSize: globals.ui.minimumPixelSize
                            fontSizeMode : Text.Fit
                        }
                    }
                    Text{

                        height:parent.height * 0.2
                        width: parent.width
                        anchors.margins: Math.min( 5, parent.height * 0.1)
                        anchors.top: parent.top
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment : Text.AlignVCenter
                        text: qsTr("Cost \n( time:%1 sec - energy:%2 )").arg(model.duration).arg(model.energyCost)
                        font.pixelSize: globals.ui.textM
                        color: "white"
                        minimumPixelSize: globals.ui.minimumPixelSize
                        fontSizeMode : Text.Fit
                    }

                    SPSProgressBar{
                        width: parent.width * 0.8
                        height: parent.height * 0.15
                        anchors.margins: Math.min( 10, parent.height * 0.5)
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        value: model.percChanceToSuccess
                        prefixText : qsTr("chance :")
                        color : "darkgrey"
                        foregroundColor : "green"
                    }
                    Text{

                        height:parent.height
                        width: parent.width
                        visible : !model.available
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment : Text.AlignVCenter
                        text: qsTr("Not available")
                        rotation : 45
                        font.pixelSize: globals.ui.textXL
                        color: "red"
                        minimumPixelSize: globals.ui.minimumPixelSize
                        fontSizeMode : Text.Fit
                    }

                    MouseArea{
                        anchors.fill:parent
                        enabled : globals.perso.energy > model.energyCost
                        onClicked:{
                            EquipmentAction.modifyEnergy(-model.energyCost);
                            //cooling time
                            remainingTime.reloadtime = model.duration;
                            timer.restart();

                            //Test if action succeed
                            var rand = Math.random() *100;
                            if ( rand <= model.percChanceToSuccess)
                            {
                                skillEvent.showMessage(qsTr("Successful skill!"),10);


                            }
                            else{
                                skillEvent.showMessage(qsTr("Too bad...You missed !"),11);
                                return;
                            }

                            EquipmentAction.useSkill(index);




                        }
                    }
                }
    }



}

