import QtQuick 2.4

import "../../../GameLogic.js" as EquipmentAction

Item{
    anchors.fill: parent

    Item{
        id:container            //This item is used to center the content of the page and is scale animated

        anchors.centerIn: parent
        width: parent.width * 0.7
        height: parent.height * 0.9
        scale : 0
        Component.onCompleted: state = "Ready";
        states: State {
            name: "Ready"
            PropertyChanges { target:container; scale : 1}
        }
        transitions: Transition {
            PropertyAnimation { properties: "scale"; duration:1000;easing.type: Easing.InOutQuad }
        }




        Rectangle {
            id:mainPage
            width: parent.width
            height: parent.height - 110

            visible: true
            opacity:0.8
            radius: height * globals.ui.backgroundRadiusPercHeight
            color: globals.ui.background



            /*
            SPSButtonText{
                width: parent.width * 0.4
                height: Math.min(100,parent.height *0.1)
                anchors.left: parent.left
                anchors.bottom : parent.top
                text:"XP-"
                onClicked:{
                    EquipmentAction.modifyXP(-100);
                }
            }

            SPSButtonText{
                width: parent.width * 0.4
                height: Math.min(100,parent.height *0.1)
                anchors.right: parent.right
                anchors.bottom : parent.top
                text:"XP+"
                onClicked:{
                    EquipmentAction.modifyXP(100);
                }
            }
            */
            ListView{
                id: lstview
                clip:lstview
                anchors.fill: parent
                anchors.margins: 2
                model: geoLocalItemsModel//playerModel //accountModel

                //onCountChanged:positionViewAtEnd()
                Component.onCompleted: positionViewAtEnd()


                delegate:Row{
                    width: parent.width
                    height : 50
                    spacing: 5

                    //Component.onCompleted: lstview.positionViewAtEnd()
                    /*Text{
                        //date time
                        text: model.DateTime
                        color:"white"
                        width: parent.width * 0.15
                        height: parent.height
                        font.pixelSize: globals.ui.textXXL
                        minimumPixelSize: globals.ui.minimumPixelSize
                        fontSizeMode : Text.Fit
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment : Text.AlignVCenter
                    }
                    Text{
                        text: model.Type === 0 ? model.MessageContent : model.NameEmitter +" : " + "@" + model.NameRecipient +" "+model.MessageContent
                        color : model.Type === 0 ? "white" : "blue"
                        width: parent.width * 0.8
                        height: parent.height
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment : Text.AlignVCenter

                        font.pixelSize: globals.ui.textM
                        minimumPixelSize: globals.ui.minimumPixelSize
                        fontSizeMode : Text.Fit
                    }*/
                    /*Text{
                        text: model.NamePlayer + " - Lat:" + model.Latitude + " long:"+model.Longitude+ " Hdg:"+model.Azimuth
                        color : "white"
                        width: parent.width * 0.8
                        height: parent.height
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment : Text.AlignVCenter

                        font.pixelSize: globals.ui.textM
                        minimumPixelSize: globals.ui.minimumPixelSize
                        fontSizeMode : Text.Fit
                    }*/
                    Text{
                        text: model.Type + " - Lat:" + model.Latitude + " long:"+model.Longitude+ " Hdg:"+model.Azimuth
                        color : "white"
                        width: parent.width * 0.8
                        height: parent.height
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment : Text.AlignVCenter

                        font.pixelSize: globals.ui.textM
                        minimumPixelSize: globals.ui.minimumPixelSize
                        fontSizeMode : Text.Fit
                    }



                }

            }


        }
        SPSButtonText{
            width: parent.width * 0.4
            height: Math.min(100,parent.height *0.1)
            anchors.left: parent.left
            anchors.bottom : parent.bottom
            text:"Return"
            onClicked:{

                //mainWnd.mainPanel.state=""
                loader.source = "MainMenu.qml"
            }
        }


    }
}



