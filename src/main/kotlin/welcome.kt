import kotlinx.css.*
import kotlinx.html.InputType
import kotlinx.html.js.onChangeFunction
import org.w3c.dom.HTMLInputElement
import react.RBuilder
import react.RComponent
import react.RProps
import react.RState
import styled.css
import styled.styledDiv
import styled.styledInput
import com.ccfraser.muirwik.components.*
import com.ccfraser.muirwik.components.button.mButton
import com.ccfraser.muirwik.components.button.mIconButton
import com.ccfraser.muirwik.components.styles.ThemeOptions
import com.ccfraser.muirwik.components.styles.createMuiTheme


data class WelcomeState(val name: String) : RState

@JsExport
class Welcome(props: RProps) : RComponent<RProps, WelcomeState>(props) {

    init {
        // state = WelcomeState(props.name)
    }

    override fun RBuilder.render() {

        mCssBaseline()

        @Suppress("UnsafeCastFromDynamic")
        val themeOptions: ThemeOptions = js("({palette: { type: 'placeholder', primary: {main: 'placeholder'}}})")
        themeOptions.palette?.type = "light"
        themeOptions.palette?.primary.main = Colors.BlueGrey.shade400.toString()

        mThemeProvider(createMuiTheme(themeOptions)) {

            themeContext.Consumer { _ ->
                styledDiv {

                    css { css { flexGrow = 1.0 } }

                    mAppBar(position = MAppBarPosition.static) {

                        mToolbar {

                            mIconButton("menu", color = MColor.inherit) {

                                css {
                                    marginLeft = (-12).px
                                    marginRight = 16.px
                                }
                            }

                            mTypography("Flamer", variant = MTypographyVariant.h6, color = MTypographyColor.inherit) {
                                css { flexGrow = 1.0 }
                            }
                            mIconButton ("account_circle", color = MColor.inherit)
                        }
                    }
                }
            }
        }
    }
}
fun RBuilder.app() = child(Welcome::class) {}
