package com.yiqiu.picacg.apis

import com.yiqiu.picacg.data.dto.ContentDTO
import retrofit2.Response
import retrofit2.http.GET
import retrofit2.http.Path

interface ContentApi {
    @GET("/comics/random")
    suspend fun randomComic(): Response<ContentDTO.RandomComicResponse>

    @GET("/comics/{comicId}")
    suspend fun comicInfo(@Path("comicId") comicId: String): Response<ContentDTO.ComicInfoResponse>
}