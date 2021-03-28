package mainFrame.mainMenu

import com.ccfraser.muirwik.components.*
import com.ccfraser.muirwik.components.button.MButtonSize
import com.ccfraser.muirwik.components.button.mFab
import com.ccfraser.muirwik.components.button.mIconButton
import com.ccfraser.muirwik.components.list.*
import kotlinx.css.*
import kotlinx.css.properties.BoxShadow
import kotlinx.html.js.onClickFunction
import kotlinx.html.js.onKeyDownFunction
import kotlinx.html.role
import mainFrame.spacer
import react.*
import react.dom.div
import styled.css
import styled.styledDiv

external interface MainMenuProps : RProps {
    var fullScreenDialogOpen: Boolean
    var fullScreenSettingsOpen: Boolean
    var value: Any
}

data class MainMenuState(
    val value: Any,
    val fullScreenDialogOpen: Boolean,
    val fullScreenSettingsOpen: Boolean
) : RState

class MainMenu(props: MainMenuProps) : RComponent<MainMenuProps, MainMenuState>(props) {

    init {
        // state = MainMenuState(value, fullScreenDialogOpen, fullScreenSettingsOpen)
    }

    override fun RBuilder.render() {

    }


}

fun RBuilder.mainMenu(fullScreenDialogOpen: Boolean, value: Any, fullScreenSettingsOpen: Boolean) = child(MainMenu::class) {
    attrs.fullScreenDialogOpen = fullScreenDialogOpen
    attrs.value = value
    attrs.fullScreenSettingsOpen = fullScreenSettingsOpen
}