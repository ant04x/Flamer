package mainFrame

import kotlinx.css.*
import com.ccfraser.muirwik.components.*
import com.ccfraser.muirwik.components.button.*
import com.ccfraser.muirwik.components.dialog.*
import com.ccfraser.muirwik.components.form.MFormControlMargin
import com.ccfraser.muirwik.components.form.MFormControlVariant
import com.ccfraser.muirwik.components.form.mFormControl
import com.ccfraser.muirwik.components.input.mFilledInput
import com.ccfraser.muirwik.components.input.mInputLabel
import com.ccfraser.muirwik.components.list.*
import com.ccfraser.muirwik.components.menu.mMenuItem
import com.ccfraser.muirwik.components.styles.*
import com.ccfraser.muirwik.components.transitions.MTransitionProps
import kotlinx.css.Color
import kotlinx.css.properties.BoxShadow
import kotlinx.html.InputType
import mainFrame.drawerMenu.xDrawerMenu
import mainFrame.taskMenu.xTaskMenu
import org.w3c.notifications.Notification
import react.*
import styled.*
import transitions.SlideRightTransitionComponent
import transitions.SlideUpTransitionComponent
import transitions.SlideLeftTransitionComponent
import kotlin.reflect.KClass


data class MainFrameState(val name: String) : RState

class MainFrame(props: RProps) : RComponent<RProps, MainFrameState>(props) {

    private var theme = "Light"
    private var selTagIcon = "sell"
    private var fullScreenLoginOpen: Boolean = true
    private var fullScreenSearchOpen: Boolean = false
    private var fullScreenSettingsOpen: Boolean = false
    private var createTagDialogOpen: Boolean = false
    private var alertDialogOpen: Boolean = false
    private var alertTransition: KClass<out RComponent<MTransitionProps, RState>>? = null
    private var themeDialogValue: String = theme
    private var themeDialogSelectedValue: String = theme
    private var themeDialogOpen: Boolean = false
    private var slow = false
    private val slowTransitionProps = js("({timeout: 1000})")
    private var value1: Any = 0
    private var temporaryLeftOpen = false
    private var temporaryBottomOpen = false
    private var checked = Array(5) { false }

    @Suppress("UnsafeCastFromDynamic")
    val themeOptions: ThemeOptions = js("({palette: { type: 'placeholder', primary: {main: 'placeholder'}, secondary: {main: 'placeholder'}}})")

