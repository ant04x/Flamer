import com.ccfraser.muirwik.components.*
import react.dom.render
import kotlinx.browser.document
import kotlinx.browser.window
import kotlinx.css.*
import styled.css
import styled.styledDiv

fun main() {
    WelcomeStyles.applyGlobalStyle()
    window.onload = {
        render(document.getElementById("root")) {
            child(Welcome::class) {
                attrs {
                    name = "Flamer"
                }
            }
        }
    }
}
