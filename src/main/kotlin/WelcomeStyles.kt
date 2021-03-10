import kotlinx.css.*
import styled.StyleSheet
import styled.css

object WelcomeStyles : StyleSheet("WelcomeStyles", isStatic = true) {

    private val styles = CSSBuilder().apply {
        body {
            margin(0.px)
            padding(0.px)
        }
    }

    fun applyGlobalStyle() {
        styled.injectGlobal(styles.toString())
    }

    val textContainer by css {
        padding(5.px)

        backgroundColor = rgb(8, 97, 22)
        color = rgb(56, 246, 137)
    }

    val textInput by css {
        margin(vertical = 5.px)

        fontSize = 14.px
    }

    val menuButtonStyle by css {
        marginLeft = (-12).px
        marginRight = 16.px
    }
} 
