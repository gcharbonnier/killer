import QtQuick 2.3
//import QtQuick.Controls 1.2

Item{
    anchors.fill: parent
    Component.onCompleted: campaignModel.resetModel();

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
            height: parent.height - 150

            visible: true
            opacity:0.8
            radius: height * globals.ui.backgroundRadiusPercHeight
            color: globals.ui.background

            ListModel{
                id:dummy
                ListElement{
                    idcampaign:1
                    name:"campaign 1"
                    type:0
                    nbTeam:2
                    nbPlayers:14
                }
                ListElement{
                    idcampaign:2
                    name:"campaign 2"
                    type:1
                    nbTeam:1
                    nbPlayers:209
                }
            }



            Column{
                id:content
                anchors.fill: parent
                anchors.margins:50

                function campaignTypeName( idType){
                    if (idType === 0)
                        return "HighLander";
                    else if (idType === 1)
                        return "Ring of Death";
                }


                ListView{
                    id: lstview
                    width : parent.width
                    height : parent.height
                    spacing : 20

                    property int nbCol: 9
                    property int nbRow: 7
                    property int colSpacing : 20
                    property int widthCol : ((width - 2* content.anchors.margins - ( nbCol-1)* colSpacing)  / nbCol)
                    property int rowHeight : ((height - 2* content.anchors.margins - ( nbCol-1)* spacing)  / nbRow)
                    model:campaignModel


                    header:
                        Row{

                        width: parent.width
                        height : lstview.rowHeight * 2
                        spacing: lstview.colSpacing
                            Rectangle{
                                color:"transparent"
                                height : parent.height
                                width: lstview.widthCol * 3
                                Text
                                {
                                    text:"Name (type)"
                                    anchors.fill: parent
                                    anchors.margins: globals.ui.buttonMargin
                                    color: globals.ui.textcolor
                                    font.pixelSize: globals.ui.textXXL
                                    minimumPixelSize: globals.ui.minimumPixelSize
                                    fontSizeMode : Text.Fit
                                    font.family: "Syncopate"
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment : Text.AlignVCenter
                                }

                            }
                            Rectangle{
                                color:"transparent"
                                height : parent.height
                                width: lstview.widthCol
                                Text
                                {
                                    text:"Teams"
                                    anchors.fill: parent
                                    anchors.margins: globals.ui.buttonMargin
                                    color: globals.ui.textcolor
                                    font.pixelSize: globals.ui.textXXL
                                    minimumPixelSize: globals.ui.minimumPixelSize
                                    fontSizeMode : Text.Fit
                                    font.family: "Syncopate"
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment : Text.AlignVCenter
                                }

                            }
                            Rectangle{
                                color:"transparent"
                                height : parent.height
                                width: lstview.widthCol
                                Text
                                {
                                    text:"Players"
                                    anchors.fill: parent
                                    anchors.margins: globals.ui.buttonMargin
                                    color: globals.ui.textcolor
                                    font.pixelSize: globals.ui.textXXL
                                    minimumPixelSize: globals.ui.minimumPixelSize
                                    fontSizeMode : Text.Fit
                                    font.family: "Syncopate"
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment : Text.AlignVCenter
                                }


                            }
                            Rectangle{
                                color:"transparent"
                                height : parent.height
                                width: lstview.widthCol
                                Text
                                {
                                    text:"Leave"
                                    anchors.fill: parent
                                    anchors.margins: globals.ui.buttonMargin
                                    color: globals.ui.textcolor
                                    font.pixelSize: globals.ui.textM
                                    minimumPixelSize: globals.ui.minimumPixelSize
                                    fontSizeMode : Text.Fit
                                    font.family: "Syncopate"
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment : Text.AlignVCenter
                                }

                            }
                            Rectangle{
                                color:"transparent"
                                height : parent.height
                                width: lstview.widthCol
                                Text
                                {
                                    text:"Edit"
                                    anchors.fill: parent
                                    anchors.margins: globals.ui.buttonMargin
                                    color: globals.ui.textcolor
                                    font.pixelSize: globals.ui.textM
                                    minimumPixelSize: globals.ui.minimumPixelSize
                                    fontSizeMode : Text.Fit
                                    font.family: "Syncopate"
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment : Text.AlignVCenter
                                }

                            }
                            Rectangle{
                                color:"transparent"
                                height : parent.height
                                width: lstview.widthCol
                                Text
                                {
                                    text:"Remove"
                                    anchors.fill: parent
                                    anchors.margins: globals.ui.buttonMargin
                                    color: globals.ui.textcolor
                                    font.pixelSize: globals.ui.textM
                                    minimumPixelSize: globals.ui.minimumPixelSize
                                    fontSizeMode : Text.Fit
                                    font.family: "Syncopate"
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment : Text.AlignVCenter
                                }

                            }
                            Rectangle{
                                color:"transparent"
                                height : parent.height
                                width: lstview.widthCol
                                Text
                                {
                                    text:"Join"
                                    anchors.fill: parent
                                    anchors.margins: globals.ui.buttonMargin
                                    color: globals.ui.textcolor
                                    font.pixelSize: globals.ui.textM
                                    minimumPixelSize: globals.ui.minimumPixelSize
                                    fontSizeMode : Text.Fit
                                    font.family: "Syncopate"
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment : Text.AlignVCenter
                                }

                            }
                        }



                    delegate:Row{
                        width: parent.width
                        height : lstview.rowHeight
                        spacing: lstview.colSpacing
                        Text{
                            anchors.verticalCenter: parent.verticalCenter
                            text: model.name + " ( " +  content.campaignTypeName( model.type ) + " )"
                            width: lstview.widthCol * 3
                        }

                        Text{
                            anchors.verticalCenter: parent.verticalCenter
                            text: model.nbTeam
                            width: lstview.widthCol
                            horizontalAlignment: Text.AlignHCenter
                        }
                        Text{
                            anchors.verticalCenter: parent.verticalCenter
                            text: model.nbPlayers
                            width: lstview.widthCol
                            horizontalAlignment: Text.AlignHCenter
                        }
                        SPSButtonText{
                            height : parent.height
                            width: lstview.widthCol
                            text: model.AmIConnected ? "Leave" : "Join";
                            color:globals.ui.buttonBkColor
                            onClicked: {
                                if (model.AmIConnected)
                                    campaignModel.leaveCampaign( model.idcampaign, accountModel.accountId );
                                else campaignModel.joinCampaign( model.idcampaign, accountModel.accountId );
                            }
                        }

                        SPSButtonText{
                            height : parent.height
                            width: lstview.widthCol
                            visible:model.isMyCampaign
                            color:globals.ui.buttonBkColor
                            text: "edit";
                            onClicked: {
                                //mainWnd.createCampaign
                                mainPanel.state="CreateCampaign";
                                loader.item.campaignId = model.idcampaign;
                            }
                        }

                        SPSButtonText{
                            height : parent.height
                            width: lstview.widthCol
                            visible:model.isMyCampaign
                            color:globals.ui.buttonBkColor
                            text: "remove";
                            onClicked: campaignModel.deleteCampaign(model.idcampaign)
                        }

                        SPSButtonText{
                            height : parent.height
                            width: lstview.widthCol
                            visible:model.AmIConnected
                            color:globals.ui.buttonBkColor
                            text: "Play !";
                            onClicked:
                            {
                                gameManager.startGame( model.idcampaign );
                                mainPanel.state="Play";
                            }
                        }


                    }

                }
            }

        }
        SPSButtonText{
            width: parent.width * 0.4
            height: Math.min(100,parent.height *0.1)
            anchors.left: parent.left
            anchors.bottom : parent.bottom
            text:"Cancel"
            onClicked:mainPanel.state=""
        }

        SPSButtonText{
            width: parent.width * 0.4
            height:Math.min(100,parent.height *0.1)
            anchors.right: parent.right
            anchors.bottom : parent.bottom
            text: "Refresh"
            onClicked: campaignModel.resetModel();

        }



    }
}
