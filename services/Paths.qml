pragma Singleton 

import Quickshell
import QtQuick

Singleton {
    id: root

    readonly property string home: Quickshell.env("HOME")
    readonly property string cava_path: Quickshell.shellPath("scripts/Cava.sh")
    readonly property string update_path: Quickshell.shellPath("scripts/Updates.sh")
}
