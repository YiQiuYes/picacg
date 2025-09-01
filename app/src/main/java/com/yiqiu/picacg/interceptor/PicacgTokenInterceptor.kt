package com.yiqiu.picacg.interceptor

import android.util.Log
import com.google.gson.Gson
import com.yiqiu.picacg.apis.AuthApi
import com.yiqiu.picacg.apis.RetrofitInstance
import com.yiqiu.picacg.data.dto.AuthDTO
import com.yiqiu.picacg.models.ErrorBody
import com.yiqiu.picacg.utils.Store
import com.yiqiu.picacg.utils.Toast
import com.yiqiu.picacg.viewmodels.LoginViewModel
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.runBlocking
import okhttp3.Authenticator
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.Response
import okhttp3.Route
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.util.concurrent.TimeUnit

class PicacgTokenInterceptor : Authenticator {
    private val tag: String = LoginViewModel::class.java.simpleName

    override fun authenticate(route: Route?, response: Response): Request? {
        if (response.code == 401) {
            val (userName, passWord, oldToken) = runBlocking {
                Triple(
                    Store.userPreferences.data.first().userName,
                    Store.userPreferences.data.first().passWord,
                    Store.userPreferences.data.first().token
                )
            }

            if (oldToken.isNullOrEmpty() || userName.isNullOrEmpty() || passWord.isNullOrEmpty()) return null

            synchronized(this) {
                return runBlocking {
                    val newToken = Store.userPreferences.data.first().token
                    if (newToken != oldToken) return@runBlocking null

                    val res = getNewToken(userName, passWord)
                    if (res.isSuccessful) {
                        val token = res.body()?.data?.token ?: ""
                        Store.userPreferences.updateData { preferences ->
                            preferences.toBuilder()
                                .setToken(token)
                                .build()
                        }

                        return@runBlocking response.request.newBuilder()
                            .header("authorization", token)
                            .build()
                    } else {
                        try {
                            val error =
                                Gson().fromJson(res.errorBody()?.string(), ErrorBody::class.java)
                            Log.e(tag, "Refresh token failed: ${error.message}")
                            Toast.showError("Refresh token failed: ${error.message}")
                            Store.userPreferences.updateData { preferences ->
                                preferences.toBuilder()
                                    .setToken("")
                                    .setPassWord("")
                                    .setIsLogin(false)
                                    .build()
                            }
                        } catch (e: Exception) {
                            Log.e(tag, "Error parsing error body: ${e.message}")
                            Toast.showError("Unexpected error occurred during refresh token")
                        }

                        return@runBlocking null
                    }
                }
            }
        }
        return null
    }

    private suspend fun getNewToken(
        userName: String,
        passWord: String
    ): retrofit2.Response<AuthDTO.LoginResponse> {
        val client = OkHttpClient.Builder()
            .addNetworkInterceptor(HttpLoggingInterceptor().setLevel(HttpLoggingInterceptor.Level.BODY))
            .addInterceptor(PicacgHeaderInterceptor())
            .connectTimeout(30, TimeUnit.SECONDS)
            .writeTimeout(30, TimeUnit.SECONDS)
            .readTimeout(30, TimeUnit.SECONDS)
            .build()

        val service = Retrofit.Builder()
            .baseUrl(RetrofitInstance.BASE_URL)
            .client(client)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
            .create(AuthApi::class.java)

        return service.login(AuthDTO.LoginRequest(userName, passWord))
    }
}