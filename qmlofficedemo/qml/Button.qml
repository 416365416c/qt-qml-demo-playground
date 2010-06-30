import Qt 4.7
import Qt.labs.particles 1.0

Rectangle {
    id: container

    property string caption: "Button"

    signal clicked

    SystemPalette { id: activePalette }
    width: buttonLabel.width + 20; height: buttonLabel.height + 6
    smooth: true
    border { width: 1; color: Qt.darker(activePalette.button) }
    radius: 8
    color: activePalette.button

    gradient: Gradient {
        GradientStop {
            position: 0.0
            color: {
                if (mouseArea.pressed)
                    return activePalette.dark
                else
                    return activePalette.light
            }
        }
        GradientStop { position: 1.0; color: activePalette.button }
    }

    MouseArea { id: mouseArea; anchors.fill: parent; onClicked: container.clicked();}

    Particles {
        id: particles

        x: mouseArea.mouseX
        y: mouseArea.mouseY
        width: 1; height: 1

        emissionRate: mouseArea.pressed?100:0
        count: -1
        lifeSpan: 700; lifeSpanDeviation: 600
        angle: 0; angleDeviation: 360;
        velocity: 100; velocityDeviation: 30
        source: 'particle.png'
    }

    Text {
        id: buttonLabel; text: container.caption; anchors.centerIn: container; color: activePalette.buttonText
    }
}
