import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LogoApp(),
    );
  }
}

class LogoApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.elasticOut)
          ..addListener(() {
            print(
                'Listener - toda vez que a animação ocorre, 1x por frame renderizado');
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _animationController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              _animationController.forward();
            }
          });

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GrowAndOpacityTransition(
        animation: _animation, childAnimation: LogoWidget());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

// class AnimatedLogo extends AnimatedWidget {
//   AnimatedLogo(Animation<double> animation) : super(listenable: animation);

//   @override
//   Widget build(BuildContext context) {
//     Animation<double> animation = listenable;
//     return Center(
//       child: Container(
//         height: animation.value,
//         width: animation.value,
//         child: FlutterLogo(),
//       ),
//     );
//   }
// }

class LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child: FlutterLogo());
  }
}

class GrowAndOpacityTransition extends StatelessWidget {
  final Animation<double> animation;
  final Widget childAnimation;

  final Tween<double> sizeTween = Tween(begin: 0, end: 300);
  final Tween<double> opacityTween = Tween(begin: 0.1, end: 1);

  GrowAndOpacityTransition(
      {@required this.animation, @required this.childAnimation});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
          child: childAnimation,
          animation: animation,
          builder: (context, child) {
            return Opacity(
              opacity: opacityTween.evaluate(animation).clamp(0, 1.0),
              child: Container(
                height:
                    sizeTween.evaluate(animation).clamp(0.0, double.infinity),
                width:
                    sizeTween.evaluate(animation).clamp(0.0, double.infinity),
                child: child,
              ),
            );
          }),
    );
  }
}
