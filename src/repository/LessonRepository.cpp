#include "LessonRepository.h"
#include <QJsonObject>
#include <QDebug>

LessonRepository::LessonRepository(QObject* parent)
    : QObject(parent)
{
}

int LessonRepository::generateId() {
    return m_nextId++;
}

int LessonRepository::create(int childId, const QString& name, const QDateTime& dateTime,
                             int type, int teacherId, const QString& location) {
    int id = generateId();
    Lesson lesson(id, childId, teacherId, name, dateTime, location, static_cast<LessonType>(type));

    m_lessons.append(lesson);
    emit dataChanged();
    return id;
}

Lesson LessonRepository::getById(int id) const {
    for (const auto& lesson : m_lessons) {
        if (lesson.id == id) {
            return lesson;
        }
    }
    return Lesson();
}

QList<Lesson> LessonRepository::getAll() const {
    return m_lessons;
}

QList<Lesson> LessonRepository::getByChildId(int childId) const {
    QList<Lesson> result;
    for (const auto& lesson : m_lessons) {
        if (lesson.childId == childId) {
            result.append(lesson);
        }
    }
    return result;
}

bool LessonRepository::update(int id, int childId, const QString& name,
                              const QDateTime& dateTime, int type,
                              int teacherId, const QString& location) {
    for (auto& lesson : m_lessons) {
        if (lesson.id == id) {
            lesson.childId = childId;
            lesson.name = name;
            lesson.dateTime = dateTime;
            lesson.type = static_cast<LessonType>(type);
            lesson.teacherId = teacherId;
            lesson.location = location;

            emit dataChanged();
            return true;
        }
    }
    return false;
}

bool LessonRepository::remove(int id) {
    for (int i = 0; i < m_lessons.size(); ++i) {
        if (m_lessons[i].id == id) {
            m_lessons.removeAt(i);
            emit dataChanged();
            return true;
        }
    }
    return false;
}

void LessonRepository::loadFromJson(const QJsonArray& jsonArray) {
    m_lessons.clear();
    m_nextId = 1;

    for (const QJsonValue& value : jsonArray) {
        QJsonObject obj = value.toObject();
        Lesson lesson;
        lesson.id = obj["id"].toInt();
        lesson.childId = obj["childId"].toInt();
        lesson.name = obj["name"].toString();
        lesson.dateTime = QDateTime::fromString(obj["dateTime"].toString(), Qt::ISODate);
        lesson.type = LessonType{obj["type"].toInt()};

        if (obj.contains("teacherId")) {
            lesson.teacherId = obj["teacherId"].toInt();
        }
        if (obj.contains("location")) {
            lesson.location = obj["location"].toString();
        }

        m_lessons.append(lesson);

        if (lesson.id >= m_nextId) {
            m_nextId = lesson.id + 1;
        }
    }

    emit dataChanged();
}
