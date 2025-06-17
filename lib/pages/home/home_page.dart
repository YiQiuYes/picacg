import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picacg/pages/home/home_store.dart';
import 'package:picacg/provider/comic_provider.dart';
import 'package:picacg/provider/notice_provider.dart';
import 'package:picacg/rust/api/types/ad_entity.dart';
import 'package:picacg/utils/toast_util.dart';
import 'package:picacg/widgets/responsive_widget.dart';

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
        mobile: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _getTitleWidget(
                title: "拯救哔咔",
                subtitle: "更多 >",
                padding: const EdgeInsets.only(
                  left: 25,
                  top: 40,
                  bottom: 20,
                  right: 25,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              sliver: SliverToBoxAdapter(
                child: SizedBox(height: 200, child: _getSwiperWidget()),
              ),
            ),
            SliverToBoxAdapter(
              child: _getTitleWidget(
                title: "公告",
                subtitle: "更多 >",
                padding: const EdgeInsets.only(
                  left: 25,
                  top: 40,
                  bottom: 20,
                  right: 25,
                ),
              ),
            ),
            _getNoticeListWidget(),
            SliverToBoxAdapter(
              child: _getTitleWidget(
                title: "本子推荐",
                subtitle: "更多 >",
                padding: const EdgeInsets.only(
                  left: 25,
                  top: 40,
                  bottom: 20,
                  right: 25,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              sliver: _getRecommendGridWidget(),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ),
        folded: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _getTitleWidget(
                title: "拯救哔咔",
                subtitle: "更多 >",
                padding: const EdgeInsets.only(
                  left: 10,
                  bottom: 20,
                  right: 25,
                  top: 20,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(left: 10, right: 25),
              sliver: _getGridViewWidget(
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.primaries[index % Colors.primaries.length],
                    child: Center(
                      child: Text(
                        'Card $index',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: _getTitleWidget(
                title: "公告",
                subtitle: "更多 >",
                padding: const EdgeInsets.only(
                  left: 10,
                  bottom: 15,
                  right: 25,
                  top: 30,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(left: 10, right: 25),
              sliver: _getGridViewWidget(
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.primaries[index % Colors.primaries.length],
                    child: Center(
                      child: Text(
                        'Card $index',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: _getTitleWidget(
                title: "本子推荐",
                subtitle: "更多 >",
                padding: const EdgeInsets.only(
                  left: 10,
                  bottom: 15,
                  right: 25,
                  top: 30,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(left: 10, right: 25),
              sliver: _getGridViewWidget(
                itemCount: 100,
                childAspectRatio: 0.75,
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.primaries[index % Colors.primaries.length],
                    child: Center(
                      child: Text(
                        'Card $index',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 50)),
          ],
        ),
        tablet: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _getTitleWidget(
                title: "拯救哔咔",
                subtitle: "更多 >",
                padding: const EdgeInsets.only(
                  left: 10,
                  bottom: 20,
                  right: 25,
                  top: 20,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(left: 10, right: 25),
              sliver: _getGridViewWidget(
                crossAxisCount: 4,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.primaries[index % Colors.primaries.length],
                    child: Center(
                      child: Text(
                        'Card $index',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: _getTitleWidget(
                title: "公告",
                subtitle: "更多 >",
                padding: const EdgeInsets.only(
                  left: 10,
                  bottom: 15,
                  right: 25,
                  top: 30,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(left: 10, right: 25),
              sliver: _getGridViewWidget(
                crossAxisCount: 4,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.primaries[index % Colors.primaries.length],
                    child: Center(
                      child: Text(
                        'Card $index',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: _getTitleWidget(
                title: "本子推荐",
                subtitle: "更多 >",
                padding: const EdgeInsets.only(
                  left: 10,
                  bottom: 15,
                  right: 25,
                  top: 30,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(left: 10, right: 25),
              sliver: _getGridViewWidget(
                itemCount: 100,
                crossAxisCount: 4,
                childAspectRatio: 0.75,
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.primaries[index % Colors.primaries.length],
                    child: Center(
                      child: Text(
                        'Card $index',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 50)),
          ],
        ),
      ),
    );
  }

  Widget _getRecommendGridWidget() {
    final recommendations = ref.watch(picacgComicRecommendApiProvider);

    return recommendations.when(
      data: (data) {
        return _getGridViewWidget(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];

            return CachedNetworkImage(
              imageUrl: formatImageUrl(item.pic),
              fit: BoxFit.cover,
              errorWidget: (context, url, error) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.errorContainer,
                  ),
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
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 70,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Text(
                        item.title,
                        style: TextStyle(fontSize: 13),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
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
            message: '加载推荐失败: ${ToastUtil.translateErrorMessage(error)}',
          ),
        );

        return SliverToBoxAdapter(
          child: Center(
            child: OutlinedButton(
              onPressed: () {
                final _ = ref.refresh(picacgComicRecommendApiProvider.future);
              },
              child: Text('重新加载'),
            ),
          ),
        );
      },
      loading:
          () => SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          ),
    );
  }

  Widget _getNoticeListWidget() {
    final announcements = ref.watch(
      picacgNoticeAnnouncementsApiProvider(page: 1),
    );

    return announcements.when(
      data: (data) {
        return SliverList.builder(
          itemBuilder: (context, index) {
            final item = data.docs[index];

            return SizedBox(
              height: 210,
              child: Stack(
                children: [
                  Positioned(
                    top: 50,
                    left: 20,
                    right: 20,
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
                    left: 40,
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
                    left: 180,
                    right: 42,
                    bottom: 15,
                    child: Text(
                      item.title,
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
                    left: 180,
                    right: 42,
                    bottom: 15,
                    child: Text(
                      item.content,
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
        );
      },
      error: (error, stackTrace) {
        Future.delayed(
          Duration(milliseconds: 50),
          () => ToastUtil.showErrorSnackBar(
            context: context,
            message: '加载公告失败: ${ToastUtil.translateErrorMessage(error)}',
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
              child: Text('重新加载'),
            ),
          ),
        );
      },
      loading:
          () => SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          ),
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

  Widget _getSwiperWidget() {
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

        return Swiper(
          itemBuilder: (context, index) {
            return CachedNetworkImage(
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
            );
          },
          itemCount: list.length,
          autoplay: true,
          autoplayDelay: 4000,
          scale: 0.8,
        );
      },
      error: (error, stackTrace) {
        Future.delayed(
          Duration(milliseconds: 50),
          () => ToastUtil.showErrorSnackBar(
            context: context,
            message: '加载广告失败: ${ToastUtil.translateErrorMessage(error)}',
          ),
        );

        return Center(
          child: OutlinedButton(
            onPressed: () {
              final _ = ref.refresh(adPicacgNoticeAdApiProvider.future);
            },
            child: Text('重新加载'),
          ),
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}
