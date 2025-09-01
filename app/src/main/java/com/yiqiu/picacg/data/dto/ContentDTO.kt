package com.yiqiu.picacg.data.dto

import com.yiqiu.picacg.models.Comic
import com.yiqiu.picacg.models.ComicInfo

class ContentDTO {
    class RandomComicResponse(
        val code: Int,
        val message: String,
        val data: RandomComicData,
    )

    class ComicInfoResponse(
        val code: Int = 0,
        val message: String = "",
        val data: ComicInfoData,
    )
}

data class RandomComicData(
    val comics: List<Comic>,
)

data class ComicInfoData(
    val comic: ComicInfo,
)