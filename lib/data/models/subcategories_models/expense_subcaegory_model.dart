// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// part 'databases_models.g.dart';
//
//
//
// @HiveType(typeId: 10)
// class SubCategoryExpense extends HiveObject {
//   SubCategoryExpense();
//   SubCategoryExpense.copyWith({
//     required this.mainCategoryExpenseName,
//     required this.subCategoryExpenseId,
//     required this.subCategoryExpenseName,
//     required this.subCategoryExpenseIconName,
//     required this.subCategoryExpenseColor,
//     required this.subCategoryExpenseIconCodePoint,
//
//   });
//   @HiveField(0)
//   late String subCategoryExpenseId;
//   @HiveField(1)
//   late String mainCategoryExpenseName ;
//   @HiveField(2)
//   late String subCategoryExpenseName ;
//   @HiveField(3)
//   late String subCategoryExpenseIconName;
//   //TODO remove colors
//   @HiveField(4)
//   late String subCategoryExpenseColor;
//   @HiveField(5)
//   late int subCategoryExpenseIconCodePoint;
// }