    override fun RBuilder.render() {

        mCssBaseline()

        themeOptions.palette?.type = theme.decapitalize()
        themeOptions.palette?.primary.main = Colors.Pink.shade900.toString()
        themeOptions.palette?.secondary.main = Colors.DeepOrange.accent400.toString()

        mThemeProvider(createMuiTheme(themeOptions)) {

            themeContext.Consumer { _ ->
                styledDiv {

                    css { css { flexGrow = 1.0 } }

                    styledDiv {
                        mAppBar(position = MAppBarPosition.fixed) {

                            mToolbar {

                                css {
                                    // color = Color.black
                                    // backgroundColor = Color.white
                                }

                                mIconButton("menu", color = MColor.inherit, onClick = { setState { temporaryLeftOpen = true } }) {

                                    css {
                                        marginLeft = (-12).px
                                        marginRight = 16.px
                                    }
                                }

                                mTypography("Tareas", variant = MTypographyVariant.h6, color = MTypographyColor.inherit) {
                                    css { flexGrow = 1.0 }
                                }
                                mIconButton ("search", color = MColor.inherit, onClick = { setState { fullScreenSearchOpen = true } } )
                            }
                        }
                        xTaskMenu(temporaryBottomOpen, onClose = { setState { temporaryBottomOpen = false } })
                        xDrawerMenu(
                            temporaryLeftOpen,
                            fullWidth = false,
                            themeOptions = themeOptions,
                            theme = theme,
                            onClose = { setState { temporaryLeftOpen = false } },
                            onAvatarClick = { setState { alertDialogOpen = true; alertTransition = null; temporaryLeftOpen = false } },
                            onTagClick = { setState { temporaryLeftOpen = false; createTagDialogOpen = true } },
                            onSettingsClick = { setState { temporaryLeftOpen = false; fullScreenSettingsOpen = true } }
                        )
                        spacer()
                        mBottomNavigation(value1,true, onChange = { _, indexValue -> setState { value1 = indexValue } }) {

                            css {

                                boxShadow.clear()
                                boxShadow.plusAssign(BoxShadow(color = rgba(0, 0, 0, 12.0), inset = false, offsetX = 0.px, offsetY = 1.px, blurRadius = 10.px, spreadRadius = 0.px)) // 3
                                boxShadow.plusAssign(BoxShadow(color = rgba(0, 0, 0, 14.0), inset = false , offsetX = 0.px, offsetY = 4.px, blurRadius = 5.px, spreadRadius = 0.px)) // 2
                                boxShadow.plusAssign(BoxShadow(color = rgba(0, 0, 0, 20.0), inset = false , offsetX = 0.px, offsetY = 2.px, blurRadius = 4.px, spreadRadius = (-1).px)) // 1

                                zIndex = 1
                                position = Position.fixed
                                left = 0.px
                                right = 0.px
                                bottom = 0.px
                            }

                            mBottomNavigationAction("Tareas", mIcon("home", addAsChild = false))
                            mFab("add", MColor.primary, size = MButtonSize.large, onClick = { setState { temporaryBottomOpen = true } }) { css { marginTop = (-28).px } }
                            mBottomNavigationAction("Archivo", mIcon("archive", addAsChild = false))
                        }
                    }

                    if (value1 == 0) {
                        mList {
                            mListItem(button = true, divider = true, onClick = { setState { temporaryBottomOpen = true } }) {
                                mListItemText("Tarea 1")
                                mListItemSecondaryAction {
                                    mCheckbox(checked[0], onChange = {_, _ -> setState {checked[0] = !checked[0]} })
                                }
                            }
                            mListItem(button = true, divider = true, onClick = { setState { temporaryBottomOpen = true } }) {
                                mListItemText("Tarea 2")
                                mListItemSecondaryAction {
                                    mCheckbox(checked[1], onChange = {_, _ -> setState {checked[1] = !checked[1]} })
                                }
                            }
                            mListItem(button = true, divider = true, onClick = { setState { temporaryBottomOpen = true } }) {
                                mListItemText("Tarea 3")
                                mListItemSecondaryAction {
                                    mCheckbox(checked[2], onChange = {_, _ -> setState {checked[2] = !checked[2]} })
                                }
                            }
                        }
                    } else if (value1 == 2) {
                        mList {
                            mListItem(button = true, divider = true, onClick = { setState { temporaryBottomOpen = true } }) {
                                mListItemText("Tarea 4")
                                mListItemSecondaryAction {
                                    mCheckbox(checked[3], onChange = {_, _ -> setState {checked[3] = !checked[3]} })
                                }
                            }
                            mListItem(button = true, divider = true, onClick = { setState { temporaryBottomOpen = true } }) {
                                mListItemText("Tarea 5")
                                mListItemSecondaryAction {
                                    mCheckbox(checked[4], onChange = {_, _ -> setState {checked[4] = !checked[4]} })
                                }
                            }
                        }
                    }
                    fullScreenSearch(fullScreenSearchOpen)
                    fullScreenSettings(fullScreenSettingsOpen)
                    fullScreenLogin(fullScreenLoginOpen)
                    createTagDialog(createTagDialogOpen)
                    alertDialog(alertDialogOpen)
                }
            }
        }
    }

    // COMPONENTE 3 => Menú de búsqueda
    private fun RBuilder.fullScreenSearch(open: Boolean) {
        fun handleClose() {
            setState { fullScreenSearchOpen = false }
        }
        mDialog(open, fullScreen = true, transitionComponent = SlideUpTransitionComponent::class, transitionProps = if (slow) slowTransitionProps else null, onClose = { _, _ -> handleClose() }) {
            mAppBar {
                css {
                    color = Color.black
                    backgroundColor = Color.white
                    position = Position.relative
                }
                mToolbar {
                    mIconButton(iconName = "arrow_back", color = MColor.inherit, iconColor = MIconColor.inherit, onClick = { handleClose() }) {
                        css {
                            marginLeft = (-12).px
                            marginRight = 16.px
                        }
                    }
                    mTextField(label = "", placeholder = "Buscar", margin = MFormControlMargin.dense, autoFocus = true) {
                        css {
                            width = LinearDimension.fillAvailable
                            marginRight = 16.px
                        }
                    }
                }
            }
            mList {
                mListItem(button = true, divider = true, onClick = { setState { temporaryBottomOpen = true } }) {
                    mListItemText("Tarea 1")
                    mListItemSecondaryAction {
                        mCheckbox(checked[0], onChange = {_, _ -> setState {checked[0] = !checked[0]} })
                    }
                }
                mListItem(button = true, divider = true, onClick = { setState { temporaryBottomOpen = true } }) {
                    mListItemText("Tarea 2")
                    mListItemSecondaryAction {
                        mCheckbox(checked[1], onChange = {_, _ -> setState {checked[1] = !checked[1]} })
                    }
                }
                mListItem(button = true, divider = true, onClick = { setState { temporaryBottomOpen = true } }) {
                    mListItemText("Tarea 3")
                    mListItemSecondaryAction {
                        mCheckbox(checked[2], onChange = {_, _ -> setState {checked[2] = !checked[2]} })
                    }
                }
                mListItem(button = true, divider = true, onClick = { setState { temporaryBottomOpen = true } }) {
                    mListItemText("Tarea 4")
                    mListItemSecondaryAction {
                        mCheckbox(checked[3], onChange = {_, _ -> setState {checked[3] = !checked[3]} })
                    }
                }
                mListItem(button = true, divider = true, onClick = { setState { temporaryBottomOpen = true } }) {
                    mListItemText("Tarea 5")
                    mListItemSecondaryAction {
                        mCheckbox(checked[4], onChange = {_, _ -> setState {checked[4] = !checked[4]} })
                    }
                }
            }
        }
    }

