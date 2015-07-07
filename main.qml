import QtQuick 2.4
import QtQuick.Window 2.2
import QtQuick.Controls 1.2
import "res/qml/component"


Window {
    property bool isDev : accountModel.accountName == "charby-dev"
    id:mainWnd
    height:isDev ? 1080 : Screen.desktopAvailableHeight
    width:isDev ? 1920 : Screen.desktopAvailableWidth
    visible: true
    //color:globals.ui.background
    visibility: isDev ? Window.Windowed : Window.FullScreen
    



    Image {
        //opacity:0.8
        anchors.fill: parent
        source: "qrc:/res/background.png"
    }
    Image {
        id:character
        x:0
        scale:1
        anchors.bottom: parent.bottom
        source: "qrc:/res/background_character.png"
        height: parent.height*0.9
        width: height / 2.23
        //fillMode: Image.PreserveAspectFit

        Component.onCompleted: animation.running = true;
        PropertyAnimation { id: animation; target: character; property: "x"; from: 0; to: (mainWnd.width - character.paintedWidth) *0.5; duration: 1500; easing.type: Easing.OutBounce;  }

    }
    Loader{
        id:loader
        anchors.fill: parent
        source: "res/qml/component/MainMenu.qml"

    }

    Globals{
        id:globals
    }


    Item{
        id:mainPanel
        property bool init:true

        states: [
                State {
                    name: "CreateCampaign"
                    PropertyChanges { target:loader; source :"res/qml/component/CreateCampaign.qml"}
                    PropertyChanges { target:character; x : 50}
                },
                State {

                    name: "JoinCampaign"
                    PropertyChanges { target:loader; source :"res/qml/component/JoinCampaign.qml"}
                    PropertyChanges { target:character; x : 150}
                },
                State {
                    name: "RegisterPage"
                    PropertyChanges { target:loader; source :"res/qml/component/RegisterPage.qml"}
                    PropertyChanges { target:character; x : 50 ; scale:1.3 ; y : character.height * 0.5 + 150}

                },
                State {
                    name: "Play"
                    PropertyChanges { target:loader; source :"res/qml/component/GamePage.qml"}

                }
            ]

        transitions: Transition {
                    PropertyAnimation { properties: "x, scale, y"; duration:1000;easing.type: Easing.InOutQuad }
            }
    }
}
