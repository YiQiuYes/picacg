import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picacg/rust/api/error/custom_error.dart';
import 'package:picacg/rust/api/reqs/comic.dart';
import 'package:picacg/rust/api/types/category_entity.dart';
import 'package:picacg/rust/api/types/category_id.dart';
import 'package:picacg/rust/api/types/comic_entity.dart';
import 'package:picacg/rust/api/types/recommend_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'comic_provider.g.dart';

@riverpod
Future<List<CategoryEntity>> picacgComicCategoryApi(Ref ref) async {
  try {
    return await picacgComicCategory();
  } on CustomError {
    rethrow;
  }
}

@riverpod
Future<List<CategoryIdEntity>> picacgComicCategoryIdApi(Ref ref) async {
  try {
    return await picacgComicCategoryId();
  } on CustomError {
    rethrow;
  }
}

@riverpod
Future<List<RecommendEntity>> picacgComicRecommendApi(Ref ref) async {
  try {
    final categoryList = await ref.watch(
      picacgComicCategoryIdApiProvider.future,
    );
    String categoryId = categoryList[Random().nextInt(categoryList.length)].id;
    return await picacgComicRecommend(categoryId: categoryId);
  } on CustomError {
    rethrow;
  }
}

@riverpod
Future<List<ComicEntity>> picacgComicRandomApi(Ref ref) async {
  try {
    return await picacgComicRandom();
  } on CustomError {
    rethrow;
  }
}
