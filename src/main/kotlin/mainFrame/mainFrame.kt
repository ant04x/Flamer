package mainFrame

import kotlinx.css.*
import com.ccfraser.muirwik.components.*
import com.ccfraser.muirwik.components.button.*
import com.ccfraser.muirwik.components.dialog.*
import com.ccfraser.muirwik.components.form.MFormControlMargin
import com.ccfraser.muirwik.components.form.MFormControlVariant
import com.ccfraser.muirwik.components.form.mFormControl
import com.ccfraser.muirwik.components.input.mFilledInput
import com.ccfraser.muirwik.components.input.mInput
import com.ccfraser.muirwik.components.input.mInputLabel
import com.ccfraser.muirwik.components.list.*
import com.ccfraser.muirwik.components.menu.mMenuItem
import com.ccfraser.muirwik.components.styles.*
import com.ccfraser.muirwik.components.transitions.MTransitionProps
import kotlinx.css.Color
import kotlinx.css.properties.BoxShadow
import kotlinx.html.InputType
import kotlinx.html.js.onClickFunction
import kotlinx.html.js.onKeyDownFunction
import kotlinx.html.role
import org.w3c.dom.events.Event
import org.w3c.notifications.Notification
import react.*
import react.dom.div
import styled.*
import transitions.SlideRightTransitionComponent
import transitions.SlideUpTransitionComponent
import transitions.SlideLeftTransitionComponent
import kotlin.reflect.KClass


data class MainFrameState(val name: String) : RState

@JsExport
class MainFrame(props: RProps) : RComponent<RProps, MainFrameState>(props) {

    // private var temporaryLeftOpen: Boolean = false
    private var theme = "Light"
    private var selTagIcon = "sell"
    private var fullScreenLoginOpen: Boolean = true
    private var fullScreenSearchOpen: Boolean = false
    private var fullScreenSettingsOpen: Boolean = false
    private var fullScreenTaskOpen: Boolean = false
    private var createTagDialogOpen: Boolean = false
    private var alertDialogOpen: Boolean = false
    private var alertTransition: KClass<out RComponent<MTransitionProps, RState>>? = null
    private var temaDialogValue: String = theme
    private var temaDialogSelectedValue: String = theme
    private var temaDialogOpen: Boolean = false
    private var slow = false
    private val slowTransitionProps: MTransitionProps = js("({timeout: 1000})")
    private var value1: Any = 0
    private var appBarHeight: LinearDimension = 0.px
    private var drawerWidth = 21
    private var temporaryLeftOpen = false
    private var temporaryBottomOpen = false
    private var selectedNames: Any = arrayOf<String>()
    private var selectedTasks: Any = arrayOf<String>()
    private var age: Any = 10
    private var checked = Array(5) { false }

    private var tags = arrayListOf(
        "ADA"
    )

    @Suppress("UnsafeCastFromDynamic")
    val themeOptions: ThemeOptions = js("({palette: { type: 'placeholder', primary: {main: 'placeholder'}, secondary: {main: 'placeholder'}}})")

    init {
        // state = WelcomeState(props.name)
    }

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
                        mDrawer(temporaryBottomOpen, MDrawerAnchor.bottom, onClose = { setState { temporaryBottomOpen = false } }) {
                            taskMenu()
                        }
                        mDrawer(temporaryLeftOpen, onClose = { setState { temporaryLeftOpen = false } }) {
                            drawerMenu(false)
                        }
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

    private fun RBuilder.taskMenu() {
        themeContext.Consumer { theme ->
            div {
                attrs.role = "button"
                attrs.onClickFunction = { setState { temporaryLeftOpen = false }}
                attrs.onKeyDownFunction = { setState { temporaryLeftOpen = false }}
            }
            mPaper {
                css {
                    backgroundColor = Color(theme.palette.background.paper)
                    width = LinearDimension.auto
                    padding(2.em, 2.em)
                }
                mTextField(label = "Título", variant = MFormControlVariant.standard, fullWidth = true)
                mFormControl(fullWidth = true) {
                    css {
                        marginTop = 8.px + 2.em
                    }
                    mInputLabel("Etiquetas", htmlFor = "select-multiple-chip", variant = MFormControlVariant.standard)
                    mSelect(selectedNames, multiple = true, input = mInput(id = "select-multiple-chip", addAsChild = false),
                        onChange = { event, _ -> handleMultipleChange(event) }) {
                        attrs.renderValue = { value: Any ->
                            styledDiv {
                                css { }
                                (value as Array<String>).forEach {
                                    mChip(it, key = it, avatar = mAvatar(addAsChild = false) { mIcon(it) })
                                }
                            }
                        }
                        mMenuItem(key = "PSP", value = "lightbulb", primaryText = "PSP")
                        mMenuItem(key = "ADA", value = "vpn_key", primaryText = "ADA")
                        mMenuItem(key = "PMDM", value = "desktop_windows", primaryText = "PMDM")
                        mMenuItem(key = "SGE", value = "book", primaryText = "SGE")
                        mMenuItem(key = "DIN", value = "web_asset", primaryText = "DIN")
                        mMenuItem(key = "ING", value = "location_city", primaryText = "ING")
                    }
                }
                mFormControl(fullWidth = true) {
                    css {
                        marginTop = 8.px + 2.em
                    }
                    mInputLabel("Tareas a finalizar para autocompletar", htmlFor = "select-multiple", variant = MFormControlVariant.standard)
                    mSelect(selectedTasks, multiple = true, input = mInput(id = "select-multiple", addAsChild = false),
                        onChange = { event, _ -> handleMultipleTaskChange(event) }) {
                        mMenuItem("None", value = "")
                        mMenuItem("Tarea 1", value = "Tarea 1")
                        mMenuItem("Tarea 2", value = "Tarea 2")
                        mMenuItem("Tarea 3", value = "Tarea 3")
                    }
                }
                mButton("Guardar", MColor.primary, variant = MButtonVariant.contained, onClick = { setState { temporaryBottomOpen = false } }) {
                    css {
                        marginTop = 16.px + 2.em
                        width = 100.pct
                    }
                }
            }
        }
    }

