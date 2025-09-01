package com.yiqiu.picacg.models

import com.google.gson.annotations.SerializedName

data class Init(
    val imageServer: String,
    val categories: List<CategoryId>
)

data class CategoryId(
    @SerializedName("_id")
    val id: String,
    val title: String
)
