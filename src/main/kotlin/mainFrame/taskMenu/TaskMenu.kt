package mainFrame.taskMenu

import com.ccfraser.muirwik.components.*
import com.ccfraser.muirwik.components.button.MButtonVariant
import com.ccfraser.muirwik.components.button.mButton
import com.ccfraser.muirwik.components.form.MFormControlVariant
import com.ccfraser.muirwik.components.form.mFormControl
import com.ccfraser.muirwik.components.input.mInput
import com.ccfraser.muirwik.components.input.mInputLabel
import com.ccfraser.muirwik.components.menu.mMenuItem
import kotlinx.css.*
import kotlinx.html.js.onClickFunction
import kotlinx.html.js.onKeyDownFunction
import kotlinx.html.role
import org.w3c.dom.events.Event
import react.*
import react.dom.div
import styled.css
import styled.styledDiv

external interface TaskMenuProps : RProps {
    var open: Boolean
    var onClose: ((Event) -> Unit)
}

class TaskMenu : RComponent<TaskMenuProps, RState>() {

    private var selectedNames: Any = arrayOf<String>()
    private var selectedTasks: Any = arrayOf<String>()

    override fun RBuilder.render() {
        themeContext.Consumer { theme ->
            mDrawer(props.open, MDrawerAnchor.bottom, onClose = props.onClose ) {
                div {
                    attrs.role = "button"
                    attrs.onClickFunction = props.onClose
                    attrs.onKeyDownFunction = props.onClose
                }
                mPaper {
                    css {
                        backgroundColor = Color(theme.palette.background.paper)
                        width = LinearDimension.auto
                        padding(2.em, 2.em)
                    }
                    mTextField(label = "Título", variant = MFormControlVariant.standard, fullWidth = true)
                    mFormControl(fullWidth = true) {
                        css {
                            marginTop = 8.px + 2.em
                        }
                        mInputLabel("Etiquetas", htmlFor = "select-multiple-chip", variant = MFormControlVariant.standard)
                        mSelect(selectedNames, multiple = true, input = mInput(id = "select-multiple-chip", addAsChild = false),
                            onChange = { event, _ -> handleMultipleChange(event) }) {
                            attrs.renderValue = { value: Any ->
                                styledDiv {
                                    css { }
                                    (value as Array<String>).forEach {
                                        mChip(it, key = it, avatar = mAvatar(addAsChild = false) { mIcon(it) })
                                    }
                                }
                            }
                            mMenuItem(key = "PSP", value = "lightbulb", primaryText = "PSP")
                            mMenuItem(key = "ADA", value = "vpn_key", primaryText = "ADA")
                            mMenuItem(key = "PMDM", value = "desktop_windows", primaryText = "PMDM")
                            mMenuItem(key = "SGE", value = "book", primaryText = "SGE")
                            mMenuItem(key = "DIN", value = "web_asset", primaryText = "DIN")
                            mMenuItem(key = "ING", value = "location_city", primaryText = "ING")
                        }
                    }
                    mFormControl(fullWidth = true) {
                        css {
                            marginTop = 8.px + 2.em
                        }
                        mInputLabel("Tareas a finalizar para autocompletar", htmlFor = "select-multiple", variant = MFormControlVariant.standard)
                        mSelect(selectedTasks, multiple = true, input = mInput(id = "select-multiple", addAsChild = false),
                            onChange = { event, _ -> handleMultipleTaskChange(event) }) {
                            mMenuItem("None", value = "")
                            mMenuItem("Tarea 1", value = "Tarea 1")
                            mMenuItem("Tarea 2", value = "Tarea 2")
                            mMenuItem("Tarea 3", value = "Tarea 3")
                        }
                    }
                    mButton("Guardar", MColor.primary, variant = MButtonVariant.contained, onClick = props.onClose) {
                        css {
                            marginTop = 16.px + 2.em
                            width = 100.pct
                        }
                    }
                }
            }
        }
    }

    private fun handleMultipleChange(event: Event) {
        val value = event.targetValue
        setState { selectedNames = value }
    }

    private fun handleMultipleTaskChange(event: Event) {
        val value = event.targetValue
        setState { selectedTasks = value }
    }
}

fun RBuilder.xTaskMenu(open: Boolean = false, onClose: ((Event) -> Unit)) = child(TaskMenu::class) {
    attrs.open = open
    attrs.onClose = onClose
}
