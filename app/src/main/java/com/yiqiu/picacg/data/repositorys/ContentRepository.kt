package com.yiqiu.picacg.data.repositorys

import com.yiqiu.picacg.apis.ContentApi
import com.yiqiu.picacg.data.dto.ContentDTO
import retrofit2.Response

class ContentRepository(private val api: ContentApi) {
    suspend fun randomComic(): Response<ContentDTO.RandomComicResponse> = api.randomComic()
    suspend fun comicInfo(comicId: String): Response<ContentDTO.ComicInfoResponse> =
        api.comicInfo(comicId = comicId)
}