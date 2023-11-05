import 'package:flutter/material.dart';
import 'dart:math';

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyHomePage( child1:ContainerR(number: AvailableColors.one),
                child2:ContainerR(number: AvailableColors.two)));
  }
}

class MyHomePage extends StatefulWidget {
  Widget child1;
  Widget child2;

   MyHomePage({super.key,required this.child1,required this.child2});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MaterialColor color2 = Colors.red;
  MaterialColor color1 = Colors.yellow;

  @override
  Widget build(BuildContext context) {
    return AvailableColorsWidget(
        color1: color1,
        color2: color2,
        child: Scaffold(
            appBar: AppBar(title: Text("Demo ModelInherited")),
            body: Column(
              children: [
                Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            color1 = colors.getRandomElement() as MaterialColor;
                          });
                        },
                        child: Text('Change Box 1')),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            color2 = colors.getRandomElement() as MaterialColor;
                          });
                        },
                        child: Text('Change Box 2')),
                  ],
                ),
              widget.child1,
              widget.child2
              ],
            )));
  }
}

enum AvailableColors { one, two }

final colors = [
  Colors.blue,
  Colors.red,
  Colors.orange,
  Colors.purple,
  Colors.cyan,
  Colors.brown
];

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(Random().nextInt(length));
}

class AvailableColorsWidget extends InheritedModel<AvailableColors> {
  final MaterialColor color1;
  final MaterialColor color2;
  final Widget child;
  const AvailableColorsWidget(
      {Key? key,
      required this.color1,
      required this.color2,
      required this.child})
      : super(child: child, key: key);

  @override
  bool updateShouldNotify(covariant AvailableColorsWidget oldWidget) {
    return color1 != oldWidget.color1 || color2 != oldWidget.color2;
  }

  @override
  bool updateShouldNotifyDependent(
      //neu ham updateShouldNotify true moi thuc hien ham nay
      covariant AvailableColorsWidget oldWidget,
      Set<AvailableColors> dependencies) {
    if (oldWidget.color1 != color1 &&
        dependencies.contains(AvailableColors.one)) return true;
    if (oldWidget.color2 != color2 &&
        dependencies.contains(AvailableColors.two))
      return true;
    else
      return false;
  }

  static MaterialColor oneof(BuildContext context) {
    return InheritedModel.inheritFrom<AvailableColorsWidget>(context,
            aspect: AvailableColors.one)!
        .color1;
  }

  static MaterialColor twoof(BuildContext context) {
    return InheritedModel.inheritFrom<AvailableColorsWidget>(context,
            aspect: AvailableColors.two)!
        .color2;
  }
}

class ContainerR extends StatelessWidget {
  final AvailableColors number;
  const ContainerR({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    print("color +${number}\n");
    return Container(
      height: 100,
      width: double.infinity,
      color: (number == AvailableColors.one)
          ? AvailableColorsWidget.oneof(context)
          : AvailableColorsWidget.twoof(context),
    );
  }
}
