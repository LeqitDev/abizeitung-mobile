import 'package:abizeitung_mobile/assets/assets.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    this.onChanged,
    required this.search,
    this.actions,
    this.title,
    this.backButton,
    this.searchString,
  })  : preferredSize = const Size.fromHeight(50.0),
        super(key: key);

  @override
  final Size preferredSize;

  final Function(String)? onChanged;
  final bool search;
  final List<Widget>? actions;
  final Widget? title;
  final bool? backButton;
  final String? searchString;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final TextEditingController _textEditingController;

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
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchField = TextField(
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
      autofocus: true,
    );

    return AppBar(
      toolbarHeight: 50,
      backgroundColor: const Color(0x00000000),
      elevation: 0,
      title: widget.search && _showSearchField
          ? Opacity(
              opacity: _animationController.value,
              child: searchField,
            )
          : widget.title,
      actions: [
        widget.search
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _showSearchField = !_showSearchField;
                    if (_showSearchField) {
                      FocusScope.of(context)
                          .requestFocus(searchField.focusNode);
                      _animationController.forward();
                    } else {
                      searchField.focusNode?.unfocus();
                      _animationController.reverse();
                    }
                  });
                },
                icon: Icon(
                  _showSearchField ? Icons.check : Icons.search,
                  color: primaryColor,
                  size: 34.0,
                ))
            : Container(),
        ...widget.actions ?? [],
      ],
      iconTheme: widget.backButton != null
          ? const IconThemeData(
              color: primaryColor,
              size: 34.0,
            )
          : null,
    );
  }
}
