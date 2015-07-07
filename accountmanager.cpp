#include "accountmanager.h"
#include <QSqlQuery>
#include <QVariant>
#include <QFile>
#include <QTextStream>
#include <QStandardPaths>
#include <QDir>

AccountManager::AccountManager(GameData& gameData, QObject *parent) : QObject(parent), m_gameData(gameData)
{
    QString filePath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/login.txt";
    QFile file( filePath );

    if (file.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        QTextStream in(&file);
        m_accountName = in.readLine();
        m_sPassword = in.readLine();

    }

    logIn();
}

AccountManager::~AccountManager()
{
    logOut();
}

uint AccountManager::accountId(QString alias)
{

    uint id = 0;
    QString req = QString("SELECT ID from  `simplisim_dejavu`.`geo_accounts` where LOGIN='%1'").arg(alias);
    QSqlQuery query;
    if ( (query.exec(  req )) && query.next())
        id = query.value(0).toUInt();

    return id;
}
bool AccountManager::accountExists(QString alias)
{
    return AccountManager::accountId(alias);
}

uint AccountManager::createAccount( QString alias, QString password)
{
    uint id = 0;
    QString req = QString("INSERT INTO  `simplisim_dejavu`.`geo_accounts` \
            (`ID` ,`LOGIN` ,`PASSWORD` ,`CONNECTED` ) VALUES \
            ( NULL ,  '%1',  '%2',  '1')").arg(alias).arg(password);
    QSqlQuery query;
    if (query.exec(  req ))
    {
        id = accountId( alias );
    }
    return id;
}

uint AccountManager::logIn()
{
    return logIn( m_accountName, m_sPassword);
}

uint AccountManager::logIn(QString alias, QString password)
{
    if ( m_accountId )
        logOut();

    m_accountId = checkPassword(alias, password );
    if ( m_accountId )
    {
        //update connection status
        QString req = QString("UPDATE  `simplisim_dejavu`.`geo_accounts` SET  `CONNECTED` =  '1' WHERE  `geo_accounts`.`ID` = %1;")
                .arg(m_accountId);
        QSqlQuery query;
        query.exec(  req );

        //Save alias and password in local file if login successfull
        QString dirPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) ;
        QDir dir ( dirPath );
        if (!dir.exists())
            dir.mkpath(dirPath);

        QFile file( dirPath + "/login.txt" );
        m_accountName = alias;
        m_sPassword = password;
        if ( file.open(QIODevice::WriteOnly | QIODevice::Text) )
        {
            //write to file
            QTextStream out(&file);
            out << alias << "\n";
            out << password << "\n";
        }

        m_gameData.setAccountData( m_accountId, m_accountName );


        emit loggedChanged();
    }
    return m_accountId;

}

uint AccountManager::checkPassword(QString alias, QString password)
{
    uint id = 0;
    QString req = QString("SELECT ID from  `simplisim_dejavu`.`geo_accounts` where LOGIN='%1' and PASSWORD='%2'")
            .arg(alias).arg(password);
    QSqlQuery query;
    if ( (query.exec(  req )) && query.next())
        id = query.value(0).toUInt();
    return id;
}

void AccountManager::logOut()
{
    if ( !m_accountId) return;


    QString req = QString("UPDATE  `simplisim_dejavu`.`geo_accounts` SET  `CONNECTED` =  '0' WHERE  `geo_accounts`.`ID` = %1;")
            .arg(m_accountId);
    QSqlQuery query;
    if (query.exec(  req ))
    {
        m_accountId = 0;
        m_gameData.setAccountData( m_accountId, "" );
        emit loggedChanged();
    }
}

