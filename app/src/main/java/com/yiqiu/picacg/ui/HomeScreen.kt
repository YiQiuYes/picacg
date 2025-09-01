package com.yiqiu.picacg.ui

import android.util.Log
import androidx.activity.compose.BackHandler
import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.togetherWith
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.GridItemSpan
import androidx.compose.foundation.lazy.grid.LazyGridState
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.rememberLazyGridState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.Search
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.ExtendedFloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.snapshotFlow
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.window.layout.DisplayFeature
import com.google.accompanist.adaptive.HorizontalTwoPaneStrategy
import com.google.accompanist.adaptive.TwoPane
import com.yiqiu.picacg.R
import com.yiqiu.picacg.ui.components.Announcement
import com.yiqiu.picacg.ui.components.AnnouncementDetail
import com.yiqiu.picacg.ui.components.AppBar
import com.yiqiu.picacg.ui.components.RecommendComic
import com.yiqiu.picacg.ui.components.RecommendComicDetail
import com.yiqiu.picacg.ui.utils.PicacgContentType
import com.yiqiu.picacg.ui.utils.PicacgNavigationType
import com.yiqiu.picacg.utils.Res
import com.yiqiu.picacg.utils.Store
import com.yiqiu.picacg.viewmodels.HomeUIState
import com.yiqiu.picacg.viewmodels.HomeViewModel
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.launch

@Composable
fun HomeScreen(
    contentType: PicacgContentType,
    navigationType: PicacgNavigationType,
    displayFeatures: List<DisplayFeature>
) {
    val homeViewModel: HomeViewModel = viewModel()
    val uiState by homeViewModel.uiState.collectAsStateWithLifecycle()

    val lazyListState = rememberLazyGridState()
    LaunchedEffect(key1 = contentType) {
        if (!uiState.isInit) {
            homeViewModel.getAnnouncements(page = 1)
            homeViewModel.getRecommendComics()
            homeViewModel.initFinish()
        }
        if (contentType == PicacgContentType.SINGLE_PANE && !uiState.isDetailOpen) {
            homeViewModel.closeDetailScreen()
        }

        snapshotFlow { lazyListState.layoutInfo.visibleItemsInfo }.map { visibleItems ->
            val lastVisibleItemIndex = visibleItems.lastOrNull()?.index ?: -1
            val totalItems = lazyListState.layoutInfo.totalItemsCount
            Pair(lastVisibleItemIndex, totalItems)
        }.collect { (lastVisibleItemIndex, totalItems) ->
            when (uiState.showMoreType) {
                HomeShowType.ANNOUNCEMENT -> {
                    if (uiState.announcements.docs.isEmpty()) {
                        return@collect
                    }

                    if (lastVisibleItemIndex >= totalItems - 1) {
                        homeViewModel.getAnnouncements(
                            page = (uiState.announcements.page < uiState.announcements.pages).let {
                                if (it) uiState.announcements.page + 1 else uiState.announcements.page
                            })
                    }
                }

                HomeShowType.RECOMMEND_COMIC -> {}
            }
        }
    }

    if (contentType == PicacgContentType.DUAL_PANE) {
        TwoPane(
            first = {
                HomeScrollList(
                    lazyGridState = lazyListState,
                    uiState = uiState,
                    contentType = contentType,
                    choiceIndex = { showType, index ->
                        homeViewModel.choiceIndex(showType, index)
                        homeViewModel.openDetailScreen()
                    },
                    changeShowMore = { homeViewModel.changeShowMore() },
                    getComicInfo = { homeViewModel.getComicInfo() },
                )
            },
            second = {
                HomeDetail(uiState = uiState, contentType = contentType)
            },
            strategy = HorizontalTwoPaneStrategy(splitFraction = 0.5f, gapWidth = 8.dp),
            displayFeatures = displayFeatures,
        )
    } else {
        Box(modifier = Modifier.fillMaxSize()) {
            SinglePaneContent(
                homeUIState = uiState,
                closeDetailScreen = { homeViewModel.closeDetailScreen() },
                lazyGridState = lazyListState,
                contentType = contentType,
                choiceIndex = { showType, index ->
                    homeViewModel.choiceIndex(showType, index)
                    homeViewModel.openDetailScreen()
                },
                changeShowMore = { homeViewModel.changeShowMore() },
                getComicInfo = { homeViewModel.getComicInfo() },
            )

            val coroutineScope = rememberCoroutineScope()

            if (navigationType == PicacgNavigationType.BOTTOM_NAVIGATION && !uiState.isDetailOpen) {
                ExtendedFloatingActionButton(
                    text = { Text(text = stringResource(id = R.string.search)) },
                    icon = { Icon(Icons.Rounded.Search, stringResource(id = R.string.search)) },
                    onClick = {
                        coroutineScope.launch {
                            Store.userPreferences.updateData { preferences ->
                                preferences.toBuilder().setToken("").setIsLogin(false).build()
                            }
                        }
                    },
                    modifier = Modifier
                        .align(Alignment.BottomEnd)
                        .padding(16.dp),
                    containerColor = MaterialTheme.colorScheme.tertiaryContainer,
                    contentColor = MaterialTheme.colorScheme.onTertiaryContainer,
                    expanded = lazyListState.lastScrolledBackward || !lazyListState.canScrollBackward,
                )
            }
        }
    }
}

