import 'dart:async';

import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ObjectWithTextureAndRotation extends StatefulWidget {
  @override
  _ObjectWithTextureAndRotationState createState() =>
      _ObjectWithTextureAndRotationState();
}

class _ObjectWithTextureAndRotationState
    extends State<ObjectWithTextureAndRotation> {
  ArCoreController arCoreController;

  ArCoreRotatingNode node;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Hello World'),
        ),
        body: Column(
          children: <Widget>[
            RotationSlider(
              degreesPerSecondInitialValue: 90.0,
              onDegreesPerSecondChange: onDegreesPerSecondChange,
            ),
            Expanded(
              child: ArCoreView(
                onArCoreViewCreated: _onArCoreViewCreated,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    _addSphere(arCoreController);
  }

  void _addSphere(ArCoreController controller) {
    final material = ArCoreMaterial(
      color: Color.fromARGB(120, 66, 134, 244),
      texture: "italia.png",
    );
    final sphere = ArCoreSphere(
      materials: [material],
      radius: 0.1,
    );
    node = ArCoreRotatingNode(
      geometry: sphere,
      position: vector.Vector3(0, 0, -1.5),
      rotation: vector.Vector4(0, 0, 0, 0),
    );
    controller.add(node);
  }

  onDegreesPerSecondChange(double value) {
    if (node == null) {
      return;
    }
    debugPrint("onDegreesPerSecondChange");
    if (node.degreesPerSecond.value != value) {
      debugPrint("onDegreesPerSecondChange: $value");
      node.degreesPerSecond.value = value;
    }
  }

  @override
  void dispose() {
    arCoreController?.dispose();
    super.dispose();
  }
}

class RotationSlider extends StatefulWidget {
  final double degreesPerSecondInitialValue;
  final ValueChanged<double> onDegreesPerSecondChange;

  const RotationSlider(
      {Key key,
      this.degreesPerSecondInitialValue,
      this.onDegreesPerSecondChange})
      : super(key: key);

  @override
  _RotationSliderState createState() => _RotationSliderState();
}

class _RotationSliderState extends State<RotationSlider> {
  double degreesPerSecond;

  @override
  void initState() {
    degreesPerSecond = widget.degreesPerSecondInitialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text("Degrees Per Second"),
        Expanded(
          child: Slider(
            value: degreesPerSecond,
            divisions: 8,
            min: 0.0,
            max: 360.0,
            onChangeEnd: (value) {
              degreesPerSecond = value;
              widget.onDegreesPerSecondChange(degreesPerSecond);
            },
            onChanged: (double value) {
              setState(() {
                degreesPerSecond = value;
              });
            },
          ),
        ),
      ],
    );
  }
}