import QtQuick 2.0

Item{

    id:root
    anchors.fill: parent

    height: mainWnd.height
    width : mainWnd.width

    property int menuEntryWidth : Math.floor(mainWnd.width / 1.5)
    property int menuEntryHeight : Math.floor(mainWnd.height / 8)
    property int menuEntrySpacing : 50

    function randomGeometry( obj)
    {
        obj.x = Math.floor(Math.random() * 800);//Math.floor((Math.random() * width) + 1);
        obj.y = Math.floor(Math.random() * 800);//Math.floor((Math.random() * height) + 1);
        obj.rotation = Math.floor((Math.random() * 90) + 1);
        //obj.opacity = 0;
    }

    Component.onCompleted: {


        randomGeometry(menuCreateCampaign);
        randomGeometry(menuJoinCampaign);
        randomGeometry(menuRegister);
        randomGeometry(menuLogin);
        randomGeometry(menuQuit);

        root.state = "ready";
    }

    SPSButtonText{
        id:menuCreateCampaign
        width : menuEntryWidth
        height: menuEntryHeight
        visible: accountModel.isLogged
        text: "Create campaign"
        onClicked: mainPanel.state="CreateCampaign"
    }

    SPSButtonText{
        id:menuJoinCampaign
        text:"join campaign"
        visible: accountModel.isLogged
        width : menuEntryWidth
        height: menuEntryHeight
        onClicked: mainPanel.state="JoinCampaign"
    }

    SPSButtonText{
        id:menuRegister
        text:"Register"
        width : menuEntryWidth
        height: menuEntryHeight
        visible: !accountModel.isLogged
        onClicked: {
            mainPanel.state="RegisterPage"
            loader.item.register = true;
        }



    }
    SPSButtonText{
        id:menuLogin
        text: accountModel.isLogged ? "Logout" : "Login"
        width : menuEntryWidth
        height: menuEntryHeight
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
        border.width: 5
        radius : 10
        width:150
        height:150
        opacity:0.7

        Image{
            source:"qrc:/res/exit.png"
            anchors.fill: parent
            anchors.margins: 20
            opacity: 1
        }

        MouseArea{
            anchors.fill: parent
            onClicked: Qt.quit();
        }

    }


    Text{
        id:reloadAnim

        text:"Test"
        color:"black"
        font.pixelSize: 150
        anchors.left: parent.left
        anchors.bottom: parent.bottom


        MouseArea{
            anchors.fill: parent
            onClicked: {
                if (root.state == "")
                    root.state = "ready";
                else root.state = "";
            }
        }

    }


    states: [


            State {
                name: "ready"
                PropertyChanges { target:menuCreateCampaign;  rotation :0 ; x:(parent.width - menuEntryWidth) / 2 ; y: (1.14 * menuEntryHeight) * 2}
                PropertyChanges { target:menuJoinCampaign;  rotation :0 ; x:menuCreateCampaign.x ; y: (1.14 * menuEntryHeight) * 3}
                PropertyChanges { target:menuRegister; rotation :0 ; x:menuCreateCampaign.x ; y: (1.14 * menuEntryHeight) * 1}
                PropertyChanges { target:menuLogin; rotation :0 ; x:menuCreateCampaign.x ; y:(1.14 * menuEntryHeight) * 5}
                PropertyChanges { target:menuQuit; rotation :0; x :  parent.width - width; y :  parent.height - height}
            }

        ]

    transitions: Transition {
                PropertyAnimation { properties: "x, y, rotation"; duration:2000;easing.type: Easing.InOutQuad }


        }
}


