import 'package:care_route/view_models/routine_view_model.dart';
import 'package:care_route/views/widgets/button_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../consts/colors.dart';
import '../../widgets/user_text.dart';

class TargetListWidget extends StatefulWidget {
  final bool isBackKey;
  final GlobalKey<TargetListWidgetState> key;

  const TargetListWidget({
    required this.key,
    this.isBackKey = true,
  }) : super(key: key);

  @override
  TargetListWidgetState createState() => TargetListWidgetState();
}

class TargetListWidgetState extends State<TargetListWidget> {
  late RoutineViewModel _routineViewModel;
  int? _selectedMemberId;

  int? get selectedMemberId => _selectedMemberId;

  @override
  void initState() {
    super.initState();
    _routineViewModel = Provider.of<RoutineViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final targetInfos = _routineViewModel.targetList.data?.targetInfos ?? [];
    return Container(
      padding: EdgeInsets.only(
        bottom: ScreenUtil().setHeight(28.0),
        left: ScreenUtil().setWidth(16.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: targetInfos.map<Widget>((info) {
                  final isSelected = info.memberId == _selectedMemberId;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedMemberId = info.memberId;
                        print('Selected memberId: ${info.memberId}');
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: ScreenUtil().setWidth(8.0)),
                      child: Column(
                        children: [
                          SizedBox(height: ScreenUtil().setHeight(20.0)),
                          ColorFiltered(
                            colorFilter: isSelected
                                ? ColorFilter.mode(
                                    Colors.transparent, BlendMode.color)
                                : ColorFilter.mode(
                                    Colors.grey, BlendMode.saturation),
                            child: Image.network(
                              info.profileImage ?? '',
                              width: ScreenUtil().setWidth(50.0),
                              height: ScreenUtil().setHeight(50.0),
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(4.0)),
                          UserText(
                            text: info.nickname,
                            color: isSelected ? const Color(UserColors.gray07) : Colors.grey,
                            weight: FontWeight.w700,
                            size: ScreenUtil().setSp(12.0),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          if (widget.isBackKey)
            Padding(
              padding: EdgeInsets.only(right: ScreenUtil().setWidth(17.0)),
              child: ButtonIcon(
                  icon: Icons.arrow_back_ios,
                  iconColor: const Color(UserColors.gray05),
                  callback: () => Navigator.of(context).pop()),
            ),
        ],
      ),
    );
  }
}
