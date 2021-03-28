import com.ccfraser.muirwik.components.styles.mStylesProvider
import react.dom.render
import kotlinx.browser.document
import mainFrame.mainFrame

fun main() {
    render(document.getElementById("root")) {
        mStylesProvider("jss-insertion-point") {
            mainFrame()
        }
    }
}
