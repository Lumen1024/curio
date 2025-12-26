#pragma once

#include <QString>
#include <QDateTime>
#include <QObject>
#include <QJsonObject>
#include "LessonType.h"
#include "Teacher.h"

class Lesson {
    Q_GADGET
    Q_PROPERTY(int id MEMBER id)
    Q_PROPERTY(int childId MEMBER childId)
    Q_PROPERTY(int teacherId MEMBER teacherId)

    Q_PROPERTY(QString name MEMBER name)
    Q_PROPERTY(QDateTime dateTime MEMBER dateTime)
    Q_PROPERTY(QString location MEMBER location)
    Q_PROPERTY(LessonType type MEMBER type)
    

public:
    int id = 0;
    int childId = 0;
    int teacherId = -1;

    QString name = "";
    QDateTime dateTime;
    QString location = "";
    LessonType type = LessonType::Mind;

    Lesson() = default;
    Lesson(int id, int childId, int teacherId, const QString& name,
           const QDateTime& dateTime, const QString& location, LessonType type)
        : id(id), childId(childId), teacherId(teacherId), name(name),
          dateTime(dateTime), location(location), type(type) {}

    QJsonObject toJson() const;
    static Lesson fromJson(const QJsonObject& json);
};
