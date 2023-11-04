import QtQuick 2.6
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.5

import ".."
import "../components"

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents


Flickable {
    Layout.fillWidth: true
    ScrollBar.vertical: ScrollBar { id: scrollbar }
    //ScrollBar.horizontal: ScrollBar { }

    contentWidth: width - (scrollbar.visible ? scrollbar.width : 0)
    contentHeight: contentItem.childrenRect.height
    clip: true
    boundsBehavior: Flickable.OvershootBounds

    OptionGroup {
        id: option_group
        header.visible: false
        anchors.left: parent.left
        anchors.right: parent.right

        OptionItem {
            text: '要求'
            text_color: Theme.textColor
            icon: '../../images/information-outline.svg'

            contentBottom: ColumnLayout {
                Text {
                    Layout.fillWidth: true
                    color: Theme.disabledTextColor
                    text: `
                        <ol>
                        <li><i>Wallpaper Engine</i> 安装在 Steam 上</li>
                        <li>订阅创意工坊的一些壁纸</li>
                        <li>选择此插件“壁纸”选项卡上的 <i>steamlibrary</i> 文件夹
                            <ul>
                                <li>包含 <i>steamapps</i> 文件夹的 <i>steamlibrary</i>
                                    <ul>
                                        <li>默认情况下通常是 <i>~/.local/share/Steam</i></li>
                                    </ul>
                                </li>
                                <li><i>Wallpaper Engine</i> 需要安装在 <i>steamlibrary</i> 中 </li>
                            </ul>
                        </li>
                        </ol>
                    `
                    wrapMode: Text.Wrap
                    textFormat: Text.RichText
                }
            }
        }
        OptionItem {
            visible: libcheck.wallpaper

            text: '修复崩溃'
            text_color: Theme.textColor
            icon: '../../images/information-outline.svg'
            contentBottom: ColumnLayout {
                Text {
                    Layout.fillWidth: true
                    color: Theme.disabledTextColor
                    text: `
                        <ol>
                        <li>删除 <i>WallpaperSource</i> 行 <b>~/.config/plasma-org.kde.plasma.desktop-appletsrc</b></li>
                        <li>重启 KDE</li>
                        </ol>
                    `
                    wrapMode: Text.Wrap
                    textFormat: Text.RichText
                }
            }
        }
        OptionItem {
            icon: '../../images/github.svg'
            text: 'Github 仓库'
            text_color: Theme.textColor
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                cursorShape: Qt.PointingHandCursor
                onClicked: Qt.openUrlExternally(Common.repo_url)
            }
        }

        OptionItem {
            text: '版本'
            text_color: Theme.textColor
            icon: '../../images/tag.svg'
            contentBottom: ColumnLayout {
                Text {
                    Layout.fillWidth: true
                    color: Theme.disabledTextColor
                    text: `
                        <ul>
                        <li>插件: ${Common.version}</li>
                        <li>插件库: ${plugin_info.version}</li>
                        ${Common.version != plugin_info.version ? "<br><b>警告：库版本与插件版本不一致</b>" : ""}
                        <li>KDE: ${Qt.application.version}</li>
                        <li>Python: ${pyext ? pyext.version : '-'}</li>
                        </ul>
                    `
                    wrapMode: Text.Wrap
                    textFormat: Text.RichText
                }
            }
        }
 
        OptionItem {
            text: '库检查'
            text_color: Theme.textColor
            icon: '../../images/checkmark.svg'
            contentBottom: ListView {
                implicitHeight: contentItem.childrenRect.height

                model: ListModel {}
                clip: false
                property var modelraw: {
                    const _model = [
                        {
                            ok: libcheck.qtwebsockets,
                            name: "*qtwebsockets (qml)"
                        },
                        {
                            ok: pyext && pyext.ok,
                            name: "*python3-websockets"
                        },
                        {
                            ok: libcheck.qtwebchannel,
                            name: "qtwebchannel (qml) (for web)"
                        },
                        {
                            ok: libcheck.wallpaper,
                            name: "plugin lib (for scene,mpv)"
                        }
                    ];
                    return _model;
                }
                onModelrawChanged: {
                    this.model.clear();
                    this.modelraw.forEach((el) => {
                        this.model.append(el);
                    });
                }
                delegate: CheckBox {
                    text: name
                    checked: ok
                    enabled: false
                }
            }
        }
    }
}
