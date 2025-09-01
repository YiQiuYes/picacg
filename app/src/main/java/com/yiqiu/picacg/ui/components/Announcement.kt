package com.yiqiu.picacg.ui.components

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.selection.SelectionContainer
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalUriHandler
import androidx.compose.ui.text.LinkAnnotation
import androidx.compose.ui.text.SpanStyle
import androidx.compose.ui.text.TextLinkStyles
import androidx.compose.ui.text.buildAnnotatedString
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.text.withLink
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import coil.compose.SubcomposeAsyncImage
import com.yiqiu.picacg.models.Announcement
import com.yiqiu.picacg.ui.utils.PicacgContentType
import com.yiqiu.picacg.utils.Res

@Composable()
fun Announcement(imageSrc: String, title: String, content: String, onClick: () -> Unit) {
    Box(
        modifier = Modifier
            .fillMaxWidth()
            .padding(bottom = 20.dp)
            .clip(RoundedCornerShape(20.dp))
            .clickable {
                onClick()
            }
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .height(190.dp)
                .clip(RoundedCornerShape(20.dp))
                .background(color = MaterialTheme.colorScheme.tertiaryContainer)
                .align(Alignment.BottomStart)
        ) {
            Text(
                modifier = Modifier.padding(
                    top = 10.dp, start = 200.dp, end = 20.dp
                ),
                text = title,
                style = MaterialTheme.typography.headlineSmall,
                fontWeight = FontWeight.Bold,
                maxLines = 2,
                overflow = TextOverflow.Ellipsis
            )

            Text(
                modifier = Modifier.padding(
                    top = 10.dp, start = 200.dp, end = 20.dp, bottom = 20.dp
                ),
                text = content,
                style = MaterialTheme.typography.bodyMedium,
                overflow = TextOverflow.Ellipsis
            )
        }

        SubcomposeAsyncImage(
            modifier = Modifier
                .height(262.dp)
                .width(180.dp)
                .padding(start = 20.dp, bottom = 20.dp)
                .align(Alignment.BottomStart)
                .clip(RoundedCornerShape(20.dp)),
            model = imageSrc,
            contentScale = ContentScale.FillBounds,
            loading = {
                Box {
                    CircularProgressIndicator(modifier = Modifier.align(Alignment.Center))
                }
            },
            contentDescription = "",
        )
    }
}

@Composable
fun AnnouncementDetail(data: Announcement, contentType: PicacgContentType) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .verticalScroll(rememberScrollState()),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        if (contentType == PicacgContentType.SINGLE_PANE) {
            SubcomposeAsyncImage(
                modifier = Modifier
                    .height(280.dp)
                    .width(160.dp)
                    .padding(top = 50.dp)
                    .clip(RoundedCornerShape(20.dp)),
                model = Res.getImageUrl(data.thumb),
                contentScale = ContentScale.FillBounds,
                loading = {
                    Box {
                        CircularProgressIndicator(modifier = Modifier.align(Alignment.Center))
                    }
                },
                contentDescription = "",
            )
        }

        SelectionContainer {
            Text(
                modifier = Modifier.padding(top = 40.dp, bottom = 20.dp),
                text = data.title,
                style = MaterialTheme.typography.headlineLarge,
                fontWeight = FontWeight.Bold,
                fontSize = 28.sp,
                maxLines = 2,
                overflow = TextOverflow.Ellipsis
            )
        }

        val uriHandler = LocalUriHandler.current
        SelectionContainer {
            val regex = Regex("""https?://\S+""")
            val annotatedString = buildAnnotatedString {
                val matches = regex.findAll(data.content)
                var lastIndex = 0
                for (match in matches) {
                    val start = match.range.first
                    val end = match.range.last + 1
                    append(data.content.substring(lastIndex, start))
                    withLink(
                        LinkAnnotation.Url(
                            match.value,
                            TextLinkStyles(style = SpanStyle(color = Color.Blue))
                        ) {
                            uriHandler.openUri(match.value)
                        }) {
                        append(match.value)
                    }
                    lastIndex = end
                }
            }

            Text(
                modifier = Modifier.padding(
                    start = 20.dp,
                    end = 20.dp,
                    bottom = 40.dp
                ),
                text = annotatedString,
                fontSize = 18.sp
            )
        }
    }
}