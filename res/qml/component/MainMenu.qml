import QtQuick 2.0

Item{

    id:root
    anchors.fill: parent

    height: mainWnd.height
    width : mainWnd.width

    property int menuEntryWidth : Math.floor(mainWnd.width / 1.5)
    property int menuEntryHeight : Math.floor(mainWnd.height / 8)
    property int menuEntrySpacing : 50

    Component.onCompleted: {
        root.state = "ready";
    }

    Text{
        text:"Dev Panel"
        anchors.right : parent.right
        anchors.top : parent.top
        visible: mainWnd.isDev
        MouseArea{
            anchors.fill: parent
            onClicked: loader.source = "DevPanel.qml"
        }
    }

    SPSButtonText{
        id:menuCreateCampaign
        width : menuEntryWidth
        height: menuEntryHeight
        visible: accountModel.isLogged
        x:(parent.width - menuEntryWidth) / 2
        y: (1.14 * menuEntryHeight) * 2
        opacity:0
        text: qsTr("Create campaign")
        onClicked: mainPanel.state="CreateCampaign"
    }

    SPSButtonText{
        id:menuJoinCampaign
        text:qsTr("join campaign")
        visible: accountModel.isLogged
        x:menuCreateCampaign.x
        y: (1.14 * menuEntryHeight) * 3
        opacity:0
        width : menuEntryWidth
        height: menuEntryHeight
        onClicked: mainPanel.state="JoinCampaign"
    }

    SPSButtonText{
        id:menuRegister
        text:qsTr("Register")
        width : menuEntryWidth
        height: menuEntryHeight
        visible: !accountModel.isLogged
        opacity:0
        x:menuCreateCampaign.x
        y: (1.14 * menuEntryHeight) * 1
        onClicked: {
            mainPanel.state="RegisterPage"
            loader.item.register = true;
        }

    }

    /*
    ShaderEffectSource {
        id: theSource
        sourceItem: menuLogin
        hideSource: true

        ShaderEffect {
            width: menuEntryWidth
            height: menuEntryHeight
            x:menuLogin.x
            y:menuLogin.y
            opacity:menuLogin.opacity
            property variant source: theSource
            property real amplitude: 0.004
            property real frequency: 10
            property real time: 0
            NumberAnimation on time { loops: Animation.Infinite; from: 0; to: Math.PI * 2; duration: 600 }
            //! [fragment]
            fragmentShader:
                "uniform lowp float qt_Opacity;" +
                "uniform highp float amplitude;" +
                "uniform highp float frequency;" +
                "uniform highp float time;" +
                "uniform sampler2D source;" +
                "varying highp vec2 qt_TexCoord0;" +
                "void main() {" +
                "    highp vec2 p = sin(time + frequency * qt_TexCoord0);" +
                "    gl_FragColor = texture2D(source, qt_TexCoord0 + amplitude * vec2(p.y, -p.x)) * qt_Opacity;" +
                "}"
            //! [fragment]


        }

    }*/



    SPSButtonText{
        id:menuLogin
        text: accountModel.isLogged ? qsTr("Logout") : qsTr("Login")
        width : menuEntryWidth
        height: menuEntryHeight
        x:menuCreateCampaign.x
        y:(1.14 * menuEntryHeight) * 5
        //visible:false
        opacity:0
        onClicked: {
            if (accountModel.isLogged)
            {
                accountModel.logOut();
                mainPanel.state="";
            }
            else{
                mainPanel.state="RegisterPage"
                loader.item.register = false;
            }
        }

    }

    Rectangle{
        id:menuQuit
        color:"white"
        border.color:"black"
        border.width: 1
        radius : 10
        width: height
        height:Math.min(150,root.height*0.15)
        opacity:0
        x :  parent.width - width
        y :  parent.height - height

        Image{
            source:"qrc:/res/exit.png"
            anchors.fill: parent
            anchors.margins: Math.min(20,menuQuit.height*0.15)
        }

        MouseArea{
            anchors.fill: parent
            onClicked: Qt.quit();
        }

    }

    states: [


            State {
                name: "ready"
                PropertyChanges { target:menuCreateCampaign;  opacity :1 }
                PropertyChanges { target:menuJoinCampaign;  opacity :1 }
                PropertyChanges { target:menuRegister; opacity :1 }
                PropertyChanges { target:menuLogin; opacity :1 }
                PropertyChanges { target:menuQuit; opacity :0.7 }
            }

        ]

    transitions: Transition {
                PropertyAnimation { properties: "opacity"; duration:2000;easing.type: Easing.InOutQuad }


        }
}


