package com.yiqiu.picacg.ui.components

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.Interaction
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.FlowRow
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.pager.HorizontalPager
import androidx.compose.foundation.pager.rememberPagerState
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.Favorite
import androidx.compose.material.icons.rounded.PlayArrow
import androidx.compose.material.icons.rounded.RemoveRedEye
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Tab
import androidx.compose.material3.TabRow
import androidx.compose.material3.TabRowDefaults
import androidx.compose.material3.TabRowDefaults.tabIndicatorOffset
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.zIndex
import coil.compose.SubcomposeAsyncImage
import com.yiqiu.picacg.R
import com.yiqiu.picacg.models.ComicInfo
import com.yiqiu.picacg.models.Image
import com.yiqiu.picacg.utils.Res
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.emptyFlow
import kotlinx.coroutines.launch

@Composable()
fun RecommendComic(imageSrc: String, title: String, onClick: () -> Unit) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(15.dp))
            .clickable {
                onClick()
            },
    ) {
        SubcomposeAsyncImage(
            modifier = Modifier
                .fillMaxWidth()
                .aspectRatio(0.7f)
                .clip(RoundedCornerShape(15.dp)),
            model = imageSrc,
            contentScale = ContentScale.FillBounds,
            loading = {
                Box {
                    CircularProgressIndicator(modifier = Modifier.align(Alignment.Center))
                }
            },
            contentDescription = "",
        )

        Text(
            modifier = Modifier.padding(top = 20.dp, bottom = 15.dp),
            text = title,
            maxLines = 2,
            fontSize = 18.sp,
            overflow = TextOverflow.Ellipsis
        )
    }
}

