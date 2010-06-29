import Qt 4.7

Testable{
    text: 'Envelopes'

    ListModel {
        id: myModel
        ListElement {
            title: 'Envelope C6'
        }
        ListElement {
            title: 'Envelope DL'
        }
    }
    templatesModel: myModel
}
