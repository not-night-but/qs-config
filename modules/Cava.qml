import QtQuick
import qs.common
import qs.services

ComponentWrapper {
    StyledText {
        id: cava
        text: CavaService.cavaOut
    }
}
