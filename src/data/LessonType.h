#pragma once

#include <QObject>

namespace LessonTypeNS {
    Q_NAMESPACE

    enum class LessonType {
        Mind,
        Sport,
        Creative
    };
    Q_ENUM_NS(LessonType)
}

using LessonType = LessonTypeNS::LessonType;
