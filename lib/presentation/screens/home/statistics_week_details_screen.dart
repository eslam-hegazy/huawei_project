import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:temp/business_logic/cubit/statistics_cubit/statistics_cubit.dart';
import 'package:temp/constants/app_icons.dart';
import 'package:temp/constants/app_lists.dart';
import 'package:temp/constants/app_strings.dart';
import 'package:temp/constants/enum_classes.dart';
import 'package:temp/data/models/transactions/transaction_model.dart';
import 'package:temp/data/repository/helper_class.dart';
import 'package:temp/presentation/screens/home/part_time_details.dart';
import 'package:temp/presentation/screens/shared/empty_screen.dart';
import 'package:temp/presentation/styles/colors.dart';
import 'package:temp/presentation/widgets/drop_down_custom.dart';
import 'package:temp/presentation/widgets/expenses_and_income_widgets/important_or_fixed.dart';
import 'package:temp/presentation/widgets/transaction_card.dart';

import '../../router/app_router.dart';
import '../../widgets/custom_app_bar.dart';

class StatisticsWeekDetailsScreen extends StatelessWidget with HelperClass {
  const StatisticsWeekDetailsScreen({
    Key? key,
    this.transactions = const [],
    this.weekRanges = const [],
    required this.builderIndex,
  }) : super(key: key);

  final List<TransactionModel> transactions;
  final List<String> weekRanges;
  final int builderIndex;

  String appTitle(index) {
    final transactionType =
        transactions[0].isExpense ? AppStrings.expenses.tr() : AppStrings.income.tr();
    return translator.activeLanguageCode == 'en'
        ? '${'the'.tr()} ${AppStrings.week.tr()} $transactionType'
        : '$transactionType ${'the'.tr()}${AppStrings.week.tr()}';
  }

  /*List<DropdownMenuItem<String>> getDropDown() {

  }*/

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final dateTime = getWeekRange(chosenDay: transactions[builderIndex].createdDate)[builderIndex];
    final dateTime = weekRanges[builderIndex];
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<StatisticsCubit, StatisticsState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomAppBar(title: appTitle(builderIndex), isEndIconVisible: false),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(dateTime,
                          style: theme.textTheme.headline6,
                          overflow: TextOverflow.ellipsis),
                      SizedBox(width: 20),
                      Expanded(
                        child: SizedBox(
                          child: DropDownCustomWidget(
                              iconHeight: 1.h,
                              isExpanded: true,
                              value:
                                  context.read<StatisticsCubit>().chosenFilterWeekDay,
                              dropDownList: AppConstantList.daysFormatList
                                  .map((e) => DropdownMenuItem<String>(
                                      value: e, child: Text(e)))
                                  .toList(),
                              hint: "Choose Day",
                              leadingIcon: AppIcons.dateIcon,
                              onChangedFunc: (val) {
                                context
                                    .read<StatisticsCubit>()
                                    .filterWeekTransactionsByDay(
                                        dayName: val, weekTransactions: transactions);
                              }),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const PriorityWidget(),
                          PriorityWidget(
                              text: PriorityType.NotImportant.name,
                              color: AppColor.pinkishGrey)
                        ],
                      ),
                    ],
                  ),
                ),
                //TODO change empty screen and make it dynamic with any empty Lost
                Expanded(
                  flex: 8,
                  child: Visibility(
                    visible:
                        context.read<StatisticsCubit>().chosenFilterWeekDay != "All" &&
                            context
                                .read<StatisticsCubit>()
                                .transactionsWeekFiltered
                                .isEmpty,
                    child: EmptyScreen(),
                    replacement: ListView.builder(
                      itemCount:
                          context.read<StatisticsCubit>().chosenFilterWeekDay == "All"
                              ? transactions.length
                              : context
                                  .read<StatisticsCubit>()
                                  .transactionsWeekFiltered
                                  .length,
                      itemBuilder: (_, currIndex) => InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => PartTimeDetails(
                                    transactionModel: context
                                                .read<StatisticsCubit>()
                                                .chosenFilterWeekDay ==
                                            "All"
                                        ? transactions[currIndex]
                                        : context
                                            .read<StatisticsCubit>()
                                            .transactionsWeekFiltered[currIndex],
                                    insideIndex: 10))),
                        child: TransactionsCard(
                          index: currIndex,
                          isRepeated: false,
                          isSeeMore: true,
                          transactionModel:
                              context.read<StatisticsCubit>().chosenFilterWeekDay ==
                                      "All"
                                  ? transactions[currIndex]
                                  : context
                                      .read<StatisticsCubit>()
                                      .transactionsWeekFiltered[currIndex],
                          priorityName:
                              context.read<StatisticsCubit>().chosenFilterWeekDay ==
                                      "All"
                                  ? transactions[currIndex].isPriority
                                      ? AppStrings.important
                                      : AppStrings.notImportant
                                  : context
                                          .read<StatisticsCubit>()
                                          .transactionsWeekFiltered[currIndex]
                                          .isPriority
                                      ? AppStrings.important
                                      : AppStrings.notImportant,

                          /// check if this is the higherExpense so show it.
                          switchWidget: SwitchWidgets.higherExpenses,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
