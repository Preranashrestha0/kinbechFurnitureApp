// This is the custom page made for the container of Profile page
import 'package:flutter/material.dart';

class CustomContainerWidget extends StatelessWidget {
  final Widget rowcontent;
  final Function()? onTap;

  const CustomContainerWidget({
    super.key,
    required this.rowcontent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
          margin: EdgeInsets.only(left: 10, right: 5, top: 5),
          height: size.height/11,
          width: size.width/1.06,
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: Color(0xff864942))
          ),
          child: rowcontent,
      ),
    );
  }
}
