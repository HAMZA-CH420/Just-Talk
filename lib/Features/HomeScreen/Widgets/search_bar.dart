import 'package:flutter/material.dart';
import 'package:just_talk/UiHelpers/Utils/Color_Palette/color_palette.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key, required this.onChanged, this.onClear});
  final Function(String) onChanged;
  final VoidCallback? onClear;
  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    searchController.addListener(
      () => widget.onChanged(searchController.text),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width,
      height: size.height / 18,
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(horizontal: 15),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Palette.secondaryColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.search,
              color: Colors.black,
              size: 27,
            ),
            hintText: "Search...",
            hintStyle: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
            suffixIcon: searchController.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      searchController.clear();
                      widget.onChanged("");
                      if (widget.onClear != null) {
                        widget.onClear!();
                      }
                    },
                    icon: Icon(
                      Icons.clear,
                      color: Colors.black,
                    ))
                : null),
      ),
    );
  }
}
