import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picacg/language/generated/l10n.dart';
import 'package:picacg/provider/comic_provider.dart';
import 'package:picacg/utils/res_util.dart';
import 'package:picacg/utils/toast_util.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoryPage extends ConsumerStatefulWidget {
  const CategoryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoryPageState();
}

class _CategoryPageState extends ConsumerState<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    final category = ref.watch(picacgComicCategoryApiProvider);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _getTitleWidget(
              title: "大家都在搜",
              padding: EdgeInsets.only(
                left: 25,
                top: 40,
                bottom: 20,
                right: 25,
              ),
            ),
          ),
          category.when(
            data: (data) {
              return SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    imageUrl: ResUtil.getImageUrl(data[index].thumb),
                    fit: BoxFit.cover,
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(data[index].title),
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
                  message: Language.of(context).errorLoadingRecommend(
                    ToastUtil.translateErrorMessage(error),
                  ),
                ),
              );

              return SliverToBoxAdapter(
                child: Center(
                  child: OutlinedButton(
                    onPressed: () {
                      final _ = ref.refresh(
                        picacgComicCategoryApiProvider.future,
                      );
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
          ),
        ],
      ),
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