    // COMPONENTE 4 => Menú de Login
    private fun RBuilder.fullScreenLogin(open: Boolean) {

        themeOptions.palette?.type = theme.decapitalize()
        themeOptions.palette?.primary.main = Colors.Pink.shade900.toString()
        themeOptions.palette?.secondary.main = Colors.DeepOrange.accent400.toString()

        mThemeProvider(createMuiTheme(themeOptions)) {
            themeContext.Consumer { theme ->

                fun handleClose() {
                    setState { fullScreenLoginOpen = false }
                }
                mDialog(open, fullScreen = true, transitionComponent = SlideLeftTransitionComponent::class, transitionProps = if (slow) slowTransitionProps else null) {

                    styledDiv {
                        css {
                            display = Display.flex
                            height = 100.pct
                            width = 100.pct
                            backgroundColor = Color("#560027")
                        }
                        mPaper {
                            css {
                                marginLeft = LinearDimension.auto
                                marginRight = LinearDimension.auto
                                marginTop = LinearDimension.auto
                                marginBottom = LinearDimension.auto
                                height = 20.em
                                right = 20.em
                                padding(1.em)
                            }

                            styledImg(src = "android-chrome-512x512.png") {
                                css {
                                    display = Display.flex
                                    height = 4.em
                                    margin(0.px, LinearDimension.auto)
                                }
                            }

                            mTextField(label = "Correo", type = InputType.email, autoComplete = "email", variant = MFormControlVariant.filled, autoFocus = true) {
                                css {
                                    display = Display.flex
                                }
                            }
                            mTextField(label = "Contraseña", type = InputType.password, autoComplete = "current-password", variant = MFormControlVariant.filled) {
                                css {
                                    display = Display.flex
                                }
                            }
                            mButton("Entrar", MColor.primary, variant = MButtonVariant.contained, onClick = { handleClose() }) {
                                css {
                                    display = Display.flex
                                    marginTop = 1.em
                                    marginLeft = LinearDimension.auto
                                }
                            }
                        }
                    }
                }
            }
        }
   }

    // COMPONENTE 5 => Menú de Configuración
    private fun RBuilder.fullScreenSettings(open: Boolean) {
        fun handleClose() {
            setState { fullScreenSettingsOpen = false }
        }
        mDialog(open, fullScreen = true, transitionComponent = SlideRightTransitionComponent::class, transitionProps = if (slow) slowTransitionProps else null, onClose = { _, _ -> handleClose() }) {
            mAppBar {
                css {
                    position = Position.relative
                }
                mToolbar {
                    mIconButton(iconName = "arrow_back", color = MColor.inherit, iconColor = MIconColor.inherit, onClick = { handleClose() }) {
                        css {
                            marginLeft = (-12).px
                            marginRight = 16.px
                        }
                    }
                    mTypography("Ajustes", variant = MTypographyVariant.h6, color = MTypographyColor.inherit) {
                        css { flexGrow = 1.0 }
                    }
                }
            }
            mList {
                mListItemWithIcon("lock", "Permisos", onClick = { Notification.requestPermission() })
                mListItemWithIcon("brightness_medium", "Tema", secondaryText = themeDialogSelectedValue, onClick = { setState { themeDialogOpen = true } })
                mListItemWithIcon("info", "Acerca de", hRefOptions = HRefOptions("https://github.com/ant04x/Flamer"))
            }
            themeDialog(themeDialogOpen)
        }
    }

