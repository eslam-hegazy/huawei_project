import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:temp/business_logic/cubit/global_cubit/global_cubit.dart';
import 'package:temp/constants/app_icons.dart';
import 'package:temp/constants/app_strings.dart';
import 'package:temp/presentation/widgets/cashati_team_widget.dart';
import 'package:temp/presentation/widgets/rate_app_dialog.dart';
import 'package:temp/presentation/widgets/setting_card_layout.dart';
import 'package:temp/presentation/widgets/show_dialog.dart';

import '../../../styles/colors.dart';
import '../../../widgets/buttons/custom_text_button.dart';
import '../../../widgets/custom_divder.dart';
import '../../../widgets/setting_choosen_component.dart';
import '../../../widgets/setting_list_tile.dart';

class SettingsScreen extends StatelessWidget with AlertDialogMixin {
  const SettingsScreen({Key? key}) : super(key: key);

  Future<void> _choseLanguage(String languageCode, context) async {
    await translator.setNewLanguage(context,
        restart: false, remember: true, newLanguage: languageCode);
    BlocProvider.of<GlobalCubit>(context)
        .onChangeLanguage(translator.activeLanguageCode == languageCode);
  }

  void _onLanguageTap(context, globalCubit) {
    globalCubit.isEnglish = false;
    globalCubit.isArabic = false;
    showSettingDialog(
      context: context,
      child: UiDialogComponent(
        header: '${AppStrings.select.tr()} ${AppStrings.language.tr()}',
        firstIcon: AppIcons.englishLang,
        secondIcon: AppIcons.arabicLang,
        firstTitle: AppStrings.english.tr(),
        secondTitle: AppStrings.arabic.tr(),
        onTapFirst: () => globalCubit.swapLangBGColor(true),
        onTapSecond: () => globalCubit.swapLangBGColor(false),
        onPressOK: () async {
          Navigator.of(context).pop();
          if (globalCubit.isEnglish || globalCubit.isArabic) {
            await _choseLanguage(globalCubit.isEnglish ? 'en' : 'ar', context);
          }
        },
      ),
    );
  }

