package com.yiqiu.picacg.apis

import com.yiqiu.picacg.interceptor.PicacgHeaderInterceptor
import com.yiqiu.picacg.interceptor.PicacgTokenInterceptor
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.util.concurrent.TimeUnit

object RetrofitInstance {
    const val BASE_URL: String = "https://picaapi.picacomic.com"

    private val loggingInterceptor by lazy {
        HttpLoggingInterceptor().setLevel(HttpLoggingInterceptor.Level.BODY)
    }

    private val headerInterceptor by lazy {
        PicacgHeaderInterceptor()
    }

    private val tokenInterceptor by lazy {
        PicacgTokenInterceptor()
    }

    private val okClient by lazy {
        OkHttpClient.Builder()
            .addNetworkInterceptor(loggingInterceptor)
            .addInterceptor(headerInterceptor)
            .authenticator(tokenInterceptor)
            .connectTimeout(30, TimeUnit.SECONDS)
            .writeTimeout(30, TimeUnit.SECONDS)
            .readTimeout(30, TimeUnit.SECONDS)
            .build()
    }

    private val retrofit by lazy {
        Retrofit.Builder().baseUrl(BASE_URL)
            .client(okClient)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
    }

    val authApi: AuthApi by lazy {
        retrofit.create(AuthApi::class.java)
    }

    val campaign: CampaignApi by lazy {
        retrofit.create(CampaignApi::class.java)
    }

    val content: ContentApi by lazy {
        retrofit.create(ContentApi::class.java)
    }

    val config: ConfigApi by lazy {
        retrofit.create(ConfigApi::class.java)
    }
}