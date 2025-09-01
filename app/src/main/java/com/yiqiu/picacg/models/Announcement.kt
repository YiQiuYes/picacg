package com.yiqiu.picacg.models

import com.google.gson.annotations.SerializedName

data class Announcement(
    @SerializedName("_id")
    val id: String = "",
    val title: String = "",
    val content: String = "",
    val thumb: Image = Image()
)