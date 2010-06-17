import Qt 4.7

XmlListModel{
    id: theModel
    source: app.contentRoot + "config.xml"
    query: "/demolauncher/demos/example"
    XmlRole{ name: "image"; query: "@image/string()" }
    XmlRole{ name: "name"; query: "@name/string()" }
    XmlRole{ name: "filename"; query: "@filename/string()" }
    XmlRole{ name: "args"; query: "@args/string()" }
}
