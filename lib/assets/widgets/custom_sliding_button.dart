import 'package:abizeitung_mobile/assets/assets.dart';
import 'package:flutter/material.dart';

class CustomSlidingButton extends StatefulWidget {
  final String text1;
  final String text2;
  final Function(int index) fn;

  final EdgeInsetsGeometry? outerPadding;
  final double? middleSpace;
  final double? radius;

  final TextStyle? selectedTextStyle;
  final TextStyle? unselectedTextStyle;

  final Color? backgroundColor;
  final Color? foregroundColor;

  final double? height;
  final int? currentIndex;

  const CustomSlidingButton({
    Key? key,
    required this.text1,
    required this.text2,
    required this.fn,
    this.outerPadding,
    this.middleSpace,
    this.radius,
    this.selectedTextStyle,
    this.unselectedTextStyle,
    this.backgroundColor,
    this.foregroundColor,
    this.height,
    this.currentIndex,
  }) : super(key: key);

  @override
  State<CustomSlidingButton> createState() => _CustomSlidingButtonState();
}

class _CustomSlidingButtonState extends State<CustomSlidingButton>
    with TickerProviderStateMixin {
  late final EdgeInsetsGeometry _outerPadding;
  late final double _middleSpace;
  late final double _radius;

  late final TextStyle _selectedTextStyle;
  late final TextStyle _unselectedTextStyle;

  late final double _textWidth;
  late final double _width;
  late final double _height;

  late final Color _backgroundColor;
  late final Color _foregroundColor;

  late int _currentIndex;

  late final AnimationController _animationController;
  late final Animation<double> _indicatorAnimation;
  late final Animation<TextStyle> _text1StyleAnimation;
  late final Animation<TextStyle> _text2StyleAnimation;

  @override
  void initState() {
    super.initState();

    _outerPadding = widget.outerPadding ??
        const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5);
    _middleSpace = _outerPadding.horizontal / 3;
    _radius = widget.radius ?? 50.0;

    _selectedTextStyle = widget.selectedTextStyle ??
        const TextStyle(
            fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black);
    _unselectedTextStyle = widget.unselectedTextStyle ??
        const TextStyle(
            fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white);

    var txt1Size = getTextSize(widget.text1, _selectedTextStyle);
    var txt2Size = getTextSize(widget.text2, _selectedTextStyle);
    _textWidth =
        txt1Size.width > txt2Size.width ? txt1Size.width : txt2Size.width;
    _width = _textWidth * 2 + _outerPadding.horizontal + _middleSpace * 2;
    _height = widget.height ?? 40.0;

    _backgroundColor = widget.backgroundColor ?? lighterSecondaryColor;
    _foregroundColor = widget.foregroundColor ?? primaryColor;

    _currentIndex = widget.currentIndex ?? 0;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      animationBehavior: AnimationBehavior.preserve,
    )..addListener(() {
        setState(() {});
      });

    _indicatorAnimation = Tween<double>(begin: 0, end: _width / 2 - 5).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _text1StyleAnimation =
        TextStyleTween(begin: _selectedTextStyle, end: _unselectedTextStyle)
            .animate(CurvedAnimation(
                parent: _animationController, curve: Curves.easeInOut));
    _text2StyleAnimation =
        TextStyleTween(begin: _unselectedTextStyle, end: _selectedTextStyle)
            .animate(CurvedAnimation(
                parent: _animationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void customSlidingButtonTapped() {
    if (_currentIndex == 0) {
      _currentIndex = 1;
      _animationController.forward();
    } else {
      _currentIndex = 0;
      _animationController.reverse();
    }
    widget.fn(_currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => customSlidingButtonTapped(),
      child: Stack(
        children: [
          Container(
            width: _width,
            height: _height,
            decoration: BoxDecoration(
              color: _backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(_radius)),
              boxShadow: const [defaultBoxShadow],
            ),
          ),
          Transform.translate(
            offset: Offset(_indicatorAnimation.value, 0),
            child: Container(
              width: _width / 2 + 5,
              height: _height,
              decoration: BoxDecoration(
                color: _foregroundColor,
                borderRadius: BorderRadius.all(Radius.circular(_radius)),
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 0.0,
                      blurRadius: 4.0,
                      color: const Color(0x44000000),
                      offset: _animationController.value == 0.0
                          ? const Offset(4, 0)
                          : const Offset(-4, 0)),
                ],
              ),
            ),
          ),
          Container(
            padding: _outerPadding,
            height: _height,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: _textWidth,
                  child: Text(
                    widget.text1,
                    textAlign: TextAlign.center,
                    style: _text1StyleAnimation.value,
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 20.0)),
                SizedBox(
                  width: _textWidth,
                  child: Text(
                    widget.text2,
                    textAlign: TextAlign.center,
                    style: _text2StyleAnimation.value,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
