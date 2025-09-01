package com.yiqiu.picacg.data.dto

import com.yiqiu.picacg.models.Login

class AuthDTO {
    class LoginResponse(
        val code: Int,
        val message: String,
        val data: Login
    )

    class LoginRequest(val email: String, val password: String)
}