#pragma once

#include <QObject>
#include <QList>
#include <QString>
#include <QDateTime>
#include <QJsonArray>
#include "../data/RepeatLesson.h"

class RepeatLessonRepository : public QObject {
    Q_OBJECT

public:
    explicit RepeatLessonRepository(QObject* parent = nullptr);

    Q_INVOKABLE int create(int childId, const QString& name, const QDateTime& dateTime,
                           int type, int repeatType,
                           int teacherId = -1, const QString& location = QString());
    Q_INVOKABLE RepeatLesson getById(int id) const;
    Q_INVOKABLE QList<RepeatLesson> getAll() const;
    Q_INVOKABLE QList<RepeatLesson> getByChildId(int childId) const;
    Q_INVOKABLE bool update(int id, int childId, const QString& name,
                           const QDateTime& dateTime, int type, int repeatType,
                           int teacherId = -1, const QString& location = QString());
    Q_INVOKABLE bool remove(int id);

    void loadFromJson(const QJsonArray& jsonArray);

signals:
    void dataChanged();

private:
    QList<RepeatLesson> m_repeatLessons;
    int m_nextId = 1;

    int generateId();
};
