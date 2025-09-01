package com.yiqiu.picacg.interceptor

import com.yiqiu.picacg.utils.Crypto
import com.yiqiu.picacg.utils.Store
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.runBlocking
import okhttp3.Headers
import okhttp3.Interceptor
import okhttp3.Response

private const val API_KEY = "C69BAF41DA5ABD1FFEDC6D2FEA56B"
private  val NONCE = "b1ab87b4800d4d4590a11701b8551afa";
private const val DIGEST_KEY = "~d}\$Q7\$eIni=V)9\\RK/P.RM4;9[7|@/CA}b~OW!3?EV`:<>M7pddUBL5n|0/*Cn"

class PicacgHeaderInterceptor : Interceptor {
    override fun intercept(chain: Interceptor.Chain): Response {
        val pathSegments = chain.request().url.pathSegments.joinToString("/")
        val query = chain.request().url.query
        val time = (System.currentTimeMillis() / 1000).toString()
        val token = runBlocking {
            Store.userPreferences.data.first().token
        }

        var url = pathSegments
        if (query != null) {
            url += "?$query"
        }

        val headers = Headers.Builder()
            .add("api-key", API_KEY)
            .add("accept", "application/vnd.picacomic.com.v1+json")
            .add("app-channel", "2")
            .add("time", time)
            .add("nonce", NONCE)
            .add("app-version", "2.2.1.2.3.3")
            .add("app-uuid", "defaultUuid")
            .add("app-platform", "android")
            .add("app-build-version", "44")
            .add("Content-Type", "application/json; charset=UTF-8")
            .add("User-Agent", "okhttp/3.8.1")
            .add("image-quality", "original")
            .add(
                "signature",
                Crypto.hmacSha256(
                    DIGEST_KEY,
                    (url + time + NONCE + chain.request().method + API_KEY).lowercase()
                )
            )
            .add("authorization", token)
            .build()

        val request = chain.request().newBuilder().headers(headers).build()
        return chain.proceed(request)
    }
}