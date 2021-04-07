package transitions

import com.ccfraser.muirwik.components.transitions.MTransitionProps
import com.ccfraser.muirwik.components.transitions.SlideTransitionDirection
import com.ccfraser.muirwik.components.transitions.mSlide
import react.RBuilder
import react.RComponent
import react.RState
import react.cloneElement

class SlideLeftTransitionComponent(props: MTransitionProps) : RComponent<MTransitionProps, RState>(props) {
    override fun RBuilder.render() {
        childList.add(cloneElement(mSlide(direction = SlideTransitionDirection.right, addAsChild = false), props))
    }
}