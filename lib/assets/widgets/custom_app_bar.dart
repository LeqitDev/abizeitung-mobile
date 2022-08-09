import 'package:abizeitung_mobile/assets/assets.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    this.onChanged,
    required this.search,
    this.actions,
    this.title,
  })  : preferredSize = const Size.fromHeight(110.0),
        super(key: key);

  @override
  final Size preferredSize;

  final Function(String)? onChanged;
  final bool search;
  final List<Widget>? actions;
  final Widget? title;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;

  bool _showSearchField = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 100),
        animationBehavior: AnimationBehavior.preserve)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 50,
      backgroundColor: const Color(0x00000000),
      elevation: 0,
      title: widget.search
          ? Opacity(
              opacity: _animationController.value,
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Suchen...',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  hintStyle: TextStyle(color: Colors.white),
                ),
                cursorColor: primaryColor,
                style: const TextStyle(color: Colors.white),
                onChanged: widget.onChanged,
              ),
            )
          : widget.title,
      actions: [
        widget.search
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _showSearchField = !_showSearchField;
                    if (_showSearchField) {
                      _animationController.forward();
                    } else {
                      _animationController.reverse();
                    }
                  });
                },
                icon: const Icon(
                  Icons.search,
                  color: primaryColor,
                  size: 42.0,
                ))
            : Container(),
        ...widget.actions ?? [],
      ],
    );
  }
}
