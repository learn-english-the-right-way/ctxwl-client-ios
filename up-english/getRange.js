(function() {
    var selection = document.getSelection()
    var anchorBeginningOffset = selection.anchorNode.parentNode.getAttribute("beginningoffset")
    var anchorEndingOffset = selection.anchorNode.parentNode.getAttribute("endingoffset")
    var focusBeginningOffset = selection.focusNode.parentNode.getAttribute("beginningoffset")
    var focusEndingOffset = selection.focusNode.parentNode.getAttribute("endingoffset")
    var leftMostOffset
    var rightMostOffset

    if (selection.anchorNode.isEqualNode(selection.focusNode)) {
        leftMostOffset = anchorBeginningOffset
        rightMostOffset = anchorEndingOffset
    } else if (anchorBeginningOffset < focusEndingOffset) {
        //selection is in left-to-right order
        var leftNode = selection.anchorNode.parentNode
        var rightNode = selection.focusNode.parentNode
        leftMostOffset = Number(leftNode.getAttribute("beginningoffset")) + selection.anchorOffset
        rightMostOffset = Number(rightNode.getAttribute("beginningoffset")) + selection.focusOffset
    } else if (focusBeginningOffset < anchorEndingOffset) {
        //selection is in right-to-left order
        var leftNode = selection.focusNode.parentNode
        var rightNode = selection.anchorNode.parentNode
        leftMostOffset = Number(leftNode.getAttribute("beginningoffset")) + selection.focusOffset
        rightMostOffset = Number(rightNode.getAttribute("beginningoffset")) + selection.anchorOffset
    }

    return `${leftMostOffset} ${rightMostOffset - leftMostOffset}`
}) ()
