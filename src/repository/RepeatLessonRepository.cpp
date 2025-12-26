#include "RepeatLessonRepository.h"
#include <QJsonObject>
#include <QDebug>

RepeatLessonRepository::RepeatLessonRepository(QObject* parent)
    : QObject(parent)
{
}

int RepeatLessonRepository::generateId() {
    return m_nextId++;
}

int RepeatLessonRepository::create(int childId, const QString& name, const QDateTime& dateTime,
                                   int type, int repeatType,
                                   int teacherId, const QString& location) {
    int id = generateId();
    RepeatLesson repeatLesson(id, childId, teacherId, name, dateTime, location,
                              static_cast<LessonType>(type), static_cast<RepeatType>(repeatType));

    m_repeatLessons.append(repeatLesson);
    emit dataChanged();
    return id;
}

RepeatLesson RepeatLessonRepository::getById(int id) const {
    for (const auto& repeatLesson : m_repeatLessons) {
        if (repeatLesson.id == id) {
            return repeatLesson;
        }
    }
    return RepeatLesson();
}

QList<RepeatLesson> RepeatLessonRepository::getAll() const {
    return m_repeatLessons;
}

QList<RepeatLesson> RepeatLessonRepository::getByChildId(int childId) const {
    QList<RepeatLesson> result;
    for (const auto& repeatLesson : m_repeatLessons) {
        if (repeatLesson.childId == childId) {
            result.append(repeatLesson);
        }
    }
    return result;
}

bool RepeatLessonRepository::update(int id, int childId, const QString& name,
                                    const QDateTime& dateTime, int type, int repeatType,
                                    int teacherId, const QString& location) {
    for (auto& repeatLesson : m_repeatLessons) {
        if (repeatLesson.id == id) {
            repeatLesson.childId = childId;
            repeatLesson.name = name;
            repeatLesson.dateTime = dateTime;
            repeatLesson.type = static_cast<LessonType>(type);
            repeatLesson.repeatType = static_cast<RepeatType>(repeatType);
            repeatLesson.teacherId = teacherId;
            repeatLesson.location = location;

            emit dataChanged();
            return true;
        }
    }
    return false;
}

bool RepeatLessonRepository::remove(int id) {
    for (int i = 0; i < m_repeatLessons.size(); ++i) {
        if (m_repeatLessons[i].id == id) {
            m_repeatLessons.removeAt(i);
            emit dataChanged();
            return true;
        }
    }
    return false;
}

void RepeatLessonRepository::loadFromJson(const QJsonArray& jsonArray) {
    m_repeatLessons.clear();
    m_nextId = 1;

    for (const QJsonValue& value : jsonArray) {
        QJsonObject obj = value.toObject();
        RepeatLesson repeatLesson;
        repeatLesson.id = obj["id"].toInt();
        repeatLesson.childId = obj["childId"].toInt();
        repeatLesson.teacherId = obj["teacherId"].toInt(-1);
        repeatLesson.name = obj["name"].toString();
        repeatLesson.dateTime = QDateTime::fromString(obj["dateTime"].toString(), Qt::ISODate);
        repeatLesson.location = obj["location"].toString("");
        repeatLesson.type = LessonType{obj["type"].toInt()};
        repeatLesson.repeatType = RepeatType{obj["repeatType"].toInt()};

        m_repeatLessons.append(repeatLesson);

        if (repeatLesson.id >= m_nextId) {
            m_nextId = repeatLesson.id + 1;
        }
    }

    emit dataChanged();
}
