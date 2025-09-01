package com.yiqiu.picacg.models

import com.google.gson.annotations.SerializedName

data class Comic (
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
    val tags: List<String>,
    val totalLikes: Int,
    val totalViews: Int,
)