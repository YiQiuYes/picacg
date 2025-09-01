package com.yiqiu.picacg.apis

import com.yiqiu.picacg.data.dto.ConfigDTO
import retrofit2.Response
import retrofit2.http.GET

interface ConfigApi {
    @GET("/init?platform=android")
    suspend fun init(): Response<ConfigDTO.InitResponse>
}