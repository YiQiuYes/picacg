package com.yiqiu.picacg.models

import com.google.gson.annotations.SerializedName

data class Creator(
    @SerializedName("_id")
    val id: String,
    val gender: String,
    val name: String,
    val title: String,
    val verified: Boolean,
    val exp: Int,
    val level: Int,
    val characters: List<String> = emptyList(),
    val avatar: Image,
    val slogan: String,
    val role: String,
    val character: String,
)
