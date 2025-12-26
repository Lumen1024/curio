#include "Lesson.h"

QJsonObject Lesson::toJson() const {
    QJsonObject obj;
    obj["id"] = id;
    obj["childId"] = childId;
    obj["teacherId"] = teacherId;
    obj["name"] = name;
    obj["dateTime"] = dateTime.toString(Qt::ISODate);
    obj["location"] = location;
    obj["type"] = static_cast<int>(type);

    return obj;
}

Lesson Lesson::fromJson(const QJsonObject& json) {
    Lesson lesson;
    lesson.id = json["id"].toInt();
    lesson.childId = json["childId"].toInt();
    lesson.teacherId = json["teacherId"].toInt(-1);
    lesson.name = json["name"].toString();
    lesson.dateTime = QDateTime::fromString(json["dateTime"].toString(), Qt::ISODate);
    lesson.location = json["location"].toString("");
    lesson.type = LessonType{json["type"].toInt()};

    return lesson;
}
