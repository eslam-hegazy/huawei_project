import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:temp/business_logic/cubit/goals_cubit/goals_cubit.dart';
import 'package:temp/constants/app_icons.dart';
import 'package:temp/constants/app_presentation_strings.dart';
import 'package:temp/data/local/hive/id_generator.dart';
import 'package:temp/data/models/goals/goal_model.dart';
import 'package:temp/presentation/router/app_router_names.dart';
import 'package:temp/presentation/styles/colors.dart';
import 'package:temp/presentation/widgets/app_bars/app_bar_with_icon.dart';
import 'package:temp/presentation/widgets/buttons/elevated_button.dart';
import 'package:temp/presentation/widgets/common_texts/green_text.dart';
import 'package:temp/presentation/widgets/drop_down_custom.dart';
import 'package:temp/presentation/widgets/editable_text.dart';
import 'package:temp/presentation/widgets/goals_widgets/note_widget.dart';
import 'package:temp/presentation/widgets/show_dialog.dart';

class AddGoalScreen extends StatefulWidget {
  const AddGoalScreen({Key? key}) : super(key: key);

  @override
  State<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> with AlertDialogMixin {
  final TextEditingController goalNameCtrl = TextEditingController();
  final TextEditingController goalCostCtrl = TextEditingController();
  final TextEditingController goalSaveRepeatAmount = TextEditingController();
  final _addGoalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    GoalsCubit goalsCubit = BlocProvider.of<GoalsCubit>(context);

    return Scaffold(
        body: Form(
      key: _addGoalKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 6.h,
            ),
            const AppBarWithIcon(
              titleIcon: AppIcons.moneyAppBar,
              titleName: AppPresentationStrings.timeToSaveMoneyEng,
              firstIcon: Icons.arrow_back_ios,
              actionIcon: '',
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.0.h),
                    const GoalNote(),
                    SizedBox(height: 1.0.h),
                    Center(
                        child: Image.asset(AppIcons.savingMoney,
                            height: 25.h, width: 70.w)),
                    SizedBox(height: 2.0.h),
                    const GreenText(text: AppPresentationStrings.goalEng),
                    SizedBox(height: 1.0.h),
                    EditableInfoField(
                        textEditingController: goalNameCtrl,
                        hint: AppPresentationStrings.buyNewMobileEng,
                        backGroundColor: AppColor.pinkishGrey.withOpacity(0.25),
                        iconName: AppIcons.medalStar),
                    SizedBox(height: 2.0.h),
                    const GreenText(text: AppPresentationStrings.goalCostEng),
                    SizedBox(height: 1.0.h),
                    EditableInfoField(
                        textEditingController: goalCostCtrl,
                        keyboardType: TextInputType.number,
                        hint: '${AppPresentationStrings.twoThousandEng} LE',
                        backGroundColor: AppColor.pinkishGrey.withOpacity(0.25),
                        iconName: AppIcons.dollarCircle),
                    SizedBox(height: 2.0.h),
                    const GreenText(text: 'Saving Style'),
                    SizedBox(height: 1.0.h),
                    BlocBuilder<GoalsCubit, GoalsState>(
                      builder: (context, state) {
                        return EditableInfoField(
                          textEditingController: goalSaveRepeatAmount,
                          keyboardType: TextInputType.number,
                          hint: '${AppPresentationStrings.fifteenEng} LE',
                          backGroundColor: AppColor.pinkishGrey.withOpacity(0.25),
                          iconName: AppIcons.cartAdd,
                          trailing: DropDownCustomWidget(
                            leadingIcon: '',
                            dropDownList: goalsCubit.dropDownChannelItems,
                            hint: AppPresentationStrings.chooseRepeatEng,
                            isExpanded: false,
                            backgroundColor: Colors.transparent,
                            icon: AppIcons.forwardArrow,
                            onChangedFunc: goalsCubit.chooseRepeat,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 2.0.h),
                    const GreenText(text: AppPresentationStrings.firstSavingDayEng),
                    SizedBox(height: 1.0.h),
                    chooseDateWidget(goalsCubit),
                    SizedBox(height: 2.0.h),
                    CustomElevatedButton(
                        height: 6.h,
                        width: 90.w,
                        borderRadius: 8.dp,
                        onPressed: () async =>
                            await validateAndAddGoal(context, goalsCubit),
                        text: AppPresentationStrings.saveEng),
                    SizedBox(height: 2.0.h),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }

  Widget chooseDateWidget(GoalsCubit goalCubit) {
    return BlocBuilder<GoalsCubit, GoalsState>(
      builder: (context, state) {
        return InkWell(
          onTap: () async {
            goalCubit.changeDate(context);
            print('Choosed Date is ${goalCubit.chosenDate}');
          },
          child: Container(
            decoration: BoxDecoration(
                color: AppColor.pinkishGrey.withOpacity(0.25),
                borderRadius: BorderRadius.circular(20)),
            child: ListTile(
              title: Text(
                goalCubit.chosenDate == null
                    ? AppPresentationStrings.chooseDateEng
                    : '${goalCubit.chosenDate!.day} \\ ${goalCubit.chosenDate!.month} \\ ${goalCubit.chosenDate!.year}',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontWeight: FontWeight.w300, fontSize: 13),
              ),
              leading: SvgPicture.asset(AppIcons.dateIcon),
            ),
          ),
        );
      },
    );
  }

  validateAndAddGoal(BuildContext context, GoalsCubit goalCubit) async {
    if (_addGoalKey.currentState!.validate()) {
      //TODO put goal comment text form field
      final GoalModel goalModel = GoalModel.copyWith(
          goalComment: 'goalComment',
          goalCreatedDay: DateTime.now(),
          id: GUIDGen.generate(),
          goalName: goalNameCtrl.text,
          goalRemainingAmount: goalCubit.countRemainingAmount(
              num.tryParse(goalCostCtrl.text)!,
              num.tryParse(goalSaveRepeatAmount.text)!),
          //num.tryParse(goalCostCtrl.text)!,
          goalRemainingPeriod: goalCubit.remainingTimes(
              cost: num.tryParse(goalCostCtrl.text)!,
              dailySaving: num.tryParse(goalSaveRepeatAmount.text)!),
          goalSaveAmount: num.tryParse(goalSaveRepeatAmount.text)!,
          goalSaveAmountRepeat: goalCubit.choseRepeat,
          goalTotalAmount: num.parse(goalCostCtrl.text),
          //num.tryParse(goalCostCtrl.text)!,
          goalStartSavingDate: goalCubit.chosenDate ?? goalCubit.today,
          goalCompletionDate: goalCubit.getCompletionDate(
              cost: num.tryParse(goalCostCtrl.text)!,
              dailySavings: num.tryParse(goalSaveRepeatAmount.text)!,
              repeat: goalCubit.choseRepeat,
              startSavingDate: goalCubit.chosenDate ?? goalCubit.today));
      await showGoalsDialog(
          context: context,
          onPressedYesFunction: () async {
            await goalCubit.addGoal(goalModel: goalModel).then((_) {
              showDialogAndNavigate(context);
            });
          },
          onPressedNoFunction: () => Navigator.of(context).pop(),
          infoMessage: goalCubit.dialogMessage(
              cost: num.tryParse(goalCostCtrl.text)!,
              dailySaving: num.tryParse(goalSaveRepeatAmount.text)!));
    }
  }

  showDialogAndNavigate(BuildContext context) {
    Navigator.pop(context);
    showSuccessfulDialog(context, AppPresentationStrings.goalAddedEng, AppPresentationStrings.youHaveSuccessfullyAddedGoalEng);
    Future.delayed(const Duration(seconds: 1), () {
      // Navigator.pop(context);
      Navigator.pushReplacementNamed(context, AppRouterNames.rGetGoals);
    });
  }
}
