import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picacg/language/generated/l10n.dart';
import 'package:picacg/provider/comic_provider.dart';
import 'package:picacg/utils/res_util.dart';
import 'package:picacg/utils/toast_util.dart';
import 'package:picacg/widgets/responsive_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoryPage extends ConsumerStatefulWidget {
  const CategoryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoryPageState();
}

class _CategoryPageState extends ConsumerState<CategoryPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: ResponsiveWidget(
        mobile: _getCustomScrollViewWidget(
          paddingLeft: 25,
          paddingRight: 25,
          crossAxisCount: 2,
          childAspectRatio: 0.8,
        ),
        folded: _getCustomScrollViewWidget(
          paddingLeft: 10,
          paddingRight: 25,
          crossAxisCount: 3,
          childAspectRatio: 0.85,
        ),
        foldedLandscape: _getCustomScrollViewWidget(
          paddingLeft: 10,
          paddingRight: 25,
          crossAxisCount: 4,
          childAspectRatio: 0.85,
        ),
        tablet: _getCustomScrollViewWidget(
          paddingLeft: 10,
          paddingRight: 25,
          crossAxisCount: 5,
          childAspectRatio: 0.85,
        ),
      ),
    );
  }

  Widget _getCustomScrollViewWidget({
    required double paddingLeft,
    required double paddingRight,
    required int crossAxisCount,
    required double childAspectRatio,
  }) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _getTitleWidget(
            title: "大家都在搜",
            padding: EdgeInsets.only(
              left: paddingLeft,
              top: 40,
              bottom: 20,
              right: paddingRight,
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsetsGeometry.only(
            left: paddingLeft,
            right: paddingRight,
          ),
          sliver: _getKeywordsWidget(),
        ),
        SliverToBoxAdapter(
          child: _getTitleWidget(
            title: "分类",
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
          sliver: _getCategoryWidget(
            childAspectRatio: childAspectRatio,
            crossAxisCount: crossAxisCount,
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 50)),
      ],
    );
  }

  Widget _getKeywordsWidget() {
    final keywords = ref.watch(picacgComicKeywordsApiProvider);

    return keywords.when(
      data: (data) {
        return SliverToBoxAdapter(
          child: Wrap(
            spacing: 10,
            runSpacing: 2,
            children: [
              for (String keyword in data)
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    keyword,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
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
            ).errorLoadingKeywords(ToastUtil.translateErrorMessage(error)),
          ),
        );

        return SliverToBoxAdapter(
          child: Center(
            child: OutlinedButton(
              onPressed: () {
                final _ = ref.refresh(picacgComicKeywordsApiProvider.future);
              },
              child: Text(Language.of(context).reload),
            ),
          ),
        );
      },
      loading: () {
        return SliverToBoxAdapter(
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(10, (index) {
              final rand = Random();

              return Skeletonizer(
                enabled: true,
                child: SizedBox(
                  child: Text(
                    List.generate(
                      rand.nextInt(10),
                      (_) => rand.nextInt(10).toString(),
                    ).join(),
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget _getCategoryWidget({
    required int crossAxisCount,
    required double childAspectRatio,
  }) {
    final category = ref.watch(picacgComicCategoryApiProvider);
    return category.when(
      data: (data) {
        return SliverGrid.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: data.length,
          itemBuilder: (context, index) {
            return CachedNetworkImage(
              imageUrl: ResUtil.getImageUrl(data[index].thumb),
              fit: BoxFit.cover,
              imageBuilder: (context, imageProvider) {
                return Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          data[index].title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                );
              },
              progressIndicatorBuilder: (context, url, progress) {
                return Skeletonizer(
                  enabled: true,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'lib/assets/images/loading.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        width: double.infinity,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        child: Center(
                          child: Text(
                            'loading...',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
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
            ).errorLoadingCategory(ToastUtil.translateErrorMessage(error)),
          ),
        );

        return SliverToBoxAdapter(
          child: Center(
            child: OutlinedButton(
              onPressed: () {
                final _ = ref.refresh(picacgComicCategoryApiProvider.future);
              },
              child: Text(Language.of(context).reload),
            ),
          ),
        );
      },
      loading: () {
        return SliverGrid.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.7,
          ),
          itemCount: 20,
          itemBuilder: (context, index) {
            return Skeletonizer(
              enabled: true,
              child: Container(
                color: Colors.grey.shade300,
                width: double.infinity,
                height: double.infinity,
              ),
            );
          },
        );
      },
    );
  }

  Widget _getTitleWidget({
    required String title,
    required EdgeInsetsGeometry padding,
  }) {
    return Padding(
      padding: padding,
      child: Text(
        title,
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
    );
  }
}
