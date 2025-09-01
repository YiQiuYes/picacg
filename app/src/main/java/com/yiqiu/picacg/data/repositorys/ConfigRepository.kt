package com.yiqiu.picacg.data.repositorys

import com.yiqiu.picacg.apis.ConfigApi
import com.yiqiu.picacg.data.dto.ConfigDTO
import retrofit2.Response

class ConfigRepository(private val api: ConfigApi) {
    suspend fun init() : Response<ConfigDTO.InitResponse> = api.init()
}