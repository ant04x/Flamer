import kotlinx.css.*
import kotlinx.html.InputType
import kotlinx.html.js.onChangeFunction
import org.w3c.dom.HTMLInputElement
import styled.css
import styled.styledDiv
import styled.styledInput
import com.ccfraser.muirwik.components.*
import com.ccfraser.muirwik.components.button.MButtonSize
import com.ccfraser.muirwik.components.button.mButton
import com.ccfraser.muirwik.components.button.mFab
import com.ccfraser.muirwik.components.button.mIconButton
import com.ccfraser.muirwik.components.list.*
import com.ccfraser.muirwik.components.styles.*
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
                            mIconButton ("search", color = MColor.inherit)
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

    private fun changeScreen() {
        console.log("Pagina seleccionada -> $paginaSeleccionada")
    }
}
fun RBuilder.app() = child(Welcome::class) {}
