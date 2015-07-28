import QtQuick 2.4
//import QtQuick.Controls 1.2

Item{
    anchors.fill: parent
    Component.onCompleted: campaignModel.resetModel();

    Item{
        id:container            //This item is used to center the content of the page and is scale animated

        anchors.centerIn: parent
        width: parent.width * 0.85
        height: parent.height * 0.95
        scale : 0
        Component.onCompleted: state = "Ready";
        states: State {
            name: "Ready"
            PropertyChanges { target:container; scale : 1}
        }
        transitions: Transition {
            PropertyAnimation { properties: "scale"; duration:1000;easing.type: Easing.InOutQuad }
        }

        property int rowHeight : Math.min(100,height *0.10)

        Rectangle {
            id:mainPage
            //anchors.fill: parent
            //anchors.bottomMargin: container.rowHeight * 2
            width: parent.width
            height: parent.height - 1.1* parent.rowHeight

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

            function campaignTypeName( idType){
                if (idType === 0)
                    return "HighLander";
                else if (idType === 1)
                    return "Ring of Death";
            }

            property int nbCol: 7
            property int nbRow: 6
            property int spacing: 5
            property int colSpacing : 5//container.rowHeight * 0.2
            property int widthCol : ((width  - ( nbCol-3)* colSpacing -10)  / nbCol)
            property int rowHeight : ((height  - ( nbRow-1)* spacing)  / nbRow)

            Row{
                id:header
                width: parent.width
                height : parent.rowHeight
                spacing: parent.colSpacing
                Rectangle{
                    color:"transparent"
                    height : parent.height
                    width: mainPage.widthCol * 3
                    Text
                    {
                        text:qsTr("Name (type)")
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
                    width: mainPage.widthCol
                    Text{
                        text:qsTr("Edit")
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
                    width: mainPage.widthCol
                    Text{
                        text:qsTr("Teams")
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
                    width: mainPage.widthCol
                    Text{
                        text:qsTr("Players")
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
                    width: mainPage.widthCol
                    Text{
                        text:""
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

            ListView{
                id: lstview
                clip:lstview
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: header.bottom
                anchors.bottom : parent.bottom
                anchors.margins: 5
                //width : parent.width
                //height : parent.height
                //spacing : container.rowHeight * 0.2


                //headerPositioning : ListView.PullBackHeader// ListView.OverlayHeader

                model:campaignModel



                delegate:Row{
                    width: parent.width
                    height : mainPage.rowHeight
                    spacing: mainPage.colSpacing
                    Text{
                        text: model.name + " ( " +  mainPage.campaignTypeName( model.type ) + " )"
                        width: mainPage.widthCol * 3
                        height: parent.height

                        font.pixelSize: globals.ui.textXXL
                        minimumPixelSize: globals.ui.minimumPixelSize
                        fontSizeMode : Text.Fit
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment : Text.AlignVCenter
                    }
                    SPSButtonText{
                        anchors.verticalCenter: parent.verticalCenter
                        height : parent.height * 0.6
                        width: mainPage.widthCol
                        opacity :(model.isMyCampaign || mainWnd.isDev) ? 1 : 0
                        color:globals.ui.buttonBkColor
                        text: qsTr("edit");
                        onClicked: {
                            if (opacity)
                            {
                                //mainWnd.createCampaign
                                mainPanel.state="CreateCampaign";
                                loader.item.campaignId = model.idcampaign;
                            }
                        }
                    }

                    Text{
                        text: model.nbTeam
                        width: mainPage.widthCol
                        height: parent.height
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment : Text.AlignVCenter

                        font.pixelSize: globals.ui.textM
                        minimumPixelSize: globals.ui.minimumPixelSize
                        fontSizeMode : Text.Fit


                    }
                    Text{
                        text: model.nbPlayers
                        width: mainPage.widthCol
                        height: parent.height
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment : Text.AlignVCenter

                        font.pixelSize: globals.ui.textM
                        minimumPixelSize: globals.ui.minimumPixelSize
                        fontSizeMode : Text.Fit
                    }
                    SPSButtonText{
                        anchors.verticalCenter: parent.verticalCenter
                        height : parent.height * 0.6
                        width: mainPage.widthCol
                        text: model.AmIConnected ? qsTr("Leave") : qsTr("Play");
                        color:model.AmIConnected ? globals.ui.buttonBkColor : "green"
                        onClicked: {
                            if (model.AmIConnected)
                                campaignModel.leaveCampaign( model.idcampaign, accountModel.accountId );
                            else{
                                //campaignModel.joinCampaign( model.idcampaign, accountModel.accountId );
                                pleaseWait.show();
                                mainPanel.state="Play";
                                gameManager.startGame( model.idcampaign );


                            }

                        }

                    }




                }

            }
        //}

        }
        SPSButtonText{
            width: parent.width * 0.4
            height: parent.rowHeight
            anchors.left: parent.left
            anchors.bottom : parent.bottom
            text:"Cancel"
            onClicked:mainPanel.state=""
        }

        SPSButtonText{
            width: parent.width * 0.4
            height:parent.rowHeight
            anchors.right: parent.right
            anchors.bottom : parent.bottom
            text: "Refresh"
            onClicked: campaignModel.resetModel();

        }



    }
}
