#include "RepeatLesson.h"

QJsonObject RepeatLesson::toJson() const {
    QJsonObject obj;
    obj["id"] = id;
    obj["childId"] = childId;
    obj["teacherId"] = teacherId;
    obj["name"] = name;
    obj["dateTime"] = dateTime.toString(Qt::ISODate);
    obj["location"] = location;
    obj["type"] = static_cast<int>(type);
    obj["repeatType"] = static_cast<int>(repeatType);

    return obj;
}

RepeatLesson RepeatLesson::fromJson(const QJsonObject& json) {
    RepeatLesson repeatLesson;
    repeatLesson.id = json["id"].toInt();
    repeatLesson.childId = json["childId"].toInt();
    repeatLesson.teacherId = json["teacherId"].toInt(-1);
    repeatLesson.name = json["name"].toString();
    repeatLesson.dateTime = QDateTime::fromString(json["dateTime"].toString(), Qt::ISODate);
    repeatLesson.location = json["location"].toString("");
    repeatLesson.type = LessonType{json["type"].toInt()};
    repeatLesson.repeatType = RepeatType{json["repeatType"].toInt()};

    return repeatLesson;
}