@Composable
fun RecommendComicDetail(modifier: Modifier = Modifier, comic: ComicInfo) {
    var selectedIndex by remember { mutableIntStateOf(0) }
    val list = listOf(
        stringResource(R.string.comic_detail),
        stringResource(R.string.chapter),
        stringResource(R.string.comment)
    )

    Box(modifier = modifier.fillMaxSize()) {
        val pagerState = rememberPagerState(pageCount = { 3 })
        val animationScope = rememberCoroutineScope()

        TabRow(
            modifier = Modifier
                .padding(start = 20.dp, end = 20.dp)
                .clip(RoundedCornerShape(50)),
            selectedTabIndex = selectedIndex,
            containerColor = MaterialTheme.colorScheme.secondaryContainer,
            contentColor = MaterialTheme.colorScheme.onSecondaryContainer,
            indicator = { tabPositions ->
                TabRowDefaults.SecondaryIndicator(
                    modifier = Modifier
                        .tabIndicatorOffset(tabPositions[selectedIndex])
                        .fillMaxSize()
                        .padding(4.dp)
                        .clip(RoundedCornerShape(50)),
                    color = MaterialTheme.colorScheme.inversePrimary,
                )
            },
        ) {
            list.forEachIndexed { index, text ->
                val selected = selectedIndex == index
                val textColor =
                    if (selected) MaterialTheme.colorScheme.primary else MaterialTheme.colorScheme.secondary
                Tab(
                    modifier = Modifier.zIndex(2f),
                    selected = selected,
                    onClick = {
                        selectedIndex = index
                        animationScope.launch {
                            pagerState.animateScrollToPage(index)
                        }
                    },
                    text = { Text(text = text, color = textColor) },
                    interactionSource = object : MutableInteractionSource {
                        override val interactions: Flow<Interaction> = emptyFlow()
                        override suspend fun emit(interaction: Interaction) {}
                        override fun tryEmit(interaction: Interaction) = true
                    },
                )
            }
        }

        HorizontalPager(
            modifier = Modifier
                .fillMaxSize()
                .padding(top = 70.dp, start = 20.dp, end = 20.dp),
            state = pagerState,
        ) { page ->
            when (page) {
                0 -> {
                    Column(
                        modifier = Modifier
                            .fillMaxSize()
                            .verticalScroll(rememberScrollState())
                    ) {
                        Row(
                            modifier = Modifier
                                .fillMaxWidth()
                                .height(150.dp),
                            horizontalArrangement = Arrangement.SpaceBetween
                        ) {
                            SubcomposeAsyncImage(
                                modifier = Modifier
                                    .width(100.dp)
                                    .height(150.dp)
                                    .clip(RoundedCornerShape(8.dp)),
                                model = Res.getImageUrl(comic.thumb),
                                contentScale = ContentScale.FillBounds,
                                loading = {
                                    Box {
                                        CircularProgressIndicator(
                                            modifier = Modifier.align(
                                                Alignment.Center
                                            )
                                        )
                                    }
                                },
                                contentDescription = "",
                            )

                            Column(
                                modifier = Modifier
                                    .fillMaxSize(1f)
                                    .padding(start = 20.dp, end = 20.dp),
                                verticalArrangement = Arrangement.SpaceBetween,
                            ) {
                                Text(
                                    modifier = Modifier
                                        .padding(top = 10.dp)
                                        .fillMaxWidth(),
                                    text = comic.title,
                                    maxLines = 2,
                                    fontSize = 22.sp,
                                    overflow = TextOverflow.Ellipsis,
                                    color = MaterialTheme.colorScheme.primary
                                )

                                Text(
                                    modifier = Modifier.fillMaxWidth(),
                                    text = "作者：${comic.author}",
                                    maxLines = 1,
                                    fontSize = 18.sp,
                                    overflow = TextOverflow.Ellipsis,
                                    color = MaterialTheme.colorScheme.secondary
                                )

                                Row(verticalAlignment = Alignment.CenterVertically) {
                                    Icon(
                                        modifier = Modifier.size(20.dp),
                                        imageVector = Icons.Rounded.RemoveRedEye,
                                        contentDescription = "",
                                        tint = MaterialTheme.colorScheme.secondary
                                    )

                                    Text(
                                        modifier = Modifier
                                            .padding(start = 5.dp)
                                            .fillMaxWidth(),
                                        text = "${comic.viewsCount}",
                                        maxLines = 1,
                                        fontSize = 18.sp,
                                        overflow = TextOverflow.Ellipsis,
                                        color = MaterialTheme.colorScheme.secondary
                                    )
                                }

                                Row(
                                    modifier = Modifier.padding(bottom = 10.dp),
                                    verticalAlignment = Alignment.CenterVertically
                                ) {
                                    Icon(
                                        modifier = Modifier.size(20.dp),
                                        imageVector = Icons.Rounded.Favorite,
                                        contentDescription = "",
                                        tint = MaterialTheme.colorScheme.secondary
                                    )

                                    Text(
                                        modifier = Modifier
                                            .padding(start = 5.dp)
                                            .fillMaxWidth(),
                                        text = "${comic.likesCount}",
                                        maxLines = 1,
                                        fontSize = 18.sp,
                                        overflow = TextOverflow.Ellipsis,
                                        color = MaterialTheme.colorScheme.secondary
                                    )
                                }
                            }
                        }

                        Text(
                            modifier = Modifier
                                .fillMaxWidth()
                                .padding(top = 20.dp),
                            text = comic.description,
                            fontSize = 18.sp,
                        )
                    }
                }

                1 -> {
                    Column(
                        modifier = Modifier
                            .fillMaxSize()
                            .verticalScroll(rememberScrollState()),
                    ) {
                        FlowRow(
                            modifier = Modifier.fillMaxSize(),
                            horizontalArrangement = Arrangement.SpaceAround,
                            verticalArrangement = Arrangement.spacedBy(10.dp),
                        ) {
                            repeat(comic.epsCount) { index ->
                                OutlinedButton(
                                    modifier = Modifier.width(100.dp),
                                    contentPadding = PaddingValues(5.dp),
                                    onClick = {}
                                ) {
                                    Text(
                                        text = "第${index + 1}话",
                                        fontSize = 15.sp,
                                    )
                                }
                            }
                        }
                    }
                }

                2 -> {
                    Box(
                        modifier = Modifier
                            .fillMaxSize()
                            .background(Color.Cyan)
                    )
                }
            }
        }

        FloatingActionButton(
            modifier = Modifier
                .align(Alignment.BottomEnd)
                .padding(bottom = 30.dp, end = 20.dp),
            onClick = {}
        ) {
            Icon(
                imageVector = Icons.Rounded.PlayArrow,
                contentDescription = "",
            )
        }
    }
}