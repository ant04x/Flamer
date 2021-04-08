package mainFrame.drawerMenu

import com.ccfraser.muirwik.components.*
import com.ccfraser.muirwik.components.list.*
import com.ccfraser.muirwik.components.styles.ThemeOptions
import com.ccfraser.muirwik.components.styles.createMuiTheme
import kotlinx.css.*
import kotlinx.html.js.onClickFunction
import kotlinx.html.js.onKeyDownFunction
import kotlinx.html.role
import org.w3c.dom.events.Event
import react.*
import react.dom.div
import styled.css

external interface DrawerMenuProps : RProps {
    var open: Boolean
    var fullWidth: Boolean
    var themeOptions: ThemeOptions
    var theme: String
    var onClose: ((Event) -> Unit)
    var onAvatarClick: ((Event) -> Unit)
    var onTagClick: ((Event) -> Unit)
    var onSettingsClick: ((Event) -> Unit)
}

class DrawerMenu : RComponent<DrawerMenuProps, RState>() {

    private var drawerWidth = 21.em

    override fun RBuilder.render() {
        props.themeOptions.palette?.type = props.theme.decapitalize()
        props.themeOptions.palette?.primary.main = Colors.Pink.shade900.toString()
        props.themeOptions.palette?.secondary.main = Colors.DeepOrange.accent400.toString()

        mThemeProvider(createMuiTheme(props.themeOptions)) {
            themeContext.Consumer { theme ->
                mDrawer(props.open, onClose = props.onClose) {
                    div {
                        attrs.role = "button"
                        attrs.onClickFunction = props.onClose
                        attrs.onKeyDownFunction = props.onClose
                    }
                    mList {
                        css {
                            backgroundColor = Color(theme.palette.background.paper)
                            width = if (props.fullWidth) LinearDimension.auto else drawerWidth
                        }
                        mListItemWithAvatar(
                            "img/profile.jpeg",
                            "Antonio Izquierdo",
                            "ant04x@gmail.com",
                            alignItems = MListItemAlignItems.flexStart,
                            onClick = props.onAvatarClick // onAvatarClick
                        )
                        mListSubheader("Etiquetas", disableSticky = true)
                        mListItemWithIcon("all_inbox", "Tareas", divider = false)
                        mListItemWithIcon("lightbulb", "PSP", divider = false)
                        mListItemWithIcon("vpn_key", "ADA", divider = false)
                        mListItemWithIcon("desktop_windows", "PMDM", divider = false)
                        mListItemWithIcon("book", "SGE", divider = false)
                        mListItemWithIcon("web_asset", "DIN", divider = false)
                        mListItemWithIcon("location_city", "ING", divider = false)

                        mDivider()
                        mListSubheader("Acciones", disableSticky = true)
                        mListItemWithIcon("sell", "Crear Etiqueta", divider = false, onClick = props.onTagClick)
                        mListItemWithIcon("settings", "Ajustes", divider = false, onClick = props.onSettingsClick)
                    }
                }
            }
        }
    }
}

fun RBuilder.xDrawerMenu(
    open: Boolean = false,
    fullWidth: Boolean,
    themeOptions: ThemeOptions,
    theme: String = "Light",
    onClose: ((Event) -> Unit),
    onAvatarClick: ((Event) -> Unit),
    onTagClick: ((Event) -> Unit),
    onSettingsClick: ((Event) -> Unit)
) = child(DrawerMenu::class) {
    attrs.open = open
    attrs.fullWidth = fullWidth
    attrs.themeOptions = themeOptions
    attrs.theme = theme
    attrs.onClose = onClose
    attrs.onAvatarClick = onAvatarClick
    attrs.onTagClick = onTagClick
    attrs.onSettingsClick = onSettingsClick
}