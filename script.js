let xhttp;
function loadXMLDoc(fileName) {
  xhttp = window.ActiveXObject
    ? new ActiveXObject("Msxml2.XMLHTTP")
    : new XMLHttpRequest();
  xhttp.open("GET", fileName, false);
  try {
    xhttp.responseType = "msxml-document";
  } catch (err) {
    console.log(err);
  }
  xhttp.send("");
  return xhttp.responseXML;
}

function displayResult() {
  const xml = loadXMLDoc("in.xml");
  const xsl = loadXMLDoc("template.xsl");
  if (window.ActiveXObject || xhttp.responseType == "msxml-document") {
    const ex = xml.transformNode(xsl);
    document.getElementById("books").innerHTML = ex;
  } else if (
    document.implementation &&
    document.implementation.createDocument
  ) {
    const xsltProcessor = new XSLTProcessor();
    xsltProcessor.importStylesheet(xsl);
    const resultDocument = xsltProcessor.transformToFragment(xml, document);
    document.getElementById("books").appendChild(resultDocument);
  }
}

displayResult();
