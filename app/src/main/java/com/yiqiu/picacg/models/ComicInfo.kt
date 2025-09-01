package com.yiqiu.picacg.models

import com.google.gson.annotations.SerializedName
import java.time.LocalDateTime

data class ComicInfo(
    @SerializedName("_id")
    val id: String,
    val title: String,
    val author: String,
    val pagesCount: Int,
    val epsCount: Int,
    val finished: Boolean,
    val categories: List<String>,
    val thumb: Image,
    val likesCount: Int,
    val creator: Creator,
    val description: String,
    val chineseTeam: String,
    val tags: List<String>,
    val updatedAt: LocalDateTime,
    val createAt: LocalDateTime,
    val allowDownload: Boolean,
    val viewsCount: Int,
    val isLiked: Boolean,
    val commentsCount: Int,
)
