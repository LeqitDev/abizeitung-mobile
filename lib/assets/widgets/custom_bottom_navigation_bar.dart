import 'package:abizeitung_mobile/assets/assets.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int? currentIndex;
  final Function(int index)? navigationTapped;

  const CustomBottomNavigationBar(
      {Key? key, this.currentIndex, this.navigationTapped})
      : super(key: key);

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late Animation<double> toNext;

  final Color selectedColor = primaryColor;
  final Color unselectedColor = Colors.white;

  final double _iconSize = 30.0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250))
      ..addListener(() {
        setState(() {});
      });
    toNext = Tween<double>(begin: 0.0, end: 0.0).animate(_animationController);
  }

  double indexIndicatorPosition(double width, int index) {
    // calculate position (x) for indicator with three evenly spaced items
    return (((width - 3 * _iconSize) / 4) * (1 + index)) +
        ((_iconSize / 2) * (1 + (index * 2))) -
        10; // width of indicator
  }

  void onNavigationTapped(int newIndex, double width) {
    // get new and old position for the tween
    double oldIndicatorPos =
        indexIndicatorPosition(width, widget.currentIndex!);
    double newIndicatorPos = indexIndicatorPosition(width, newIndex);

    // give him more time for longer distance
    if ((widget.currentIndex! - newIndex) % 2 == 0) {
      _animationController.duration = const Duration(milliseconds: 500);
    } else {
      _animationController.duration = const Duration(milliseconds: 375);
    }

    // stop old animation if running and reset old animation
    if (_animationController.isAnimating) _animationController.stop();
    _animationController.reset();

    // set new tween animation with new positions
    toNext = Tween<double>(begin: oldIndicatorPos, end: newIndicatorPos)
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.easeInOut));

    // play animation
    _animationController.forward();

    // give the programmer the new index
    widget.navigationTapped!(newIndex);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height * 0.0625;
    return Container(
        width: _width,
        height: _height,
        decoration: const BoxDecoration(
          border:
              Border(top: BorderSide(color: lighterSecondaryColor, width: 0.5)),
        ),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  child: Icon(
                    Icons.home,
                    color: widget.currentIndex == 0
                        ? selectedColor
                        : unselectedColor,
                    size: _iconSize,
                  ),
                  onTap: () => onNavigationTapped(0, _width),
                ),
                GestureDetector(
                  child: Icon(
                    Icons.class_,
                    color: widget.currentIndex == 1
                        ? selectedColor
                        : unselectedColor,
                    size: _iconSize,
                  ),
                  onTap: () => onNavigationTapped(1, _width),
                ),
                GestureDetector(
                  child: Icon(
                    Icons.bar_chart,
                    color: widget.currentIndex == 2
                        ? selectedColor
                        : unselectedColor,
                    size: _iconSize,
                  ),
                  onTap: () => onNavigationTapped(2, _width),
                ),
              ],
            ),
            Transform.translate(
              offset: Offset(
                  toNext.status == AnimationStatus.forward
                      ? toNext.value
                      : indexIndicatorPosition(_width, widget.currentIndex!),
                  _height / 2 - 7.0),
              child: Container(
                height: 4.0,
                width: 20.0,
                decoration: const BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                ),
              ),
            )
          ],
        ));
  }
}
