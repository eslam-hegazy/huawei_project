import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:temp/business_logic/cubit/statistics_cubit/statistics_cubit.dart';
import 'package:temp/constants/app_presentation_strings.dart';
import 'package:temp/data/models/transactions/transaction_model.dart';
import 'package:temp/data/repository/helper_class.dart';
import 'package:temp/presentation/widgets/custom_app_bar.dart';
import '../../../business_logic/cubit/add_exp_inc/add_exp_or_inc_cubit.dart';
import '../../../constants/app_icons.dart';
import '../../styles/colors.dart';
import '../../widgets/add_income_expense_widget/choose_container.dart';
import '../../widgets/editable_text.dart';
import '../../widgets/expenses_and_income_widgets/important_or_fixed.dart';

class PartTimeDetails extends StatefulWidget {
  const PartTimeDetails(
      {Key? key, required this.transactionModel, required this.insideIndex})
      : super(key: key);
  final TransactionModel transactionModel;
  final int insideIndex;

  @override
  State<PartTimeDetails> createState() => _PartTimeDetailsState();
}

class _PartTimeDetailsState extends State<PartTimeDetails> with HelperClass {
  final TextEditingController mainCategoryController = TextEditingController();
  final TextEditingController calenderController = TextEditingController();
  final TextEditingController subCategoryController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    dateController.dispose();
    amountController.dispose();
    subCategoryController.dispose();
    descriptionController.dispose();
    calenderController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  AddExpOrIncCubit getAddExpOrIncCubit() => BlocProvider.of<AddExpOrIncCubit>(context);

  void showDatePick() async {
    final datePicker = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (datePicker == null) return;
    getAddExpOrIncCubit().changeDate(datePicker);
  }

  void onDelete() async {
    final statisticsCubit = BlocProvider.of<StatisticsCubit>(context);
    await statisticsCubit.deleteTransaction(widget.transactionModel);
    statisticsCubit.getExpenses();
    statisticsCubit.getTodayExpenses(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(
      child: SingleChildScrollView(
        child: BlocBuilder<StatisticsCubit, StatisticsState>(
          builder: (context, state) {
            return Column(
              children: [
                SizedBox(height: 15.dp),
                CustomAppBar(
                    title: '${widget.transactionModel.mainCategory} ${AppPresentationStrings.expenseDetailsEng}',
                    isEndIconVisible: false),
                SizedBox(height: 40.dp),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: BlocBuilder<AddExpOrIncCubit, AddExpOrIncState>(
                    builder: (context, state) {
                      return Column(
                        children: [
                          SizedBox(
                              width: 90.w,
                              child: DateChooseContainer(
                                onTap: () async => showDatePick(),
                                dateTime: widget.transactionModel.createdDate,
                              )),
                          SizedBox(height: 15.dp),
                          EditableInfoField(
                            textEditingController: mainCategoryController,
                            hint: widget.transactionModel.mainCategory,
                            iconName: AppIcons.categoryIcon,
                            keyboardType: TextInputType.text,
                          ),
                          SizedBox(height: 15.dp),
                          EditableInfoField(
                            textEditingController: subCategoryController,
                            hint: widget.transactionModel.subCategory,
                            iconName: AppIcons.categories,
                            keyboardType: TextInputType.text,
                          ),
                          SizedBox(height: 15.dp),
                          EditableInfoField(
                            textEditingController: amountController,
                            hint: '${widget.transactionModel.amount}LE',
                            iconName: AppIcons.amountIcon,
                            keyboardType: TextInputType.text,
                            trailing: IconButton(
                                icon: const Icon(Icons.edit_outlined),
                                color: AppColor.primaryColor,
                                onPressed: () {
                                  widget.transactionModel.amount =
                                      int.parse(amountController.text);
                                }),
                          ),
                          SizedBox(height: 15.dp),
                          EditableInfoField(
                            textEditingController: dateController,
                            hint: widget.transactionModel.repeatType,
                            iconName: AppIcons.change,
                            keyboardType: TextInputType.text,
                          ),
                          SizedBox(height: 15.dp),
                          EditableInfoField(
                            textEditingController: descriptionController,
                            header: AppPresentationStrings.descriptionEng,
                            hint: widget.transactionModel.description == ''
                                ? 'There are many variations of... There are many variations of...'
                                : widget.transactionModel.description,
                            iconName: '',
                            keyboardType: TextInputType.multiline,
                          ),
                          SizedBox(height: 30.dp),
                          Row(
                            children: [
                              const Expanded(child: SizedBox()),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    onDelete();
                                    Navigator.of(context).pop();
                                  },
                                  child: CircleAvatar(
                                    radius: 16.sp,
                                    backgroundColor: AppColor.primaryColor,
                                    child: SvgPicture.asset(AppIcons.delete,
                                        color: AppColor.white),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    const Spacer(),
                                    PriorityWidget(
                                      color: widget.transactionModel.isPriority
                                          ? AppColor.secondColor
                                          : AppColor.pinkishGrey,
                                      text: priorityNames(
                                          widget.transactionModel.isExpense,
                                          widget.transactionModel.isPriority),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    ));
  }
}