    private fun handleMultipleChange(event: Event) {
        val value = event.targetValue
        setState { selectedNames = value }
    }

    private fun handleMultipleTaskChange(event: Event) {
        val value = event.targetValue
        setState { selectedTasks = value }
    }

    private fun handleAgeChange(event: Event) {
        val value = event.targetValue
        setState { age = value }
    }

    private fun RBuilder.drawerMenu(fullWidth: Boolean) {

        themeOptions.palette?.type = theme.decapitalize()
        themeOptions.palette?.primary.main = Colors.Pink.shade900.toString()
        themeOptions.palette?.secondary.main = Colors.DeepOrange.accent400.toString()

        mThemeProvider(createMuiTheme(themeOptions)) {
            themeContext.Consumer { theme ->
                div {
                    attrs.role = "button"
                    attrs.onClickFunction = { setState { temporaryLeftOpen = false } }
                    attrs.onKeyDownFunction = { setState { temporaryLeftOpen = false } }
                }
                mList {
                    css {
                        backgroundColor = Color(theme.palette.background.paper)
                        width = if (fullWidth) LinearDimension.auto else drawerWidth.em
//                style = js { width = if (fullWidth) "auto" else drawerWidth; backgroundColor = "white" }
                    }
                    mListItemWithAvatar(
                        "img/profile.jpeg",
                        "Antonio Izquierdo",
                        "ant04x@gmail.com",
                        alignItems = MListItemAlignItems.flexStart,
                        onClick = { setState { alertDialogOpen = true; alertTransition = null; temporaryLeftOpen = false } }
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
                    mListItemWithIcon("sell", "Crear Etiqueta", divider = false, onClick = { setState { temporaryLeftOpen = false; createTagDialogOpen = true } })
                    mListItemWithIcon("settings", "Ajustes", divider = false, onClick = { setState { temporaryLeftOpen = false; fullScreenSettingsOpen = true } })
                }
            }
        }
    }

    private fun RBuilder.fullScreenTask(open: Boolean) {
        fun handleClose() {
            setState { fullScreenTaskOpen = false }
        }
        mDialog(open, fullScreen = true, transitionComponent = SlideRightTransitionComponent::class, transitionProps = if (slow) slowTransitionProps else null, onClose = { _, _ -> handleClose() }) {
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
                    mTypography("Tarea X", variant = MTypographyVariant.h6, color = MTypographyColor.inherit) {
                        css { flexGrow = 1.0 }
                    }
                }
            }

        }
    }

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
                mListItemWithIcon("lock", "Permisos", onClick = { requestPermissions() })
                mListItemWithIcon("brightness_medium", "Tema", secondaryText = temaDialogSelectedValue, onClick = { setState { temaDialogOpen = true } })
                mListItemWithIcon("info", "Acerca de", hRefOptions = HRefOptions("https://github.com/ant04x/Flamer"))
            }
            themeDialog(temaDialogOpen)
        }
    }

    private fun requestPermissions() {
        Notification.requestPermission().then()
    }

    private fun RBuilder.themeDialog(open: Boolean, scroll: DialogScroll = DialogScroll.paper) {

        mDialog(open, scroll = scroll, transitionProps = if (slow) slowTransitionProps else null, fullWidth = true, maxWidth = Breakpoint.md) {

            attrs.disableEscapeKeyDown = true
            mDialogTitle("Tema")

            mDialogContent(scroll == DialogScroll.paper) {
                mRadioGroup(value = temaDialogValue, onChange = {_, value -> setState { temaDialogValue = value }} ) {
                    mRadioWithLabel("Light", value = "Light")
                    mRadioWithLabel("Dark", value = "Dark")
                    mRadioWithLabel("Auto", value = "Auto")
                }
            }
            mDialogActions {
                mButton("Cancelar", color = MColor.primary, onClick = { setState {
                    temaDialogValue = temaDialogSelectedValue
                    temaDialogOpen = false
                }})
                mButton("Ok", color = MColor.primary, onClick = { setState {
                    temaDialogSelectedValue = temaDialogValue
                    temaDialogOpen = false
                }})
            }
        }
    }

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

    private fun RBuilder.createTagDialog(open: Boolean) {
        fun handleClose() {
            setState { createTagDialogOpen = false}
        }
        var selectValue = "Item 2"
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

private fun Any.then() {}

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

fun RBuilder.mainFrame() = child(MainFrame::class) {}