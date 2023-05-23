// Assuming Readability.js has already been injected

// clone the document and get new HTML string
var documentClone = document.cloneNode(true)
var article = new Readability(documentClone).parse()
var readerModeHTMLString = `<body><h1>${article.title}</h1>${article.content}</body>`

// load new HTML string into documentClone
documentClone.documentElement.innerHTML = readerModeHTMLString

// process documentClone
function mapTextNodeToSpannedNodes(node, offsetCounter) {
    var string = node.nodeValue
    var splittedArray = string.split(/([^a-z])/gi)
    var processedNodesArray = splittedArray.map(string => {
        if (string.match(/[a-z]/i)) {
            var span = document.createElement("span")
            span.innerText = string
            span.setAttribute("beginningOffset", offsetCounter.current)
            span.setAttribute("endingOffset", offsetCounter.current + string.length)
            offsetCounter.current += string.length
            return span
        } else {
            offsetCounter.current += string.length
            return document.createTextNode(string)
        }
    })
    return processedNodesArray
}

function processAndExtractFullTextFrom(root) {
    var treeWalker = document.createTreeWalker(root, NodeFilter.SHOW_TEXT)
    var textNodes = []
    while(textNode = treeWalker.nextNode()) {
        textNodes.push(textNode)
    }
    var fullText = textNodes.map(node => node.nodeValue).join("")
    var offsetCounter = {
        current: 0
    }
    for (const node of textNodes) {
        node.replaceWith(...mapTextNodeToSpannedNodes(node, offsetCounter))
    }
    return fullText
}

// give the new HTML string to iOS
function processArticle() {
    var fullText = processAndExtractFullTextFrom(documentClone)
    var newHTMLString = `<html><head><style>body {
    margin-left: 5%;
    margin-right: 5%;
    font-family: -apple-system, BlinkMacSystemFont, sans-serif;
    background-color: #f7f1e4;
    color: #4b3320;
}
h1 {font-size: 70px}
p {font-size: 50px}</style></head>${documentClone.documentElement.innerHTML}</html>`
    var message = {
        fullText: fullText,
        newHTMLString: newHTMLString
    }
    window.webkit.messageHandlers.htmlHandler.postMessage(message)
}

window.onload = processArticle
