import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picacg/rust/api/error/custom_error.dart';
import 'package:picacg/rust/api/reqs/notice.dart';
import 'package:picacg/rust/api/types/ad_entity.dart';
import 'package:picacg/rust/api/types/page_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notice_provider.g.dart';

@riverpod
Future<AnnouncementPageData> picacgNoticeAnnouncementsApi(
  Ref ref, {
  required int page,
}) async {
  try {
    return await picacgNoticeAnnouncements(page: page);
  } on CustomError {
    rethrow;
  }
}

@riverpod
Future<List<AdEntity>> adPicacgNoticeAdApi(Ref ref) async {
  try {
    return await picacgNoticeAd();
  } on CustomError {
    rethrow;
  }
}
