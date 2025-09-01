package com.yiqiu.picacg.models

data class PageData<T>(
    val total: Int,
    val limit: Int,
    val page: Int,
    val pages: Int,
    val docs: List<T>
)
