import Qt 4.7

Testable{
    text: 'Blank Documents'

    ListModel {
        id: myModel
        ListElement {
            title: 'Blank Document'
            icon: 'document.png'
            icon_size: 48
        }
        ListElement {
            title: 'Colorful Document'
            icon: 'document.png'
            icon_size: 48
        }
        ListElement {
            title: 'Two Columns'
            icon: 'document.png'
            icon_size: 48
        }
    }
    templatesModel: myModel
}
