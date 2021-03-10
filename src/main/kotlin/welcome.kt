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

external interface WelcomeProps : RProps {
    var name: String
}

data class WelcomeState(val name: String) : RState

@JsExport
class Welcome(props: WelcomeProps) : RComponent<WelcomeProps, WelcomeState>(props) {

    init {
        state = WelcomeState(props.name)
    }

    val styles = CSSBuilder().apply {
        body {
            margin(0.px)
            padding(0.px)
        }
    }

    override fun RBuilder.render() {

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

                    mTypography(state.name, variant = MTypographyVariant.h6, color = MTypographyColor.inherit) {
                        css { flexGrow = 1.0 }
                    }
                    mIconButton ("account_circle", color = MColor.inherit)
                }
            }
        }
    }
}
