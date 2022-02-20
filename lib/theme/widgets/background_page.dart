import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:very_good_slide_puzzle/animated_bg/animated_background.dart';
import 'dart:ui';


class BackgroundPage extends StatefulWidget {
  BackgroundPage({
    Key? key, 
    required this.child,
    this.isBlur = false
  }) : super(key: key);


  final Widget child;

  final bool isBlur;

  @override
  _BackgroundPageState createState() => new _BackgroundPageState();
}

class _BackgroundPageState extends State<BackgroundPage> with TickerProviderStateMixin {

  ParticleOptions particleOptions = ParticleOptions(
    spawnOpacity: 0.3,
    opacityChangeRate: 0.0,
    minOpacity: 0.4,
    maxOpacity: 0.4,
    spawnMinSpeed: 70.0,
    spawnMaxSpeed: 100.0,
    spawnMinRadius: 7.0,
    spawnMaxRadius: 15.0,
    particleCount: 25,
  );

  var particlePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;

  // General Variables
  Behaviour? _behaviour;

  Behaviour _buildBehaviour() {
    return RandomParticleBehaviour(
      options: particleOptions,
      paint: particlePaint,
    );
  }


  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: AnimatedBackground(
        behaviour: _behaviour = _buildBehaviour(),
        vsync: this,
        child: widget.isBlur ? BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white.withOpacity(0.4),
            ), 
            child: widget.child
          ),
        ) : widget.child,
      ),
    );
  }
}