  void _onCurrencyTap(BuildContext context, GlobalCubit globalCubit) {
    globalCubit.isEnglish = false;
    globalCubit.isArabic = false;
    showSettingDialog(
      context: context,
      child: UiDialogComponent(
        header: '${AppStrings.select.tr()} ${AppStrings.currency.tr()}',
        firstTitle: globalCubit.getCurrency[0].tr(),
        secondTitle: globalCubit.getCurrency[1].tr(),
        onTapFirst: () => globalCubit.swapCurrencyBGColor(true),
        onTapSecond: () => globalCubit.swapCurrencyBGColor(false),
        onPressOK: () {
          Navigator.of(context).pop();
          if (globalCubit.isEnglish || globalCubit.isArabic) {
            globalCubit.changeCurrency();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final globalCubit = context.read<GlobalCubit>();
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<GlobalCubit, GlobalState>(
      builder: (context, state) {
        return Scaffold(
            body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 1.h),
                Text(
                  AppStrings.reminders.tr(),
                  style: textTheme.headline3!.copyWith(fontSize: 17),
                ),
                SizedBox(height: 1.h),
                // Todo: change the List tile to date Picker.
                /// ReminderDate should be Date Picker
                SettingCardLayout(
                  settingChild: Column(
                    children: [
                      SettingListTile(
                        icon: AppIcons.reminder,
                        title: AppStrings.dailyReminders.tr(),
                        subtitle: AppStrings.reminderSubtitle.tr(),
                        dateTime: AppStrings.reminderTime.tr(),
                        isTrail: true,
                        isReminder: true,
                        switchValue: false,
                        onChangedFunc: (value) {},
                      ),
                      const CustomDivider(),
                      BlocBuilder<GlobalCubit, GlobalState>(
                        builder: (context, state) {
                          return SettingListTile(
                            icon: AppIcons.notificationSetting,
                            title: AppStrings.notifications.tr(),
                            subtitle: globalCubit.isEnable
                                ? AppStrings.disableAlerts.tr()
                                : AppStrings.enableAlerts.tr(),
                            isTrail: true,
                            switchValue: globalCubit.isEnable,
                            onChangedFunc: (value) =>
                                globalCubit.enableNotifications(value: value),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  AppStrings.moreSettings.tr(),
                  style: textTheme.headline3!.copyWith(fontSize: 17),
                ),
                SizedBox(height: 1.h),

                /// Language Card.
                SettingCardLayout(
                  settingChild: Column(
                    children: [
                      SettingListTile(
                        icon: AppIcons.englishLang,
                        title: AppStrings.language.tr(),
                        subtitle: AppStrings.englishSettingUsa.tr(),
                        isTrail: false,
                        onTap: () => _onLanguageTap(context, globalCubit),
                      ),
                      const CustomDivider(),

                      /// Currency Card
                      SettingListTile(
                          icon: AppIcons.currencySettings,
                          title: AppStrings.currency.tr(),
                          subtitle: globalCubit.selectedCurrency.tr(),
                          isTrail: false,
                          onTap: () => _onCurrencyTap(context, globalCubit)),
                    ],
                  ),
                ),
                SizedBox(height: 1.h),
                Text(AppStrings.appInfo.tr(), style: textTheme.headline3!),
                SizedBox(height: 1.h),
                SettingCardLayout(
                    settingChild: Column(
                  children: [
                    ExpansionTile(
                      iconColor: AppColor.primaryColor,
                      title: Text(AppStrings.aboutApp.tr()),
                      leading: const Icon(Icons.info_outline),
                      childrenPadding:
                          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
                      children: [
                        SizedBox(
                          width: 30.w,
                          child: SvgPicture.asset(AppIcons.cashatiLogoSVG),
                        ),
                        SizedBox(height: 3.h),
                        Text(AppStrings.aboutUsInfo.tr(), style: textTheme.subtitle1!),
                        SizedBox(height: 1.h),
                        Text(AppStrings.aboutDetailsSubTitle.tr(),
                            style: textTheme.overline!
                                .copyWith(color: AppColor.middleGrey))
                      ],
                    ),
                    const CustomDivider(),
                    const CashatiTeamWidget(),
                    const CustomDivider(),
                    RateAppWidget()
                  ],
                ))
              ],
            ),
          ),
        ));
      },
    );
  }
}

class UiDialogComponent extends StatelessWidget {
  const UiDialogComponent({
    super.key,
    required this.onPressOK,
    required this.header,
    required this.firstTitle,
    required this.secondTitle,
    required this.onTapFirst,
    required this.onTapSecond,
    this.firstIcon,
    this.secondIcon,
  });

  final String firstTitle;
  final String secondTitle;
  final String? firstIcon;
  final String? secondIcon;
  final void Function() onTapFirst;
  final void Function() onTapSecond;
  final void Function() onPressOK;
  final String header;

  @override
  Widget build(BuildContext context) {
    final globalCubit = BlocProvider.of<GlobalCubit>(context);
    return BlocBuilder<GlobalCubit, GlobalState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.dp, vertical: 16.dp),
          child: Column(
            crossAxisAlignment: globalCubit.isLanguage
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Align(
                alignment: globalCubit.isLanguage
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Text(header, style: Theme.of(context).textTheme.headline5),
              ),
              const Spacer(),
              Expanded(
                flex: 8,
                child: Column(
                  children: [
                    SettingsChosenComponent(
                        icon: firstIcon,
                        iconName: firstTitle,
                        isPressed: globalCubit.isEnglish,
                        onTap: onTapFirst),
                    const CustomDivider(),
                    SettingsChosenComponent(
                        icon: secondIcon,
                        iconName: secondTitle,
                        isPressed: globalCubit.isArabic,
                        onTap: onTapSecond),
                    const Spacer(flex: 2),
                    Row(
                      children: [
                        CustomTextButton(
                          text: AppStrings.cancel.tr(),
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                        CustomTextButton(
                            text: AppStrings.ok.tr(), onPressed: onPressOK),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
