import QtQuick 2.3
//import QtQuick.Controls 1.2

Item{
    anchors.fill: parent
    property int campaignId : 0

    onCampaignIdChanged: {
        if (campaignId !=0){
            //reload campaign data
            var campaignData = campaignModel.get( campaignId);
            campaignType.currentSelection = campaignData.type;
            campaignName.name = campaignData.name;
            numTeam.nbTeam = campaignData.nbTeam;
        }
        else
        {

            //Default new campaign values
            campaignType.currentSelection = 0;
            campaignName.name = "Campaign name";
            numTeam.nbTeam = 2;
        }
    }

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

        property int rowHeight : Math.min(100,height *0.10)

        Rectangle {
            id:mainPage
            width: parent.width
            height: parent.height - container.rowHeight * 2

            visible: true
            opacity:0.8
            radius: height * globals.ui.backgroundRadiusPercHeight
            color: globals.ui.background


            ListModel{
                id:campaignTypeModel
                ListElement{
                    idChoice:1
                    label:"Highlander"
                }
                ListElement{
                    idChoice:2
                    label:"Ring of death"
                }
            }

            Column
            {
                id:content
                anchors.fill : parent
                anchors.margins: container.rowHeight * 0.5
                property int rowHeight : Math.floor( Math.min(100, (height - 6 * spacing) /7))
                spacing: 5


                Row{
                    id: campaignName
                    spacing:5
                    width: parent.width
                    height:2 * parent.rowHeight
                    property string name: qsTr("campaign name")
                    Text{
                        text:"Campaign name :"
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: globals.ui.textXL
                        color: globals.ui.textcolor
                        minimumPixelSize: globals.ui.minimumPixelSize
                        fontSizeMode : Text.Fit
                        width: parent.width * 0.5
                        height:parent.height
                    }

                    SPSTextField{
                        text: parent.name
                        height:content.rowHeight
                        width: parent.width * 0.4
                        onTextChanged: campaignName.name = text;

                    }

                }


                Row{
                    id:campaignType
                    spacing:5
                    width: parent.width
                    height: 2 * parent.rowHeight
                    property alias currentSelection: spinCampaignType.currentSelection

                    Text{
                        text:qsTr("Campaign type :")
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: globals.ui.textXL
                        color: globals.ui.textcolor
                        minimumPixelSize: globals.ui.minimumPixelSize
                        fontSizeMode : Text.Fit
                        width: parent.width * 0.5
                        height:parent.height
                    }

                    SPSSpinButton{
                        id:spinCampaignType
                        model:campaignTypeModel
                        width: parent.width * 0.4
                        height:content.rowHeight
                    }

                }

                Row{
                    id: areaCenter
                    property double latitude: 12.5
                    property double longitude: 8.4
                    spacing:5
                    width: parent.width
                    height:parent.rowHeight
                    Text{
                        text:qsTr("Area center :")
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: globals.ui.textXL
                        color: globals.ui.textcolor
                        minimumPixelSize: globals.ui.minimumPixelSize
                        fontSizeMode : Text.Fit
                        width: parent.width * 0.5
                        height:parent.height
                    }

                    SPSTextField{
                        text: parent.latitude
                        height:parent.height
                        width: parent.width * 0.2
                        onEditingFinished: areaCenter.latitude = parseFloat(text)
                        validator: DoubleValidator{bottom: -90; top: 90; decimals:8}
                    }
                    SPSTextField{
                        text: parent.longitude
                        height:parent.height
                        width: parent.width * 0.2
                        validator: DoubleValidator{bottom: -180; top: 180; decimals:8}
                        onEditingFinished: areaCenter.longitude = parseFloat(text)
                    }
                }
                Row{
                    id: areaRadius
                    property int radius: 500
                    spacing:5
                    width: parent.width
                    height:parent.rowHeight
                    Text{
                        text:qsTr("Area radius :")
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: globals.ui.textXL
                        color: globals.ui.textcolor
                        minimumPixelSize: globals.ui.minimumPixelSize
                        fontSizeMode : Text.Fit
                        width: parent.width * 0.5
                        height:parent.height
                    }

                    SPSTextField{
                        text: parent.radius
                        height:parent.height
                        width: parent.width * 0.4
                        validator: IntValidator{bottom: 0; top: 50000;}
                        onEditingFinished: areaRadius.radius = parseInt(text)
                    }

                }


                Row{
                    id: numTeam
                    property int nbTeam: 2
                    spacing:5
                    width: parent.width
                    height:parent.rowHeight
                    Text{
                        text:qsTr("Number of team :")
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: globals.ui.textXL
                        color: globals.ui.textcolor
                        minimumPixelSize: globals.ui.minimumPixelSize
                        fontSizeMode : Text.Fit
                        width: parent.width * 0.5
                        height:parent.height
                    }

                    SPSTextField{
                        text: parent.nbTeam
                        height:parent.height
                        width: parent.width * 0.4
                        validator: IntValidator{bottom: 0; top: 10;}
                        onEditingFinished: {
                            numTeam.nbTeam = parseInt(text);
                        }

                    }

                }
            }
        }

        SPSButtonText{
            width: parent.width * 0.3
            height: container.rowHeight
            anchors.left: parent.left
            anchors.bottom : parent.bottom
            text:qsTr("Cancel")
            onClicked:mainPanel.state=""
        }

        SPSButtonText{
            width: parent.width * 0.3
            height:container.rowHeight
            anchors.right: removeButton.left
            anchors.bottom : parent.bottom
            anchors.rightMargin: parent.width *0.05
            color:enabled ? globals.ui.buttonBkColor : "grey"
            text: campaignId === 0 ? qsTr("Create") : qsTr("Modify")
            onClicked: {
                if ( gameManager.createCampaign( campaignType.currentSelection, campaignName.name, numTeam.nbTeam, campaignId ))
                {
                    mainPanel.state= "JoinCampaign";
                    //campaignId = 0;
                }
                else
                    showError();
            }

        }
        SPSButtonText{
            id:removeButton
            width: parent.width * 0.3
            height:container.rowHeight
            anchors.right: parent.right
            anchors.bottom : parent.bottom
            color:"red"
            text: qsTr("Remove")
            visible: campaignId != 0
            onClicked: {
                campaignModel.deleteCampaign(campaignId);
                mainPanel.state=""
            }

        }



    }
}