@Composable
fun SinglePaneContent(
    homeUIState: HomeUIState,
    lazyGridState: LazyGridState,
    modifier: Modifier = Modifier,
    closeDetailScreen: () -> Unit,
    contentType: PicacgContentType,
    choiceIndex: (HomeShowType, Int) -> Unit,
    changeShowMore: () -> Unit,
    getComicInfo: () -> Unit,
) {
    AnimatedContent(
        targetState = homeUIState.isDetailOpen,
        label = "SinglePaneContentSwitch",
        transitionSpec = {
            fadeIn(animationSpec = tween(700)) togetherWith fadeOut(animationSpec = tween(700))
        }) { isDetailOpen ->
        if (isDetailOpen) {
            BackHandler {
                closeDetailScreen()
            }
            HomeDetail(
                uiState = homeUIState,
                contentType = contentType,
                closeDetailScreen = closeDetailScreen
            )
        } else {
            HomeScrollList(
                lazyGridState = lazyGridState,
                modifier = modifier,
                uiState = homeUIState,
                contentType = contentType,
                choiceIndex = choiceIndex,
                changeShowMore = changeShowMore,
                getComicInfo = getComicInfo,
            )
        }
    }
}

@Composable
fun HomeScrollList(
    lazyGridState: LazyGridState,
    modifier: Modifier = Modifier,
    uiState: HomeUIState,
    contentType: PicacgContentType,
    choiceIndex: (HomeShowType, Int) -> Unit,
    changeShowMore: () -> Unit,
    getComicInfo: () -> Unit,
) {
    Box(
        modifier = modifier.fillMaxSize()
    ) {
        LazyVerticalGrid(
            modifier = modifier.fillMaxWidth(),
            columns = GridCells.Fixed(2),
            horizontalArrangement = Arrangement.spacedBy(15.dp),
            contentPadding = PaddingValues(20.dp),
            state = lazyGridState,
        ) {
            item(span = { GridItemSpan(maxLineSpan) }) {
                Box(modifier = Modifier.height(20.dp))
            }

            item(span = { GridItemSpan(maxLineSpan) }) {
                TitleText(
                    text = "公告",
                    subText = if (uiState.showMoreType == HomeShowType.ANNOUNCEMENT) "收起 ↑" else "更多 >",
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(bottom = 40.dp),
                    enableSub = true,
                    onClick = {
                        changeShowMore()
                    },
                )
            }

            val announcementCount =
                if (uiState.announcements.docs.size >= 3 && uiState.showMoreType != HomeShowType.ANNOUNCEMENT) 3
                else uiState.announcements.docs.size
            items(count = announcementCount, span = { GridItemSpan(maxLineSpan) }) { index ->
                val announcement = uiState.announcements.docs[index]
                Announcement(
                    imageSrc = Res.getImageUrl(announcement.thumb),
                    title = announcement.title,
                    content = announcement.content,
                    onClick = {
                        choiceIndex(HomeShowType.ANNOUNCEMENT, index)
                    },
                )
            }

            item(span = { GridItemSpan(maxLineSpan) }) {
                AnimatedContent(
                    targetState = uiState.showMoreType,
                    label = "RecommendComicTitle",
                    transitionSpec = {
                        fadeIn(animationSpec = tween(700)) togetherWith fadeOut(
                            animationSpec = tween(
                                700
                            )
                        )
                    },
                ) { showMoreType ->
                    if (showMoreType == HomeShowType.RECOMMEND_COMIC) {
                        TitleText(
                            text = "推荐漫画",
                            modifier = Modifier
                                .fillMaxWidth()
                                .padding(bottom = 30.dp, top = 20.dp),
                        )
                    }
                }
            }

            items(count = uiState.recommendComics.size) { index ->
                AnimatedContent(
                    targetState = uiState.showMoreType, label = "re",
                    transitionSpec = {
                        fadeIn(animationSpec = tween(700)) togetherWith fadeOut(
                            animationSpec = tween(
                                700
                            )
                        )
                    },
                ) { showMoreType ->
                    if (showMoreType == HomeShowType.RECOMMEND_COMIC) {
                        val comic = uiState.recommendComics[index]
                        RecommendComic(
                            imageSrc = Res.getImageUrl(comic.thumb), title = comic.title,
                            onClick = {
                                choiceIndex(HomeShowType.RECOMMEND_COMIC, index)
                            },
                        )
                    }
                }
            }

            if (uiState.showMoreType == HomeShowType.ANNOUNCEMENT && uiState.announcementIsEnd.not()) {
                item(span = { GridItemSpan(maxLineSpan) }) {
                    Box(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(bottom = 20.dp, top = 20.dp),
                        contentAlignment = Alignment.Center
                    ) {
                        CircularProgressIndicator()
                    }
                }
            } else if (contentType == PicacgContentType.SINGLE_PANE) {
                item(span = { GridItemSpan(maxLineSpan) }) {
                    Box(modifier = Modifier.height(80.dp))
                }
            } else {
                item(span = { GridItemSpan(maxLineSpan) }) {
                    Box(modifier = Modifier.height(20.dp))
                }
            }
        }
    }
}

