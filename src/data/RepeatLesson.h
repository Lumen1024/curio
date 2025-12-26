#pragma once

#include <QObject>
#include <QString>
#include <QTime>
#include <QJsonObject>
#include "RepeatType.h"
#include "LessonType.h"

class RepeatLesson {
    Q_GADGET
    Q_PROPERTY(int id MEMBER id)
    Q_PROPERTY(int childId MEMBER childId)
    Q_PROPERTY(int teacherId MEMBER teacherId)

    Q_PROPERTY(QString name MEMBER name)
    Q_PROPERTY(QDateTime dateTime MEMBER dateTime)
    Q_PROPERTY(QString location MEMBER location)
    Q_PROPERTY(LessonType type MEMBER type)

    Q_PROPERTY(RepeatType repeatType MEMBER repeatType)

public:
    int id = 0;
    int childId = 0;
    int teacherId = -1;

    QString name = "";
    QDateTime dateTime;
    QString location = "";
    LessonType type = LessonType::Mind;

    RepeatType repeatType;

    RepeatLesson() = default;
    RepeatLesson(int id, int childId, int teacherId, const QString& name,
                 const QDateTime& dateTime, const QString& location,
                 LessonType type, RepeatType repeatType)
        : id(id), childId(childId), teacherId(teacherId), name(name),
          dateTime(dateTime), location(location), type(type), repeatType(repeatType) {}

    QJsonObject toJson() const;
    static RepeatLesson fromJson(const QJsonObject& json);
};
