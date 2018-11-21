#include "datebackend.h"
#include <QDate>

DateBackEnd::DateBackEnd(QObject *parent) : QObject(parent)
{
    QDate current;
    current = current.currentDate();
    for(int i=-182; i<=182; i++)
    {
        QDate a = current.addDays(i);
        date_record.append(a.year());
        date_record.append(a.month());
        date_record.append(a.day());
    }

}

QList<int> DateBackEnd::date()
{
    return date_record;
}
