package mainFrame.drawerMenu

import com.ccfraser.muirwik.components.*
import com.ccfraser.muirwik.components.list.*
import com.ccfraser.muirwik.components.styles.ThemeOptions
import com.ccfraser.muirwik.components.styles.createMuiTheme
import com.ccfraser.muirwik.components.transitions.MTransitionProps
import kotlinx.css.*
import kotlinx.html.js.onClickFunction
import kotlinx.html.js.onKeyDownFunction
import kotlinx.html.role
import react.*
import react.dom.div
import styled.css
import kotlin.reflect.KClass

external interface DrawerMenuProps : RProps {
    var drawerOpen: Boolean
    var fullWidth: Boolean
    var themeOptions: ThemeOptions
    var theme: String
    var alertDialogOpen: Boolean
    var alertTransition: KClass<out RComponent<MTransitionProps, RState>>?
    var createTagDialogOpen: Boolean
    var fullScreenSettingsOpen: Boolean
}

class DrawerMenu : RComponent<DrawerMenuProps, RState>() {

    private var drawerWidth = 21.em

    override fun RBuilder.render() {
        props.themeOptions.palette?.type = props.theme.decapitalize()
        props.themeOptions.palette?.primary.main = Colors.Pink.shade900.toString()
        props.themeOptions.palette?.secondary.main = Colors.DeepOrange.accent400.toString()

        mThemeProvider(createMuiTheme(props.themeOptions)) {
            themeContext.Consumer { theme ->
                mDrawer(props.drawerOpen, onClose = { setState { props.drawerOpen = false } }) {
                    div {
                        attrs.role = "button"
                        attrs.onClickFunction = { setState { props.drawerOpen = false } }
                        attrs.onKeyDownFunction = { setState { props.drawerOpen = false } }
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
                            onClick = { setState { props.alertDialogOpen = true; props.alertTransition = null; props.drawerOpen = false } }
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
                        mListItemWithIcon("sell", "Crear Etiqueta", divider = false, onClick = { setState { props.drawerOpen = false; props.createTagDialogOpen = true } })
                        mListItemWithIcon("settings", "Ajustes", divider = false, onClick = { setState { props.drawerOpen = false; props.fullScreenSettingsOpen = true } })
                    }
                }
            }
        }
    }
}

fun RBuilder.xDrawerMenu(drawerOpen: Boolean = false, fullWidth: Boolean, themeOptions: ThemeOptions, theme: String = "Light", alertDialogOpen: Boolean, alertTransition: KClass<out RComponent<MTransitionProps, RState>>?, createTagDialogOpen: Boolean, fullScreenSettingsOpen: Boolean) = child(DrawerMenu::class) {
    attrs.drawerOpen = drawerOpen
    attrs.fullWidth = fullWidth
    attrs.themeOptions = themeOptions
    attrs.theme = theme
    attrs.alertDialogOpen = alertDialogOpen
    attrs.alertTransition = alertTransition
    attrs.createTagDialogOpen = createTagDialogOpen
    attrs.fullScreenSettingsOpen = fullScreenSettingsOpen
}