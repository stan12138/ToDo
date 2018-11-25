#include "datamaster.h"

DataMaster::DataMaster(QObject *parent) : QObject(parent)
{

}

bool DataMaster::database_init()
{
    db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("./data.db");
    db.open();

    query = QSqlQuery(db);

    query.prepare("create table if not exists PlanData (id int primary key, content text, type int, year int, month int, day int, hour int, minute int)");
    query.exec();
    query.prepare("create table if not exists IdData (id int primary key, next int)");
    query.exec();
    query.prepare("insert into IdData values(:id, :next)");
    query.bindValue(":id", 0);
    query.bindValue(":next", 0);
    return query.exec();

}

bool DataMaster::insert(QVariantList item)
{
    int id = item[0].toInt();
    QString content = item[1].toString();
    int type = item[2].toInt();
    int year = item[3].toInt();
    int month = item[4].toInt();
    int day = item[5].toInt();
    int hour= item[6].toInt();
    int minute = item[7].toInt();

    query.prepare("insert into PlanData values (:id, :content, :type, :year, :month, :day, :hour, :minute)");
    query.bindValue(":id", id);
    query.bindValue(":content", content);
    query.bindValue(":type", type);
    query.bindValue(":year", year);
    query.bindValue(":month", month);
    query.bindValue(":day", day);
    query.bindValue(":hour", hour);
    query.bindValue(":minute", minute);

    bool res = query.exec();

    update_id(id+1);

    return res;

}

QVariantList DataMaster::get_data()
{
    QVariantList res;
    query.exec("select * from PlanData");
    while (query.next()) {
        res.append(query.value(0).toInt());
        res.append(query.value(1).toString());
        res.append(query.value(2).toInt());
        res.append(query.value(3).toInt());
        res.append(query.value(4).toInt());
        res.append(query.value(5).toInt());
        res.append(query.value(6).toInt());
        res.append(query.value(7).toInt());
    }

    return res;
}

bool DataMaster::update_item(QVariantList item)
{
    int id = item[0].toInt();
    QString content = item[1].toString();
    int type = item[2].toInt();
    int year = item[3].toInt();
    int month = item[4].toInt();
    int day = item[5].toInt();
    int hour= item[6].toInt();
    int minute = item[7].toInt();

    query.prepare("update PlanData set content=:content, type=:type, year=:year, month=:month, day=:day, hour=:hour, minute=:minute where id=:id");
    query.bindValue(":id", id);
    query.bindValue(":content", content);
    query.bindValue(":type", type);
    query.bindValue(":year", year);
    query.bindValue(":month", month);
    query.bindValue(":day", day);
    query.bindValue(":hour", hour);
    query.bindValue(":minute", minute);

    return query.exec();
}

int DataMaster::get_id()
{
    query.exec("select * from IdData");
    int res;
    while(query.next())
    {
        res = query.value(1).toInt();
    }

    return res;
}

bool DataMaster::update_id(int id)
{
    query.prepare("update IdData set next=:next where id=0");
    query.bindValue(":next", id);

    return query.exec();
}

void DataMaster::database_close()
{
    query.finish();
    db.commit();
    db.close();
}
