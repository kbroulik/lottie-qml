# Lottie QML

This provides a QML `Item` to render Adobe® After Effects™ animations exported as JSON with Bodymovin using the Lottie Web library.

See http://airbnb.io/lottie/

## How to use

You can use the `LottieAnimation` item just like any other `QtQuick` element, such as an `Image` and place it in your scene any way you please.

```
import org.kde.lottie 1.0

LottieAnimation {
    id: fancyAnimation
    anchors.fill: parent
    source: Qt.resolvedUrl("animations/fancy_animation.json")
    loops: Animation.Infinite
    fillMode: Image.PreserveAspectFit
    running: true
}
```

There is a testing application provided in this repository:

```
qmlscene tester.qml
```

Just drag a Lottie JSON animation file into it and tweak the settings provided in the toolbar.
You can also add multiple files and switch between them using the ComboBox in the top left or Ctrl+(Shift)+Tab shortcuts.

### Property documentation

* `source` can be an absolute URL to an animation JSON file (including `qrc:/`), a JSON data string, or a JavaScript object.
    * Relative URLs are currently not supported, use `Qt.resolvedUrl`, if neccessary
* `status` can be `Image.Null`, `Image.Ready`, `Image.Loading`, or `Image.Error`. In the latter case `errorString` may contain error messages explaining the failure to load.
* `loops` (default 0) can be an integer number of loops, or `Animation.Infinite` to repeat the animation indefinitely
* `running` whether the animation is and should be running (you can also call `start()`, `pause()`, and `stop()`)
* `speed` (default 1.0) modifies the animation speed, e.g. 0.5x, 2.0x, …
* `reverse` runs the animation in reverse
* `clearBeforeRendering` (default true) Whether to clear the canvas before each frame, might improve performance on full-screen scenes but also cause unwanted rendering artefacts when disabled
* `fillMode` can be `Image.Stretch` (default), `Image.PreserveAspectFit`, `Image.PreserveAspectCrop`, or `Image.Pad`
* `renderStrategy` and `renderTarget` aliased to the internal `Canvas`

### Notes

* The item's `implicitWidth` and `implicitHeight` will be set to the animation's native canvas size.

## How to install

```
mkdir build
cd build
cmake ..
make
make install
```

## Known issues

* [QTBUG-68278](https://bugreports.qt.io/browse/QTBUG-68278): `requestAnimationFrame` passes seconds to its callback
causing the animations to not advance properly. There is currently a workaround in place that uses the current time
to advance the animations.
* [QTBUG-71524](https://bugreports.qt.io/browse/QTBUG-71524): You cannot use the non-minified `lottie.js` as Qt chokes on reserved keywords used as function names and arguments inside.

## License

This library is licensed under either version 2.1 of the GNU Lesser General Public License, or (at your option) version 3, or any later version accepted by the membership of KDE e.V. (or its successor approved by the membership of KDE e.V.), see `COPYING.LGPL-2.1`, except for:

### src/qml/3rdparty/lottie.min.js

```
The MIT License (MIT)

Copyright (c) 2015 Bodymovin

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
