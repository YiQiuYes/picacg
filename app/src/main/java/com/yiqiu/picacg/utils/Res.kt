package com.yiqiu.picacg.utils

import com.yiqiu.picacg.models.Image
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.runBlocking

object Res {
    fun getImageUrl(image: Image): String {
        val imageServer = runBlocking {
            Store.settingPreferences.data.first().imageServer
        }

        val baseUrl = imageServer.replace(Regex("/static.*"), "")
        val path = if (image.path.startsWith("/")) {
            image.path.substring(1)
        } else {
            image.path
        }
        return "$baseUrl/static/$path"
    }
}