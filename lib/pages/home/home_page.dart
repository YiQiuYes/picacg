import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picacg/language/generated/l10n.dart';
import 'package:picacg/pages/home/home_store.dart';
import 'package:picacg/provider/comic_provider.dart';
import 'package:picacg/provider/notice_provider.dart';
import 'package:picacg/rust/api/types/ad_entity.dart';
import 'package:picacg/utils/toast_util.dart';
import 'package:picacg/widgets/responsive_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage>, HomeStore {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: ResponsiveWidget(
        mobile: _getSliverCustomScrollView(
          paddingLeft: 25,
          paddingRight: 25,
          swiperShowCount: 1,
          noticeCrossAxisCount: 1,
          noticeChildAspectRatio: 1.55,
          noticeMaxItemCount: 3,
          recommendCrossAxisCount: 2,
          recommendChildAspectRatio: 0.65,
        ),
        folded: _getSliverCustomScrollView(
          paddingLeft: 10,
          paddingRight: 25,
          swiperShowCount: 2,
          noticeCrossAxisCount: 2,
          noticeChildAspectRatio: 1.2,
          noticeMaxItemCount: 4,
          recommendCrossAxisCount: 3,
          recommendChildAspectRatio: 0.65,
        ),
        foldedLandscape: _getSliverCustomScrollView(
          paddingLeft: 10,
          paddingRight: 25,
          swiperShowCount: 2,
          noticeCrossAxisCount: 2,
          noticeChildAspectRatio: 1.5,
          noticeMaxItemCount: 4,
          recommendCrossAxisCount: 4,
          recommendChildAspectRatio: 0.65,
        ),
        tablet: _getSliverCustomScrollView(
          paddingLeft: 10,
          paddingRight: 25,
          swiperShowCount: 2,
          noticeCrossAxisCount: 3,
          noticeChildAspectRatio: 1.5,
          noticeMaxItemCount: 6,
          recommendCrossAxisCount: 5,
          recommendChildAspectRatio: 0.65,
        ),
      ),
    );
  }

  Widget _getSliverCustomScrollView({
    required double paddingLeft,
    required double paddingRight,
    required int swiperShowCount,
    required int noticeCrossAxisCount,
    required double noticeChildAspectRatio,
    required int noticeMaxItemCount,
    required int recommendCrossAxisCount,
    required double recommendChildAspectRatio,
  }) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _getTitleWidget(
            title: Language.of(context).saveBiKa,
            subtitle: Language.of(context).moreArrow,
            padding: EdgeInsets.only(
              left: paddingLeft,
              top: 40,
              bottom: 20,
              right: paddingRight,
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.only(left: paddingLeft, right: paddingRight),
          sliver: SliverToBoxAdapter(
            child: SizedBox(
              height: 180,
              child: _getSwiperWidget(showCount: swiperShowCount),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: _getTitleWidget(
            title: Language.of(context).notice,
            subtitle: Language.of(context).moreArrow,
            padding: EdgeInsets.only(
              left: paddingLeft,
              top: 40,
              bottom: 20,
              right: paddingRight,
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.only(left: paddingLeft, right: paddingRight),
          sliver: _getNoticeListWidget(
            crossAxisCount: noticeCrossAxisCount,
            childAspectRatio: noticeChildAspectRatio,
            maxItemCount: noticeMaxItemCount,
          ),
        ),
        SliverToBoxAdapter(
          child: _getTitleWidget(
            title: Language.of(context).bookRecommend,
            subtitle: Language.of(context).moreArrow,
            padding: EdgeInsets.only(
              left: paddingLeft,
              top: 40,
              bottom: 20,
              right: paddingRight,
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.only(left: paddingLeft, right: paddingRight),
          sliver: _getRecommendGridWidget(
            recommendCrossAxisCount: recommendCrossAxisCount,
            recommendChildAspectRatio: recommendChildAspectRatio,
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 50)),
      ],
    );
  }

  Widget _getRecommendImageWidget({
    required String imageUrl,
    required String title,
  }) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.hardEdge,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, downloadProgress) {
          return Skeletonizer(
            enabled: true,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 70,
                width: double.infinity,
                color: Theme.of(context).colorScheme.primaryContainer,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text(
                  title,
                  style: TextStyle(fontSize: 13),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          );
        },
        errorWidget: (context, url, error) {
          return Container(
            color: Theme.of(context).colorScheme.errorContainer,
            child: Center(
              child: Icon(
                Icons.error,
                color: Theme.of(context).colorScheme.error,
                size: 50,
              ),
            ),
          );
        },
        imageBuilder: (context, imageProvider) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 70,
                width: double.infinity,
                color: Theme.of(context).colorScheme.primaryContainer,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text(
                  title,
                  style: TextStyle(fontSize: 13),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getRecommendGridWidget({
    int recommendCrossAxisCount = 2,
    double recommendChildAspectRatio = 0.65,
  }) {
    final randomComics = ref.watch(picacgComicRandomApiProvider);

    return randomComics.when(
      data: (data) {
        return _getGridViewWidget(
          crossAxisCount: recommendCrossAxisCount,
          childAspectRatio: recommendChildAspectRatio,
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];

            return _getRecommendImageWidget(
              imageUrl: getImageUrl(item.thumb),
              title: item.title,
            );
          },
        );
      },
      error: (error, stackTrace) {
        Future.delayed(
          Duration(milliseconds: 50),
          () => ToastUtil.showErrorSnackBar(
            context: context,
            message: Language.of(
              context,
            ).errorLoadingRecommend(ToastUtil.translateErrorMessage(error)),
          ),
        );

        return SliverToBoxAdapter(
          child: Center(
            child: OutlinedButton(
              onPressed: () {
                final _ = ref.refresh(picacgComicRandomApiProvider.future);
              },
              child: Text(Language.of(context).reload),
            ),
          ),
        );
      },
      loading: () {
        return _getGridViewWidget(
          crossAxisCount: recommendCrossAxisCount,
          childAspectRatio: recommendChildAspectRatio,
          itemCount: 10,
          itemBuilder: (context, index) {
            return Skeletonizer(
              enabled: true,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("lib/assets/images/loading.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 70,
                    width: double.infinity,
                    color: Theme.of(context).colorScheme.primaryContainer,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(
                      "loading...",
                      style: TextStyle(fontSize: 13),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _getNoticeListWidget({
    required int crossAxisCount,
    required double childAspectRatio,
    required int maxItemCount,
  }) {
    final announcements = ref.watch(
      picacgNoticeAnnouncementsApiProvider(page: 1),
    );

    return announcements.when(
      data: (data) {
        return _getGridViewWidget(
          itemBuilder: (context, index) {
            final item = data.docs[index];

            return Stack(
              children: [
                Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  bottom: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 20,
                  bottom: 30,
                  child: CachedNetworkImage(
                    width: 120,
                    imageUrl: getImageUrl(item.thumb),
                    fit: BoxFit.cover,
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 65,
                  left: 160,
                  right: 15,
                  bottom: 15,
                  child: Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Positioned(
                  top: 105,
                  left: 160,
                  right: 15,
                  bottom: 25,
                  child: Text(
                    item.content,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            );
          },
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          itemCount:
              data.docs.length > maxItemCount ? maxItemCount : data.docs.length,
        );
      },
      error: (error, stackTrace) {
        Future.delayed(
          Duration(milliseconds: 50),
          () => ToastUtil.showErrorSnackBar(
            context: context,
            message: Language.of(
              context,
            ).errorLoadingNotice(ToastUtil.translateErrorMessage(error)),
          ),
        );

        return SliverToBoxAdapter(
          child: Center(
            child: OutlinedButton(
              onPressed: () {
                final _ = ref.refresh(
                  picacgNoticeAnnouncementsApiProvider(page: 1).future,
                );
              },
              child: Text(Language.of(context).reload),
            ),
          ),
        );
      },
      loading: () {
        return Skeletonizer.sliver(
          child: SliverList.builder(
            itemBuilder: (context, index) {
              return SizedBox(
                height: 210,
                child: Stack(
                  children: [
                    Positioned(
                      top: 50,
                      left: 0,
                      right: 0,
                      bottom: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      left: 20,
                      bottom: 30,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Image.asset(
                          "lib/assets/images/loading.png",
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 65,
                      left: 160,
                      right: 15,
                      bottom: 15,
                      child: Text(
                        "loading...",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 105,
                      left: 160,
                      right: 15,
                      bottom: 15,
                      child: Text(
                        "loading...",
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              );
            },
            itemCount: 3,
          ),
        );
      },
    );
  }

  Widget _getGridViewWidget({
    int crossAxisCount = 3,
    double childAspectRatio = 1.8,
    int itemCount = 3,
    double mainAxisSpacing = 10,
    double crossAxisSpacing = 10,
    required Widget? Function(BuildContext, int) itemBuilder,
  }) {
    return SliverGrid.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
      ),
      itemBuilder: itemBuilder,
      itemCount: itemCount,
    );
  }

  Widget _getTitleWidget({
    required String title,
    required String subtitle,
    required EdgeInsetsGeometry padding,
  }) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getSwiperWidget({int showCount = 1}) {
    final announcement = ref.watch(adPicacgNoticeAdApiProvider);

    return announcement.when(
      data: (data) {
        List<AdEntity> list = [];
        for (var item in data) {
          int index = list.indexWhere((e) => e.thumb == item.thumb);
          if (index == -1) {
            list.add(item);
          }
        }
        storeIndex = 0;

        return CarouselSlider.builder(
          itemBuilder: (context, itemIndex, pageViewIndex) {
            List<int> showIndexList = [];
            for (int i = 0; i < showCount; i++) {
              showIndexList.add(storeIndex++);
              if (storeIndex >= list.length) {
                storeIndex = 0;
              }
            }

            return Row(
              spacing: 20,
              children: [
                for (int index in showIndexList)
                  Expanded(
                    child: CachedNetworkImage(
                      imageUrl: getImageUrl(list[index].thumb),
                      fit: BoxFit.cover,
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                      progressIndicatorBuilder: (
                        context,
                        url,
                        downloadProgress,
                      ) {
                        return Skeletonizer(
                          enabled: true,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
          itemCount:
              list.length % showCount == 0
                  ? list.length ~/ showCount
                  : list.length,
          options: CarouselOptions(
            autoPlay: true,
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            enlargeCenterPage: true,
            viewportFraction: 0.8,
          ),
        );
      },
      error: (error, stackTrace) {
        Future.delayed(
          Duration(milliseconds: 50),
          () => ToastUtil.showErrorSnackBar(
            context: context,
            message: Language.of(
              context,
            ).errorLoadingAd(ToastUtil.translateErrorMessage(error)),
          ),
        );

        return Center(
          child: OutlinedButton(
            onPressed: () {
              final _ = ref.refresh(adPicacgNoticeAdApiProvider.future);
            },
            child: Text(Language.of(context).reload),
          ),
        );
      },
      loading: () {
        return CarouselSlider.builder(
          itemBuilder: (context, itemIndex, pageViewIndex) {
            return Row(
              spacing: 20,
              children: [
                for (int i = 0; i < showCount; i++)
                  Expanded(
                    child: Skeletonizer(
                      enabled: true,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Image.asset(
                          'lib/assets/images/loading.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
          itemCount: 10,
          options: CarouselOptions(
            autoPlay: true,
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            enlargeCenterPage: true,
            viewportFraction: 0.8,
          ),
        );
      },
    );
  }
}
