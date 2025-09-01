package com.yiqiu.picacg.data.repositorys

import com.yiqiu.picacg.apis.AuthApi
import com.yiqiu.picacg.data.dto.AuthDTO
import retrofit2.Response

class AuthRepository(private val api: AuthApi) {
    suspend fun login(body: AuthDTO.LoginRequest): Response<AuthDTO.LoginResponse> = api.login(body)
}