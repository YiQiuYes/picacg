package com.yiqiu.picacg.apis

import com.yiqiu.picacg.data.dto.AuthDTO
import retrofit2.Response
import retrofit2.http.Body
import retrofit2.http.POST

interface AuthApi {
    @POST("/auth/sign-in")
    suspend fun login(@Body body: AuthDTO.LoginRequest): Response<AuthDTO.LoginResponse>
}