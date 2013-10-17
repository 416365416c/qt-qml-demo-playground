
import QtQuick 2.0
import Qt.labs.presentation 1.0

    CodeSlide {
        title: "Bindings"
	//DPI aware with custom buckets width bindings
        code:
'Image {
    source: {
      if (Screen.logicalPixelDensity < 40)
	"image_ultralowdpi.png"
      else if (Screen.logicalPixelDensity > 300)
	"image_ultrahighdpi.png"
      else
	"image.png"
    }
}
'
    }