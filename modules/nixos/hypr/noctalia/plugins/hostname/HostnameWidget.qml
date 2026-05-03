// Noctalia bar widget that displays the current host name with a tooltip.

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Services.System
import qs.Services.UI
import qs.Widgets

Item {
  id: root

  property var pluginApi: null
  property ShellScreen screen
  property string widgetId: ""
  property string section: ""

  readonly property string screenName: screen?.name ?? ""
  readonly property string barPosition: Settings.getBarPositionForScreen(screenName)
  readonly property bool isBarVertical: barPosition === "left" || barPosition === "right"
  readonly property real capsuleHeight: Style.getCapsuleHeightForScreen(screenName)
  readonly property real barFontSize: Style.getBarFontSizeForScreen(screenName)
  readonly property string hostName: HostService.hostName || Quickshell.env("HOSTNAME") || "unknown"
  readonly property real contentWidth: isBarVertical ? capsuleHeight : ((contentLoader.item?.implicitWidth ?? 0) + Style.marginM * 2)
  readonly property real contentHeight: isBarVertical ? ((contentLoader.item?.implicitHeight ?? 0) + Style.marginM * 2) : capsuleHeight

  implicitWidth: contentWidth
  implicitHeight: contentHeight

  Rectangle {
    id: visualCapsule
    x: Style.pixelAlignCenter(parent.width, width)
    y: Style.pixelAlignCenter(parent.height, height)
    width: root.contentWidth
    height: root.contentHeight
    color: mouseArea.containsMouse ? Color.mHover : Style.capsuleColor
    radius: Style.radiusL
    border.color: Style.capsuleBorderColor
    border.width: Style.capsuleBorderWidth

    Loader {
      id: contentLoader
      anchors.centerIn: parent
      sourceComponent: root.isBarVertical ? verticalContent : horizontalContent
    }
  }

  Component {
    id: horizontalContent

    RowLayout {
      id: content
      spacing: Style.marginS

      NIcon {
        icon: "server"
        color: Color.mPrimary
      }

      NText {
        text: root.hostName
        color: Color.mOnSurface
        pointSize: root.barFontSize
        font.weight: Font.Medium
      }
    }
  }

  Component {
    id: verticalContent

    ColumnLayout {
      id: contentVertical
      spacing: -2

      Repeater {
        model: root.hostName.split("")

        NText {
          text: modelData
          color: Color.mOnSurface
          pointSize: root.barFontSize
          font.weight: Font.Medium
          horizontalAlignment: Text.AlignHCenter
        }
      }
    }
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true

    onEntered: {
      TooltipService.show(root, "Host: " + root.hostName, BarService.getTooltipDirection())
    }

    onExited: {
      TooltipService.hide()
    }
  }
}
