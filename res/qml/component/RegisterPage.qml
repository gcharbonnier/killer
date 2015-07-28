import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.3

Item{
    property bool register:true
    property bool accountExists:accountModel.accountExists(aliasTxt.text)
    anchors.fill: parent

    Item{
        id:container            //This item is used to center the content of the page and is scale animated

        anchors.centerIn: parent
        width: Math.min( parent.width * 0.7, 800)
        height: Math.min( parent.height * 0.8, 600)
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
            id:mainPage         //This is a corner rounded rectangle
            width: parent.width
            height: parent.height - parent.rowHeight * 2

            visible: true
            opacity:0.8
            radius: height * globals.ui.backgroundRadiusPercHeight
            color: globals.ui.background



            function showError(){
                createAccountError.opacity = 1;
                timerShowError.start();
            }

            Timer{
                id:timerShowError
                interval:5000
                triggeredOnStart: false
                onTriggered: {
                    createAccountError.opacity = 0;
                }

            }

            Column{
                id:content
                anchors.fill : parent
                anchors.margins: container.rowHeight * 0.5
                property int rowHeight : Math.floor( Math.min(100,height /7))
                spacing: 5
                Text{
                    id:createAccountError
                    text: register ? qsTr("Register error") : qsTr("Login error, check password")
                    color:"red"
                    width: parent.width
                    height: parent.rowHeight
                    font.pixelSize: globals.ui.textM
                    minimumPixelSize: globals.ui.minimumPixelSize
                    fontSizeMode : Text.Fit
                    opacity:0

                    Behavior on opacity{
                        NumberAnimation{  duration: 2000}
                    }
                }

                Row{
                    spacing:container.rowHeight * 0.5
                    width: parent.width
                    height:parent.rowHeight
                    Text{
                        text:qsTr("Login")
                        font.pixelSize: globals.ui.textXL
                        minimumPixelSize: globals.ui.minimumPixelSize
                        fontSizeMode : Text.Fit
                        color: globals.ui.textcolor
                        width: parent.width * 0.6
                        height:parent.height
                    }
                    Text{
                        id:accountExist
                        text:register ? qsTr("This alias already exists, choose another one !") : qsTr("This account does not exist !")
                        anchors.verticalCenter: parent.verticalCenter
                        color:"red"
                        font.pixelSize: globals.ui.textS
                        minimumPixelSize: globals.ui.minimumPixelSize
                        fontSizeMode : Text.Fit
                        visible: !registerButton.enabled
                        height:parent.height
                        width: parent.width * 0.3
                    }
                }


                Row{
                    width: parent.width
                    height:parent.rowHeight

                    Rectangle{
                        //margin
                        width: container.rowHeight * 0.5
                        height: parent.height
                        opacity:0
                    }
                    SPSTextField{
                        id: aliasTxt
                        //placeholderText: "Alias / Login"
                        text: accountModel.accountName

                        //font.pixelSize: globals.ui.textM
                        height:parent.height
                        width: parent.width * 0.7

                    }
                }

                Rectangle{
                    //Separator
                    height:parent.rowHeight
                    width: parent.width
                    opacity:0
                }



                Row{
                    spacing:container.rowHeight * 1.5
                    width: parent.width
                    height:parent.rowHeight

                    Text{
                        text:"Password"
                        font.pixelSize: globals.ui.textXL
                        minimumPixelSize: globals.ui.minimumPixelSize
                        fontSizeMode : Text.Fit
                        color: globals.ui.textcolor
                        width: parent.width * 0.6
                        height:parent.height

                    }
                    Text{
                        text: password.echoMode == TextInput.Normal ? qsTr("hide"):qsTr("show")
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: globals.ui.textM
                        minimumPixelSize: globals.ui.minimumPixelSize
                        fontSizeMode : Text.Fit
                        color: globals.ui.textcolor
                        MouseArea{
                            hoverEnabled: true
                            anchors.fill:parent
                            onClicked: {
                                if (password.echoMode == TextInput.Normal)
                                    password.echoMode = TextInput.Password
                                else password.echoMode = TextInput.Normal
                            }
                        }
                        height:parent.height
                        width: parent.width * 0.3
                    }
                }


                Row{
                    width: parent.width
                    height:parent.rowHeight

                    Rectangle{
                        //margin
                        width: container.rowHeight * 0.5
                        height: parent.height
                        opacity:0
                    }

                    SPSTextField{
                        id:password
                        //placeholderText: "enter your password"
                        text:accountModel.password


                        //persistentSelection: true
                        echoMode: TextInput.Password
                        //passwordCharacter: "€"
                        //style: globals.ui.textFieldStyle
                        height:parent.height
                        width: parent.width * 0.7
                    }
                }




            }


        }

        SPSButtonText{
            width: parent.width * 0.4
            height: parent.rowHeight
            anchors.left: parent.left
            anchors.bottom : parent.bottom
            text:qsTr("Cancel")
            onClicked:mainPanel.state=""
        }

        SPSButtonText{
            id:registerButton
            width: parent.width * 0.4
            height: parent.rowHeight
            anchors.right: parent.right
            anchors.bottom : parent.bottom
            enabled: register ? !accountExists : accountExists
            color:enabled ? globals.ui.buttonBkColor : "grey"
            text: register ? qsTr("Register"):qsTr("Login")
            onClicked: {
                if (register)
                {
                    if ( accountModel.createAccount( aliasTxt.text, password.text))
                    {
                        accountModel.logIn( aliasTxt.text, password.text );
                        mainPanel.state="";
                    }
                    else
                        showError();
                } else
                //Login
                {
                    if ( accountModel.logIn( aliasTxt.text, password.text ))
                        mainPanel.state="";
                    else
                        mainPage.showError();
                }
            }

        }
    }



}