@Composable()
fun TitleText(
    modifier: Modifier = Modifier,
    text: String,
    subText: String = "",
    enableSub: Boolean = false,
    onClick: () -> Unit = { }
) {
    Row(
        modifier = modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Text(
            text = text,
            style = MaterialTheme.typography.headlineMedium,
            fontWeight = FontWeight.Bold
        )

        if (enableSub) {
            AnimatedContent(
                targetState = subText, label = "RecommendComicTitle",
                transitionSpec = {
                    fadeIn(animationSpec = tween(700)) togetherWith fadeOut(
                        animationSpec = tween(
                            700
                        )
                    )
                },
            ) { subText ->
                Text(
                    modifier = Modifier
                        .clip(RoundedCornerShape(10.dp))
                        .clickable {
                            onClick()
                        }
                        .padding(horizontal = 10.dp, vertical = 5.dp),
                    text = subText,
                    fontSize = 18.sp,
                    color = MaterialTheme.colorScheme.secondary,
                )
            }
        }
    }
}

enum class HomeShowType {
    ANNOUNCEMENT, RECOMMEND_COMIC
}

@Composable
fun HomeDetail(
    uiState: HomeUIState, contentType: PicacgContentType, closeDetailScreen: () -> Unit = { }
) {
    AnimatedContent(
        targetState = uiState.showDetailType,
        label = "HomeDetail",
        transitionSpec = {
            fadeIn(animationSpec = tween(700)) togetherWith fadeOut(animationSpec = tween(700))
        },
    ) { showDetailType ->
        var appBarTitle = ""

        Box(modifier = Modifier.fillMaxSize()) {
            val paddingTop = if (contentType == PicacgContentType.SINGLE_PANE) 100.dp else 40.dp

            when (showDetailType) {
                HomeShowType.ANNOUNCEMENT -> {

                    AnimatedContent(
                        targetState = uiState.selectAnnouncementIndex,
                        label = "HomeAnnouncementDetail",
                        transitionSpec = {
                            fadeIn(animationSpec = tween(700)) togetherWith fadeOut(
                                animationSpec = tween(
                                    700
                                )
                            )
                        },
                    ) { selectIndex ->
                        if (selectIndex == -1) {
                            Box(modifier = Modifier.fillMaxSize())
                        } else {
                            val announcement =
                                uiState.announcements.docs[selectIndex]
                            AnnouncementDetail(announcement, contentType)
                        }
                    }

                }

                HomeShowType.RECOMMEND_COMIC -> {
                    if (uiState.comicInfo != null) {
                        AnimatedContent(
                            targetState = uiState.selectRecommendIndex,
                            label = "HomeComicDetail",
                            transitionSpec = {
                                fadeIn(animationSpec = tween(700)) togetherWith fadeOut(
                                    animationSpec = tween(
                                        700
                                    )
                                )
                            },
                        ) { selectIndex ->
                            appBarTitle = uiState.recommendComics[selectIndex].title
                            RecommendComicDetail(
                                modifier = Modifier.padding(top = paddingTop),
                                comic = uiState.comicInfo,
                            )
                        }
                    }
                }
            }
        }

        if (contentType == PicacgContentType.SINGLE_PANE) {
            AppBar(closeDetailScreen = closeDetailScreen, title = appBarTitle)
        }
    }
}