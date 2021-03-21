import kotlinx.css.*
import kotlinx.html.InputType
import kotlinx.html.js.onChangeFunction
import org.w3c.dom.HTMLInputElement
import styled.css
import styled.styledDiv
import styled.styledInput
import com.ccfraser.muirwik.components.*
import com.ccfraser.muirwik.components.button.*
import com.ccfraser.muirwik.components.dialog.mDialog
import com.ccfraser.muirwik.components.list.*
import com.ccfraser.muirwik.components.styles.*
import com.ccfraser.muirwik.components.transitions.MTransitionProps
import com.ccfraser.muirwik.components.transitions.SlideTransitionDirection
import com.ccfraser.muirwik.components.transitions.mSlide
import kotlinx.css.Color
import kotlinx.css.properties.BoxShadow
import kotlinx.css.properties.BoxShadows
import kotlinx.html.js.onClickFunction
import kotlinx.html.js.onKeyDownFunction
import kotlinx.html.role
import react.*
import react.dom.div
import react.dom.select
import react.dom.span
import react.dom.style
import styled.cssifyDeclaration
import kotlin.js.Console


data class WelcomeState(val name: String) : RState

@JsExport
class Welcome(props: RProps) : RComponent<RProps, WelcomeState>(props) {

    private var temporaryLeftOpen: Boolean = false
    private var fullScreenDialogOpen: Boolean = false
    private var slow = false
    private val slowTransitionProps: MTransitionProps = js("({timeout: 1000})")
    private var paginaSeleccionada: Any = 0
    private var drawerWidth = 21
    private var value1: Any = 0

    init {
        // state = WelcomeState(props.name)
    }

    override fun RBuilder.render() {

        mCssBaseline()

        @Suppress("UnsafeCastFromDynamic")
        val themeOptions: ThemeOptions = js("({palette: { type: 'placeholder', primary: {main: 'placeholder'}}})")
        themeOptions.palette?.type = "light"
        themeOptions.palette?.primary.main = Colors.Indigo.accent400.toString()

        mThemeProvider(createMuiTheme(themeOptions)) {

            themeContext.Consumer { _ ->
                styledDiv {

                    css { css { flexGrow = 1.0 } }

                    mAppBar(position = MAppBarPosition.static) {

                        mToolbar {

                            css {
                                color = Color.black
                                backgroundColor = Color.white
                                position = Position.fixed
                                left = 0.px
                                right = 0.px
                                top = 0.px
                            }

                            mIconButton("menu", color = MColor.inherit, onClick = { setState { temporaryLeftOpen = true } }) {

                                css {
                                    marginLeft = (-12).px
                                    marginRight = 16.px
                                }
                            }

                            mTypography("Flamer", variant = MTypographyVariant.h6, color = MTypographyColor.inherit) {
                                css { flexGrow = 1.0 }
                            }
                            mIconButton ("search", color = MColor.inherit, onClick = { setState { fullScreenDialogOpen = true } } )
                        }
                    }
                    mDrawer(temporaryLeftOpen, onClose = { setState { temporaryLeftOpen = false } }) {
                        mailPlaceholder(false)
                    }

                    mBottomNavigation(value1, true, onChange = { _, indexValue -> setState { value1 = indexValue } }) {

                        css {

                            boxShadow.clear()
                            boxShadow.plusAssign(BoxShadow(color = rgba(0, 0, 0, 12.0), inset = false, offsetX = 0.px, offsetY = 1.px, blurRadius = 10.px, spreadRadius = 0.px)) // 3
                            boxShadow.plusAssign(BoxShadow(color = rgba(0, 0, 0, 14.0), inset = false , offsetX = 0.px, offsetY = 4.px, blurRadius = 5.px, spreadRadius = 0.px)) // 2
                            boxShadow.plusAssign(BoxShadow(color = rgba(0, 0, 0, 20.0), inset = false , offsetX = 0.px, offsetY = 2.px, blurRadius = 4.px, spreadRadius = (-1).px)) // 1

                            position = Position.fixed
                            left = 0.px
                            right = 0.px
                            bottom = 0.px
                        }

                        mBottomNavigationAction("Tareas", mIcon("home", addAsChild = false))
                        mFab("add", MColor.primary, size = MButtonSize.large) { css { marginTop = (-28).px } }
                        mBottomNavigationAction("Archivo", mIcon("archive", addAsChild = false))
                    }
                    if (value1 == 0) {
                        styledDiv {
                            css {
                                height = 60.em
                                width = 100.pct
                                backgroundColor = Color.green
                            }
                        }
                    } else if (value1 == 2) {
                        styledDiv {
                            css {
                                height = 60.em
                                width = 100.pct
                                backgroundColor = Color.red
                            }
                        }
                    }
                    fullScreenDialog(fullScreenDialogOpen)
                }
            }
        }
    }

    private fun RBuilder.mailPlaceholder(fullWidth: Boolean) {
        themeContext.Consumer { theme ->
            div {
                attrs.role = "button"
                attrs.onClickFunction = { setState { temporaryLeftOpen = false }}
                attrs.onKeyDownFunction = { setState { temporaryLeftOpen = false }}
            }
            mList {
                css {
                    backgroundColor = Color(theme.palette.background.paper)
                    width = if (fullWidth) LinearDimension.auto else drawerWidth.em
//                style = js { width = if (fullWidth) "auto" else drawerWidth; backgroundColor = "white" }
                }
                mListItemWithAvatar(
                    "/img/profile.jpg",
                    "Anais Fernandez",
                    "anaisfernandez@gmail.com",
                    alignItems = MListItemAlignItems.flexStart
                )
                mListSubheader("Etiquetas", disableSticky = true)
                mListItemWithIcon("lightbulb", "PSP", divider = false)
                mListItemWithIcon("vpn_key", "ADA", divider = false)
                mListItemWithIcon("desktop_windows", "PMDM", divider = false)
                mListItemWithIcon("book", "SGE", divider = false)
                mListItemWithIcon("web_asset", "DIN", divider = false)
                mListItemWithIcon("location_city", "ING", divider = false)

                mDivider()
                mListSubheader("Acciones", disableSticky = true)
                mListItemWithIcon("sell", "Crear Etiqueta", divider = false)
                mListItemWithIcon("settings", "Ajustes", divider = false)
            }
        }
    }

    private fun RBuilder.fullScreenDialog(open: Boolean) {
        fun handleClose() {
            setState { fullScreenDialogOpen = false }
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
                    // mToolbarTitle("Sound")
                    // mButton("save", variant = MButtonVariant.text, color = MColor.inherit, onClick = { handleClose() })
                }
            }
            // mListItem(primaryText = "Phone ringtone", secondaryText = "Titania", divider = true)
        }
    }

    class SlideUpTransitionComponent(props: MTransitionProps) : RComponent<MTransitionProps, RState>(props) {
        override fun RBuilder.render() {
            childList.add(cloneElement(mSlide(direction = SlideTransitionDirection.down, addAsChild = false), props))
        }
    }
}
fun RBuilder.app() = child(Welcome::class) {}