    // COMPONENTE 6 => Diálogo de configuración de temas.
    private fun RBuilder.themeDialog(open: Boolean, scroll: DialogScroll = DialogScroll.paper) {

        mDialog(open, scroll = scroll, transitionProps = if (slow) slowTransitionProps else null, fullWidth = true, maxWidth = Breakpoint.md) {

            attrs.disableEscapeKeyDown = true
            mDialogTitle("Tema")

            mDialogContent(scroll == DialogScroll.paper) {
                mRadioGroup(value = themeDialogValue, onChange = { _, value -> setState { themeDialogValue = value }} ) {
                    mRadioWithLabel("Light", value = "Light")
                    mRadioWithLabel("Dark", value = "Dark")
                    mRadioWithLabel("Auto", value = "Auto")
                }
            }
            mDialogActions {
                mButton("Cancelar", color = MColor.primary, onClick = { setState {
                    themeDialogValue = themeDialogSelectedValue
                    themeDialogOpen = false
                }})
                mButton("Ok", color = MColor.primary, onClick = { setState {
                    themeDialogSelectedValue = themeDialogValue
                    themeDialogOpen = false
                }})
            }
        }
    }

    // COMPONENTE 7 => Diálogo de cerrar sesión.
    private fun RBuilder.alertDialog(open: Boolean) {
        fun closeAlertDialog() {
            setState { alertDialogOpen = false }
        }

        mDialog(open, onClose = { _, _ ->  closeAlertDialog() }, transitionComponent = alertTransition, transitionProps = if (slow) slowTransitionProps else null) {
            mDialogTitle("Cerrar Sesión")
            mDialogContent {
                mDialogContentText("Al cerrar sesión no podrás administrar tus tareas de Flamer pero tus datos seguirán guardados en la nube. Podrás iniciar sesión con la misma cuenta u otra después de cerrar sesión.")
            }
            mDialogActions {
                mButton("Cancelar", MColor.primary, onClick = { closeAlertDialog() })
                mButton("Aceptar", MColor.primary, onClick = { closeAlertDialog(); setState { fullScreenLoginOpen = true } })
            }
        }
    }

    // COMPONENTE 8 => Diálogo para crear etiquetas.
    private fun RBuilder.createTagDialog(open: Boolean) {
        fun handleClose() {
            setState { createTagDialogOpen = false}
        }
        // var selectValue = "Item 2"
        mDialog(open, onClose =  { _, _ -> handleClose() }, transitionProps = if (slow) slowTransitionProps else null) {
            mDialogTitle("Crear Etiqueta")
            mDialogContent {
                styledDiv {
                    css {
                        display = Display.flex
                    }
                    styledForm {
                        mFormControl(variant = MFormControlVariant.outlined) {
                            mInputLabel("", variant = MFormControlVariant.outlined)
                            mSelect(selTagIcon, input = mFilledInput(id = "test", addAsChild = false), onChange = { event, _ -> run { setState { selTagIcon = event.targetValue as String } } }) {
                                mMenuItem(value = "lightbulb") {
                                    mIcon(iconName = "lightbulb") { css { marginRight = 10.px; fontSize = 15.px } }
                                }
                                mMenuItem(value = "vpn_key") {
                                    mIcon(iconName = "vpn_key") { css { marginRight = 10.px; fontSize = 15.px } }
                                }
                                mMenuItem(value = "desktop_windows") {
                                    mIcon(iconName = "desktop_windows") { css { marginRight = 10.px; fontSize = 15.px } }
                                }
                                mMenuItem(value = "sell") {
                                    mIcon(iconName = "sell") { css { marginRight = 10.px; fontSize = 15.px } }
                                }
                                mMenuItem(value = "book") {
                                    mIcon(iconName = "book") { css { marginRight = 10.px; fontSize = 15.px } }
                                }
                                mMenuItem(value = "web_asset") {
                                    mIcon(iconName = "web_asset") { css { marginRight = 10.px; fontSize = 15.px } }
                                }
                                mMenuItem(value = "location_city") {
                                    mIcon(iconName = "location_city") { css { marginRight = 10.px; fontSize = 15.px } }
                                }
                            }
                        }
                    }
                    mTextField(label = "Título", variant = MFormControlVariant.filled, autoFocus = true, fullWidth = true) {
                        css {
                            marginTop = 0.px
                            marginLeft = 1.25.em
                        }
                    }
                }
            }
            mDialogActions {
                mButton("Cancelar", color = MColor.primary, onClick = { handleClose() }, variant = MButtonVariant.text)
                mButton("Siguiente", color = MColor.primary, onClick = { handleClose() }, variant = MButtonVariant.text)
            }
        }
    }
}

fun RBuilder.spacer() {
    themeContext.Consumer { theme ->
        val themeStyles = object : StyleSheet("ComponentStyles", isStatic = true) {
            val toolbar by css {
                toolbarJsCssToPartialCss(theme.mixins.toolbar)
            }
        }

        // This puts in a mainFrame.spacer to get below the AppBar.
        styledDiv {
            css(themeStyles.toolbar)
        }
        mDivider {  }
    }
}

@ExperimentalJsExport
fun RBuilder.mainFrame() = child(MainFrame::class) {}