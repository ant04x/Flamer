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
} 
