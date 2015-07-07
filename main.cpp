#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSqlDatabase>
#include <QQmlContext>
#include <QDebug>
#include "gamemanager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);


    //Open database
    QSqlDatabase db = QSqlDatabase::addDatabase("QMYSQL");
    db.setHostName("mysql-simplisim.alwaysdata.net");
    db.setDatabaseName("simplisim_dejavu");
    db.setUserName("simplisim");
    db.setPassword("zardoz44");
    if ( !db.open())
    {
        qDebug() << "Error opening database connection";
        //return 1;
    }

    QQmlApplicationEngine engine;


    GameManager theGame;
    engine.rootContext()->setContextProperty("gameManager", &theGame);
    engine.rootContext()->setContextProperty("playerModel", &theGame.playerModel()); //TODO : it should be possible to use the model as the property of the gps logger
    engine.rootContext()->setContextProperty("campaignModel", &theGame.campaignModel());
    engine.rootContext()->setContextProperty("accountModel", &theGame.accountModel());

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
