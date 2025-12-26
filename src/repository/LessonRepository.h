#pragma once

#include <QObject>
#include <QList>
#include <QString>
#include <QDateTime>
#include <QJsonArray>
#include "../data/Lesson.h"

class LessonRepository : public QObject {
    Q_OBJECT

public:
    explicit LessonRepository(QObject* parent = nullptr);

    Q_INVOKABLE int create(int childId, const QString& name, const QDateTime& dateTime,
                           int type, int teacherId = -1,
                           const QString& location = QString());
    Q_INVOKABLE Lesson getById(int id) const;
    Q_INVOKABLE QList<Lesson> getAll() const;
    Q_INVOKABLE QList<Lesson> getByChildId(int childId) const;
    Q_INVOKABLE bool update(int id, int childId, const QString& name,
                           const QDateTime& dateTime, int type,
                           int teacherId = -1, const QString& location = QString());
    Q_INVOKABLE bool remove(int id);

    void loadFromJson(const QJsonArray& jsonArray);

signals:
    void dataChanged();

private:
    QList<Lesson> m_lessons;
    int m_nextId = 1;

    int generateId();
};
