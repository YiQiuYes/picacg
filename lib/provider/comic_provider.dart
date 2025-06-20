import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picacg/rust/api/error/custom_error.dart';
import 'package:picacg/rust/api/reqs/comic.dart';
import 'package:picacg/rust/api/types/category_entity.dart';
import 'package:picacg/rust/api/types/comic_entity.dart';
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
Future<List<ComicEntity>> picacgComicRandomApi(Ref ref) async {
  try {
    return await picacgComicRandom();
  } on CustomError {
    rethrow;
  }
}

@riverpod
Future<List<String>> picacgComicKeywordsApi(Ref ref) async {
  try {
    return await picacgComicKeywords();
  } on CustomError {
    rethrow;
  }
}
