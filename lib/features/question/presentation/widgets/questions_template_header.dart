import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/text/custom_text_rubik.dart';

class QuestionsTemplateHeader extends StatelessWidget {
  const QuestionsTemplateHeader(
      {super.key, required this.title, required this.action});

  final String title;
  final GestureTapCallback action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomTextRubik(
            text: title,
            weight: FontWeight.w600,
            size: 20,
            color: AppPalette.blackColor),
        Spacer(),
        GestureDetector(
          onTap: action,
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/section/bulb.svg',
                height: 20,
              ),
              Text(
                'Show Hint',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Color(0xFF3629B7),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationThickness: 2,
                    ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
