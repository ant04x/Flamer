package mainFrame

import kotlinx.css.*
import styled.StyleSheet

object MainFrameStyles : StyleSheet("mainFrame.MainFrameStyles", isStatic = true) {

    private val styles = CSSBuilder().apply {
        body {
            margin(0.px)
            padding(0.px)
        }
    }
} 
