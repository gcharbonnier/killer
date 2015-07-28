#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSqlDatabase>
#include <QQmlContext>
#include <QTranslator>
#include <QLibraryInfo>
#include <QDebug>
#include "gamemanager.h"
#include "gameenum.hpp"
#include <QtQml>
#include "networkprobe.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);


    //Load translation file
    QTranslator translator;
    translator.load(QLocale::system(), ":/killer","_",QCoreApplication::applicationDirPath(),".qm");
    app.installTranslator(&translator);


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
    const QVariant& vAppVersion = app.applicationVersion();
    engine.rootContext()->setContextProperty("appVersion", vAppVersion);

    qmlRegisterUncreatableType<GameEnums>("MyEnums", 1, 0, "Enums", "Enums is not a type, just a wrapper for enums used in the program");
    engine.rootContext()->setContextProperty("gameManager", &theGame);
    engine.rootContext()->setContextProperty("playerModel", &theGame.playerModel()); //TODO : it should be possible to use the model as the property of the gps logger
    engine.rootContext()->setContextProperty("campaignModel", &theGame.campaignModel());
    engine.rootContext()->setContextProperty("accountModel", &theGame.accountModel());
    engine.rootContext()->setContextProperty("messageModel", &theGame.messageModel());
    engine.rootContext()->setContextProperty("geoLocalItemsModel", &theGame.geoLocalItemsModel());

    NetworkProbe netprob(&db);
    engine.rootContext()->setContextProperty("networkProbe", &netprob);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    int exitCode =  app.exec();

    //db.close();

    return exitCode;
}
