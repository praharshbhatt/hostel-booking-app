import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_controller.dart';

class SlowMoController extends FlareController {
  final String animationName;
  ActorAnimation _animation;
  double speed;
  double _time = 0;

  SlowMoController(this.animationName, {this.speed = 2});

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    if (_animation == null) {
      return false;
    }
    if (_animation.isLooping) {
      _time %= _animation.duration;
    }
    _animation.apply(_time, artboard, 1.0);
    _time += elapsed * speed;
    // Stop advancing if animation is done and we're not looping.
    return _animation.isLooping || _time < _animation.duration;
  }

  @override
  void initialize(FlutterActorArtboard artboard) {
    _animation = artboard.getAnimation(animationName);
  }

  @override
  void setViewTransform(viewTransform) {
    // intentionally empty, we don't need the viewTransform in this controller
  }
}
