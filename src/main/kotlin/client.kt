import com.ccfraser.muirwik.components.*
import com.ccfraser.muirwik.components.styles.mStylesProvider
import react.dom.render
import kotlinx.browser.document
import kotlinx.browser.window
import kotlinx.css.*
import styled.css
import styled.styledDiv

fun main() {
    render(document.getElementById("root")) {
        mStylesProvider("jss-insertion-point") {
            app()
        }
    }
}
