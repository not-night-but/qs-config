pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Widgets
import qs.common
import qs.services

ComponentWrapper {
    id: root
    visible: !!root.windowTitle

    required property ShellScreen qsScreen

    property HyprlandMonitor monitor: Hyprland.monitorFor(qsScreen)
    property DesktopEntry activeDesktopEntry: null

    readonly property var currentTopLevel: {
        if (root.monitor.activeWorkspace?.toplevels.values.length <= 0) return null
        const topLevels = root.monitor.activeWorkspace.toplevels.values.filter((t) => t.activated)
        return topLevels[0]
    }

    readonly property string windowTitle: {
        if (root.monitor.activeWorkspace?.toplevels.values.length <= 0) return ""
        return currentTopLevel?.title
    }

    function getAppIcon() {
        if (root.monitor.activeWorkspace?.toplevels.values.length <= 0) return ""
        const lookup = root.moddedAppId(root.currentTopLevel.wayland.appId)
        const icon = DesktopEntries.heuristicLookup(lookup)?.icon
        return Quickshell.iconPath(icon || "", true)
    }

    function moddedAppId(appId: string): string {
        const steamMatch = appId.match(/^steam_app_(\d+)$/);
        if (steamMatch)
            return `steam_icon_${steamMatch[1]}`;
        return appId;
    }

    RowLayout {
        Loader {
            id: icon
            asynchronous: true
            active: false && root.getAppIcon() !== ""

            sourceComponent: IconImage {
                asynchronous: true
                implicitSize: Settings.iconSize
                source: root.getAppIcon()
            }
        }

        TruncatedText {
            text: root.windowTitle
            maxWidth: Settings.windowTitleWidth
            color: Settings.text
        }

        Connections {
            target: Hyprland
            function onRawEvent(ev) {
                switch (ev.name) {
                    case "openwindow":
                    case "closewindow":
                    case "changefloatingmode":
                    case "movewindow":
                    case "focusedmon":
                    case "workspace":
                        Hyprland.refreshToplevels()
                        return

                    default:
                        return
                }
            }
        }
    }

}
